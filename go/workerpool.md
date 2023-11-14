### WorkerPool
worker pool也就计算机中的生产者、消费者模型;一边负责生产任务、一边负责处理（消费）任务；

在golang中是通过channel用做任务队列,用gorounite从channel中取任务执行实现的。

#### 1. 简单示例
其实无论多么负责的代码都是简单的地方堆叠而成，我们只要看懂这个简单的实现；其它复杂的也能很容易懂。

下面的例子虽然比较简陋，但它阐述了worker pool的核心点。

```go
package main

import (
	"fmt"
	"time"
)

func main() {
	const numJobs = 10 // jobs数

	jobs := make(chan int, numJobs)   // 任务队列
	result := make(chan int, numJobs) // 处理结果队列

	for i := 0; i < 10; i++ {
		jobs <- i // 加任务到jobs中
	}
	close(jobs) // 加完关闭

	// 开4个gorotinue 去处理任务
	for i := 0; i < 4; i++ {
		go worker(i+1, jobs, result)
	}

	for i := 0; i < numJobs; i++ {
		fmt.Printf("result: %d\n", <-result)
	}
}

// id worker id
// jobs 任务通道
// result 结果通道
func worker(id int, jobs <-chan int, result chan<- int) {
	fmt.Printf("worker: %d start\n", id)
	for job := range jobs {
		time.Sleep(time.Second) // 模拟耗时间操作
		// 计算结果存入result 通道
		result <- job * job
	}
	fmt.Printf("worker: %d completed!\n", id)
}
```
```
worker: 4 start
worker: 1 start
worker: 2 start
worker: 3 start
result: 9
result: 4
result: 1
result: 0
result: 36
result: 16
worker: 2 completed!
result: 25
result: 49
worker: 4 completed!
worker: 3 completed!
result: 81
worker: 1 completed!
result: 64
go run main1.go  0.19s user 0.16s system 10% cpu 3.284 total
```
我们通过`time go run main.go`测试输出如下



最后一行`0.19s user 0.16s system 10% cpu 3.284 total`含义为:
- 0.19s 在用户态执行时间
- 0.16s 在内核态执行时间
- 10% cpu使用律
- 3.284 代码程序执行总时间

我们一个任务需要执行1s,十个任务理论需要执行10s;由于我们开启了四个gorounite我们只花了3.28s。

#### 2. 封装结构体
上面的代码稍微简陋，下面我们写个稍微完整点的实现。

我们可以把它封装到一个结构体中,只需要设定好worker数量,然后添加任务任务进去就可以自动执行即可。

```go
package main

import (
	"log"
	"runtime"
	"time"
)

type WorkerPool struct {
	maxWorkers  int         // worker数量
	queuedTaskC chan func() // 任务通道队列 类型为函数
}

// 运行
func (wp *WorkerPool) Run() {
	for i := 0; i < wp.maxWorkers; i++ {
		// 开启maxWorkers个worker
		go func() {
			for task := range wp.queuedTaskC {
				task() // 执行任务
			}
		}()
	}
}

// 添加task
func (wp *WorkerPool) AddTask(task func()) {
	wp.queuedTaskC <- task
}

// 工厂方法返回一个workerPool
func NewWorkerPool(maxWorkers int) *WorkerPool {
	// 这里queuedTaskC 必须用make初始化（它是引用类型）队列缓存大小10
	return &WorkerPool{maxWorkers: maxWorkers, queuedTaskC: make(chan func(), 10)}
}

func main() {
	// 等待通道
	waitC := make(chan bool)

	// 每秒中检查当前有多少个gorountine
	go func() {
		for {
			time.Sleep(time.Second)
			log.Printf("[main] Total current goroutine: %d", runtime.NumGoroutine())
		}
	}()

	wp := NewWorkerPool(5)

	wp.Run() // 先运行起来
	for i := 0; i < 10; i++ {
		id := i + 1 // 注意这里 匿名函数参数引用的原因
		// PS: 匿名函数(非执行)不能是一个带参数的函数;通过匿名函数的特性传参数
		wp.AddTask(func() {
			log.Printf("[main] Starting task %d\n", id)
			time.Sleep(time.Second) // 模拟耗时间操作
			log.Printf("[main] Finished task %d\n", id)
		})
	}

	// 如果没有值进来会阻塞在这里
	<-waitC
}
```
