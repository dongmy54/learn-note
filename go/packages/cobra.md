## cobra
cobra是go语言中一个非常强大的命令行构建工具，我们非常熟悉的docker、k8s、etcd都是基于cobra开发的。如果你想打造自己的命令行工具，那么cobra就是你的最佳选择。

cobra支持的功能非常完善，比如：help、子命令、标志等，它的使用还是非常简单的，下面我们一起看下。

### 一、命令组成结构
在正式开始介绍cobra来，我们先来了解下命令的组成结构。

在开发中我们经常使用`git`,常常会克隆代码仓库，比如：
`git clone git@github.com:spf13/cobra.git --depth=1`

- `git` 是根命令（root command）
- `clone` 是命令（也可以认为是git的子命令）,代表要执行的动作
- `git@github.com:spf13/cobra.git` 是参数（argument），代表操作的对象
- `--depth=1` 是标志（flag），它是对命令的补充、修饰

从上面我们可以看出一个命令由`命令`、`参数`、`标志`组成，cobra也不例外，它也围绕这三者展开。

### 二、一个最简单的命令
现在我们一起用cobra来构造一个最简单的命令，比如：我想构造一个叫`hello`的命令，执行后打印`hello world`。

初始化项目
```shell
mkdir cobra-practice
cd cobra-practice
go mod init example/cobra-practice
touch main.go
```

`main.go`内容
```go
package main

import (
	"fmt"

	"github.com/spf13/cobra"
)

func main() {
	rootCmd := cobra.Command{
		// Use 定义命令的名字
		Use: "hello",
		// Short 简单描述
		// Long 详细描述
		Short: "Hello command",
		Long:  "This is hello command",
		// Run 命令执行的逻辑
		Run: func(cmd *cobra.Command, args []string) {
			fmt.Println("Hello world")
		},
	}

	// Execute 启动命令
	rootCmd.Execute()
}
```

执行`go mod tidy`后，执行`go run main.go` 你将看到`Hello world`输出。
我们在项目路径下执行`go build -o hello` 可以编译出一个可执行文件`hello`，然后执行`./hello` 你将看到`Hello world`输出。

注意：`go build -o .` 如果不指定可执行文件名，生成的可执行文件并不是命令哦。

### 三、参数（arg）
前面我们构建了`hello`命令，但是它没有参数，我们来添加一个参数。我们希望不是每次都打印`Hello world`，而是打印`Hello [name]`。
```go
package main

import (
	"fmt"

	"github.com/spf13/cobra"
)

func main() {
	rootCmd := cobra.Command{
		// Use 定义命令的名字
		// []用于表明它需要一个参数
		Use: "hello [name]",
		// Short 简单描述
		// Long 详细描述
		Short: "Hello command",
		Long:  "This is hello command",
		// Run 命令执行的逻辑
		// args 是命令行参数
		// 如果命令行没有参数，args 是一个空数组
		Run: func(cmd *cobra.Command, args []string) {
			fmt.Printf("Hello: %s\n", args[0])
		},
	}

	// Execute 启动命令
	rootCmd.Execute()
}
```
我们可以看到添加参数主要是利用args来实现的，我们传入的参数存放在args数组切片中。我们执行
`go run main.go dmy`输出`Hello: dmy`。

#### 1 参数校验
上面我们如果运行`go run main.go`会报错,如下：
```
dongmingyan@pro ⮀ ~/go_playground/cobra-practice ⮀ go run main.go    
panic: runtime error: index out of range [0] with length 0

goroutine 1 [running]:
main.main.func1(0xc000004300?, {0x13401f8?, 0x0?, 0x0?})
```
原因是我们没有给`hello`命令添加参数，所以`args`是空数组，我们无法通过`args[0]`获取到参数。

因此有些时候我们有必要进行参数的校验,直接用`Args`就能实现，代码如下：
```go
package main

import (
	"fmt"

	"github.com/spf13/cobra"
)

func main() {
	rootCmd := cobra.Command{
		// Use 定义命令的名字
		// []用于表明它需要一个参数
		Use: "hello [name]",
		// Short 简单描述
		// Long 详细描述
		Short: "Hello command",
		Long:  "This is hello command",
		// 限定必须准确的有一个参数
		Args: cobra.ExactArgs(1),
		// Run 命令执行的逻辑
		// args 是命令行参数
		// 如果命令行没有参数，args 是一个空数组
		Run: func(cmd *cobra.Command, args []string) {
			fmt.Printf("Hello: %s\n", args[0])
		},
	}

	// Execute 启动命令
	rootCmd.Execute()
}
```
此时如果继续执行`go run main.go`输出如下：
```
dongmingyan@pro ⮀ ~/go_playground/cobra-practice ⮀ go run main.go 
Error: accepts 1 arg(s), received 0
Usage:
  hello [name] [flags]

Flags:
  -h, --help   help for hello
```
看到了吧，这个提示友好了很多。

