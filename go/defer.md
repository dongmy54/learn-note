### defer
延迟调用，保证无论任何时候，即使发生错误，也要执行，主要用于资源的释放，比如锁的释放、文件的关闭等等

它有如下特性：
#### 1: 延迟执行（执行完当前函数后，再执行）
```go
package main

import "fmt"

func main() {
	defer fmt.Println("defer exectue")

	fmt.Println("main主体执行")
}

// main主体执行
// defer exectue
```

#### 2. 多个defer先进后出
```go
package main

import "fmt"

func main() {
	defer fmt.Println("first defer")

	defer fmt.Println("second defer")

	defer fmt.Println("third defer")

	fmt.Println("main主体执行")
}

// main主体执行
// third defer
// second defer
// first defer
```

#### 3. 即使中途发送错误也会执行
```go
package main

import "fmt"

func main() {
	// 还是会执行
	defer fmt.Println("defer 1")

	// 这里发生错误
	panic("this is error")
}

// defer 1
// panic: this is error

// goroutine 1 [running]:
// main.main()
//         /Users/dongmingyan/main1.go:8 +0x73
// exit status 2
```

#### 4. 匿名函数（参数复制-闭包变量引用）
最容易的错误
```go
package main

import "fmt"

func main() {
	x := 10
	y := 20

	defer func(x int) {
		fmt.Printf("defer中x: %d;y: %d\n", x, y) // y是闭包-引用指针
	}(x) // x复制 执行到此处的值

	x += 2
	y += 1

	fmt.Printf("最终x: %d; 最终y: %d\n", x, y)
}

// 最终x: 12; 最终y: 21
// defer中x: 10;y: 21
```

range遍历的时候，参数是同一个内存地址；只是不同的值放入同一地址而已
```go
package main

import "fmt"

func main() {
	s := [5]int{1, 2, 3, 4}

	for i := range s {
		fmt.Printf("i地址%p,i值为%d\n", &i, i)
		defer func() {
			fmt.Println(i) // 这里是引用地址 所以执行时始终是最后的值 4
		}()
	}
}

// i地址0xc00001a1a0,i值为0
// i地址0xc00001a1a0,i值为1
// i地址0xc00001a1a0,i值为2
// i地址0xc00001a1a0,i值为3
// i地址0xc00001a1a0,i值为4
// 4
// 4
// 4
// 4
// 4
```
