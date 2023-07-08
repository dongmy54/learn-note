### 开始前的说明
在开始前，做些说明；最近打算学习go语言，打算采取以教助学的方式，一方面可以加深的自己对go的了解，另外一方面，希望可以对后来学习go的同学提供一些帮助；

在学习的过程中，我会把一些自己认为重要的知识点，进行记录和说明；但由于自己也是新手难免有不准确和错误的地方，欢迎指正。

### 认识go语言
#### 为什么要创建go语言？
1. go语言是由google公司创建的，主要目的是解决并发的问题；传统编程语言在对计算机的多核使用上不够友好。
2. 另外一个原因，像C/C++这类语言编译非常耗时
3. 当前的编程语言，C/C++性能很好，但是开发速度慢；动态语言开发很快，但是性能很差，go在性能和开发速度上找到了一种平衡


#### 有哪些语言特性?
1. 原生支持并发（用很少的代码量）
2. 编译速度很快
3. 做到了性能和开发速度的兼顾
4. 强类型静态语言（实现定义好类型）
5. 没有面向对象的类和继承(通过其它方式实现)
6. 易于部署和分享（build 后直接生成一个二进制文件）

#### 用它可以做什么?
1. web开发
2. 云/网络服务
3. 命令行

### 学习go有哪些资源?
#### 官网
1. https://golang.google.cn/
官网整体还是不错的，安装、简单了解、框架等都很不错

#### 书籍
1. go入门指南（适合入门）
2. Go Web编程(适合入门，兼顾web开发)
3. go语言实战（比较深入，需要些基础）
4. go语言学习笔记（绝对算的是一个老手写的很地道的文章）
5. GoWeb开发实战（主要介绍框架Gin）
6. 跟煎鱼学go(不是从基础入手，书中带着实验的性质去研究探讨)

#### 在线书籍
1. https://github.com/unknwon/the-way-to-go_ZH_CN/blob/master/eBook/preface.md （go入门指南-github版，github浏览体验不是特别舒服，推荐书籍看）
2. https://gfw.go101.org/ (101适合入门)
3. https://www.topgoer.com/ 比较全面-不够细（语法、框架、微服务）

### 安装go
有多种安装方式，推荐使用官网的直接下载安装（下载好后一路next就可以了）
![](2023-07-02-21-41-04.png)
> 安装过程会自动配置好一些环境变量，目前看只有linux需要自己收到去设置环境变量
> mac电脑会将go安装到 /usr/local/go目录
```shell
go version # 检查go当前版本
# go version go1.20.5 darwin/amd64
```

### 用go写第一个程序
#### hello world来啦
步骤如下：
1. `mkdir hello` 创建一个目录
2. `cd hello` 切换到目录下
3. `go mod init example/hello` 初始化go.mod(这是一个记录依赖的文件非常重要)，example/hello 代表模块路径
4. `touch hello.go` 创建一个go的代码文件
```go
// hello.go
package main

import "fmt"

func main() {
    fmt.Println("Hello, World!")
}
```
5. `go run .` （此时自动运行当前目录下的go文件）
>dongmingyan@pro ⮀ ~/hello ⮀ go run .
Hello, World!

说明：
整体而言还是比较简单，这里需要记住的是`go mod init` 命令初始化go.mod文件

#### 引入外部包
1. 修改hello.go文件
```go
// hello.go
package main

import "fmt"
import "rsc.io/quote" // 引入外部包-已经发布的包

func main() {
    fmt.Println(quote.Go()) // 直接使用外部包的Go函数
}
```
2. 执行`go mod tidy` 它会查找包，并修改依赖(go.mod) 还会生成go.sum文件
3. `go run .`执行
> dongmingyan@pro ⮀ ~/hello ⮀ go mod tidy
go: finding module for package rsc.io/quote
go: found rsc.io/quote in rsc.io/quote v1.5.2
 dongmingyan@pro ⮀ ~/hello ⮀ go run .
Don't communicate by sharing memory, share memory by communicating.

说明：
命令`go mod tidy`下载包并使用


### 快速了解go基础语法
前面我们了解如何用go写一个程序，但是没有对语法做任何的说明，这里我们快速过下go中的一些基础概念和语法。

