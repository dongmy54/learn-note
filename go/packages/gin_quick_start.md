## gin quick start
gin是go最受欢迎的web框架之一。有必要熟练掌握，老规矩，我们还是按照一步步探索的方式，从零开始一起学习它,不要怕，一切都很简单加油！。

### 1. 项目搭建
1. `mkdir gin_practice` 
2. `cd gin_practice`
3. `go mod init gin_practice` 初始化go mod
4. `touch main.go`创建main文件

`main.go`内容如下，我们先实现一个简单的hello world展示吧
```go
package main

import "github.com/gin-gonic/gin"

func main() {
	// 创建一个默认的路由器
	r := gin.Default()

	// 注册一个hello路由
	r.GET("/hello", func(c *gin.Context) {
		// 向客户端返回hello world
		c.String(200, "hello world")
	})
	r.Run() // 启动服务 默认在8080端口
}
```

执行`go mod tidy` 更新需要必须的包（这里会拉取`gin`包）
然后执行`go run .`跑起来
```shell
dongmingyan@pro ⮀ ~/go_playground/gin_practice ⮀ go run .
[GIN-debug] [WARNING] Creating an Engine instance with the Logger and Recovery middleware already attached.

[GIN-debug] [WARNING] Running in "debug" mode. Switch to "release" mode in production.
 - using env:   export GIN_MODE=release
 - using code:  gin.SetMode(gin.ReleaseMode)

[GIN-debug] GET    /hello                    --> main.main.func1 (3 handlers)
[GIN-debug] [WARNING] You trusted all proxies, this is NOT safe. We recommend you to set a value.
Please check https://pkg.go.dev/github.com/gin-gonic/gin#readme-don-t-trust-all-proxies for details.
[GIN-debug] Environment variable PORT is undefined. Using port :8080 by default
[GIN-debug] Listening and serving HTTP on :8080
```

好啦，浏览器打开`http://localhost:8080/hello`就能看到输出的"hello world"了。
![alt text](images/gin_hello.png)

到这里我们已经实现了一个最最基本的web请求，🎉🎉🎉


### 2. 基本的json响应
在大多数时候,前后端分离项目，响应的是`json`而不是字符串，因此我们来看看如何响应一个json.

```go
func main() {
	// 省略...

	// 响应json的hello路由
	r.GET("/hellojson", func(c *gin.Context) {
		c.JSON(200, gin.H{
			"code":    200,
			"message": "hello world",
		})
	})

	r.Run() // 启动服务
}
```

这个时候，`ctrl + c`终止掉，重新`go run .` 启动服务（PS：每次更新都需要重新启动）
浏览器输入`http://localhost:8080/hellojson`
![alt text](images/gin_hellojson.png)

### 3. html页面
要响应html页面，当然我们需要创建html页面，首先给它一个存放html页面的目录
- `mkdir templates`
- `touch templates/index.html` 新建index文件
  
`index.html`
```html
<html>
<head>
	<title>Welcome to Gin Practice</title>
</head>
<body>
	<h1>
    <!-- 通过 {{ .变量 }} 使用参数-->
    {{ .title }}欢迎您来到Gin Practice
  </h1>
	<p>这里是我们的第一个gin页面</p>
</body>
</html>
```

修改`main.go`文件
```go
func mian {
  // ...

  // 响应html页面
	r.LoadHTMLGlob("templates/*") // 加载模板文件
	//r.LoadHTMLFiles("templates/template1.html", "templates/template2.html")
	r.GET("/index.html", func(c *gin.Context) {
		c.HTML(200, "index.html", gin.H{
			"title": "dmy", // 传递给模板的数据
		})
	})

	r.Run() // 启动服务
}
```

重启服务后浏览器输入`http://localhost:8080/index.html`
![alt text](images/gin_index_html.png)

可以响应html也可以传参到页面上，理论上不区分前后端一起开发也是支持的。

### 4. POST/PUT/Delete请求
前面我们快速的上手了响应了json和html页面，但是我们请求的方式都是`GET`，这里一起学习下其它的请求方式。

#### 4.1 POST
```go
func main {
  // ...

  // POST请求
	r.POST("/login", func(c *gin.Context) {
		name := c.PostForm("name")         // 获取表单数据
		password := c.PostForm("password") // 获取表单数据

		type any map[string]interface{}
		c.JSON(200, gin.H{
			"code":    200,
			"message": "login success",
			"data":    any{"name": name, "password": password}, // 传递给客户端的数据
		})
	})

	r.Run() // 启动服务
}
```
您可以在`postman`或者`apifox`这样的工具中测试
```shell
 dongmingyan@pro ⮀ ~ ⮀ curl --location --request POST 'http://localhost:8080/login' \
--form 'name="dmy"' \
--form 'password="123456"'

{"code":200,"data":{"name":"dmy","password":"123456"},"message":"login success"}
```

