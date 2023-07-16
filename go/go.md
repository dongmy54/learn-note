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

#### 其它
1. package查询 https://pkg.go.dev/
2. gin 框架文档 https://gin-gonic.com/docs/
3. go 语言语法文档 https://devdocs.io/go/
4. go语法使用常见例子 https://gobyexample.com/

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


### 工作空间（workspace)
PS：工作空间需要 1.18 以上版本

#### 包、模块、工作空间关系
前面我们已经对包、模块进行了学习，但是理解上还是不够准确，这节结合工作区，重新梳理下包、模块、工作区之前的关系。

- 包：相当于其它语言中的命名空间
> 之前的认识有问题,不能认为是ruby中的gem;包是go语言组织代码的基本单位，任何一个`.go`文件都必须属于一个包(package)，多个`.go`文件可以属于同一个包，一般而言，同一个目录下文件，都属于同一个包
>
- 模块：相当于项目
> 一个模块下可以有多个包,模块下管理多个包之间的依赖关系也就是`go.mod`文件
>
- 工作空间：用于管理多个模块
> 1. 设置工作区后，可以在工作区目录运行模块代码
> 2. 工作空间使一个模块调用另外一个模块中方法变得更容易

#### 工作空间使用
1. 新建一个目录workspace用于练习工作区`mkdir workspace`
2. 在工作区中建立一个hello模块
```shell
cd workspace 
mkdir hello
go mod init example.com/hello # 初始化模块
```
3. 添加模块依赖项,`go get golang.org/x/example`
```shell
 dongmingyan@pro ⮀ ~/go_playground/workspace/hello ⮀ go get golang.org/x/example
go: added golang.org/x/example v0.0.0-20230515183114-5bec75697667
```
4. 添加`hello.go`文件
```go
// workspace/hello/hello.go
package main

import (
    "fmt"
    "golang.org/x/example/stringutil" 
)

func main() {
    fmt.Println(stringutil.Reverse("Hello"))
}
```
5. 模块（hello目录）下运行
```shell
dongmingyan@pro ⮀ ~/go_playground/workspace/hello ⮀ go run .
olleH
```
6. 回到workspace目录下，初始化工作空间`go work init ./hello`
   这会生成一个go.work文件
```shell
// workspace/go.work

go 1.20

use ./hello
```
此时可以在工作空间目录（不用到模块目录下）执行模块，`go run example.com/hello`
```shell
dongmingyan@pro ⮀ ~/go_playground/workspace ⮀ go run example.com/hello
olleH
```
7. 将golang.org/x/example 模块项目下载到workspace目录，`git clone git@github.com:golang/example.git`，并加入工作空间`go work use ./example`，此时工作空间同时拥有了两个模块
```shell
dongmingyan@pro ⮀ ~/go_playground/workspace ⮀ git clone git@github.com:golang/example.git
正克隆到 'example'...
remote: Enumerating objects: 221, done.
remote: Counting objects: 100% (17/17), done.
remote: Compressing objects: 100% (10/10), done.
remote: Total 221 (delta 3), reused 11 (delta 1), pack-reused 204
接收对象中: 100% (221/221), 173.38 KiB | 269.00 KiB/s, 完成.
处理 delta 中: 100% (83/83), 完成.
 dongmingyan@pro ⮀ ~/go_playground/workspace ⮀
 dongmingyan@pro ⮀ ~/go_playground/workspace ⮀
 dongmingyan@pro ⮀ ~/go_playground/workspace ⮀ go work use ./example
```

9. 修改克隆项目，在`workspace/example/stringutil`目录下新增`toupper.go`文件
```go
// workspace/example/stringutil/toupper.go
package stringutil

import "unicode"

// 转成大写
func ToUpper(s string) string {
    r := []rune(s)
    for i := range r {
        r[i] = unicode.ToUpper(r[i])
    }
    return string(r)
}
```

10. 在hello模块下，直接使用新增的ToUpper函数
```go
// workspace/hello/hello.go
package main

import (
    "fmt"

    "golang.org/x/example/stringutil"
)

func main() {
    // 使用ToUpper
    fmt.Println(stringutil.ToUpper("Hello"))
}
```

11. 回到工作空间（workspace）目录下，运行`go run example.com/hello`发现新增的ToUpper函数生效了

