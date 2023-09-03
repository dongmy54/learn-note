### goroutinue 和 channel
在正式学习go之前，对go的一个基本了解是，它非常适合高并发场景；但自己并不了高并发场景代码是如何编写的。

这就要说到今天的主角goroutine和channel了。

#### 一、什么是goroutinue?
在操作系统层我们知道有进程和线程，线程位于进程之下，线程相比于进程更轻量，因此我们在其它变成语言中可以看到对于并发场景可以采用多线程编程。

但是在go中，认为线程还不够轻量，于是搞出了goroutinue（协程），一般而言一个goroutinue大小为（4-8K），而一个线程大小一般在几M左右；可以看出goroutine确实非常的轻量；这也是为什么go可以轻松的开启上万个goroutine的原因。

- 上下文开销切换大小：
> **进程 > 线程 > goroutine(协程)**

对**goroutinue我们可以通过类比线程去理解**，比如开启一个goroutine可以简单的类比开启了一个线程（其它语言）。

- 那么goroutine和线程之间到底有什么关系呢？
1. **goroutinue是go并发执行单元**（由go运行时调度-go内部的）
2. 线程是操作系统级并执行单元（由操作系统内核调度）
3. **多个goroutine可在一个线程内交替执行**，它于线程的映射是由go去管理的，开发者不需要直接管理
4. goroutine切换更轻量，切换开销更小

- goroutinue有什么用？
**让程序异步执行，增加了并发性，提高性能**

- goroutinue是并发还是并行执行呢？
默认情况下goroutinue是并发执行的，默认在一个核心上执行，如果要在多个核心上并行执行需要设置GOMAXPROCS大于1.

现在我们对goroutinue已经有了一个大体的认识，但是还不清楚如何开启gorotinue?

#### 二、如何开启goroutine?
开启goroutine非常简单，通过go关键字就可以开启，语法如下：
> go 函数

例子
```go
package main

import (
	"fmt"
	"time"
)

func main() {
	// 开启goroutine（以外部函数）
	go hello()
	// 以匿名函数方式开启gorotinue
	go func() {
		fmt.Println("匿名函数goroutine")
	}()

	// 等待异步执行完成
	time.Sleep(time.Second)
}

func hello() {
	fmt.Println("hello world!")
}
```

运行结果：
```shell
dongmingyan@pro ⮀ ~/go_playground/play ⮀ go run .
匿名函数goroutine
hello world!
```

#### 三、sync.WaitGroup优化time.Sleep
虽然上面的代码中我们开启goroutine,但是引入了time.Sleep不够优雅，我们优化下，在go中可以通过`sync.WaitGroup`自动等待goroutine结束，而不用通过time.Sleep去保证。

优化后代码如下：
```go
package main

import (
	"fmt"
	"sync"
)

var wg sync.WaitGroup

func main() {
	wg.Add(2) // 开启了两个goroutinue所以这里写2

	// 开启goroutine（以外部函数）
	go hello()
	// 以匿名函数方式开启gorotinue
	go func() {
		fmt.Println("匿名函数goroutine")
		wg.Done() // 标记该goroutine已完成
	}()

	// 等待异步执行完成
	wg.Wait()
}

func hello() {
	fmt.Println("hello world!")
	wg.Done()
}
```

#### 四、channel-通道
在开始介绍channel-通道之前，先来看一个问题：

假设我们有两个goroutine，分别用于做计算任务，我们希望在他们完成计算结果后，将结果合并展示到外层主程序，我们如何实现呢？

```go
// 伪代表

func main() {
  go worker1() // 两个worker做计算任务
  go worker2() 

  // 这里汇总结果
  // go worker1() + go worker2()
}
```

我们知道两个worker采用goroutine（协程）方式启动，他们是异步的，需要把结果汇总,我们可以定义一个共享变量,但是这样会引发竞态问题。

到这里，我们的channel可以登场了，它的主要作用在：
> **解决协程之间的通信和同步，避免使用共享数据引发竞态问题**

- 那么为什么通道可以做到呢？
**通道是线程安全的，同一个时间点只有一个goroutine可以从通道中写入/读取**

有了这个基本认识，我们看看通道如何解决上面的问题：
```go
package main

import (
	"fmt"
	"time"
)

func worker1(ch chan int) {
	// 模拟耗时工作
	time.Sleep(time.Second)
	ch <- 42 // 将结果发送到通道
}

func worker2(ch chan int) {
	// 模拟耗时工作
	time.Sleep(2 * time.Second)
	ch <- 23 // 将结果发送到通道
}

func main() {
	// 创建一个整数通道
	ch := make(chan int)

	// 启动两个协程进行工作
	go worker1(ch)
	go worker2(ch)

	// 从通道接收工作结果
	result1 := <-ch
	result2 := <-ch

	// 合并结果
	finalResult := result1 + result2

	fmt.Printf("Final Result: %d\n", finalResult)
}
```
```shell
dongmingyan@pro ⮀ ~/go_playground/play ⮀ go run .
Final Result: 65
```

