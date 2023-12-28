## 反射
### 1. 什么是反射？
反射是一种程序在运行时可以检查自身变量类型、自身值、有哪些方法等的一种能力，这么说你可能没啥感觉，让我们换一种方式。

go作为一种静态语言，一般而言，我们的变量是什么类型都是一开始就定好的；大多数时候，也能满足我们的使用要求；但是在某些时候，我们无法一开始就确定下来它的具体类型，需要在程序运行的时候，才知道它的具体类型、以及一些其它信息。

那这个 **“某些时候”** 指的是哪些时候呢？
比如: 我们要编写一个根据任意结构体实例，生成sql语句的功能，我们的结构体实例在一开始可能是Person类型，后续变成了Order类型，它们的类型是不确定的，没办法一开始定好；

另外，我们需要知道这个结构体实例上有哪些字段，才能生存sql语句。

go做为一门静态语言，大多时候都是老老实实的，一是一，二是二；但是有了反射，为它提供了一种超越静态的一些能力 ———— 它可以在运行时候做很多操作（比如：生成函数、动态调用方法、改变结构体字段值），这么看它已具备了一部分元编程的能力。

这种能力在go的许多包、以及框架中都有许多使用,所以才为我们提供了许多非常好用的功能，所以学习它非常有必要。

在我们为go有这样一种能力欢呼的同时，也需要像大多数go反射相关文章的那样，提醒你反射它的性能不是很好哦～

最后,由于反射它处理的就是事先不确定具体的类型的情况，因此在实际的代码中，我们常常可以看到反射的使用一般和`interface`勾兑在一起的，这也见怪不怪了哦。

好啦！经过这么长的叙述，相信你已经对什么是反射有了一个整体框架，让我们开始继续探索吧！

文章有点长,希望您能耐心读完。

### 2. 反射初探
前面都是文字叙述，没有涉及到代码的部分，从这里开始我们进入代码部分，不过别怕，我们尽量先从简单的地方开始，一起来探索神秘的反射。

**初探1**
```go
package main

import (
	"fmt"
	"reflect"
)

type Person struct {
	Name string `param:"name" max:"10"` // 添加两个tag param 和 max
	Age  int    `param:"age" max:"20"`
}

func main() {
	// 先定义一个结构体实例
	p := Person{Name: "张三", Age: 12}

	// 返回一个反射的类型 reflect.Type
	t := reflect.TypeOf(p)
	// 返回反射的值reflect.Value
	v := reflect.ValueOf(p)

	// reflect.Type这里的返回是带包名的
	fmt.Println("reflect.Type", t)
	// Kind返回的底层的具体类型 比如这里结构体返回struct
	fmt.Println("kind", t.Kind())
	// Name返回无包名的 名称对于 有些类型没有Name比如切片 这里返回Person
	fmt.Println("Name", t.Name())

	// NumField返回结构体有多少个字段
	for i := 0; i < t.NumField(); i++ {
		field := t.Field(i) // 返回第字段 reflect.StructField 是一个结构体

		// 字段值 注意这里从reflect.Value中取
		fieldVal := v.Field(i)
		fieldType := field.Type // 字段类型

		// name是结构体中的一个字段 代表字段名称
		// 使用Interface()将反射值转换换成interface{}类型
		fmt.Printf("第%d个字段: %s type: %s, 值：%v\n", i+1, field.Name, fieldType, fieldVal.Interface())

		// 取tag在内部也是一个结构体 reflect.StructTag
		fmt.Printf("字段：%s,param tag is: %s\n", field.Name, field.Tag.Get("param"))
		fmt.Printf("字段：%s,max tag is: %s\n", field.Name, field.Tag.Get("max"))
	}
}

// reflect.Type main.Person
// kind struct
// Name Person
// 第1个字段: Name type: string, 值：张三
// 字段：Name,param tag is: name
// 字段：Name,max tag is: 10
// 第2个字段: Age type: int, 值：12
// 字段：Age,param tag is: age
// 字段：Age,max tag is: 20
```
这里我们需要注意的是`Type`、`Kind`、`Name`三者的区别：
- Type: 带包名的类型（可理解为全称）
- Kind: 底层类型比如`int`、`string`、`struct`等等（忽略类型别名）
- Name: 不带包的名称，结构体返回结构体名称（有些类型无Name，比如切片）

**初探2**
我们除了可以解析结构体中的字段、类型、tag外，我们还可以修改结构体中的字段值、动态调用结构体方法，我们一起来看下。
```go
package main

import (
	"fmt"
	"reflect"
)

type Person struct {
	Name string `param:"name" max:"10"` // 添加两个tag param 和 max
	Age  int    `param:"age" max:"20"`
}

func (u Person) PrintInfo() {
	fmt.Printf("姓名：%s，年龄：%d\n", u.Name, u.Age)
}

func main() {
	// 先定义一个结构体实例
	p := Person{Name: "张三", Age: 12}

	// 返回一个反射的类型 reflect.Type
	t := reflect.TypeOf(p)
	// 返回反射的值reflect.Value
	v := reflect.ValueOf(p)

	// 列出结构体有哪些方法
	// NumMethod返回方法的个数
	for i := 0; i < t.NumMethod(); i++ {
		// reflect.Method返回 一个结构体
		m := t.Method(i)
		fmt.Printf("方法名：%s, 方法类型：%s\n", m.Name, m.Type)
	}

	// 根据名称找调用方法 从value中取(凡是和执行调用相关的都从value中取)
	m1 := v.MethodByName("PrintInfo")
	// 调用方法 参数这里应该用reflect.Value切片 如果无参数可以用nil
	m1.Call(nil)
}
```

