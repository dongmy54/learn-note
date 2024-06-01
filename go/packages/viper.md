## viper
在go的项目中，我们常常会涉及到各种配置参数的使用,viper可以非常轻松、灵活的帮助我们管理各项配置，下面我们一起来看下。

### 一、快速使用
我们先从一个最简单的demo快速上手，它的使用非常简单。

假设你已经初始化好了一个项目,我们直接开始,在项目目录下创建一个`config.yaml`文件作为我们的配置文件。
```yaml
server:
  port: 8080

database:
  host: localhost
  port: 3306
  user: root
  password: password
```

然后我们在`main.go`中读取配置
```go
package main

import (
	"fmt"

	"github.com/spf13/viper"
)

func main() {
	viper.SetConfigName("config") // 设置配置文件名（无需加后缀）
	// viper.SetConfigType("yaml")   // 设置配置文件类型 可以省略
	viper.AddConfigPath(".") // 设置配置文件路径
	// 读取配置文件
	if err := viper.ReadInConfig(); err != nil {
		fmt.Println("Error reading config file, ", err)
	}
	// 读取配置项
	fmt.Printf("server.port: %d\n", viper.GetInt("server.port"))                                                             // 读取配置项并转换类型
	fmt.Printf("database.host: %s and database.port: %d\n", viper.GetString("database.host"), viper.GetInt("database.port")) // 读取配置项并转换类型
}
```

运行`run main.go`您将看到如下输出：
```shell
dongmingyan@pro ⮀ ~/go_playground/hello ⮀ go run main.go
server.port: 8080
database.host: localhost and database.port: 3306
```
我们成功啦！

需要注意的写入viper配置信息我们都是通过`GetXXX`的方式获取的，除了上面看到的还有些其它类型，比如：
```go
Get(key string) : any
GetBool(key string) : bool
GetFloat64(key string) : float64
GetInt(key string) : int
GetIntSlice(key string) : []int
GetString(key string) : string
GetStringMap(key string) : map[string]any
GetStringMapString(key string) : map[string]string
GetStringSlice(key string) : []string
GetTime(key string) : time.Time
GetDuration(key string) : time.Duration
```

如果你想查看viper中所有的信息，可以使用`viper.AllSettings()`查看

### 二、常见使用
我们已经成功上车，让我们进一步探索一些常见的使用方式。

#### 1. 设置默认值
为了在缺省的情况程序能正常使用，默认值非常重要
```go
viper.SetDefault("server.port", 9090) // 设置默认值
```

#### 2. 手动设置变量值
```go
viper.Set("name", "hello") // 设置name 默认值
viper.Set("age", 20) // 设置age默认值

// 可以看到刚才设置的值
fmt.Println("name", viper.Get("name"))
// hello
fmt.Println("age", viper.GetInt("age"))
// 20
```
需要注意的是**Set方式设置的值具有最高优先级，会使你在配置文件、环境变量中设置的值均失效**。

#### 3. 读取环境变量
如果项目搭配docker使用,使用环境变量非常方便。
需要注意的是：对于**环境变量是区分大小写的,viper匹配的是大写的key**,因此使用时，环境变量一律大写。
PS: 但是`viper.GetXX(这里key可以随意)`

```go
// 它代表的是将调用时候的点替换成下划线，比如：app.name => APP_NAME环境变量
// 如果涉及分割符号转换repace是必须的，viper不会自动将app.name 和 环境变量APP_NAME关联起来

replace := strings.NewReplacer(".", "_") // 替换点为下划线
viper.SetEnvKeyReplacer(replace)         // 设置环境变量的替换器
viper.AutomaticEnv()                     // 自动绑定环境变量

// export APP_NAME=hello
// app.name中点替换为_ => app_name 转大写 => APP_NAME
fmt.Println("app.name", viper.GetString("app.name"))
// key大小写随意写，它始终能找到大小的环境变量key APP_VERSON
fmt.Println("App.name", viper.GetString("App.name"))
// 不用点替换也行
fmt.Println("app_name", viper.GetString("app.name"))

// 上面三者获取都是同一个环境变量
```
**环境变量前缀**
```go
viper.AutomaticEnv()                     // 自动绑定环境变量
viper.SetEnvPrefix("APP")                // 设置环境变量的前缀

// 自动获取带前缀APP_NAME的值
fmt.Println("name", viper.GetString("name"))
```

#### 4. 命令行读取值
有时候我们希望在程序启动时，从命令行获取一些参数的值，viper也是能做到的，搭配`pflags`一起使用

引入
```go
import(
  //...
  "github.com/spf13/pflag"
  //...
)
```

```go
// 使用pflag定义一个命令行参数
pflag.Int("port", 9999, "app port") // 命令行参数名为port，默认端口号为9999
// 解析
pflag.Parse()
viper.BindPFlag("app.port", pflag.Lookup("port")) // 将获取到的port绑定到viper的配置项app.port上

fmt.Println("app.port", viper.GetInt("app.port")) // 打印获取到的端口号
```
外部使用`go run main.go --port=8888`测试。