#### 2.自定义参数校验
`cobra.ExactArgs()`是cobra自带的参数校验,非常方便，当然如果你想自定义参数校验也是可以的。
```go
package main

import (
	"errors"
	"fmt"

	"github.com/spf13/cobra"
)

func main() {
	rootCmd := cobra.Command{
		// ...
    // 自定义校验 一个函数结构，返回error
		Args: func(cmd *cobra.Command, args []string) error {
			if args == nil || len(args) != 1 {
				return errors.New("must have one argument")
			}
			return nil
		},
		// ...
	}

	// Execute 启动命令
	rootCmd.Execute()
}
```
此时执行`go run main.go`会看到变成`Error: must have one argument`了。


#### 3.内置的参数校验列表
除了上面的`ExactArgs`还有很多，这里列下。
1. NoArgs 无任何参数
2. ExactArgs(n) 必须恰好有n个参数
3. MinimumNArgs(n) 至少有n个参数
4. MaximumNArgs(n) 最多有n个参数
5. RangeArgs(min, max) 参数个数在min和max之间
6. OnlyValidArgs 验证传入参数是否在list中
PS: 
- 这里如果没有传入任何参数，那么不会做校验
- 需要搭配：ValidArgs-指定参数的值列表一起使用。
```go
validColors := []string{"red", "green", "blue"}

var cmdColor = &cobra.Command{
    Use:   "color",
    Short: "Color output",
    ValidArgs: validColors, // 指定参数的值列表
    Args: cobra.OnlyValidArgs, // 验证传入参数是否在list中,如果不在则报错
    Run: func(cmd *cobra.Command, args []string) {
        // 处理颜色参数
    },
}
```
7. ArbitraryArgs 任意数量参数

### 四、标志(flag)
前面我们学习了参数，这里我们进一步学习标志如何使用。

假设我们需要实现,一个`verson`标志，如果为true的话，则为详细版本。

```go
package main

import (
	"fmt"
	"time"

	"github.com/spf13/cobra"
)

// 是否是冗余版本
var verbose bool

func main() {
	rootCmd := cobra.Command{
		Use:   "hello [name]",
		Short: "Hello command",
		Long:  "This is hello command",
		Args:  cobra.ExactArgs(1),
		Run: func(cmd *cobra.Command, args []string) {
			// 使用标志绑定的变量
			if verbose { // 冗余版本
				fmt.Printf("%v hello: %s\n", time.Now(), args[0])
			} else {
				fmt.Printf("Hello: %s\n", args[0])
			}
		},
	}

	// 定义标志 并将verbose绑定到全局变量verbose上
	rootCmd.Flags().BoolVarP(&verbose, "verbose", "v", false, "verbose output")
	rootCmd.Execute()
}
```

上面我们执行`go run main.go dmy -v=true`，输出`2024-06-09 15:39:41.591036 +0800 CST m=+0.000355867 hello: dmy`。

### 五、子命令
前面的hello是一个命令，同时它也是一个根命令，我们可以在`hello`的基础上添加子命令。

我们添加一个`version`的子命令，用于打印版本信息。
```go
package main

import (
	"fmt"
	"time"

	"github.com/spf13/cobra"
)

// 是否是冗余版本
var verbose bool

// 版本信息
var version = "v0.0.1"

func main() {
	rootCmd := cobra.Command{
		Use:   "hello [name]",
		Short: "Hello command",
		Long:  "This is hello command",
		Args:  cobra.ExactArgs(1),
		Run: func(cmd *cobra.Command, args []string) {
			if verbose {
				fmt.Printf("%v hello: %s\n", time.Now(), args[0])
			} else {
				fmt.Printf("Hello: %s\n", args[0])
			}
		},
	}

	// 版本命令
	versionCmd := &cobra.Command{
		Use:   "version",
		Short: "Print the version number",
		Long:  "Print the version number",
		Run: func(cmd *cobra.Command, args []string) {
			fmt.Printf("hello version: %s\n", version)
		},
	}

	rootCmd.Flags().BoolVarP(&verbose, "verbose", "v", false, "verbose output")

	// 在rootCmd中添加version子命令
	rootCmd.AddCommand(versionCmd)
	rootCmd.Execute()
}
```

我们执行`go run main.go version`，输出`hello version: v0.0.1`。

### 六、持续标志
我们此时如果执行`go run main.go -v=true`会发现报错`Error: unknown shorthand flag: 'v' in -v` 原因是，我们的`v`只在rootCmd中定义，而`versionCmd`中并没有效。