小结：
工作空间的主要目的在于管理多个模块，使用模块之间的调用变得简单，同时也获得了在工作空间直接调用模块的能力。

### 使用Gin web框架开发api
gin框架是go语言用于开发web的框架，开发一个api,仍然包含路由、控制器、数据处理、响应返回这么几部分。

#### 1.项目准备
初始化项目
```shell
mkdir web-server-gin 
cd web-server-gin

go mod init example/web-server-gin # 初始化模块
touch main.go # 作为入口文件，为简单起见，所有请求和处理都放在这里
```
main.go 文件内容
```go
// main.go
package main 

import(
    "net/http"
	"github.com/gin-gonic/gin" // 引入我们要的用的gin框架
)

func main() {
}
```

#### 2. 开始我们第一个api
这里我们以唱片album需求来实现，遵从restful api原则，开发
`GET /alubms` 获取唱片列表

- 先写入路由
```go
// main.go
package main 

import(
    "net/http"
	"github.com/gin-gonic/gin" // 引入我们要的用的gin框架
)

// 此步骤添加
func main() {
	router := gin.Default()
	router.GET("/albums", getAlbums) // 路由写在这里

	router.Run("localhost:8080")
}
```

- 补全控制器
```go
// main.go
package main 

import(
    "net/http"
	"github.com/gin-gonic/gin" // 引入我们要的用的gin框架
)

// 此步骤添加
func main() {
	router := gin.Default()
	router.GET("/albums", getAlbums) // 路由写在这里

	router.Run("localhost:8080")
}

// 控制器函数 gin.Context 是框架的上下问
func getAlbums(c *gin.Context) {
    // c.IndentedJSON是返回缩减的json
	c.IndentedJSON(http.StatusOK, albums)
}

// 结构体 ID（字段） String(字段类型)
type album struct {
	ID     string  `json:"id"`
	Title  string  `json:"title"`
	Artist string  `json:"artist"`
	Price  float64 `json:"price"`
}

// 用新的结构体类型 定义一个唱片集合
var albums = []album{
	{ID: "1", Title: "Blue Train", Artist: "John Coltrane", Price: 56.99},
	{ID: "2", Title: "Jeru", Artist: "Gerry Mulligan", Price: 17.99},
	{ID: "3", Title: "Sarah Vaughan and Clifford Brown", Artist: "Sarah Vaughan", Price: 39.99},
}
```

- 运行
```shell
go mod tidy # 运行获取需要用到的依赖,为什么在最终这里执行，不在一开始引入模块的时候执行，目前的理解是，最终才会知道需要用到哪些依赖
go run .    # 运行
```
在命令行`curl http://localhost:8080/albums`
```
 dongmingyan@pro ⮀ ~/go_playground/web-server-gin ⮀ go run .
[GIN-debug] [WARNING] Creating an Engine instance with the Logger and Recovery middleware already attached.

[GIN-debug] [WARNING] Running in "debug" mode. Switch to "release" mode in production.
 - using env:	export GIN_MODE=release
 - using code:	gin.SetMode(gin.ReleaseMode)

[GIN-debug] GET    /albums                   --> main.getAlbums (3 handlers)
[GIN-debug] [WARNING] You trusted all proxies, this is NOT safe. We recommend you to set a value.
Please check https://pkg.go.dev/github.com/gin-gonic/gin#readme-don-t-trust-all-proxies for details.
[GIN-debug] Listening and serving HTTP on localhost:8080
[GIN] 2023/07/10 - 22:34:52 | 200 |     116.705µs |       127.0.0.1 | GET      "/albums"
```

```
dongmingyan@pro ⮀ ~ ⮀ curl http://localhost:8080/albums
[
    {
        "id": "1",
        "title": "Blue Train",
        "artist": "John Coltrane",
        "price": 56.99
    },
    {
        "id": "2",
        "title": "Jeru",
        "artist": "Gerry Mulligan",
        "price": 17.99
    },
    {
        "id": "3",
        "title": "Sarah Vaughan and Clifford Brown",
        "artist": "Sarah Vaughan",
        "price": 39.99
    }
]%
```

#### 2.添加接口 `POST /albums`创建唱片
- 添加路由
```go
// main.go
   //  main函数中添加
   router.POST("/albums", postAlbums)
```

