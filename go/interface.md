## interface
interface是go中一个非常重要的概念，使用的地方非常非常多，有必要好好学习。

- 那什么是接口呢？
在现实中我们有usb接口、type-c接口、HDMI接口,它们是一种约定,凡是实现了这个约定的电源线，插上就能有对应的功能;

回到go中,go的接口也类似这样,**它是一种约定，约定实现了xx方法，那么就实现了该接口**。


- 接口有什么用呢？
一句话表述：**可以实现多态和灵活的数据类型设计、代码接耦**。

### 1. 接口定义
接口定义非常简单
```go
type 接口名称 interface {
  方法签名
}
```

### 2. 多态实现
go是一个强类型语言, 有了接口，我们可以把具有相同功能的对象抽象为一个接口，从而实现多态。
```go
package main

import "fmt"

// 定义一个Speaker接口
type Speaker interface {
	// 这个接口中需要包含一个say方法
	say()
}

type Dog struct{}

// dog实现了Speaker接口
func (d Dog) say() {
	fmt.Println("汪汪汪！")
}

type Cat struct{}

// cat实现了Speaker接口
func (c Cat) say() {
	fmt.Println("喵喵喵")
}

// 对Speaker切片元素调用say方法
func Speak(s []Speaker) {
	for _, sp := range s {
		sp.say() // 多态体现
	}
}

func main() {
	// 初始化一个长度为2的 Speaker接口类型的切片
	s := make([]Speaker, 2)

	s[0] = Cat{}
	s[1] = Dog{}

	Speak(s)
}

// 喵喵喵
// 汪汪汪！
```

### 3. 解耦合实现
假设在我们的项目中需要支持多种支付方式，比如微信支付、支付宝支付、银行卡支付，该如何实现呢？
```go
package main

// 支付方式
type PaymentMethod interface {
	// 支付
	Pay(amount float32) error
	// 退款
	Refund(amount float32) error
}

// 支付宝支付
type AliPay struct{}

func (a *AliPay) Pay(amount float32) error {
	// 支付操作
	return nil
}
func (a *AliPay) Refund(amount float32) error {
	// 支付操作
	return nil
}

// 微信支付
type WeixinPay struct{}

func (a *WeixinPay) Pay(amount float32) error {
	// 支付操作
	return nil
}

func (a *WeixinPay) Refund(amount float32) error {
	// 支付操作
	return nil
}

// 操作支付
func DoPay(pm PaymentMethod, amount float32) {
	// 实现于具体支付的接耦
	pm.Pay(amount)
}

func main() {
	pm := &AliPay{}
	DoPay(pm, 100)
}
```

### 4. 值接收者 和 指针接收者
这是一个易错点，需要特别注意哦！

在结构体中，我们知道一个实例不区分值接收者还是指针接收者，都可以正常调用；但是在接口中不是这样的，让我们看下代码：

```go
package main

import "fmt"

// 薪水计算接口
type SalaryCalculator interface {
	calSalary() int
}

// 永久员工
type Permant struct {
	empId       int
	basicPay    int // 基本薪资
	performance int // 绩效
}

// 实现薪水计算接口
func (p *Permant) calSalary() int {
	return p.basicPay + p.performance
}

func main() {
	p := Permant{empId: 1, basicPay: 100, performance: 50}

	// 定义接口类型变量
	var sc SalaryCalculator
	sc = p // 发生错误
	//  cannot use p (variable of type Permant) as SalaryCalculator value in assignment: Permant does not implement SalaryCalculator (method calSalary has pointer receiver)
	fmt.Println(sc.calSalary())
}
```

在上面的代码中,由于接口中方法实现接收者是指针,所以必须保持接口对象也是指针，否则会报错。

记住下面的规则就行：**对于接口而言，当方法是指针接收者时，必须和接收者保持一致（指针），值接收者无所谓**

为什么会这样呢？
大概是编译器在处理接口类型值转指针时,转换不了。

### 5. 空接口使用
空接口在go中的使用也是相当的多,主要用做任意类型值的做为参数传入的场景。

`interface {}`**由于空接口中没有任何方法签名，所以任何类型都实现了空接口.**这也是为什么空接口可以支持任意类型参数传入的原因。

