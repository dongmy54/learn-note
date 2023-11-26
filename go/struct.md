## struct概述
结构体是go语言最重要的数据结构之一,go和其它编程语言不一样,它没有类的概念，类比过来struct就相当于其它语言中的类,因此十分重要。

结构体这部分涉及到的知识点页比较多，此文偏长,请耐心阅读。

### 1. 认识结构体
直接说语法往往非常枯燥，在正式开始前,我们先来看一段简单的结构体代码，建立整体感知，后续我们再一一细说其中的知识点。
```go
package main

import "fmt"

// Person结构体 - 相当于类
type Person struct {
	Name string // 字段Name 类型为string
	Age  int8   // 字段Age  类型为int8
}

// 实例方法
func (p Person) GetName() {
	fmt.Printf("My name: %s\n", p.Name)
}

func main() {
	p := Person{
		Name: "zhangsan",
		Age:  18,
	}

	p.GetName()
}

// My name: zhangsan
```
看到了吧,还是很简单的,跟着注释你大概已经看懂了如何使用。
下面我们拆分成知识点细细分析

#### 1.1 如何定义
它按照如下方式定义（PS: 它还可以代标签，为简单起见，这里暂且不讨论）
```go
// 如下格式
type 结构体名 struct {
  字段名1 字段类型1
  字段名2 字段类型2
  .....
}
```

#### 1.2 实例化
主要有几种方式：
```go
var p = new(Person) // 这里返回的是实力化后的地址  注意地址哈
var p Person        // 它是值类型 所以这种相当于零值初始化
var p = Person{}    // 这种和上面等效

// 这是一种最标准的赋值方式 把每个字段名都写了出来
p := Person{
	Name: "zhangsan",
	Age:  18,
}

// 可以省略字段名
p := Person{"zhangsan", 18}
```

实际例化后我们可以通过`obj.字段名`的方式调出值，如上例中`p.Name`

#### 1.3 方法
结构体方法,对应到面向对象语言中就是实例方法.

在上例中,如下部分：
```go
// 实例方法
func (p Person) GetName() {
	fmt.Printf("My name: %s\n", p.Name)
}

// 在这里 p Person称为接收者 后续为方法名
// 定义后 我们可以同 obj.方法名调用
```

方法和函数有什么主要区别呢？
> 方法它有接收者，而函数没有

#### 1.4 接收者
接收者既可以是值也可以是指针类型,我们看下：
```go
package main

import "fmt"

// Person结构体 - 相当于类
type Person struct {
	Name string // 字段Name 类型为string
	Age  int8   // 字段Age  类型为int8
}

// 值接收者
func (p Person) GetName() {
	fmt.Printf("My name: %s\n", p.Name)
}

// 指针接收者
func (p *Person) GetAge() {
	fmt.Printf("My age: %d\n", p.Age)
}

func main() {
	p1 := Person{Name: "张三", Age: 18}  // 值
	p2 := &Person{Name: "李四", Age: 16} // 指针

	// 值对象可以同时调用 值接收者 和 指针接收者方法
	p1.GetName()
	p1.GetAge()

	fmt.Println("---------分割线-------")
	// 指针对象可以同时调用 值接收者 和 指针接收者方法
	p2.GetName()
	p2.GetAge()
}

// My name: 张三
// My age: 18
// ---------分割线-------
// My name: 李四
// My age: 16
```
我们可以发现，**无论接收者是值类型还是指针类型,它们在调用上却不会有任何区别**，这是因为go编译器会悄悄自动帮我转换, nice!

#### 1.5 指针接收者or值接收者
那么什么时候使用值接收者啥时候用指针接收者呢?

1. 在go中一般约定,同一个struct接收者类型保持一致（**要么全是指针接收者，要么全是值接收者**）
2. 值接收者: **结构体相对较小（拷贝成本不高），不需要改变结构体内部值**场景
3. 指针接收者: **结构体比较大（拷贝成本高）,需要改变结构体内部值**场景

### 2. 匿名字段及嵌套
匿名字段可以说是结构体最有用的功能,使用的地方比比皆是，下面我们来看下

