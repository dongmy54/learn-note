### package
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
在go中有导出的概念

#### 初始化

#### 包嵌套