#### 5. 配置信息绑定到结构体
viper支持将配置信息绑定到一个结构体中，假设我们有一个`AppConfig`的结构体需要绑定，代码如下：
```go
package main

import (
	"fmt"

	"github.com/spf13/viper"
)

type AppConfig struct {
	Name    string `mapstructure:"name"`
	Version string `mapstructure:"version"`
}

func main() {
	viper.AddConfigPath("./")
	viper.SetConfigName("config")

	if err := viper.ReadInConfig(); err != nil {
		panic(err)
	}

	var appConfig AppConfig
	// 将配置中的app部分绑定到AppConfig实例
	// config.yaml有
	// app:
	// 	 name: my-app
	// 	 version: 1.0.0
	viper.UnmarshalKey("app", &appConfig)

	fmt.Printf("Name: %s, Version: %s\n", appConfig.Name, appConfig.Version)
	// Name: my-app, Version: 1.0.0
}
```

#### 6. 判断是否有设置值
有时候我们需要判断一个key是否有设置
```go
viper.IsSet("app.name")
// true
viper.IsSet("app.number")
// false
```

#### 7. 写配置数据到文件
一个线上的配置配置数据，设置是动态的；我们如果想查看这些配置，或者固化到配置文件中viper也提供了方式。
我们这里展示将配置文件写入一个指定文件
```go
if err := viper.WriteConfigAs("new_config.yaml"); err != nil {
	fmt.Printf("Error writing config: %s\n", err)
}

// 上面的代码会在当前项目下写入new_config.yaml文件
// 它还提供了安全的方式带Safe的自行查看文档
```

### 8. 实时监听配置文件变更?
viper支持实时监听配置文件，啥意思？意思就是程序启动后，我们去修改配置文件仍然能生效。
怎么做呢？
```go
// 监控配置文件变化
viper.WatchConfig()
// fsnotify一个单独的包
// 这是一个回调函数，当配置文件变化时，会调用这个函数
viper.OnConfigChange(func(e fsnotify.Event) {
  fmt.Println("Config file changed:", e.Name)
  // 变化后的值
  fmt.Printf("viper all settings: %v\n", viper.AllSettings())
})
```

### 三、配置优先级顺序
`手动Set > 命令行 > 环境变量 > 配置文件`

### 四、关于key的大小写？
在**viper中只有环境变量区分大小写，其它都不区分大小写**;在获取值时可以是任意大小写的值
```go
// 下面都获取的是同一个值
// 如果是在yaml文件中 变量名不区分大小 可以是name1 Name1 namE1都可以
// 如果在环境变量中   始终对应NAME1
fmt.Println("name1", viper.GetString("name1"))
fmt.Println("name1", viper.GetString("Name1"))
fmt.Println("name1", viper.GetString("nAme1"))
fmt.Println("name1", viper.GetString("nAMe1"))
```

### 五、多配置文件如何使用?
如果配置参数比较多，全部写在一个文件中，感觉不太清晰；我们可以把配置拆分到多个文件中，使用viper读取多个文件，然后采用`MergeInConfig`方式合并配置项来实现。

下面我们看看如何实现,假设我们把所有的配置项都放在`config`目录下，这个目录下有
- `database.yaml`
- `redis.yaml`
- `settings.yaml`
这些配置文件，以后还会有许多的配置文件等等。


我们在config目录下新建`config.go`文件
```go
package config

import (
	"fmt"
	"os"
	"path/filepath"

	"github.com/spf13/viper"
)

func NewConfig() *viper.Viper {
	v := viper.New()
	// 设置配置文件的目录
	configDir := "./config"
	v.AddConfigPath(configDir)

	// 获取配置目录下的所有文件
	files, err := os.ReadDir(configDir)
	if err != nil {
		fmt.Println("读取配置文件失败：", err)
	}

	// 遍历所有文件
	for _, file := range files {
		// 获取文件的完整路径
		filePath := filepath.Join(configDir, file.Name())

		// 获取文件的扩展名
		ext := filepath.Ext(filePath)

		// 只处理.yaml文件
		if ext == ".yaml" {
			// 设置配置文件的名称（不包括扩展名）
			baseName := filepath.Base(filePath) // 这里是包含了扩展名的
			configName := baseName[0 : len(baseName)-len(ext)]
			v.SetConfigName(configName)

			// 读取配置文件 (会覆盖之前的配置)
			if err := v.MergeInConfig(); err != nil {
				fmt.Println("读取配置文件失败：", err)
			}
		}
	}
	return v
}
```

在`main.go`中引入使用
```go
package main

import (
	"fmt"

	"example/user/hello/config"
)

func main() {
	all_config := config.NewConfig()
	fmt.Println(all_config.AllSettings())
}
```





