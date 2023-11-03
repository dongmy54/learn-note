### panic 与 recover
panic在go中是内置方法，通常用于遇到非常严重的问题时抛出，它会终止程序的执行
recover 用于捕获panic抛出的错误，`recover()`默认情况下返回nil;需要捕获错误需要与defer搭配使用

#### 示例一（简单用法）
```go
package main

import "fmt"

func main() {
	// 默认情况洗 recover为<nil>
	fmt.Println("recover()直接执行返回: %#v\n", recover())

	division(1, 0)
}

func division(a, b int) int {
	// 1. 必须 搭配defer
	// 2. 遇到错误捕获 然后处理
	defer func() {
		if err := recover(); err != nil {
			fmt.Println(err)
		}
	}()

	if b == 0 {
		panic("Cannot divide by zero")
	} else {
		result := a / b
		return result
	}
}
```

#### 示例二（实现try捕获效果）
```go
package main

import "fmt"

func main() {
	// 这里传的是函数 非函数执行func()
	Try(test, hander, 0)
}

func test(a int) int {
	if a == 0 {
		panic("a can't be zero")
	}
	return a + 10
}

func hander() {
	if err := recover(); err != nil {
		fmt.Println(err)
	}
}

// 接收两个参数
// 1. fn 有效函数
// 2. handler函数用于处理捕获panic处理
func Try(fn func(int) int, handler func(), x int) {
	defer hander()
	fn(x)
}
```