- 添加控制器,main.go文件底部添加
```go
// main.go

// 添加条目到albums
func postAlbums(c *gin.Context) {
    // 定义一个变量 为结构体类型album
	var newAlbum album

	// 调用 BindJSON 绑定接受到的json到 newAlbum变量
	if err := c.BindJSON(&newAlbum); err != nil {
			return
	}

	// 将newAlbum 加入到albums中,这里是加到内存中的
	albums = append(albums, newAlbum)
	c.IndentedJSON(http.StatusCreated, newAlbum)
}
```

- 运行，如果之前是运行的需要先终止掉，重新`go run .`

```shell
dongmingyan@pro ⮀ ~ ⮀ curl http://localhost:8080/albums \
    --include \
    --header "Content-Type: application/json" \
    --request "POST" \
    --data '{"id": "4","title": "The Modern Sound of Betty Carter","artist": "Betty Carter","price": 49.99}'

HTTP/1.1 201 Created
Content-Type: application/json; charset=utf-8
Date: Tue, 11 Jul 2023 13:15:06 GMT
Content-Length: 116

{
    "id": "4",
    "title": "The Modern Sound of Betty Carter",
    "artist": "Betty Carter",
    "price": 49.99
}%
```

#### 3. 添加`GET /albums/:id` 接口
- 在main函数中，添加路由
```go
// main.go
router.GET("/albums/:id", getAlbumByID)
```

- 添加控制器函数
```go
// main.go
func getAlbumByID(c *gin.Context) {
	id := c.Param("id") // 路径参数获取值

	// 循环找到id
	for _, a := range albums {
			if a.ID == id {
					c.IndentedJSON(http.StatusOK, a)
					return
			}
	}
	c.IndentedJSON(http.StatusNotFound, gin.H{"message": "album not found"})
}
```

- 运行，`go run .`

```shell
✘ dongmingyan@pro ⮀ ~/go_playground/web-server-gin ⮀ go run .
[GIN-debug] [WARNING] Creating an Engine instance with the Logger and Recovery middleware already attached.

[GIN-debug] [WARNING] Running in "debug" mode. Switch to "release" mode in production.
 - using env:	export GIN_MODE=release
 - using code:	gin.SetMode(gin.ReleaseMode)

[GIN-debug] GET    /albums                   --> main.getAlbums (3 handlers)
[GIN-debug] POST   /albums                   --> main.postAlbums (3 handlers)
[GIN-debug] GET    /albums/:id               --> main.getAlbumByID (3 handlers)
[GIN-debug] [WARNING] You trusted all proxies, this is NOT safe. We recommend you to set a value.
Please check https://pkg.go.dev/github.com/gin-gonic/gin#readme-don-t-trust-all-proxies for details.
[GIN-debug] Listening and serving HTTP on localhost:8080
[GIN] 2023/07/11 - 21:24:02 | 200 |     108.951µs |       127.0.0.1 | GET      "/albums/3"
[GIN] 2023/07/11 - 21:24:05 | 200 |      74.037µs |       127.0.0.1 | GET      "/albums/1"
```
```shell
dongmingyan@pro ⮀ ~ ⮀ curl http://localhost:8080/albums/1
{
    "id": "1",
    "title": "Blue Train",
    "artist": "John Coltrane",
    "price": 56.99
}%
```

### go泛型入门
什么是泛型，简单点说就是，用同一个函数，处理不同的数据类型。

看下面的例子，会有深入的感受
#### 1.用两个不同类型的函数，处理不同的类型
- 初始化项目
```shell
mkdir generics
cd generics
go mod init example/generics # 初始化模块
```

- 完善main.go文件
创建`touch main.go`文件
```go
// mian.go
package main

import "fmt"

func main() {
     // 初始化整数映射
    ints := map[string]int64{
        "first":  34,
        "second": 12,
    }

    // 初始化浮点数映射
    floats := map[string]float64{
        "first":  35.98,
        "second": 26.99,
    }

    fmt.Printf("Non-Generic Sums: %v and %v\n",
        SumInts(ints),
        SumFloats(floats))
}

// int64 求和
func SumInts(m map[string]int64) int64 {
    var s int64
    for _, v := range m {
        s += v
    }
    return s
}

// float64求和
func SumFloats(m map[string]float64) float64 {
    var s float64
    for _, v := range m {
        s += v
    }
    return s
}
```

