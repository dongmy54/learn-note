### 错误生成与处理
go中的错误生成与定制相对还是比较简单，error是go中的错误类型，如下:

```go
type error interface {
  Error() string // 自定义错误类型只需要实现这个方法就行
}
```

go中生成错误主要有以下几种方式：
1. `errors.New()`
2. `fmt.Errorf()` 
3. 自定义错误类型

下面我们分别看下
#### 1. errors.New()
简单的生成error
```go
package main

import (
	"errors"
	"fmt"
)

func main() {
	if err := doSomething(); err != nil {
		fmt.Println(err)
		//  do something failed
	}
}

func doSomething() error {
	// 非常简单直接放字符串就行
	return errors.New("do something failed")
}
```

#### 2. fmt.Errorf 
格式化error
```go
package main

import (
	"fmt"
)

func main() {
	if err := doSomething1(); err != nil {
		fmt.Println(err)
		//  do something1 failed
	}
}

func doSomething1() error {
	// 可以提供占位符
	return fmt.Errorf("do %s failed", "something1")
}
```

#### 3. 自定义错误类型
```go
package main

import (
	"fmt"
)

func main() {
	if err := doSomething2(); err != nil {
		fmt.Println(err)
		//  code: 500 message: Unknown error
	}
}

// 自定义错误类型
type MyError struct {
	code string
	msg  string
}

// 实现error interface的Error
func (e MyError) Error() string {
	return fmt.Sprintf("code: %s message: %s", e.code, e.msg)
}

func doSomething2() error {
	// 使用自定义的错误类型
	return MyError{code: "500", msg: "Unknown error"}
}
```

上面介绍了错误生成，下面来看下错误处理，错误处理除了上面简单粗暴的打印错误外，还有两种：
1. errors.Is - 通过错误值判断
2. errors.As - 通过类型判断

#### 4. 错误处理errors.Is
```go
package main

import (
	"fmt"

	"errors"
)

func main() {
	if err := doSomething2(); err != nil {
		// 错误等值判断
		if errors.Is(err, UnknownError) {
			fmt.Println(err)
			// code: 500 message: Unknown error
		}
	}
}

// 自定义错误类型
type MyError struct {
	code string
	msg  string
}

// 这里实现将错误列出来
var UnknownError = MyError{code: "500", msg: "Unknown error"}

// 实现error interface的Error
func (e MyError) Error() string {
	return fmt.Sprintf("code: %s message: %s", e.code, e.msg)
}

func doSomething2() error {
	// 可以提供占位符
	return MyError{code: "500", msg: "Unknown error"}
}
```

#### 5. 错误处理errors.As
类型判断
```go
package main

import (
	"fmt"

	"errors"
)

func main() {
	if err := doSomething2(); err != nil {
		// 类型判断这里要传指针
		if errors.As(err, &MyError{}) {
			fmt.Println(err)
			// code: 500 message: Unknown error
		}
	}
}

// 自定义错误类型
type MyError struct {
	code string
	msg  string
}

// 实现error interface的Error
func (e MyError) Error() string {
	return fmt.Sprintf("code: %s message: %s", e.code, e.msg)
}

func doSomething2() error {
	// 可以提供占位符
	return MyError{code: "500", msg: "Unknown error"}
}
```