#### 包（package）
什么是包,如果你有之前有过编程经验，可以认为它就是程序库；如果没有编程经验，可以认为它是一个提供某种功能的工具集，有了它可以方便的实现某些功能。

#### main
是主程序的入口，所有go代码执行都从main开始

#### 导入(import)
用于引入包

#### 包名
```go
package main

import "fmt"
import "rsc.io/quote" // 路径的最后一个是包名 这里为quote

func main() {
    fmt.Println(quote.Go()) // 通过报名使用包 比如这里 quote
}
```

#### 变量
如果申明了一个变量，却没有使用go会包错
```go
package main

import "fmt"

func main() {
	var a , b int // 老老实实 先申明类型,后赋值（初始化不知道值才用）
	a = 2
	b = 3

	var x, y string = "x", "y" // 批量 定义好类型 赋值

	var c, python, java = true, false, "no" // 批量推断类型（推荐）

	e, f := 2, 4 // 短变量申明，连var都省略了(推荐）
	fmt.Println(a, b, x, y, e, f, c, e, python, java)
}
```

#### 变量的基本类型
go中的变量有一个零值（默认值）
- 数值型 - 0
- 布尔型 - false
- 字符串 - ""
```shell
bool

string

int  int8  int16  int32  int64
uint uint8 uint16 uint32 uint64 uintptr

byte // uint8 的别名

rune // int32 的别名
    // 表示一个 Unicode 码点

float32 float64

complex64 complex128
```

#### 类型转换
go中类型转换只能显示抓换
```go
package main

import "fmt"

var a = 3
var f = float32(3)
var u = uint32(f)

func main() {
	fmt.Println(a, f, u)
}
```

#### 常量
1. 常量不能用：写法
2. 常量可以不用大写（注意）
3. 常量申明了可以不用（和变量不同）
```go
package main

import "fmt"

const Pi = 3.14      // 单独
const B, C = 12, 34  // 批量写法1
const (              // 批量写法2
	Big   = 233545
	Small = -12

)
func main() {
	fmt.Println(Pi, Big, Small, B, C)
}
```

#### 函数
1. return 关键字不能剩
```go
package main

import "fmt"

// 每个入参都写明类型 返回值也写明类型
func add(x int, y int) int {
	return x + y
}

// 多个入参数类型都相同 可只在最后一个写类型
func add1(x, y int) int {
	return x + y
}

// 返回值可以定义变量名（返回值也可以是多个）
func add2(x, y int) (sum int) {
	sum = x + y
	return // 这里都不用写sum
}

func main() {
	fmt.Println(add(2,3), add1(2,3), add2(3,4))
}
```

### 创建模块
#### 1. 创建一个greetings包
为了方便练写go建议在电脑的专门的一个目录，比如go_playground中做练习。

> 从官方文档看，对于包和模块的描述比较笼统，查了下资料，我的大概理解是：任何一个程序都必须在包（package）内;
> 模块更多的层面在于管理包之间的依赖
1. 创建一个greetings目录`mkdir greetings`
2. 切换到greetings目录下`cd greetings`
3. 初始化模块`go mod init example.com/greetings` 任何模块一开始都必须用这个命令，至于这里的路径默认后续为包名，前半截随意
4. 添加文件`touch greetings.go`

```go
// greetings.go
package greetings

import "fmt"

// 定义一个hello函数 供其它包使用
func Hello(name string) string {
    // Return a greeting that embeds the name in a message.
    message := fmt.Sprintf("Hi, %v. Welcome!", name)
    return message
}
```

#### 2. 从hello模块中调用greetings包
1. 回到初始目录`cd ..`（如果你创建了go_playground的话）是回到此目录
2. 创建hello目录`mkdir hello`
3. 进入hello目录`cd hello`
4. 初始化hello模块`go mod init example/hello`
5. 创建`touch hello.go`文件
```go
// hello.go
package main

import (
    "fmt"
    "example.com/greetings"// 引入我们本地greetings包
)

func main() {
    // 调用包中函数
    message := greetings.Hello("Gladys")
    fmt.Println(message)
}
```
6. 编辑go mod路径`go mod edit -replace example.com/greetings=../greetings` （指定本地路径）
7. 同步安装包依赖`go mod tidy`
8. 运行hello.go `go run .`
```
dongmingyan@pro ⮀ ~/go_playground/hello ⮀ go run .
Hi, Gladys. Welcome!
```