- 运行，`go run .`
```shell
dongmingyan@pro ⮀ ~/go_playground/generics ⮀ go run .
Non-Generic Sums: 46 and 62.97
```
#### 2.引入泛型
在上面我们用了两个不同的函数分别处理int和float类型，实在有点麻烦；这里我们用一个函数实现
```go
// main.go
package main

import "fmt"

func main() {
     // 初始化整数映射
    ints := map[string]int64{
        "first":  34,
        "second": 12,
    }

    // 初始化浮点数映射
    floats := map[string]float64{
        "first":  35.98,
        "second": 26.99,
    }

    fmt.Printf("Non-Generic Sums: %v and %v\n",
        SumIntsOrFloats[string, int64](ints), // 使用时候也多传下类型，如果可以类型推断出来可以省略
        SumIntsOrFloats[string, float64](floats))

		// 和上写法等效
		fmt.Printf("Non-Generic Sums: %v and %v\n",
        SumIntsOrFloats(ints),
        SumIntsOrFloats(floats))
}
// 求和浮点数或整数
// [] 里申明类型
// comparable代表一种可以比较的类型
func SumIntsOrFloats[K comparable, V int64 | float64](m map[K]V) V {
    var sum V

    for _, v := range m {
        sum += v
    }
    return sum
}
```

运行
```shell
dongmingyan@pro ⮀ ~/go_playground/generics ⮀ go run .
Non-Generic Sums: 46 and 62.97
Non-Generic Sums: 46 and 62.97
```
小结：方式就是在函数开头加上[]，设定好支持哪些类型

#### 3.优化-类型约束
上面的写法已经实现了替代两个函数，但是并不简洁，如果有许多个地方都需要用到这种数据类型，我们并没有办法复用；我们可以把这里的类型抽取出来

```go
// main.go
package main

import "fmt"

func main() {
     // 初始化整数映射
    ints := map[string]int64{
        "first":  34,
        "second": 12,
    }

    // 初始化浮点数映射
    floats := map[string]float64{
        "first":  35.98,
        "second": 26.99,
    }

    fmt.Printf("Non-Generic Sums: %v and %v\n",
        SumIntsOrFloats[string, int64](ints), // 使用时候也多传下类型，如果可以类型推断出来可以省略
        SumIntsOrFloats[string, float64](floats))

		// 和上写法等效
		fmt.Printf("Non-Generic Sums: %v and %v\n",
        SumIntsOrFloats(ints),
        SumIntsOrFloats(floats))
}

// 这里申明一种Number类型 可以同时代表int64和float64
type Number interface{
	int64 | float64 // 注意这里是单竖线
}

// 求和浮点数或整数
// [] 里申明类型
// compareable代表一种可以比较的类型 Number复用其中
func SumIntsOrFloats[K comparable, V Number](m map[K]V) V {
    var sum V

    for _, v := range m {
        sum += v
    }
    return sum
}
```

### 模糊测试（Fuzz Test)
版本要求：go 1.18(至少)

#### 什么是模糊测试?
模糊顾名思义它不是指定某个具体测试数据，然后去测试；它的原理是根据我们给了一个基本的种子测试数据，自动随机生成一系列未知的测试数据，去测试。

用途：通常用于测试一些普通测试无法覆盖到的临界测试条件，它的覆盖更广、更全面

>PS：启动模糊测试后，如果未发生测试失败的情况下，测试会一直运行下去，除非人为终止（当然我们可以手动指定一个允许测试的耗费时间，比如10s）


#### 初始化项目代码
```shell
mkdir fuzz
cd fuzz
go mod init example/fuzz
touch main.go
```

- 写main.go文件
```go
// main.go
package main

import "fmt"

func main() {
    input := "The quick brown fox jumped over the lazy dog"
    rev := Reverse(input)
    doubleRev := Reverse(rev)
    fmt.Printf("original: %q\n", input)
    fmt.Printf("reversed: %q\n", rev)
    fmt.Printf("reversed again: %q\n", doubleRev)
}

// 将字符串进行反转
func Reverse(s string) string {
    b := []byte(s) // 将字符串按照字节转换成切片
    for i, j := 0, len(b)-1; i < len(b)/2; i, j = i+1, j-1 {
        b[i], b[j] = b[j], b[i]
    }
    return string(b)
}
```
- 运行
```shell
dongmingyan@pro ⮀ ~/go_playground/fuzz ⮀ go run .
original: "The quick brown fox jumped over the lazy dog"
reversed: "god yzal eht revo depmuj xof nworb kciuq ehT"
reversed again: "The quick brown fox jumped over the lazy dog"
```