#### 4.2 PUT
```go
func main {
  // ...

  // PUT更新请求
	r.PUT("/user/:id", func(c *gin.Context) {
		id := c.Param("id") // 获取路径参数
		name := c.PostForm("name")
		password := c.PostForm("password")

		type any map[string]interface{}
		c.JSON(200, gin.H{
			"code":    200,
			"message": "update success",
			"data":    any{"id": id, "name": name, "password": password},
		})
	})
	r.Run() // 启动服务
}
```

为简单起见我们直接命令行执行吧。
```shell
curl --location --request PUT 'http://localhost:8080/user/12' \
  --form 'name="dmy"' \
  --form 'password="123456"'

{"code":200,"data":{"id":"12","name":"dmy","password":"123456"},"message":"update success"}
```


#### 4.3 Delete
修改main.go
```go
func main(){
  // ...

	// DELETE删除请求
	r.DELETE("/user/:id", func(c *gin.Context) {
		id := c.Param("id") // 获取路径参数
		c.JSON(200, gin.H{
			"code":    200,
			"message": "delete success",
			"data":    id,
		})
	})

	r.Run() // 启动服务
}
```
测试
```shell
curl --location --request DELETE 'http://localhost:8080/user/12'

{"code":200,"data":"12","message":"delete success"}
```

### 5. 获取参数值
gin针对各种参数的获取都写了响应的各种方法，前面我们使用了一些比如：**form、路径参数**,这里我们进一步探索其它参数的获取方式。

#### 5.1 查询参数
```go
  // 查询参数
	// curl "http://localhost:8080/query?name=dmy&age=20&ids=1&ids=2&ids=3"
	// 返回结果：{"code":200,"data":{"age":"20","ids":["1","2","3"],"name":"dmy"},"message":"query success"}
	r.GET("/query", func(c *gin.Context) {
		name := c.Query("name")            // 获取查询参数
		age := c.DefaultQuery("age", "18") // 获取查询参数，如果不存在则返回默认值
		ids := c.QueryArray("ids")         // 获取查询参数数组

		fmt.Printf("%#v\n", ids)
		c.JSON(200, gin.H{
			"code":    200,
			"message": "query success",
			"data":    gin.H{"name": name, "age": age, "ids": ids},
		})
	})
```

#### 5.2 json绑定参数
这种用的比较多,参数进来后，绑定到一个结构体上
```go
  type User struct {
		Name string `form:"name" json:"name" xml:"name" binding:"required"`
		Age  int    `form:"age" json:"age" xml:"age" binding:"required"`
	}

  // curl -X POST -H "Content-Type: application/json" -d '{"name": "dmy", "age": 20}' http://localhost:8080/users
	r.POST("/users", func(c *gin.Context) {
		var user User
		// 自动决定绑定类型，默认是JSON绑定 也可以是xml
		if err := c.ShouldBind(&user); err == nil {
			fmt.Println(user.Name, user.Age)
			c.JSON(200, gin.H{
				"code":    200,
				"message": "user created",
				"data":    user,
			})
		} else {
			c.JSON(400, gin.H{
				"code":    400,
				"message": "invalid request",
				"error":   err.Error(),
			})
		}
	})
```

#### 5.3 表单form参数
```go
  // 表单参数
	//  curl -X POST  -d "ids=1&ids=2&ids=3" -d "name=dmy" -d "password=6789" http://localhost:8080/form
	// 返回结果： {"code":200,"data":{"ids":["1","2","3"],"name":"dmy","password":"6789"},"message":"form success"}
	// 表单参数
	//  curl -X POST  -d "ids=1&ids=2&ids=3" -d "name=dmy&password=456" -d "account[id]=111&account[name]=dmy" http://localhost:8080/form
	// 返回结果： {"code":200,"data":{"account":{"id":"111","name":"dmy"},"ids":["1","2","3"],"name":"dmy","password":"456"},"message":"form success"}
	r.POST("/form", func(c *gin.Context) {
		name := c.PostForm("name")
		password := c.DefaultPostForm("password", "123456") // 获取表单参数，如果不存在则返回默认值
		ids := c.PostFormArray("ids")                       // 获取表单参数数组
		// 表单map
		account := c.PostFormMap("account") // account[id]=111&account[name]=dmy

		fmt.Println(name, password)
		c.JSON(200, gin.H{
			"code":    200,
			"message": "form success",
			"data":    gin.H{"name": name, "password": password, "ids": ids, "account": account},
		})
	})
```