#### 3. 添加错误处理
> 添加go标准包，不用执行`go mod`
1. greetings包添加空值检验
```go
// greetings.go
package greetings

import (
	"errors" // 这是go标准库中包 添加后无需单独运行go mod
	"fmt"
)

// 定义一个hello函数 供其它包使用
func Hello(name string) (string, error) {
    // 返回多个值
    if name == "" {
        return "", errors.New("empty name")
    }

    message := fmt.Sprintf("Hi, %v. Welcome!", name)
    return message, nil
}
```

2. hello模块添加日志
```go
// hello.go
package main

import (
	"fmt"
	"log"  // 本地库包
	"example.com/greetings"// 引入我们本地greetings包
)

func main() {
    // 设置日志前缀 不带时间、文件 行号
    log.SetPrefix("greetings: ")
    log.SetFlags(0)

    // Request a greeting message.
    message, err := greetings.Hello("")
    if err != nil {
        log.Fatal(err) // 日志记录
    }

    // If no error was returned, print the returned message
    // to the console.
    fmt.Println(message)
}
```

运行hello.go(必须在目录下执行-含有go.mod依赖文件)
```
 ✘ dongmingyan@pro ⮀ ~/go_playground/hello ⮀ go run .
greetings: empty name
exit status 1
```

#### 4.返回随机问候语
1. 修改greetings包
```go
// greetings.go
package greetings

import (
	"errors" // 这是go标准库中包 添加后无需单独运行go mod
	"fmt"
    "math/rand" // 引入go标准包
)

// 定义一个hello函数 供其它包使用
func Hello(name string) (string, error) {
    // 返回多个值
    if name == "" {
        return "", errors.New("empty name")
    }

    // Create a message using a random format.
    message := fmt.Sprintf(randomFormat(), name)
    return message, nil
}

// 这里函数名是小写 因此只能在包自己内部用
func randomFormat() string {
    // 切片
    formats := []string{
        "Hi, %v. Welcome!",
        "Great to see you, %v!",
        "Hail, %v! Well met!",
    }

    // 返回随机问候
    return formats[rand.Intn(len(formats))]
}
```

2. 修改hello.go文件
```go
// hello.go
package main

import (
	"fmt"
	"log"  // 本地库包
	"example.com/greetings"// 引入我们本地greetings包
)

func main() {
    // 设置日志前缀 不带时间、文件 行号
    log.SetPrefix("greetings: ")
    log.SetFlags(0)

    // 这里改成一个随机名称
    message, err := greetings.Hello("dmy")
    if err != nil {
        log.Fatal(err) // 日志记录
    }

    // If no error was returned, print the returned message
    // to the console.
    fmt.Println(message)
}
```

3. 运行
```
dongmingyan@pro ⮀ ~/go_playground/hello ⮀ go run .
Hail, dmy! Well met!
 dongmingyan@pro ⮀ ~/go_playground/hello ⮀ go run .
Hail, dmy! Well met!
 dongmingyan@pro ⮀ ~/go_playground/hello ⮀ go run .
Great to see you, dmy!
```

小结：
- 切片和数组的区别，在于切片声明时候可以省略大小，意味着它底层数组的大小可以动态改变
- 在一个包内小写函数，代表只能在包自己内部使用

####5. 多人问候
之前我们已经写了一个Hello函数支持单人问候，如果要支持多人问候问候需要修改Hello函数参数，为了保证向后兼容性我们单独写一个函数Hellos函数供使用