#### 添加模糊测试
模糊测试的文件和普通测试一样

- 测试代码
在当前项目列表下，添加文件`touch reverse_test.go`

```go
// reverse_test.go
package main

import (
	"testing"
	"unicode/utf8"
)

// 模糊测试函数以Fuzz开头
// *testing.go 代表的是指针变量
func FuzzReverse(f *testing.F) {
	testcases := []string{"Hello, world", " ", "!12345"}
	
    for _, tc := range testcases {
		f.Add(tc) // 添加种子测试数据,模糊测试将以此种子数据为基础生成测试数据
	}

    // 模糊测试部分
	f.Fuzz(func(t *testing.T, orig string) {
		rev := Reverse(orig)
		doubleRev := Reverse(rev)
        // 由于模糊测试具有随机性，我们事先并不清楚，输入是什么，因此
        // 只能按照某些规则去写测试，这里按照生成
        // 1. 生成前后都是uft8
        // 2. 反转之后再反转应该和原来相同进行测试
		if orig != doubleRev {
			t.Errorf("Before: %q, after: %q", orig, doubleRev)
		}
		if utf8.ValidString(orig) && !utf8.ValidString(rev) {
			t.Errorf("Reverse produced invalid UTF-8 string %q", rev)
		}
	})
}
```

- 运行测试`go test -fuzz=Fuzz`
```shell
✘ dongmingyan@pro ⮀ ~/go_playground/fuzz ⮀ go test -fuzz=Fuzz
fuzz: elapsed: 0s, gathering baseline coverage: 0/38 completed
fuzz: minimizing 47-byte failing input file
fuzz: elapsed: 0s, gathering baseline coverage: 5/38 completed
--- FAIL: FuzzReverse (0.02s)
    --- FAIL: FuzzReverse (0.00s)
        reverse_test.go:21: Reverse produced invalid UTF-8 string "\xb8\xca"

    Failing input written to testdata/fuzz/FuzzReverse/0463d8535940015d
    To re-run:
    go test -run=FuzzReverse/0463d8535940015d
FAIL
exit status 1
FAIL	example/fuzz	0.639s
```

- 修复错误
注意这时候如果你仔细观察会发现在项目下生成了一个`testdata/fuzz/FuzzReverse/xxxxxxxx`文件，这个文件记录的是模糊测试失败的用例

从上面的报错中我们可以看出，这个是由于reverse后产生了非utf8字符导致的。
为了调试这里的错误，我们可以通过 打印`fmt.Printf` 或者 日志`t.Logf`等方式找出错误原因，这里省略此过程

1. 修复main.go文件
```go
// main.go
package main

import (
    "errors"
    "fmt"
    "unicode/utf8"
)

func main() {
    input := "The quick brown fox jumped over the lazy dog"
    rev, revErr := Reverse(input)
    doubleRev, doubleRevErr := Reverse(rev)
    fmt.Printf("original: %q\n", input)
    fmt.Printf("reversed: %q, err: %v\n", rev, revErr)
    fmt.Printf("reversed again: %q, err: %v\n", doubleRev, doubleRevErr)
}

func Reverse(s string) (string, error) {
    // 防止输入过程中包含 无效uft8字符
    if !utf8.ValidString(s) {
        return s, errors.New("input is not valid UTF-8")
    }

    r := []rune(s) // 对于有些字符，可能需要几个字节，比如中文，所以这里不能用字节类型，用rune-32位
    for i, j := 0, len(r)-1; i < len(r)/2; i, j = i+1, j-1 {
        r[i], r[j] = r[j], r[i]
    }
    return string(r), nil
}
```
2. 修复测试文件
```go
// reverse_test.go
package main

import (
    "testing"
    "unicode/utf8"
)

func FuzzReverse(f *testing.F) {
    testcases := []string{"Hello, world", " ", "!12345"}
    for _, tc := range testcases {
        f.Add(tc) // 
    }
    f.Fuzz(func(t *testing.T, orig string) {
        rev, err1 := Reverse(orig)
        // 有错误直接跳过
        if err1 != nil {
            return
        }

        doubleRev, err2 := Reverse(rev)
        if err2 != nil {
            return
        }
        if orig != doubleRev {
            t.Errorf("Before: %q, after: %q", orig, doubleRev)
        }
        if utf8.ValidString(orig) && !utf8.ValidString(rev) {
            t.Errorf("Reverse produced invalid UTF-8 string %q", rev)
        }
    })
}
```