#### 5.4 文件上传
```go
// 文件上传
	// curl -X POST -F "file=@/Users/dongmingyan/Desktop/test.txt" http://localhost:8080/upload
	r.POST("/upload", func(c *gin.Context) {
		file, _ := c.FormFile("file") // 获取上传的文件

		c.SaveUploadedFile(file, "./uploads/"+file.Filename) // 保存文件到指定路径
		c.JSON(200, gin.H{
			"code":    200,
			"message": "upload success",
			"data":    file.Filename,
		})
	})
```

#### 5.5 其它
```go
// /user/:id
id := c.Param("id") // 获取路径参数

// 请求头
token := c.GetHeader("Authorization")
```

### 6. 路由组
根据api区分v1和v2的路由
```go
//========================== 路由组 ==========================//
	apiGroup := r.Group("/api")
	{
		// api/v1路由组
		v1Group := apiGroup.Group("/v1")
		{
			v1Group.GET("/users", func(c *gin.Context) {
				c.JSON(200, gin.H{"code": 200, "message": "v1 users"})
			})
		}

		// api/v2路由组
		v2Group := apiGroup.Group("/v2")
		{
			v2Group.GET("/users", func(c *gin.Context) {
				c.JSON(200, gin.H{"code": 200, "message": "v2 users"})
			})
		}
	}
```

### 7. 中间件
- 定义中间键
```go
// 定义用户中间件
func userMiddleware() gin.HandlerFunc {
	return func(c *gin.Context) {
		// 做一些用户的获取和验证操作

		currentUser := "dmy"              // 获取当前用户信息
		c.Set("currentUser", currentUser) // 设置当前用户信息到上下文

		c.Next() // 继续处理请求
		//c.JSON(404, gin.H{"code": 404, "message": "not found"})
		//c.Abort() // 中止请求 终止前要写响应不然啥也没有
	}
}
```

- 注册中间件
```go
func main() {
	// 创建一个默认的路由器
	r := gin.Default()

	r.Use(userMiddleware()) // 注册用户中间件 这里注册后对所有的路由都能获取到当前用户信息
  
  // ...
}
```

- 使用中间件
```go
// 测试当前用户信息
	r.GET("/current_user", func(c *gin.Context) {
		// 获取当前用户信息 这是中间件中存下的
		currentUser, exists := c.Get("currentUser")

		if exists {
			c.JSON(200, gin.H{
				"code":         200,
				"message":      "current user",
				"current_user": currentUser,
			})
		} else {
			c.JSON(401, gin.H{
				"code":    401,
				"message": "unauthorized",
			})
		}
	})
```

### 8. 日志记录到文件
默认情况下gin的日志没有写到文件中，所以需要手动配置下
```go
func main() {
	//日志记录到当前目录下development.log文件
	f, _ := os.Create("development.log")
	// 同时保留了控制台输出
	gin.DefaultWriter = io.MultiWriter(f, os.Stdout)

  //...
}
```