1. 修改greetings.go
```go
// greetings.go
package greetings

import (
	"errors" // 这是go标准库中包 添加后无需单独运行go mod
	"fmt"
    "math/rand" // 引入go标准包
)

// 定义一个hello函数 供其它包使用
func Hello(name string) (string, error) {
    // 返回多个值
    if name == "" {
        return "", errors.New("empty name")
    }

    // Create a message using a random format.
    message := fmt.Sprintf(randomFormat(), name)
    return message, nil
}


// 入参为为切片
// 返回映射-类似于ruby中hash
func Hellos(names []string) (map[string]string, error) {
    // 初始化一个map 用于返回
    messages := make(map[string]string)

    // 循环name
    for _, name := range names {
        message, err := Hello(name)

        if err != nil {
            return nil, err
        }

        messages[name] = message
    }

    return messages, nil
}

// 这里函数名是小写 因此只能在包自己内部用
func randomFormat() string {
    // 切片
    formats := []string{
        "Hi, %v. Welcome!",
        "Great to see you, %v!",
        "Hail, %v! Well met!",
    }

    // 返回随机问候
    return formats[rand.Intn(len(formats))]
}
```

2. 修改hello.go文件
```go
// hello.go
package main

import (
	"fmt"
	"log"  // 本地库包
	"example.com/greetings"// 引入我们本地greetings包
)

func main() {
    // 设置日志前缀 不带时间、文件 行号
    log.SetPrefix("greetings: ")
    log.SetFlags(0)

    // 生成一个切片名称数组
    names := []string{"张三", "lisi", "wangwu"}

    // 这里返回问候map-映射
    messages, err := greetings.Hellos(names)
    if err != nil {
        log.Fatal(err) // 日志记录
    }

    fmt.Println(messages)
}
```

3. 运行
```go
dongmingyan@pro ⮀ ~/go_playground/hello ⮀ go run .
map[lisi:Great to see you, lisi! wangwu:Hi, wangwu. Welcome! 张三:Hi, 张三. Welcome!]
 dongmingyan@pro ⮀ ~/go_playground/hello ⮀ go run .
map[lisi:Hi, lisi. Welcome! wangwu:Great to see you, wangwu! 张三:Hail, 张三! Well met!]
```

小结：
- map 映射类似于ruby中hash
- 映射类型写法 map[key-type]value-type
- 创建一个映射 make(map[key-type]value-type)
- 初始化切片 []string{"张三", "lisi", "wangwu"}
- for 循环`_, name := range names`写法


#### 6. 添加测试
1. 在greetings目录下，新建一个测试文件`touch greetings_test.go`
```go
// greetings_test.go
package greetings

import (
    "testing" // go原生支持
    "regexp" // 原生支持
)

// 测试输入一个name后能正常返回
func TestHelloName(t *testing.T) {
    name := "Gladys"

    // 正则其中包含名称 name
    want := regexp.MustCompile(`\b`+name+`\b`)
    msg, err := Hello("Gladys")
    if !want.MatchString(msg) || err != nil {
        t.Fatalf(`Hello("Gladys") = %q, %v, want match for %#q, nil`, msg, err, want)
    }
}

// 测试名称为空时 应返回错误
func TestHelloEmpty(t *testing.T) {
    msg, err := Hello("")
    if msg != "" || err == nil {
        t.Fatalf(`Hello("") = %q, %v, want "", error`, msg, err)
    }
}
```
2. 在greetings目录下运行`go test`
```
 dongmingyan@pro ⮀ ~/go_playground/greetings ⮀ go test
PASS
ok  	example.com/greetings	0.547s
 dongmingyan@pro ⮀ ~/go_playground/greetings ⮀ go test -v
=== RUN   TestHelloName
--- PASS: TestHelloName (0.00s)
=== RUN   TestHelloEmpty
--- PASS: TestHelloEmpty (0.00s)
PASS
ok  	example.com/greetings	0.118s
```

小结：
1. go原生支持测试(testing)
2. go中的测试通过函数实现，函数名表明测试项
3. 发现测试不通过直接产生错误
4. 命令`go test` 和 `go test -v`

#### 7.编译和安装应用
前面我们已经写了些go代码，但是对go命令的了解还少，这里学习下go相关的命令

1. 我们来到hello目录下，执行`go build`,此时生成了hello 可执行文件，在当前目录下 `./hello` 可执行
```shell
dongmingyan@pro ⮀ ~/go_playground/hello ⮀ go build
 dongmingyan@pro ⮀ ~/go_playground/hello ⮀ tree
.
├── go.mod
├── hello
└── hello.go

1 directory, 3 files
 dongmingyan@pro ⮀ ~/go_playground/hello ⮀ ./hello
