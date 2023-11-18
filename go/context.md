### context
context字面意思是上下文,它有什么用呢？
它主要用于多gorountine、多层级的goroutine（一个goroutine下又有goroutine-子goroutine）的情况下，上层对于开启的gorotine的取消。

另外一个作用是，传递值，可以将一些特殊值塞入context中,在后续可以取出来。

ok,我们简单总结下context的作用：
1. 控制goroutine的取消
2. 值传递

下面我们从代码层面说明,先看最简单的值传递。

### 1.值传递
#### 1.1 `context.WithValue`值传递
这个最简单，需要注意的是
1. 这里的key不能用golang的内置类型，需要自定义一个类型；
2. `Value()` 取出之前的存的值
```go
package main

import (
	"context"
	"fmt"
)

// 上下文值类型 需要自定义类型
type mystring string

func main() {
	// mystring("abc") 将“bac"转换成mystring类型
	ctx := context.WithValue(context.Background(), mystring("abc"), "hello")
	doTask(ctx)
}

func doTask(ctx context.Context) {
	// 从上下文中取出值
	fmt.Println(ctx.Value(mystring("abc")))
}

// hello
```

### 2. 取消

#### 2.1 取消概述
下面我们来看下取消，取消主要有两种：
1. 主动调用`cancel`
2. 到期取消`timeout` / `deadline`

如何实现goroutine的取消呢？
是通过`Done()`方法实现,它是通道；在超时或者手动取消后，会有值弹出；
在后续goroutine中通过监测Done()通道实现取消。

PS：
1. 在context建立后，需要cancel保证资源的释放
2. 在取消后,多次调用`Done()`都会有值返回

好啦！下面看代码

#### 2.2 手动cancel
```go
package main

import (
	"context"
	"log"
	"time"
)

func main() {
	ctx, cancel := context.WithCancel(context.Background())
	defer cancel() // 保证资源释放

	go doTask(ctx)              // goroutine中做任务
	time.Sleep(5 * time.Second) // 5s 后触发取消
	cancel()
	time.Sleep(time.Second) // 等待1s后退出 看到 ctx.Done内容
}

func doTask(ctx context.Context) {
	for {
		select {
		case <-ctx.Done(): // 收到取消
			log.Printf("取消啦：%s\n", ctx.Err())
			return // 退出for循环
		default:
		}

		time.Sleep(time.Second) //耗时间操作
		log.Printf("do task ...\n")
	}
}

// 2023/11/18 16:42:04 do task ...
// 2023/11/18 16:42:05 do task ...
// 2023/11/18 16:42:06 do task ...
// 2023/11/18 16:42:07 do task ...
// 2023/11/18 16:42:08 do task ...
// 2023/11/18 16:42:08 取消啦：context canceled
```

#### 2.3 超时取消
通过`context.WithTimeout`或者`context.Deadline`实现
这两者使用非常相似,差别在于一个传递的是到期时间，另外一个传时间间隔。

```go
// 传时间间隔
ctx, cancel := context.WithTimeout(context.Background(), 5 * time.Second)
// 传时间
ctx, cancel := context.WithDeadline(context.Background(), time.Now().Add(5*time.Second))
```

完整代码如下：
```go
package main

import (
	"context"
	"log"
	"sync"
	"time"
)

var w sync.WaitGroup

func main() {
	// 5s超时间
	ctx, cancel := context.WithTimeout(context.Background(), 5*time.Second)
	defer cancel()

	w.Add(1)
	go doTask(ctx) // goroutine中做任务

	w.Wait() // 等待执行完
}

func doTask(ctx context.Context) {
	for {
		select {
		case <-ctx.Done(): // 操时收到
			log.Printf("取消啦：%s\n", ctx.Err())
			w.Done()
			return // 退出for循环
		default:
		}

		time.Sleep(time.Second) //耗时间操作
		log.Printf("do task ...\n")
	}
}

// 2023/11/18 16:51:40 do task ...
// 2023/11/18 16:51:41 do task ...
// 2023/11/18 16:51:42 do task ...
// 2023/11/18 16:51:43 do task ...
// 2023/11/18 16:51:44 do task ...
// 2023/11/18 16:51:44 取消啦：context deadline exceeded
```

#### 2.4 多层取消
上面我们演示的都是一层的gorotine的取消，下面看看多层取消(goroutine 又生成goroutine的情况)

```go
package main

import (
	"context"
	"log"
	"time"
)

func main() {
	// 5s超时间
	ctx, cancel := context.WithDeadline(context.Background(), time.Now().Add(time.Second*5))
	defer cancel()

	go doTask(ctx) // goroutine中做任务

	time.Sleep(6 * time.Second) // 留一定时间看task输出
}

func doTask(ctx context.Context) {
	// 子goroutine
	go doChildTask(ctx)

	for {
		select {
		case <-ctx.Done(): // 操时收到
			log.Printf("do task取消啦: %s\n", ctx.Err())
			return // 退出for循环
		default:
		}

		time.Sleep(time.Second) //耗时间操作
		log.Printf("do task ...\n")
	}
}

// task的子task
func doChildTask(ctx context.Context) {
	for {
		select {
		case <-ctx.Done(): // 操时收到
			log.Printf("child task取消啦: %s\n", ctx.Err())
			return // 退出for循环
		default:
		}

		time.Sleep(time.Second) //耗时间操作
		log.Printf("do child task ...\n")
	}
}


// 2023/11/18 16:59:34 do child task ...
// 2023/11/18 16:59:34 do task ...
// 2023/11/18 16:59:35 do child task ...
// 2023/11/18 16:59:35 do task ...
// 2023/11/18 16:59:36 do task ...
// 2023/11/18 16:59:36 do child task ...
// 2023/11/18 16:59:37 do child task ...
// 2023/11/18 16:59:37 do task ...
// 2023/11/18 16:59:38 do child task ...
// 2023/11/18 16:59:38 do task ...
// 2023/11/18 16:59:38 child task取消啦: context deadline exceeded
// 2023/11/18 16:59:38 do task取消啦: context deadline exceeded
```