先来看一个示例
```go
package main

import "fmt"

// 打印任何类型的东西
func printAny(v interface{}) {
	fmt.Printf("%#v\n", v)
}

type Person struct {
	name string
}

func main() {
	// 任意类型随便装
	printAny("abc")
	printAny(12)
	printAny(23.54)
	printAny(Person{name: "sd"})
}

// "abc"
// 12
// 23.54
// main.Person{name:"sd"}
```

### 6. 类型断言
在上面小结的代码中,我们胡乱的往里面传任意类型的值,虽然代码能运行，但是没啥意义。

在真实的场景中，我们通常需要知道传入的是什么数据类型，并对特定类型做相应的处理，这时候类型断言就派上用场了。

类型断言主要有两种写法：
1. `x.(T)` // x是T类型，如果不是，panic
2. `val, ok := x.(T)` // 比较安全如果不是 ok为false

我们实践下
```go
package main

import "fmt"

func main() {
	var a interface{}

	a = "hello"             // a当前是一个字符串类型
	fmt.Println(a.(string)) // ok
	// fmt.Println(a.(int))    // not ok 直接报错

	val, ok := a.(string)
	fmt.Printf("val: %#v, ok: %v\n", val, ok)
}

// hello
// val: "hello", ok: true
```

如果类型很多,上面的ok模式就不太好用,go还提供了一种switch方式，代码如下：
```go
package main

import "fmt"

func main() {
	printAny("abc")
	printAny(float32(1.23))
	printAny(23)
	printAny([]int{1, 2})
}

func printAny(v interface{}) {
	// 注意这里写的是type
	switch val := v.(type) {
	case string:
		// 区分出类型后 再转换成对应类型
		fmt.Printf("这是一个字符串: %s\n", val)
	case float32:
		fmt.Printf("这是一个32位浮点数: %v\n", val)
	case int:
		fmt.Printf("这是一个整型：%v\n", val)
	default:
		fmt.Printf("Unknown type: %v\n", val)
	}
}

// 这是一个字符串: abc
// 这是一个32位浮点数: 1.23
// 这是一个整型：23
// Unknown type: [1 2]
```

### 6. 接口本质
接口底层本质是（type,value) 它们是一对的关系，任何一个接口都是由类型和

### 7. 空接口与nil值
接口相关的nil值和空指针结构体比较非常容易让人困惑，我们先来看一段代码

```go
package main

import "fmt"

type Person struct{}

func main() {
	var a interface{} // 空接口

	if a == nil {
		fmt.Println("空接口等于nil的哦！")
	}

	var p *Person // 一个指向Person结构体指针
	if p == nil {
		fmt.Println("结构体空指针也等于nil")
	}

	//========= 上面很好理解，关键看下面 ========//
	var b interface{} // 定义一个空接口
	b = p             // 把结构体空指针 赋给空接口

	if b != nil {
		fmt.Println("空结构体指针接口不等于nil")
	}

	if b != a {
		fmt.Println("空结构体指针结构体也不等于空接口")
	}
}

// 空接口等于nil的哦！
// 结构体空指针也等于nil
// 空结构体指针接口不等于nil
// 空结构体指针结构体也不等于空接口
```
怎么样，对输出有疑惑吧！我们大概总结下，
首先，无论对于空接口还是空结构体指针它们都是 `== nil`的
但是,空结构体指针接口，既不等于`nil`, 也不等于空接口

对这个问题困惑的原因，是因为对接口本质不够理解，**接口的内部本质上是由`(type,value)`一对组成的**；

对于空接口，它的类型和值都是nil;
对于空结构体指针接口，它的类型是对应结构体指针类型，值是nil;

所以很容易得出它们不相等。

### 6. 接口嵌套（组合）
前面我们看到的都是单一接口，接口是支持组合嵌套的，可以由多个单一接口组合成一个其它接口,比如：

```go
// 定义基本接口
type Reader interface {
	Read() string
}

// 在基本接口的基础上定义扩展接口
type ReaderWithInfo interface {
	Reader // 这里嵌套了另外一个接口
	Info() string
}
```






