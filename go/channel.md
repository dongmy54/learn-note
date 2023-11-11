### channel-通道
为什么要有通道呢？
通道的作用是解决各个gorountine之间通行的问题;

在开始之前可以先记住一个原则，通道必须和gorountine一起使用，一个直观的体现就是必须要和`go`关键字搭配使用。
其实也非常好理解，因为如果只有一个gorountine，那么也用不着通信，所以也就用不着通道了。

#### 1. 如何理解通道？
我们可以把通道类比为队列-（先进先出）,因此在它内部是可以存值和取值的，但是它有些自己的特点:
1. 线程安全
2. 它是一种类型,用`chan`表示,`chan int`代表这是一个int型的通道
3. 既然它是一种类型,那就涉及是引用类型还是值类型，它是引用类型，所以需要make初始化

对于通道的操作来讲，主要就三种操作：
1. `ch<- 10` 往通道存值
2. `<-ch ` 从通道取值
3. `close(ch)` 关闭通道

PS: 
- ch这里是一个通道类型的变量名,不是go关键字
- 如何记忆呢 <-指向通道，则存/否则取值

#### 2. 定义通道
前面说了一大堆，一行代码没看，我们来定义通道,写一段代码看看,前面说了**通道是引用类型**,因此我们需要通过make初始化通道。

```go
package main

import "fmt"

func main() {
	ch := make(chan int) // 定义一个装int型的通道

	go func() {
		ch <- 10 // 从通道存
	}()

	fmt.Println(<-ch) // 从通道取
}
```

上面的代码可以正确运行，会打印出10；我们先不用纠结为是10；我还是继续讨论这里的为啥必须用make初始化，下面不用make看看
```go
package main

import "fmt"

func main() {
	var ch chan int // 定义一个装int型的通道,通道是引用类型,没有make是nil

	go func() {
		ch <- 10 // 从通道存
	}()

	fmt.Println(<-ch) // 从通道取
	// fatal error: all goroutines are asleep - deadlock! 
}
```
看到了吧 报错了，如果你是一个初学者，很可能会多次遇到上述错误。

#### 3. 通道的阻塞性
通道在存和取的过程中是存在阻塞的,那么什么时候阻塞呢？
比如：
  1. 从通道中取出一个值`<- ch` 而此时通道中没有值
  2. 向通道中存入一个值`ch<- 10` 而此时通道中没有地方可以存 

然后我们再回过头来看通道定义中的代码
```go
func main() {
	ch := make(chan int) // 定义一个装int型的通道

  // goroutinue 是异步的不会阻塞
	go func() {
		ch <- 10 // 向通道中存ch
	}()

  // 但是执行到这里 从通道中取值(<-ch)但是此时通道中并没有值，所以阻塞了
	// 等待前面的go 匿名函数中存入通道后，这里阻塞解除，打印出了10
	fmt.Println(<-ch) // 从通道取
}
```

上述代码加了注释，希望可以帮助你理解通道中的阻塞。

#### 4. 非缓冲通道- 同步通道
什么是非缓冲通道?
指的是通道中一个元素也不能存下,存入和取出必须同时进行，这有点像两个人A和B,A只能直接把东西交给B,不能放到快递点后，过一段时间B再去取;因此非阻塞通道也叫同步通道。

再定义通道的例子中那就是一个同步通道，打印的时候和存必须同时进行。
我们再来看一个例子
```go
package main

import "fmt"

func main() {
	ch := make(chan int) // 非缓冲通道 - 同步通道
  
	// 理论上：这里会阻塞 因为ch是一个非缓冲通道，它在等待另一个goruntine 从通道取值
	// 但是这里找不到其它gorountine 取值
	// 所以这里会deadlock报错
	// 这也是为什么说通道都是和go关键字一起使用的原因
	ch <- 10
	fmt.Println(<-ch) // 虽然这里是向通道取值 但是他们不是另外一个gorountine
}
```
改成下面这样，程序将正常运行
```go
package main

import "fmt"

func main() {
	ch := make(chan int) // 非缓冲通道 - 同步通道

	// 有go关键字哦
	go func() {
		fmt.Println(<-ch)
	}()

	ch <- 10
}
```

#### 5. 缓冲通道
经过前面的非缓冲通道的叙述，相信聪明的你，一定能立马清楚什么是缓冲通道：
**也就是通道中可以存一定数量的东东,现在在也不用像上面那么一手交钱一手交货啦**

我们还是来看一段代码
```go
package main

import (
	"fmt"
	"time"
)

func main() {
	ch := make(chan int, 6) // 这个通道可以存6个元素

	go func() {
		// 由于从通道中取（range)中有sleep
		// 且由于这里是(缓冲通道) 所以这里会一次将6个值全部存入通道 并不会阻塞
		for i := 0; i < 6; i++ {
			ch <- i
		}

		close(ch) // 存完后关闭通道 不会影响通道的接收
		fmt.Println("6个通道元素全部存完")
	}()

	for i := range ch {
		fmt.Printf("从通道取出值: %d\n", i)
		time.Sleep(time.Second)
	}
}
```
输出结果如下：
```
6个通道元素全部存完
从通道取出值: 0
从通道取出值: 1
从通道取出值: 2
从通道取出值: 3
从通道取出值: 4
从通道取出值: 5
```

#### 6. 单向通道
顾名思义，单向，要么是只能存，要么只能取；
一般是用于函数参数中

看代码
```go
package main

import (
	"fmt"
)

// ch只能存
func counter(ch chan<- int) {
	for i := 0; i < 6; i++ {
		ch <- i
	}

	close(ch) // 存完后关闭通道（放心不影响取）
}

// ch1只能存
// ch2只能取
func squarer(ch1 chan<- int, ch2 <-chan int) {
	for i := range ch2 {
		ch1 <- i * i
	}

	close(ch1) // ch1存完关闭
}

// ch 只能取
func printer(ch <-chan int) {
	for i := range ch {
		fmt.Println(i)
	}
}

func main() {
	ch1 := make(chan int)
	ch2 := make(chan int)
	go counter(ch1)
	go squarer(ch2, ch1)

	printer(ch2)
}
```

#### 7.通道取值
主要有两种方式：
1. range
```go
for i := range ch{
	// xxx
}
```
2. data,ok := ch
```go
for {
	if data,ok := ch; ok{
		// xxx
	} else {
		break
	}
}
```
这两种方式都必须要close(ch)

#### 8. close通道
通道和文件不同，创建后通道可以不用写close;它可以被垃圾回收；
但是推荐再发送完后都写下，这样做的一个好处时，可以`range` 和 `data,ok`取值。

对于close另外一点是，close通道后，即使通道内还有数据，也不影响接收，所以放心大胆的`close`吧.


