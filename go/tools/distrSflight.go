package utils

import (
	"context"
	"errors"
	"fmt"
	"log"
	"time"

	"github.com/google/uuid"
	"github.com/redis/go-redis/v9"
)

// 定义 Redis key 的前缀，方便管理
const (
	resultKeyPrefix  = "dist_sflight:result:"
	lockKeyPrefix    = "dist_sflight:lock:"
	channelKeyPrefix = "dist_sflight:channel:"
	// 释放锁脚本
	releaseLockScript = `
		if redis.call("get", KEYS[1]) == ARGV[1] then
      	return redis.call("del", KEYS[1])
    else
        return 0
    end
	`
)

// DistrSflight 结构体封装了所有需要的依赖和配置，
// 实现了一个跨进程/跨机器的 single-flight 模式。
type DistrSflight struct {
	client      *redis.Client
	lockTTL     time.Duration // 分布式锁的过期时间
	resultTTL   time.Duration // 结果的过期时间
	waitTimeout time.Duration // 等待通知的超时时间
}

// NewDistrSflight 创建一个新的 DistrSflight 实例
func NewDistrSflight(client *redis.Client, lockTTL, resultTTL, waitTimeout time.Duration) *DistrSflight {
	return &DistrSflight{
		client:      client,
		lockTTL:     lockTTL,
		resultTTL:   resultTTL,
		waitTimeout: waitTimeout,
	}
}

// Do 是核心方法，它执行一个函数 fn，并确保在分布式环境中只有一个实例执行
func (s *DistrSflight) Do(ctx context.Context, key string, fn func() (string, error)) (string, error) {
	resultKey := resultKeyPrefix + key
	lockKey := lockKeyPrefix + key
	channelKey := channelKeyPrefix + key
	taskId := s.taskID()

	// 1. 尝试直接从结果key获取数据 (快速路径)
	val, err := s.client.Get(ctx, resultKey).Result()
	if err == nil {
		log.Printf("taskId %s: cache hit for key %s", taskId, key)
		return val, nil
	}
	if err != redis.Nil {
		// 如果是除了 "key not found" 之外的其它Redis错误，直接返回
		return "", fmt.Errorf("redis GET error: %w", err)
	}

	// 结果不存在，进入慢速路径，准备抢锁
	log.Printf("taskId %s: cache miss for key %s, trying to acquire lock", taskId, key)

	// 2. 尝试获取分布式锁
	ok, err := s.client.SetNX(ctx, lockKey, taskId, s.lockTTL).Result()
	if err != nil {
		return "", fmt.Errorf("redis SETNX error: %w", err)
	}

	if ok {
		// 3. 成功获取锁，成为 "Leader"
		log.Printf("taskId %s: acquired lock for key %s. executing function...", taskId, key)

		// 使用 defer 确保锁一定会被释放
		defer func() {
			// 使用Lua脚本保证原子性：只有当锁的value匹配时才删除，防止误删其它协程的锁
			s.client.Eval(ctx, releaseLockScript, []string{lockKey}, taskId)
			log.Printf("taskId %s: released lock for key %s", taskId, key)
		}()

		// 执行耗时的业务逻辑
		result, fnErr := fn()
		if fnErr != nil {
			// 如果业务逻辑出错，不缓存结果，直接返回错误
			// 并且通知其它等待者，让它们自己重试
			s.client.Publish(ctx, channelKey, "error")
			return "", fnErr
		}

		// 业务逻辑成功，将结果存入 Redis
		err = s.client.Set(ctx, resultKey, result, s.resultTTL).Err()
		if err != nil {
			// 如果设置结果失败，也认为本次操作失败
			s.client.Publish(ctx, channelKey, "error")
			return "", fmt.Errorf("failed to set result to redis: %w", err)
		}

		log.Printf("taskId %s: function executed, result stored in redis. key: %s", taskId, key)

		// 发布"完成"消息到频道，通知所有等待者
		s.client.Publish(ctx, channelKey, "done")

		return result, nil
	}

	// 4. 获取锁失败，成为 "Follower"，等待结果
	log.Printf("taskId %s: failed to acquire lock for key %s. waiting for result...", taskId, key)
	return s.waitForResult(ctx, taskId, resultKey, channelKey)
}

// waitForResult 封装了等待者（Follower）的逻辑
func (s *DistrSflight) waitForResult(ctx context.Context, taskId, resultKey, channelKey string) (string, error) {
	pubsub := s.client.Subscribe(ctx, channelKey)
	defer pubsub.Close()

	// 创建一个带超时的上下文
	waitCtx, cancel := context.WithTimeout(ctx, s.waitTimeout)
	defer cancel()

	// 等待通知
	select {
	case <-waitCtx.Done():
		// 等待超时
		log.Printf("taskId %s: wait timed out", taskId)
	case msg := <-pubsub.Channel():
		// 收到了来自 Leader 的通知
		log.Printf("taskId %s: received notification: %s", taskId, msg.Payload)
	}

	// 无论收到通知还是超时，都再次尝试获取结果
	// 这是因为即使收到通知，也可能因为网络延迟等原因结果还没写入
	// 或者等待超时后，结果可能已经写入了
	val, err := s.client.Get(ctx, resultKey).Result()
	if err == nil {
		log.Printf("taskId %s: got result after waiting.", taskId)
		return val, nil
	}
	if err == redis.Nil {
		// 可能是Leader执行失败或其它异常情况，结果仍未写入
		return "", errors.New("leader finished but result is not available")
	}

	return "", fmt.Errorf("redis GET error after waiting: %w", err)
}

// 任务id（用于标记一个任务，方便日志查看）
func (s *DistrSflight) taskID() string {
	return uuid.NewString()
}