### 9. 完整代码
`main.go`完整代码如下
```go
package main

import (
	"fmt"
	"io"
	"os"

	"github.com/gin-gonic/gin"
)

func main() {
	//日志记录到当前目录下development.log文件
	f, _ := os.Create("development.log")
	// 同时保留了控制台输出
	gin.DefaultWriter = io.MultiWriter(f, os.Stdout)

	// 创建一个默认的路由器
	r := gin.Default()

	r.Use(userMiddleware()) // 注册用户中间件 这里注册后对所有的路由都能获取到当前用户信息
	// 注册一个hello路由
	r.GET("/hello", func(c *gin.Context) {
		// 向客户端返回hello world
		c.String(200, "hello world")
	})

	// 响应json的hello路由
	r.GET("/hellojson", func(c *gin.Context) {
		c.JSON(200, gin.H{
			"code":    200,
			"message": "hello world",
		})
	})

	// 响应html页面
	r.LoadHTMLGlob("templates/*") // 加载模板文件
	//r.LoadHTMLFiles("templates/template1.html", "templates/template2.html")
	r.GET("/index.html", func(c *gin.Context) {
		c.HTML(200, "index.html", gin.H{
			"title": "dmy", // 传递给模板的数据
		})
	})

	// POST请求
	r.POST("/login", func(c *gin.Context) {
		name := c.PostForm("name")         // 获取表单数据
		password := c.PostForm("password") // 获取表单数据

		type any map[string]interface{}
		c.JSON(200, gin.H{
			"code":    200,
			"message": "login success",
			"data":    any{"name": name, "password": password}, // 传递给客户端的数据
		})
	})

	// PUT更新请求
	r.PUT("/user/:id", func(c *gin.Context) {
		id := c.Param("id") // 获取路径参数
		name := c.PostForm("name")
		password := c.PostForm("password")

		type any map[string]interface{}
		c.JSON(200, gin.H{
			"code":    200,
			"message": "update success",
			"data":    any{"id": id, "name": name, "password": password},
		})
	})

	// DELETE删除请求
	r.DELETE("/user/:id", func(c *gin.Context) {
		id := c.Param("id") // 获取路径参数
		c.JSON(200, gin.H{
			"code":    200,
			"message": "delete success",
			"data":    id,
		})
	})

	//========================== 参数部分 ==========================//
	// 查询参数
	// curl "http://localhost:8080/query?name=dmy&age=20&ids=1&ids=2&ids=3"
	// 返回结果：{"code":200,"data":{"age":"20","ids":["1","2","3"],"name":"dmy"},"message":"query success"}
	r.GET("/query", func(c *gin.Context) {
		name := c.Query("name")            // 获取查询参数
		age := c.DefaultQuery("age", "18") // 获取查询参数，如果不存在则返回默认值
		ids := c.QueryArray("ids")         // 获取查询参数数组

		fmt.Printf("%#v\n", ids)
		c.JSON(200, gin.H{
			"code":    200,
			"message": "query success",
			"data":    gin.H{"name": name, "age": age, "ids": ids},
		})
	})

	type User struct {
		Name string `form:"name" json:"name" xml:"name" binding:"required"`
		Age  int    `form:"age" json:"age" xml:"age" binding:"required"`
	}

	// curl -X POST -H "Content-Type: application/json" -d '{"name": "dmy", "age": 20}' http://localhost:8080/users
	r.POST("/users", func(c *gin.Context) {
		var user User
		// 自动决定绑定类型，默认是JSON绑定 也可以是xml
		if err := c.ShouldBind(&user); err == nil {
			fmt.Println(user.Name, user.Age)
			c.JSON(200, gin.H{
				"code":    200,
				"message": "user created",
				"data":    user,
			})
		} else {
			c.JSON(400, gin.H{
				"code":    400,
				"message": "invalid request",
				"error":   err.Error(),
			})
		}
	})

	// 表单参数
	//  curl -X POST  -d "ids=1&ids=2&ids=3" -d "name=dmy&password=456" -d "account[id]=111&account[name]=dmy" http://localhost:8080/form
	// 返回结果： {"code":200,"data":{"account":{"id":"111","name":"dmy"},"ids":["1","2","3"],"name":"dmy","password":"456"},"message":"form success"}
	r.POST("/form", func(c *gin.Context) {
		name := c.PostForm("name")
		password := c.DefaultPostForm("password", "123456") // 获取表单参数，如果不存在则返回默认值
		ids := c.PostFormArray("ids")                       // 获取表单参数数组
		// 表单map
		account := c.PostFormMap("account") // account[id]=111&account[name]=dmy

		fmt.Println(name, password)
		c.JSON(200, gin.H{
			"code":    200,
			"message": "form success",
			"data":    gin.H{"name": name, "password": password, "ids": ids, "account": account},
		})
	})

	// 文件上传
	// curl -X POST -F "file=@/Users/dongmingyan/Desktop/test.txt" http://localhost:8080/upload
	r.POST("/upload", func(c *gin.Context) {
		file, _ := c.FormFile("file") // 获取上传的文件

		c.SaveUploadedFile(file, "./uploads/"+file.Filename) // 保存文件到指定路径
		c.JSON(200, gin.H{
			"code":    200,
			"message": "upload success",
			"data":    file.Filename,
		})
	})

	//========================== 路由组 ==========================//
	apiGroup := r.Group("/api")
	{
		// api/v1路由组
		v1Group := apiGroup.Group("/v1")
		{
			v1Group.GET("/users", func(c *gin.Context) {
				c.JSON(200, gin.H{"code": 200, "message": "v1 users"})
			})
		}

		// api/v2路由组
		v2Group := apiGroup.Group("/v2")
		{
			v2Group.GET("/users", func(c *gin.Context) {
				c.JSON(200, gin.H{"code": 200, "message": "v2 users"})
			})
		}
	}

	// 测试当前用户信息
	r.GET("/current_user", func(c *gin.Context) {
		// 获取当前用户信息
		currentUser, exists := c.Get("currentUser")

		if exists {
			c.JSON(200, gin.H{
				"code":         200,
				"message":      "current user",
				"current_user": currentUser,
			})
		} else {
			c.JSON(401, gin.H{
				"code":    401,
				"message": "unauthorized",
			})
		}
	})

	r.Run() // 启动服务
}

// 定义用户中间件
func userMiddleware() gin.HandlerFunc {
	return func(c *gin.Context) {
		// 做一些用户的获取和验证操作

		currentUser := "dmy"              // 获取当前用户信息
		c.Set("currentUser", currentUser) // 设置当前用户信息到上下文

		c.Next() // 继续处理请求
		//c.JSON(404, gin.H{"code": 404, "message": "not found"})
		//c.Abort() // 中止请求 终止前要写响应不然啥也没有
	}
}
```




