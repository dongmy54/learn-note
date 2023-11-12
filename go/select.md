### select
在开始介绍select之前，我们先说一个概念`多路复用`

什么是多路复用呢？
我们从一个大家所熟知的场景说起，比如在一个学校里面要举行运动会，运动会上有许多的比赛项目，比如：100米短跑、跳远、跳绳、篮球等等；总之很多,这些项目许多都是同时进行的，做为学校广播室的播音员，需要实时报道各项目的进行情况；在这种情况下就需要，播音员随时根据各个项目的比赛进度，进行报道;

同时关注各个项目的比赛进度，一旦有进展，就进行报道；这个过程我们就可以称之为多路复用。

类比到计算机里,我们有多个gorountine同时在进行,我们需要实时监控各个gorountine的执行情况；在go中是通过`select`实现的。

`select`通过对多个通道的监控，来实现不同功能，比如监控到通道1有值时做A任务；通道2有值做B任务。



#### 1. select特点
1. 哪个通道准备好，执行哪个通道
2. 多个通道都准备好，从中随意选择执行
3. 不带default,没有通道准备好，则阻塞
4. 带default,没有通道准备好，则执行default

#### 2. select用法
它的语法如下：
```go
select {
  case // 通道1xx:
    // 执行A操作
  case // 通道2xx:
    // 执行B操作
  default:
    // 执行默认操作
}
```

比如：
```go
package main

import (
	"fmt"
	"time"
)

func main() {
	// 初始化两个通道
	ch1 := make(chan string)
	ch2 := make(chan string)

	go func() {
		time.Sleep(time.Second)
		ch1 <- "channle 1 string"
	}()

	go func() {
		time.Sleep(time.Second)
		ch2 <- "channle 2 string"
	}()

	// 这里等待两个通道 所以for写了两次
	for i := 0; i < 2; i++ {
		select {
		case msg1 := <-ch1: // 通道1接收到值
			fmt.Println("recevie: ", msg1)
		case msg2 := <-ch2: // 通道2接收到值
			fmt.Println("recevie: ", msg2)
		}
	}
}
```

#### 3. select 带default
先看代码，我们直接在上面的代码中加上default，执行看看：
```go
package main

import (
	"fmt"
	"time"
)

func main() {
	// 初始化两个通道
	ch1 := make(chan string)
	ch2 := make(chan string)

	go func() {
		time.Sleep(time.Second)
		ch1 <- "channle 1 string"
	}()

	go func() {
		time.Sleep(time.Second)
		ch2 <- "channle 2 string"
	}()

	// 这里等待两个通道 所以for写了两次
	for i := 0; i < 2; i++ {
		select {
		case msg1 := <-ch1: // 通道1接收到值
			fmt.Println("recevie: ", msg1)
		case msg2 := <-ch2: // 通道2接收到值
			fmt.Println("recevie: ", msg2)
		default:
			fmt.Println("execute select default")
		}
	}
}
```
会发现执行结果为：
```
execute select default
execute select default
```
为啥两次都执行到默认值呢，可能你会比较困惑。因为在for循环两次执行select的时,`ch1`和`ch2`都没有准备好（他们阻塞在sleep）,所以都去执行default了；default执行的非常快，两次执行完花费的时间通道都没有准备好，有兴趣你可以适当延长default执行时间试试。

上面的default虽然加了，但是没啥意义，下面我们写一个稍微有意义的代码：
```go
package main

import (
	"fmt"
	"time"
)

func main() {
	// 初始化两个通道
	ch := make(chan string)

	go func() {
		// 向通道发送10次值
		for i := 0; i < 10; i++ {
			time.Sleep(time.Second)
			ch <- fmt.Sprintf("%v time msg", i)
		}
	}()

	// 定时器 5s后触发
	timer := time.NewTimer(5 * time.Second)
	for {
		select {
		case msg := <-ch: // 通道接收到值
			fmt.Println("recevie: ", msg)
		case <-timer.C: // 5s后结束
			fmt.Println("finished!")
			return // 退出for
		default:
			time.Sleep(1 * time.Second) // 避免default执行太快 增加耗时
			fmt.Println(time.Now(), "execute select default")
		}
	}
}
```

执行输入如下
```
2023-11-12 21:59:06.38006 +0800 CST m=+1.001353869 execute select default
recevie:  0 time msg
2023-11-12 21:59:07.380926 +0800 CST m=+2.002264357 execute select default
recevie:  1 time msg
2023-11-12 21:59:08.38216 +0800 CST m=+3.003541897 execute select default
recevie:  2 time msg
2023-11-12 21:59:09.382799 +0800 CST m=+4.004225373 execute select default
recevie:  3 time msg
2023-11-12 21:59:10.38338 +0800 CST m=+5.004850410 execute select default
recevie:  4 time msg
finished!
```
