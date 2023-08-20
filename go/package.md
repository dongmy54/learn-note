### package
这篇文章稍长，总共写了两个晚上总算完工了，基本涵盖了包常用的知识点，希望对您有帮助。

#### 基本认识
包本质上是为了实现某些功能，方便其它人使用的的代码集合；类似于ruby中的gem。

只不过go中的包有一些自身的特点：
- 包是go语言程序的基本单位，一切go程序都必须在包里才能运行
- `main`包是go程序的执行入口，所有go项目有且只有一个main包（入口包）
- 一般在一个目录对应一个包，目录下的go文件都属同一个包
-  包的使用方式，通常为`包名.xxx`,比如fmt包使用`fmt.Println(a)`方式调用

#### 作用域
在同一个包面名下，包中的变量对包中是可见的，即使是在不同文件的中。

比如：
```go
// version.go
package main

var Version = 1.0
```

```go
// main.go
package main

import "fmt"

func main() {
	fmt.Println(Version) // 这里调用version.go文件中的Version
}

// 输出
// 1
```

#### 包变量无序性
我暂且把它称为无序性，不清楚官方如何称呼，让我们直接看代码
```go
package main

import "fmt"

// 注意包变量不能用：=语法
var (
	a = b  // 这里先定义了a然后定义b 最后定义c 我们可以认为go很智能它能推断出a b c的值；
	b = c  // 不需要您实现按照一个已知的顺序去定义
	c = hu()
)

func main() {
	fmt.Println(a, b, c)
}

func hu() int {
	return 23
}
```

#### 导入
包做为程序包，我们可以在我们的项目中引入使用，语法主要是使用`import`关键字
```go
// 引入单个包
import "fmt" 

// 引入多个包
import (
  "fmt"
  "os"
)

// 其它用法
import (
  "fmt"
  _ "os"   // _ 引入一个暂时未使用的包 如果不加_ 不能编译通过

  // 别名
  "greet"
  child "greet/greet" // 由于和上面的包是同一个名称，这里前面加一个名称做区分

  // 直接提升到当前包
  . "strings" // 这样写后 你可以直接调用strings包中的函数或变量等，而不用在前面加上 strings.xxx 比如可以这样写 Contains("sd", "sdb")
)
```

#### 导出
在go中有导出的概念,这个导出指的是，当被导入时，对外界可见的变量、函数、结构体、结构体字段；

这有点类似ruby这种语言中，public方法和private方法。

但是在go中相当简单，有一个简单规则：**大写表示外界可见，小写外界不可见**

举例
```go
package greet

var a = 1 // 外界不可见
var B = 2 // 外界可见 可以使用 greet.B 使用

// 结构体不可导出
type dog struct {
  name string
}

// 结构体可导出 通过 greet.Dog{}调用
type Dog struct {
  name string // 字段不可导出
  Age int     // 字段可导出
}

// 外界不可见
func hu(){
  //...
}

// 外界可见  可使用 greet.Hu() 调用
func Hu(){
  //...
}
```
#### 初始化
##### init函数
对于任意一个包而言，都可以在包内init函数,这个函数主要用于初始化一些包数据
  1. **一个包 可以有多个init函数**
  2. **同一文件中多个init函数按照先后顺序执行**
  3. **不同文件中多个init函数按照文件名字母顺序执行**

举例说明：
```go
// a.go文件
package main

import "fmt"

func init() {
	fmt.Println("333")
}
```

```go
// main.go
package main

import (
	"fmt"
)

func main() {
}

// 同一个文件按顺序执行 
func init() {
	fmt.Println("232")
}

func init() {
	fmt.Println(232324)
}

```

```go
// y.go
package main

import "fmt"

func init() {
	fmt.Println("444")
}
```

按照文件字母顺序应该是a.go、main.go、y.go,执行结果如下：
```
dongmingyan@pro ⮀ ~/go_playground/play ⮀ go run .
333
232
232324
444
```

##### 导入包执行顺序
一般而言我们一个项目会导入多个包，那么在导入这些包的时候执行顺序是怎样的呢？

记住一个简单原则：在一个包中，执行顺序是：
1. 初始化包变量
2. 初始化包init函数
3. 剩下才是包函数...

比如：
```go
package main

import (
	"fmt"
)

var b = hu()

func main() {
	fmt.Println("我是包函数最后执行", b)
}

func hu() int {
	fmt.Println("由于我是包变量b的值，所以第一执行")
	return 23
}

func init() {
	fmt.Println("我是init函数在 包变量之后执行")
}
```

执行顺序为：
```
dongmingyan@pro ⮀ ~/go_playground/play ⮀ go run .
由于我是包变量b的值，所以第一执行
我是init函数在 包变量之后执行
我是包函数最后执行 23
```

根据这个规则我们可以延伸出更负责的包执行顺序：
```bash
1. main包初始化--开始
2. main包的导入包先初始化
  2.1 导入的多个包依次执行，包导入包（递归）
  2.2 每个包都按照上述单个初始化规则顺序
3. main包初始化--包变量
4. main包初始化--init
5. main包初始化--函数
```

#### 包嵌套
一般而言，在一个目录下就只有一个包；但是我们包其实是可以嵌套的——在一个目录下，可以新增目录创建其它包。

比如：
```go
// greet/greet.go
package greet

import "fmt"

func Hello() {
	fmt.Println("外部 Hello")
}
```

```go
// greet/hello/hello.go
// 在greet/hello目录下新增了 hello包
package hello

import "fmt"

func Hello() {
	fmt.Println("inside Hello")
}
```

```go
// main.go
package main

import (
	"example/play/greet/hello" //这里加了 hello 引入的是内层包
)

func main() {
	hello.Hello()
}

// 输出
inside Hello
```

项目目录结构为：
```bash
dongmingyan@pro ⮀ ~/go_playground/play ⮀ tree
.
├── go.mod
├── go.sum
├── greet
│   ├── greet.go
│   └── hello
│       └── hello.go
└── main.go

3 directories, 5 files
```


