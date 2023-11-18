### atomic
atomic是go提供的一个执行原子操作的包，虽然提供了这个包,但是go官方并不是很推荐使用；
除了做一些低级的应用程序外,go更推荐使用通道和sync来处理;

PS: go中的`sync.Mutex`底层都是通过atomic来实现的;这么看`atomic`确实比较低级。

虽然它比较底层，但是我还是有必要了解使用它。

#### 1. 什么是原子操作呢?
可以这么简单的理解,在程序执行某一个操作的时候,在计算机底层其实是分了多个步骤去处理它；
有多个步骤处理，那么就意味着有中间状态（操作中、没操作完的状态）；

而原子操作，**它是一个不可分割的整体,没有中间状态，要么成功了、要么失败了。**，它通过底层的cpu操作去实现。

这样有什么好处,在多goroutine并发操作的同一个数据的时候,可以保护数据的一致性。

#### 2. atomic 概述
在golang中,atomic主要提供了下面几种操作：
1. Store - 存一个值
2. Load - 获取一个值
3. Swap - 更新一个值（返回旧值）
4. Add - 加值
5. CompareAndSwap - 比较然后更新值（如果值还是原来的值，则更新）

另外主要是对下面的类型实现原子操作：
- `int32`
- `int64`
- `uint32`
- `unint64`
- `uintptr` 

函数格式为`操作` + `类型`，比如:
对于int32,会有下列函数:
- `atomic.AddInt32()` 
- `atomic.StoreInt32()` 
- `atomic.LoadInt32()` 
- `atomic.SwapInt32()`
- `atomic.CompareAndSwapInt32()`,其它类型同理。

虽然go提供了函数操作，但是go鼓励我们采用，方法调用（更人性化、不臃肿）.
比如`atomic.AddInt32()`对应的方法为`Add()`非常简洁哦～

#### 3. 函数调用方式
需要注意的是：atomic操作的都是地址
由于每种类型使用方式基本差不多，这里拿`int32`举例演示


```go
package main

import (
	"fmt"
	"sync/atomic"
)

func main() {
	var a int32

	// 将1 存给a变量
	atomic.StoreInt32(&a, 1)

	fmt.Println(a)
	fmt.Println(atomic.LoadInt32(&a)) // 读取a地址的值

	// 更新值
	oldValue := atomic.SwapInt32(&a, 2)
	fmt.Println("新值：", a, "旧值：", oldValue)

	// 添加值
	atomic.AddInt32(&a, 2) // 加2
	fmt.Println("增加后值：", a)
	atomic.AddInt32(&a, -1) // 减1
	fmt.Println("减少后值：", a)

	// 比较后更新 返回是否更新成功
	swapped := atomic.CompareAndSwapInt32(&a, 3, 6) // 如果旧值是3 则更新为6
	fmt.Println("第一次比较更新是否成功：", swapped, "当前值为:", a)

	swapped = atomic.CompareAndSwapInt32(&a, 4, 3) // 如果旧值是4 则更新为3
	fmt.Println("第二次比较更新是否成功: ", swapped, "当前值为：", a)
}

// 1
// 1
// 新值： 2 旧值： 1
// 增加后值： 4
// 减少后值： 3
// 第一次比较更新是否成功： true 当前值为: 6
// 第二次比较更新是否成功:  false 当前值为： 6
```

#### 4. 方法调用方式
go推荐使用这种，简洁。

直接将函数调用方式改成方法调用方式，如下：
```go
package main

import (
	"fmt"
	"sync/atomic"
)

func main() {
	// 使用atomic内置的类型（结构体）
	// 注意这个时候取值 要用a.Load()方式
	var a atomic.Int32

	// 将1 存给a变量
	a.Store(1)

	fmt.Println(a.Load()) // 读取a地址的值

	// 更新值
	oldValue := a.Swap(2)
	fmt.Println("新值：", a.Load(), "旧值：", oldValue)

	// 添加值
	a.Add(2) // 加2
	fmt.Println("增加后值：", a.Load())
	a.Add(-1) // 减1
	fmt.Println("减少后值：", a.Load())

	// 比较后更新 返回是否更新成功
	swapped := a.CompareAndSwap(3, 6) // 如果旧值是3 则更新为6
	fmt.Println("第一次比较更新是否成功：", swapped, "当前值为:", a.Load())

	swapped = a.CompareAndSwap(4, 3) // 如果旧值是4 则更新为3
	fmt.Println("第二次比较更新是否成功: ", swapped, "当前值为：", a.Load())
}
```
看看是不是简介了很多。

#### 5. 无符号类型做减法
对于有符号类型，Add时候直接给一个负数是没有问题的；但是对于无符号类型比如（uint32,uint64）不能直接给负数——无符号没有负数，这个时候需要转换下，

怎么转换下呢？
在Add的时候，加一个**按位取反，然后+1的数**

下面看代码：
```go
package main

import (
	"fmt"
	"sync/atomic"
)

func main() {
	// 无符号类型整数
	var a atomic.Uint32

	// 将1 存给a变量
	a.Store(10)

	fmt.Println(a.Load()) // 读取a地址的值

	// 添加值
	a.Add(2)                       // 加2
	fmt.Println("增加后值：", a.Load()) // 加完后当前为 12
	a.Add(^uint32(3) + 1)          // 减3 按位取反 然后加1

	fmt.Println("第一次减少后值：", a.Load())

	// 减少1
	a.Add(^uint32(1) + 1)
	fmt.Println("第二次减少后值: ", a.Load())

	// 再次减少1
	a.Add(^uint32(0)) // ^uint32(0) 等价于 ^uint32(1) + 1
	fmt.Println("第三次减少后值: ", a.Load())
}

// 10
// 增加后值： 12
// 第一次减少后值： 9
// 第二次减少后值:  8
// 第三次减少后值:  7
```


#### 6. Value类型（任意类型）
前面的操作都是针对某个类型的操作,这个类型可以对任意类型操作
PS: 这种类型，没有Add方式

```go
package main

import (
	"fmt"
	"sync/atomic"
)

type Person struct {
	name string
	age  int8
}

func main() {
	// 任意类型
	var a atomic.Value

	p := Person{
		name: "张三",
		age:  18,
	}
	// 将p 结构体存入
	a.Store(p)

	fmt.Printf("取出值为：%#v\n", a.Load()) // 读取a地址的值
}

// 取出值为：main.Person{name:"张三", age:18}
```