map[lisi:Hail, lisi! Well met! wangwu:Great to see you, wangwu! 张三:Hail, 张三! Well met!]
```

2. `go install`的作用是生成可执行文件并放置到配置的bin目录下
首先我们看下当前执行会放到的目录是哪个,执行命令`go list -f '{{.Target}}'`
```shell
dongmingyan@pro ⮀ ~/go_playground/hello ⮀ go list -f '{{.Target}}'
/Users/dongmingyan/go/bin/hello
```
可以看到放置的路径是`/Users/dongmingyan/go/bin`,这里本质上是默认的GOPATH下的bin路径
我们可以设置GOBIN路径来更改此路径，执行` go env -w GOBIN=/usr/local/go/bin`
```shell
dongmingyan@pro ⮀ ~/go_playground/hello ⮀ go env | grep GOPATH
GOPATH="/Users/dongmingyan/go"
 dongmingyan@pro ⮀ ~/go_playground/hello ⮀ go env -w GOBIN=/usr/local/go/bin
 dongmingyan@pro ⮀ ~/go_playground/hello ⮀ go list -f '{{.Target}}'
/usr/local/go/bin/hello
```
> 将这个bin路径放到PATH变量中，那么执行`go install`后在任意目录下，都可以执行我们生成的命令

3. 执行`go install`
上一步我们已经将路径改成了`/usr/local/go/bin`,在hello目录下执行`go install`,然后去`/usr/local/go/bin`检查可以看到我们生成的hello可执行文件
```shell
dongmingyan@pro ⮀ ~/go_playground/hello ⮀ sudo go install
Password:
 dongmingyan@pro ⮀ ~/go_playground/hello ⮀ cd /usr/local/go/bin
 dongmingyan@pro ⮀ /usr/local/go/bin ⮀ ls
go    gofmt hello
```

补充go环境变量`go env`
```
dongmingyan@pro ⮀ /usr/local/go/bin ⮀ go env
GO111MODULE="on"
GOARCH="amd64"
GOBIN="/usr/local/go/bin"
GOCACHE="/Users/dongmingyan/Library/Caches/go-build"
GOENV="/Users/dongmingyan/Library/Application Support/go/env"
GOEXE=""
GOEXPERIMENT=""
GOFLAGS=""
GOHOSTARCH="amd64"
GOHOSTOS="darwin"
GOINSECURE=""
GOMODCACHE="/Users/dongmingyan/go/pkg/mod"
GONOPROXY=""
GONOSUMDB=""
GOOS="darwin"
GOPATH="/Users/dongmingyan/go"
GOPRIVATE=""
GOPROXY="https://goproxy.cn,direct"
GOROOT="/usr/local/go"
GOSUMDB="sum.golang.org"
GOTMPDIR=""
GOTOOLDIR="/usr/local/go/pkg/tool/darwin_amd64"
GOVCS=""
GOVERSION="go1.20.5"
GCCGO="gccgo"
GOAMD64="v1"
AR="ar"
CC="clang"
CXX="clang++"
CGO_ENABLED="1"
GOMOD="/dev/null"
GOWORK=""
CGO_CFLAGS="-O2 -g"
CGO_CPPFLAGS=""
CGO_CXXFLAGS="-O2 -g"
CGO_FFLAGS="-O2 -g"
CGO_LDFLAGS="-O2 -g"
PKG_CONFIG="pkg-config"
GOGCCFLAGS="-fPIC -arch x86_64 -m64 -pthread -fno-caret-diagnostics -Qunused-arguments -fmessage-length=0 -fdebug-prefix-map=/var/folders/j8/08btplt912l0m3jg760nkbpw0000gn/T/go-build496445168=/tmp/go-build -gno-record-gcc-switches -fno-common"
```
当前关注以下几个
- GOPATH go主要目录（一般在家目录下）
- GOBIN go可执行文件安装位置
- GOPROXY 包下载url地址

小结：
- `go run` 用于代码的快速编译和运行，不会生成可执行文件（常用于写代码即使运行）
- `go build` 生成本地可执行文件,但不会安装
- `go install` 生成可执行文件并安装到本地
- `go env -w` 用于改变go 环境变量的值