#### 五、探究channel语法
我们在四中看到了如何用channel解决问题，但是并没有说明其语法特性，这里做说明。

**channel是一种数据线程安全的数据结构，类似于队列，遵循先进先出。**

channel用`chan`表示,
##### 1. channel 根据是否可以写/读可以分成三种：
```go
// 双向 可读也可写
func dd(ch chan int) {
	ch <- 1
	fmt.Println(10)
}

// 只能（发送）写
func foo(ch chan<- int) {
	ch <- 1
}

// 只能(接收）读
func bar(ch <-chan int) {
	fmt.Println(<-ch)
}
```

##### 2. channel分为无缓冲通道/缓冲通道
无缓冲通道：**没有指定通道大小默认为0，单独的写和读都会导致阻塞；同时一边读且另一边读的时候才不会阻塞，因此它是同步的，又称同步通道。**
```go
package main

import (
	"fmt"
)

func main() {
	ch := make(chan int) // 无缓冲通道 没有指定通道大小默认为0
	go foo(ch)
	fmt.Println(<-ch)
}

func foo(ch chan<- int) {
	ch <- 1
}
```

缓冲通道：**在初始化通道时，指定缓冲数；这样可以在现将数据先行发送到通道中，直到缓冲区满，才会阻塞。因此又称异步通道。**
```go
package main

import (
	"fmt"
)

func main() {
	ch := make(chan int, 10) // 缓冲通道 初始化时指定大小为10
	go foo(ch)

	// rang 通道可以遍历通道 在通道关闭后自动停止
	for x := range ch {
		fmt.Println(x)
	}
}

func foo(ch chan<- int) {
	for i := 0; i < 10; i++ {
		ch <- i
	}
	close(ch) // 关闭通道
}
```

##### 3. 通道的使用条件
通道的使用是有条件的，并非所有时候都能使用通道，使用不当会报错-死锁！
> fatal error: all goroutines are asleep - deadlock!

1. 必须搭配goroutine使用
2. 比如要同时有通道的发送 - 接收，这是一对

##### 4. `var ch1 chan int`和`ch1 := make(chan int)`区别
`var ch1 chan int`只声明了通道变量，此时并没有初始化，没有分配真正的内存空间，这个时候直接使用是会报错的。

下面会报错
```go
package main

import (
	"fmt"
)

func main() {
	var ch chan int
	// ch = make(chan int) // 打开这里注释才不会报错
	go foo(ch)

	// rang 通道可以遍历通道 在通道关闭后自动停止
	fmt.Println(<-ch)
}

func foo(ch chan<- int) {
	ch <- 1
}
```

##### 5. 通道读取结果判断
主要用两种方式：
```go
// 1. range 方式（推荐）
for x := range ch{
  //...
}

// 2. val , oK := <- ch 方式
for {
		i, ok := <-ch
		if !ok {
			fmt.Println("通道关闭")
			break
		}

		fmt.Println("读取成功，值为：", i)
	}
```

##### 6. select同时监听多个通道
select 同时监听多个通道，从而实现多通道的非阻塞操作。select 会找其中已经就绪的case去执行

它类似于switch，只不过这里作用对象是通道，它可以实现许多有用的操作，比如超时退出、多久执行一次等等。

```go
package main

import (
	"fmt"
	"time"
)

func main() {
	ch1 := make(chan string)
	ch2 := make(chan string)

	go func() {
		time.Sleep(2 * time.Second) // 2s后发送
		ch1 <- "Hello from ch1"
	}()

	go func() {
		time.Sleep(3 * time.Second) // 3s后发送
		ch2 <- "Hello from ch2"
	}()

	for {
		select {
		case msg1 := <-ch1: // 当ch1接收到后 执行
			fmt.Println(msg1)
		case msg2 := <-ch2: //当ch2接收到后 执行
			fmt.Println(msg2)
		case <-time.After(3 * time.Second): // 3s后超时
			fmt.Println("Timeout: No message received")
			return
		}
	}
}
```

输出：
```shell
dongmingyan@pro ⮀ ~/go_playground/play ⮀ go run .
Hello from ch1
Hello from ch2
Timeout: No message received
```