我还可以修改变量的值, 有三点需要注意：
1. 传递指针地址作为参数
2. 使用Elem()
3. reflect.Value转换回具体的类型采用`interface().(xx类型)`

比如：
```go
package main

import (
	"fmt"
	"reflect"
)

type Person struct {
	Name string `param:"name" max:"10"` // 添加两个tag param 和 max
	Age  int    `param:"age" max:"20"`
}

func main() {
	p := Person{
		Name: "张三",
		Age:  18,
	}

	// 一定要传指针 否则无法修改 返回的是指针的reflect.Value
	pVal := reflect.ValueOf(&p)
	// 指针reflect.Value 转换为结构体reflect.Value
	sVal := pVal.Elem()

	// 通过setXX设置其中的值
	sVal.Field(0).SetString("李四")
	sVal.Field(1).SetInt(20)

	// 看看改动后的情况
	fmt.Printf("%#v\n", p)
}

// main.Person{Name:"李四", Age:20}
```

### 3. 反射与正常使用之间的桥梁
经过前面初探部分代码实践，我们已经对go的反射使用有些了解；但是还不够清晰；比较零散，这里我们一起归类总结下。

go的反射和我们正常（普通）使用相比，就像两个不同的世界，在它们的世界都有各自的规律 —— 不同的使用方式;但是它们并非完全隔绝,有两个东西是他们之间的桥梁：

1. `reflect.TypeOf()` 类型相关
2. `reflect.ValueOf()` 值相关

透过这两个东西，我们们可以穿梭于反射、正常（普通）使用两个世界。

相信您在看了更多反射代码后会有更深刻的体会，好的！我们继续前行。

前面我们对go结构体相关反射就行了初探，但实际上反射能做的事远远不止于此，我们可以先有这么一个认知：

> 通过反射能做到许多go正常（普通）代码能做到的许多操作，比如：构建切片、构建映射、构建函数、结构体等等。

在开始之前先记住一个规律，操作反射世界就需要使用反射世界的元素去操作，比如在反射赋值就需要给一个`reflect.Value`类型的值。

### 4. 构建切片
我们可以通过反射创建切片，主要通过`reflect.MakeSlice`实现。

```go
package main

import (
	"fmt"
	"reflect"
)

func main() {
	// 准备一个切片
	s := make([]int, 0)

	// 获取切片的类型
	sliceType := reflect.TypeOf(s)
	// 构建切片 和 普通make写法类似
	sliceValue := reflect.MakeSlice(sliceType, 0, 0)
	// 准备填充reflect Slice的值 类型必为reflect.Value类型
	svalue := reflect.ValueOf(1)
	// 往切片中放元素
	// PS： 不能这么写 sliceValue[0] = svalue
	sliceValue = reflect.Append(sliceValue, svalue)

	// 转成普通世界的值
	slice := sliceValue.Interface().([]int)
	fmt.Println("当前slice: ", slice)
}

// 当前slice:  [0 1]
```

### 5. 构建map
主要通过`reflect.MakeMap`实现

```go
package main

import (
	"fmt"
	"reflect"
)

func main() {
	// 准备一个map类型
	m := make(map[string]int)

	// 获取反射map类型
	mapType := reflect.TypeOf(m)
	// 构建反射map值
	mapValue := reflect.MakeMap(mapType)
	// 准备反射key
	key := reflect.ValueOf("one")
	val := reflect.ValueOf(1)

	// map赋值
	mapValue.SetMapIndex(key, val)

	// 转换成普通世界值
	convertMap := mapValue.Interface().(map[string]int)

	// 打印看看
	fmt.Printf("%#v\n", convertMap)
}

// map[string]int{"one":1}
```

### 6. 构建函数
主要通过`reflect.MakeFunc`实现
```go
package main

import (
	"fmt"
	"reflect"
	"runtime"
	"time"
)

func main() {
	// 末尾转换成一个正常普通函数
	tHello := timeSpend(hello).(func(string))
	// 执行新函数
	tHello("dmy")
}

// 一个hello函数 做什么无所谓主要用于测试
func hello(name string) {
	fmt.Printf("hello %s\n", name)
	// 模拟耗时操作
	time.Sleep(time.Second)
}

// 生成一个计算函数执行时间的函数
// 入参数：一个函数 interface{}
// 返回值：一个函数 interface{}类型
func timeSpend(f interface{}) interface{} {
	// 反射类型
	t := reflect.TypeOf(f)
	// 如果传入的不是函数类型就报错
	if t.Kind() != reflect.Func {
		panic("need a function")
	}

	// 反射值
	v := reflect.ValueOf(f)
	// 构建反射函数
	wrapperF := reflect.MakeFunc(t, func(in []reflect.Value) []reflect.Value {
		// 获取当前时间
		start := time.Now()
		// 调用函数
		out := v.Call(in)
		// 计算执行时间
		// FuncForPC 用于计算函数名
		fmt.Printf("call %s spend %v\n", runtime.FuncForPC(v.Pointer()).Name(), time.Since(start))
		// 返回
		return out
	})

	// 返回函数的反射值的Interface
	return wrapperF.Interface()
}

// hello dmy
// call main.hello spend 1.001285193s
```

