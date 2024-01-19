### 闭包
go是支持闭包的，闭包是匿名函数 + 变量引用（指针）
本质：变量指针的引用

#### 例子
```go
package main

import "fmt"

func main() {
	t1 := test()

	fmt.Println(t1(1)) // 每次执行 t1 闭包里的i就会增加一次
	fmt.Println(t1(1))
	fmt.Println(t1(1))

	fmt.Println("========")
	// t2和t1是完全不同的 它内部的i地址是不同的地址
	t2 := test()
	fmt.Println(t2(1))
	fmt.Println(t2(1))
}

func test() func(int) int {
	i := 0

	// 返回一个匿名函数
	return func(x int) int {
		i++ // 执行一次+1
		x = x + i
		return x
	}
}

// 2
// 3
// 4
// ========
// 2
// 3
```