如果我们想在`versionCmd`中也能拥有和rootCmd一样的`v`标志，我们可以使用`PersistentFlags`。

```go
// 改变添加标志的行为如下行即可
// PersistentFlags 持续标志 会顺延到它的子命令也有效
rootCmd.PersistentFlags().BoolVarP(&verbose, "verbose", "v", false, "verbose output")
```

### 七、钩子
经过前面的学习，对于常用的命令构造基本够用了；但是cobra还提供了一些更好的功能，比如钩子，什么是构子呢？

比如我们希望在执行某个命令前、后执行一些操作，比如读取配置文件，那么我们可以使用钩子。

看代码
```go
package main

import (
	"fmt"
	"time"

	"github.com/spf13/cobra"
)

// 是否是冗余版本
var verbose bool

// 版本信息
var version = "v0.0.1"

func main() {
	rootCmd := cobra.Command{
		Use:   "hello [name]",
		Short: "Hello command",
		Long:  "This is hello command",
		Args:  cobra.ExactArgs(1),
		// 命令执行前执行
		PreRun: func(cmd *cobra.Command, args []string) {
			fmt.Println("hello执行前执行")
		},
		Run: func(cmd *cobra.Command, args []string) {
			if verbose {
				fmt.Printf("%v hello: %s\n", time.Now(), args[0])
			} else {
				fmt.Printf("Hello: %s\n", args[0])
			}
		},
		// 命令执行后执行
		PostRun: func(cmd *cobra.Command, args []string) {
			fmt.Println("hello执行后执行")
		},
	}

	versionCmd := &cobra.Command{
		Use:   "version",
		Short: "Print the version number",
		Long:  "Print the version number",
		Run: func(cmd *cobra.Command, args []string) {
			fmt.Printf("hello version: %s\n", version)
		},
	}

	rootCmd.PersistentFlags().BoolVarP(&verbose, "verbose", "v", false, "verbose output")

	rootCmd.AddCommand(versionCmd)
	rootCmd.Execute()
}
```

执行`go run main.go dmy`为
```shell
dongmingyan@pro ⮀ ~/go_playground/cobra-practice ⮀ go run main.go dmy
hello执行前执行
Hello: dmy
hello执行后执行
```

如果我们希望钩子在子命令中生效，我们可以使用`PersistentPreRun`和`PersistentPostRun`。

### 八、搭配viper
```go
package main

import (
	"fmt"
	"time"

	"github.com/spf13/cobra"
	"github.com/spf13/viper"
)

var verbose bool

// 版本信息
var version = "v0.0.1"

func main() {
	rootCmd := cobra.Command{
		Use:   "hello [name]",
		Short: "Hello command",
		Long:  "This is hello command",
		Args:  cobra.ExactArgs(1),
		PersistentPreRun: func(cmd *cobra.Command, args []string) {
			fmt.Println("hello执行前执行")
		},
		Run: func(cmd *cobra.Command, args []string) {
			if verbose {
				fmt.Printf("%v hello: %s\n", time.Now(), args[0])
			} else {
				fmt.Printf("Hello: %s\n", args[0])
			}
		},
		PostRun: func(cmd *cobra.Command, args []string) {
			fmt.Println("hello执行后执行")
		},
	}

	versionCmd := &cobra.Command{
		Use:   "version",
		Short: "Print the version number",
		Long:  "Print the version number",
		Run: func(cmd *cobra.Command, args []string) {
			fmt.Printf("hello version: %s\n", version)
		},
	}

	rootCmd.PersistentFlags().BoolVarP(&verbose, "verbose", "v", false, "verbose output")

	// 不带Var 此时没有绑定到变量上
	rootCmd.PersistentFlags().StringP("config", "c", "", "config file (default is $HOME/.hello.yaml)")
	// 绑定到viper的config中
	viper.BindPFlag("config", rootCmd.PersistentFlags().Lookup("config"))

	rootCmd.AddCommand(versionCmd)
	rootCmd.Execute()

	// 一定要注意 viper变量的获取要在root.CmdExecute()之后执行
	// 因为要保证标志解析后使用
	fmt.Println("config:", viper.GetString("config"))
}
```

执行`go run main.go dmy -c=hello.yaml` 将会看到,
```
hello执行前执行
Hello: dmy
hello执行后执行
config: hello.yaml
```

我们能从命令行中获取到配置文件，并且配置文件是绑定到viper的config变量中的,就可以进一步对配置文件进行操作了。

### 九、Run与RunE
RunE是`cobra`提供的带错误处理的版本，建议使用RunE。它相比于`Run`多了一个error的返回值。如果返回了一个error，那么`cobra`会打印错误信息并退出。如果使用Run需要我们自己处理错误。