### 7. 构建结构体
构建结构体和前面的稍微复杂些，主要有三步：
1. 构建结构体字段切片
2. 通过`reflect.StructOf()`构建结构体类型
3. 通过`reflect.New()` 构建出结构体reflect.value

```go
package main

import (
	"fmt"
	"reflect"
)

func main() {
	// 这会构建出一个三个字段
	// Field1 int
	// Field2 string
	// Field3 bool
	// 需要注意的是这里构建的结构体
	// 一般我们是没法实现写一个结构体来转换的 因为类型随意了
	s := MakeStruct(10, "abc", true).(*struct {
		Field1 int
		Field2 string
		Field3 bool
	})

	s.Field1 = 12
	fmt.Printf("s: %#v\n", *s)

	// 大多数时候我们通过反射去修改生成结构体中的值
	// 返回的是一个指针
	s1 := MakeStruct("a", 10)
	// 取valueOf 转Elem来改结构体的值
	s1Value := reflect.ValueOf(s1).Elem()
	s1Value.Field(0).SetString("abc")
	s1Value.Field(1).SetInt(12)

	// 打印值
	fmt.Printf("s1: %#v\n", s1Value.Interface())
}

// 构建结构体
// 入参数：任意个任意类型参数
// 每个参数代码 字段的类型 顺序
func MakeStruct(vals ...interface{}) interface{} {
	// 1. 准备结构体字段切片
	// 准备一个切片 用于存储结构体字段数据
	// 这里类型用的是 structField哦
	structSlice := make([]reflect.StructField, len(vals))

	// 遍历参数
	for i, val := range vals {
		// StructField本身就是一个结构体
		sf := reflect.StructField{
			Name: fmt.Sprintf("Field%d", i+1), // 字段名
			Type: reflect.TypeOf(val),         // 字段类型这里要用reflect.Type
		}

		structSlice[i] = sf // 存入切片
	}

	// 2. 构建结构体类型
	sType := reflect.StructOf(structSlice)
	// 3. 构建结构体反射值
	sValue := reflect.New(sType)
	// 4. 转为interface类型返回
	return sValue.Interface()
}

// s: struct { Field1 int; Field2 string; Field3 bool }{Field1:12, Field2:"", Field3:false}
// s1: struct { Field1 string; Field2 int }{Field1:"abc", Field2:12}
```

### 8. 应用的例子
最后我们写一个常用的例子收尾，写啥呢？
写一个在数据映射中经常要做的操作，通过结构体实例生成相关的插入sql语句。

```go
package main

import (
	"fmt"
	"reflect"
	"strings"
)

// user结构体
type user struct {
	name string
	age  int
}

func main() {
	u := user{name: "zhangs", age: 18}
	fmt.Println(GenerateSql(u))
}

// 生成任意结构体实例的insert sql语句
// 为简单起见 这里只有考虑字段有两种类型 string 和 age
// 为简单起见 这里没有考虑单复数 大小写的的情况
// 比如一个user{Name:"张三",age:18} 生成的sql语句为 insert into user(name,age) values("张三",18)
func GenerateSql(s interface{}) (sql string) {
	// 反射类型
	t := reflect.TypeOf(s)
	// 检查传入的类型
	if t.Kind() != reflect.Struct {
		fmt.Println("传入的不是结构体")
		return ""
	}

	// 反射的值备用
	v := reflect.ValueOf(s)
	// 字段名切片
	fieldNames := make([]string, 0, t.NumField())
	// 字段值切片 任意类型 统统先转换成字符串 方便后续join后拼接字符串
	fieldValues := make([]string, 0, t.NumField())

	// 循环取值
	for i := 0; i < t.NumField(); i++ {
		// 取字段名
		fieldNames = append(fieldNames, t.Field(i).Name)
		// 字段
		field := v.Field(i)
		// 根据字段类型做不同操作
		switch field.Kind() {
		case reflect.String:
			// 如果字段类型不是sting 用String会报错
			fieldValues = append(fieldValues, field.String())
		case reflect.Int:
			// int转字符
			fieldValues = append(fieldValues, fmt.Sprintf("%v", field.Int()))
		}
	}

	// 表名
	tableName := t.Name()
	// 拼接sql
	sql = fmt.Sprintf("insert into %s(%s) values(%s)", tableName, strings.Join(fieldNames, ","), strings.Join(fieldValues, ","))
	return
}

// insert into user(name,age) values(zhangs,18)
```