#### 2.1 匿名字段
所谓匿名字段指的是在结构体中字段名可以不用显示写出来,比如：
```go
package main

import "fmt"

type Data struct {
	uint8 // 没有结构体字段名 只有类型名
	      // 此时字段名 == 类型名
}

func main() {
	d := Data{8}
	// 直接通过类型名调用
	fmt.Println(d.uint8)
}

// 8
```
关键点在于**字段名 == 类型名**

#### 2.2 结构体嵌套
在开始之前我们来看下两个结构体

```go
// 人结构体
type Person struct {
	Name string // 姓名
	Age  int8   // 年龄
}

// 结构体
type Student struct {
	ID    int     // 学生id
	Name  string  // 姓名
	Age   int8    // 年龄
	Score float32 // 分数
}
```
我们会发现学生结构体和人结构体相比只多了两个字段（`ID`和`Score`）分别定义有点浪费？
另外人和学生有许多相似的地方,某些时候Person结构体中的方法,Student同样也需要，如果分别写两份相同的方法，也很浪费？

好啦！在go中可以通过`嵌套`解决,直接看代码
```go
package main

import "fmt"

type Person struct {
	Name string // 姓名
	Age  int8   // 年龄
}

// person结构体方法
func (p Person) GetName() {
	fmt.Printf("My name: %s\n", p.Name)
}

type Student struct {
	ID     int     // 学生id
	Score  float32 // 分数
	Person         // 嵌套Person结构体 这里是匿名字段
}

func (s Student) GetScore() {
	fmt.Printf("My score: %v\n", s.Score)
}

func main() {
	p := Student{
		ID:    1,
		Score: 98,
		Person: Person{ // 这里是匿名字段 字段名 == 字段类型
			Name: "zhangsan",
			Age:  18,
		},
	}

	// 调用嵌套结构体字段
	fmt.Printf("My age: %d\n", p.Age)                     // 直接调用 嵌套结构体字段
	fmt.Printf("My age p.Person.age: %d\n", p.Person.Age) // 通过匿名字段间接调用

	p.GetScore()       // 调用自己方法
	p.GetName()        // 直接调用嵌套结构体字段
	p.Person.GetName() // 通过匿名字段间接调用
}

// My age: 18
// My age p.Person.age: 18
// My score: 98
// My name: zhangsan
// My name: zhangsan
```
上面的注释已经非常详细，这里总结下规律：

匿名结构体嵌套，会有如下效果：
1. 匿名结构体中字段,当前结构体可以直接调用
2. 匿名结构体方法,当前结构体可以直接调用

本质是：**go在字段查找时,现在本结构体中找，如果找不到则到匿名结构体中查找；方法同理**

#### 2.3 匿名结构体嵌套经典使用
数据库表设计中:
我们可以把常用的字段抽出来成一个结构体，其它结构体只需要引入就可以扩展其中字段以及方法，比如：
```go
package main

import (
	"fmt"
	"time"
)

type BaseTable struct {
	ID        int
	CreatedAt time.Time
	UpdatedAt time.Time
}

type User struct {
	Name      string
	BaseTable // 扩展User
}
```

### 3. 方法值和方法表达式
方法值和方法表达式类似于函数表达式,我们可以将函数表达式当作变量传递,方法值和方法表达式也是一样,文字上不太容易明白，直接看代码

```go
package main

import (
	"fmt"
)

type Person struct {
	Name string
	Age  int8
}

func (p Person) GetName() {
	fmt.Printf("My name: %s\n", p.Name)
}

func main() {
	p := Person{Name: "zhangsan", Age: 18}

	// 方法值
	getName := p.GetName
	getName() // 调用方法值

	fmt.Println("--------分割线-------")
	// 方法表达方式
	pGetName := Person.GetName
	pGetName(p) // 方法表达式需要传递接收者
}

// My name: zhangsan
// --------分割线-------
// My name: zhangsan
```

它可以做为变量取出,因此可以实现复杂精巧场景下的使用，举例这里不做举例,方法值和方法表达式的区别在于：
> 方法表达式需要把接收者做为参数传入

