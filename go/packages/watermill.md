// 文档：https://watermill.io/docs/middlewares/
// github：https://github.com/ThreeDotsLabs/watermill
```go
package main

import (
	"context"
	"errors"
	"fmt"
	"log"
	"os"
	"os/signal"
	"syscall"
	"time"

	"github.com/ThreeDotsLabs/watermill"
	"github.com/ThreeDotsLabs/watermill-redisstream/pkg/redisstream"
	"github.com/ThreeDotsLabs/watermill/message"
	"github.com/ThreeDotsLabs/watermill/message/router/middleware"
	"github.com/ThreeDotsLabs/watermill/message/router/plugin"
	"github.com/redis/go-redis/v9"
)

var (
	// 发布订阅主题
	topic = "pub_sub_test"
)

func main() {
	// 创建 Redis 客户端
	redisClient := redis.NewClient(&redis.Options{
		Addr:     "127.0.0.1:6379",
		Password: "",
		DB:       0,
	})

	// 测试 Redis 连接
	ctx := context.Background()
	_, err := redisClient.Ping(ctx).Result()
	if err != nil {
		panic(fmt.Errorf("连接 Redis 失败: %w", err))
	}

	// 创建日志适配器
	logger := watermill.NewStdLogger(false, false)

	// 创建 Redis Streams 配置
	publisherConfig := redisstream.PublisherConfig{
		Client:     redisClient,
		Marshaller: &redisstream.DefaultMarshallerUnmarshaller{},
	}

	// 创建发布者
	publisher, err := redisstream.NewPublisher(publisherConfig, logger)
	if err != nil {
		panic(fmt.Errorf("创建发布者失败: %w", err))
	}

	// 创建订阅者
	subscriberConfig := redisstream.SubscriberConfig{
		Client:       redisClient,
		Unmarshaller: &redisstream.DefaultMarshallerUnmarshaller{},
	}

	// 创建订阅者
	subscriber, err := redisstream.NewSubscriber(subscriberConfig, logger)
	if err != nil {
		panic(fmt.Errorf("创建订阅者失败: %w", err))
	}

	// 订阅者逻辑
	// 创建路由器
	router, err := message.NewRouter(message.RouterConfig{}, logger)
	if err != nil {
		log.Fatalf("创建路由器失败: %v", err)
	}

	// 优雅关闭
	router.AddPlugin(plugin.SignalsHandler)

	// 添加中间件
	// 1. 顺序有重要性 上面的包（洋葱上面的在外层）下面的
	// 2. Ack慎用，直接ack后都不会处罚重试机制
	// 3. 官方的重试属于应用层的重试，并不是一定就只重试这么多次，redis本次也有投递不成功继续投递的问题
	//    因此，会在上层添加一个死信队列的重试
	// 4. 使用重试时，不要使用超时中间件；
	//   就算要使用也要注意，timeout要放在重试中间件上面；绝对不要放在重试中间件下面，这会导致重试中间件失效
	//   那么如何保证超时呢？使用重试中的MaxElapsedTime 最大重试时间来做
	//   根本原因：超时中间件和重试中间件它们都有自己的时间控制，两者叠加不好计算，也容易冲突；当前watermill无法实现，对单次处理超时（带上重试）的控制
	// 5. 由于重试是基于内存的，如果总共要重试5次，那么在重试到第2次时，此时程序重启，那么会从头开始计算重试次数哦。
	//    虽然计算次数不对，但是消息并不会丢失；所以不会有问题。
    // 6. 由于重试是基于内存的，因此如果一个消费者组里面只有一个消费者，与此同时重试设置的时间比较长，那么这段时间内其它消息消费都会被阻塞掉
	//     因此重试机制，时间不要设置的太长，最好速战速决
    router.AddMiddleware(
		//middleware.InstantAck,
		middleware.CorrelationID,
		middleware.Recoverer,
		dlqMiddleware(),
		// 重试中间件：基本重试功能
		middleware.Retry{
			// MaxRetries:          3,
			// InitialInterval:     500 * time.Millisecond, // 首次重试时间间隔
			// MaxInterval:         time.Minute * 5, // 最大重试时间间隔
			// Multiplier:          2.0, // 重试时间间隔倍数
			// MaxElapsedTime:      time.Minute * 10, // 最大重试时间
			// RandomizationFactor: 0.1, // 随机因子
			// ResetContextOnRetry: true, // 重试时是否重置上下文
			// OnRetryHook: func(retryNum int, delay time.Duration) {
			// 	log.Printf("Retry attempt %d, next delay: %v", retryNum, delay)
			// },
			// ShouldRetry: func(params middleware.RetryParams) bool {
			// 	if params.RetryNum >= 3 {
			// 		return false
			// 	}
			// 	// 自定义重试逻辑，比如某些错误不重试
			// 	return !strings.Contains(params.Err.Error(), "permanent")
			// },
			// Logger: logger,
			MaxRetries:      3,
			InitialInterval: time.Millisecond * 100,
			Logger:          logger,
		}.Middleware,
	)

	// 添加处理器
	// 只有消费者模式下，才会使用
	// 一次AddConsumerHandler 就相当于添加了一个消费者；要并发处理，可以多添加几个（处理函数相同），只是handler_name不同即可
	router.AddConsumerHandler("callback_handler", topic, subscriber, func(msg *message.Message) error {
		fmt.Println("收到消息: ", string(msg.Payload))
		time.Sleep(1 * time.Second)
		// 标记消息已被处理 不要重投消息了
		// 核心在于这里的ack后，消息就不会再被投递了；和下面的错误返回无关
		// msg.Ack()
		return errors.New("处理失败")
	})

	// 设置信号处理
	ctx, cancel := context.WithCancel(context.Background())
	defer cancel()

	sigChan := make(chan os.Signal, 1)
	signal.Notify(sigChan, syscall.SIGINT, syscall.SIGTERM)
	// 在单独的 goroutine 中运行路由器
	go func() {
		if err := router.Run(ctx); err != nil {
			log.Printf("路由器运行失败: %v", err)
			cancel()
		}
		log.Println("消息订阅者已经启动，等待消息...")
	}()

	// 等待订阅者完全就绪
	time.Sleep(2 * time.Second)
	log.Println("订阅者已就绪，开始发布消息...")

	// 发布者逻辑
	err = publisher.Publish(topic, message.NewMessage("", fmt.Appendf([]byte{}, "hello world")))
	if err != nil {
		log.Printf("发布消息失败: %v", err)
	}
	time.Sleep(1 * time.Second)

	// 等待信号
	<-sigChan
	log.Println("收到退出信号，正在关闭...")
	cancel()
	log.Println("关闭成功")
}

// 防止redis无限重试
func dlqMiddleware() message.HandlerMiddleware {
	return func(h message.HandlerFunc) message.HandlerFunc {
		return func(msg *message.Message) ([]*message.Message, error) {
			produced, err := h(msg)
			if err != nil {
				// // 发布到 DLQ（非阻塞示例）
				// dlqMsg := message.NewMessage(uuid.NewString(), msg.Payload)
				// for k, v := range msg.Metadata {
				// 	dlqMsg.Metadata[k] = v
				// }
				// if pub != nil {
				// 	_ = pub.Publish("dead_letter_topic", dlqMsg) // 记录失败消息
				// }
				// 确认消息，防止底层再次重投
				msg.Ack()
				log.Println("消息处理失败，已确认")
				// 返回 nil，表示我们已经处理完（避免 Router/Nack 再触发）
				return nil, nil
			}
			return produced, nil
		}
	}
}
```