- 修复后再次运行
```shell
 dongmingyan@pro ⮀ ~/go_playground/fuzz ⮀ go test -fuzz=Fuzz
fuzz: elapsed: 0s, gathering baseline coverage: 0/39 completed
fuzz: elapsed: 0s, gathering baseline coverage: 39/39 completed, now fuzzing with 8 workers
fuzz: elapsed: 3s, execs: 365386 (121788/sec), new interesting: 1 (total: 40)
fuzz: elapsed: 6s, execs: 744288 (126305/sec), new interesting: 1 (total: 40)
fuzz: elapsed: 9s, execs: 1114466 (123388/sec), new interesting: 1 (total: 40)
^Cfuzz: elapsed: 10s, execs: 1237156 (121777/sec), new interesting: 1 (total: 40)
PASS
ok  	example/fuzz	10.532s
```

另外也可以通过`go test -fuzz=Fuzz -fuzztime=10s`指定运行时间为10s

小结：
1. 模糊测试和普通测试在同一个文件
2. 模糊测试命令`go test -fuzz=Fuzz`
3. 指定运行时间`go test -fuzz=Fuzz -fuzztime=10s`
4. 模糊测试失败后会在项目下生成一个`testdata`文件夹用于存放失败用例


### vscode中go代码如何调试？
写代码的过程中难免会产生bug，我们需要学会如何调试代码，这非常重要，无论你调试程序还说阅读源码这都非常重要。

#### 准备：插件go
在开始前先介绍一个插件-go
![](2023-07-16-15-22-02.png)
这个插件有非常多的好处：
1. 函数跳转（mac按住cmd键）
2. 鼠标移动在函数上,显示函数介绍
3. 自动引入包（当使用了某个包时）
4. import的包，带了链接，可以直接点击跳转
5. 代码自动格式化
6. 检查语法错误
7. 写代码时，会自动补全提示
...
总之非常推荐安装，对新手非常友好

#### step1: 安装Delve调试器
最基本的调试，我们可以通过记录日志和打印输出两种方式，但是不够好。

在go中我们通过 Delve go调试来实现，非常强大，它可以在任意位置打断点、进入函数内部、查看变量值等等。

- 安装delve `go get -u github.com/go-delve/delve/cmd/dlv`

#### step2: 配置`launch.json`文件
在项目路径下，添加一个目录 
```shell
mkdir .vscode
touch launch.json
```

```json
// .vscode/launch.json
{
    // Use IntelliSense to learn about possible attributes.
    // Hover to view descriptions of existing attributes.
    // For more information, visit: https://go.microsoft.com/fwlink/?linkid=830387
    "version": "0.2.0",
    "configurations": [
      {
        "name": "Launch",
        "type": "go",
        "request": "launch",
        "mode": "auto",
        "program": "${fileDirname}",
        "env": {},
        "args": [],
        // 这里跳过go版本检查时因为我本地go版本有点高，所以跳过了
        "dlvFlags": ["--check-go-version=false"] 
      }
    ]
}
```

一般而言,vscode左侧在点击`Run and Debug`后，如果没有配置文件，会有提示，让你创建 launch.json文件，上面我配置的时候直接去创建；你也可以点击去创建。

![](2023-07-16-15-38-28.png)

#### step3: 开始调试
- 遇到的坑
大多数时候，经过上面的配置就可以正常调试了；但是我自己遇到了一个坑，一直不行，后来发现是自己少装了一些东西，而为什么少装是由于,vscode自动安装某些东西的时候，需要操作go的目录(/usr/local/go) 文件，但是没有权限。

解决办法：
```shell
# 递归打开这个目录下相关权限
sudo chmod -R 777 /usr/local/go
```
- 调试步骤
1. 在需要查看的点位，打断点
2. 按照run and debug
3. continue/skip over/ skip into / restart / stop
![](2023-07-16-15-53-23.png)

- continue 只在断点停留
- skip over 只在当前代码块-非常关键，不进入具体跳入函数中，用于关注当前上下文执行
- skip into 调入函数执行细节中
- restart 重新再次执行（丢弃本次）
- stop 停止调试




