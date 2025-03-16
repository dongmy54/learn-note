## retry包
go语言虽然自身就有net/http包，但是说实话用起来没那么好用。retry包是go语言中一个非常受欢迎的http请求处理包，它的api非常简洁、属于一看就懂的那种、对新手非常有友好。它支持链式调用、支持超时、重试机制，还支持中间件，可以在请求发送前，发送后做些操作，使用起来非常舒服。
今天我们一起来看下吧。

### 安装
先来安装下`go get github.com/go-resty/resty/v2`

### 一、一个简单的get
发一个get请求试试呢？
```go
package main

import (
	"fmt"

	"github.com/go-resty/resty/v2"
)

func main() {
	client := resty.New()

	resp, err := client.R().
		Get("https://www.baidu.com")

	if err != nil {
		fmt.Println("请求出错:", err)
		return
	}

	fmt.Println("状态码:", resp.StatusCode())
	fmt.Println("响应体:", resp.String())
	fmt.Println("响应头:", resp.Header())                       // 获取全部header
	fmt.Println("特定响应头:", resp.Header().Get("Content-Type")) // 获取特定的header
	// 状态码: 200
	// 响应体: xxx太多了省略掉...
	// 响应头: map[Accept-Ranges:[bytes] Cache-Control:[no-cache] Connection:[keep-alive] Content-Length:[227] Content-Security-Policy:[frame-ancestors 'self' https://chat.baidu.com http://mirror-chat.baidu.com https://fj-chat.baidu.com https://hba-chat.baidu.com https://hbe-chat.baidu.com https://njjs-chat.baidu.com https://nj-chat.baidu.com https://hna-chat.baidu.com https://hnb-chat.baidu.com http://debug.baidu-int.com;] Content-Type:[text/html] Date:[Sun, 16 Mar 2025 09:43:18 GMT] P3p:[CP=" OTI DSP COR IVA OUR IND COM " CP=" OTI DSP COR IVA OUR IND COM "] Pragma:[no-cache] Server:[BWS/1.1] Set-Cookie:[BD_NOT_HTTPS=1; path=/; Max-Age=300 BIDUPSID=10846246655E82CCF356A792677D7EA8; expires=Thu, 31-Dec-37 23:55:55 GMT; max-age=2147483647; path=/; domain=.baidu.com PSTM=1742118198; expires=Thu, 31-Dec-37 23:55:55 GMT; max-age=2147483647; path=/; domain=.baidu.com BAIDUID=10846246655E82CC89D4B0052594BBBE:FG=1; max-age=31536000; expires=Mon, 16-Mar-26 09:43:18 GMT; domain=.baidu.com; path=/; version=1; comment=bd] Traceid:[1742118198045022490612843349543995319034] X-Ua-Compatible:[IE=Edge,chrome=1] X-Xss-Protection:[1;mode=block]]
	// 特定响应头: text/html
}
```
使用起来非常简单，它支持链式调用，唯一需要注意的是**`请求方式 + 路径`要放在最后——它返回响应**。

### 二、带查询参数
```go
resp, err := client.R().
	SetQueryParam("postId", "1"). // 设置单个查询参数 也是可以的
	Get("https://jsonplaceholder.typicode.com/posts")

// resp, err := client.R().
// 	SetQueryParams(map[string]string{ // 设置多个查询参数
// 		"postId": "1",
// 	}).
// 	Get("https://jsonplaceholder.typicode.com/posts")
```
它支持一次设置多个查询参数`SetQueryParams`、和单个查询参数`SetQueryParam`两种方式方式。

### 三、设置请求头、body
由于支持链式调用，设置请求头也很方便
```go
	resp, err := client.R().
		SetHeader("Content-Type", "application/json"). // 设置单个请求头
		SetBody(`{"title": "foo", "body": "bar", "userId": 1}`). // 字符串形式
		Post("https://jsonplaceholder.typicode.com/posts")

	resp, err := client.R().
		SetBody(map[string]interface{}{ // 支持 map结构
			"title":  "foo",
			"body":   "bar",
			"userId": 1,
		}).
		SetHeaders(map[string]string{  // 设置多个请求头
			"Content-Type": "application/json",
		}).
		Post("https://jsonplaceholder.typicode.com/posts")

	resp, err := client.R().
		SetBody(Post{Title: "foo", Body: "bar", UserId: 1}). // 支持struct
		SetHeaders(map[string]string{
			"Content-Type": "application/json",
		}).
		Post("https://jsonplaceholder.typicode.com/posts")

	// 从文件创建 io.Reader
	file, err := os.Open("my_file.txt")
	if err != nil {
			// ... 错误处理 ...
	}
	defer file.Close()
	resp, err := client.R().
			// 不设置也可以， resty会根据reader自动推断content-type
			SetHeader("Content-Type", "application/octet-stream"). // 或者根据文件类型设置
			SetBody(file). // 支持 io.Reader方式
			Post("https://example.com/upload")
```
- `SetBody` 支持方式非常丰富`json字符串`、`map`、`struct`、`[]byte`、`io.Reader`
- 设置请求头和前面的设置查询参数类似，同时支持单个、多个`复数s`两种方式。

### 四、设置表单数据
```go
resp, err := client.R().
		SetFormData(map[string]string{"title": "foo", "body": "bar", "userId": "1"}).
		Post("https://jsonplaceholder.typicode.com/posts")
```
需要注意`SetFormData`参数只支持`map[string]string`类型。

### 五、处理响应

```go
// 请求
	type postReq struct {
		Title  string `json:"title"`
		Body   string `json:"body"`
		UserId int    `json:"userId"`
	}

	// 响应
	type postRes struct {
		ID     int    `json:"id"`
		Title  string `json:"title"`
		Body   string `json:"body"`
		UserId int    `json:"userId"`
	}

	var pr postRes

	resp, err := client.R().
		SetHeader("Content-Type", "application/json").
		SetBody(postReq{Title: "foo", Body: "bar", UserId: 1}).
		SetResult(&pr). // 设置响应后内容
		Post("https://jsonplaceholder.typicode.com/posts")

	if err != nil {
		fmt.Println("请求出错:", err)
		return
	}

	fmt.Println("请求成功了么？", resp.IsSuccess()) // 是否响应成了
	fmt.Printf("响应结果:%#v\n", pr)
	// 请求成功了么？ true
	// 响应结果:main.postRes{ID:101, Title:"foo", Body:"bar", UserId:1}
```
- `IsSuccess`判断 响应是否成
- `SetResult`支持把响应结果映射到结构体中

### 六、超时与重试
```go
	client := resty.New().
		SetTimeout(5 * time.Second).          // 设置超时时间
		SetRetryCount(3).                     // 设置重试次数为 3
		SetRetryWaitTime(1 * time.Second).    // 设置重试间隔为 1 秒
		SetRetryMaxWaitTime(5 * time.Second). //最大重试间隔
		AddRetryCondition(
			func(r *resty.Response, err error) bool {
				return r.StatusCode() == http.StatusTooManyRequests // 429 错误时重试
			},
		)

	resp, err := client.R().
		SetHeader("Content-Type", "application/json").
		SetBody(postReq{Title: "foo", Body: "bar", UserId: 1}).
		SetResult(&pr).
		Post("https://jsonplaceholder.typicode.com/posts")
```

需要之一的是`resty.New()` 和 下面的 `client.R()`是不同的类，前者主要用于设置全局性相关的设置（比如：超时、重试等）；
后者主要用于请求的发送相关设置；

### 七、调试模式
```go
resp, err := client.R().
		SetHeader("Content-Type", "application/json").
		SetBody(postReq{Title: "foo", Body: "bar", UserId: 1}).
		SetResult(&pr).
		SetDebug(true). // 开启调试模式
		Post("https://jsonplaceholder.typicode.com/posts")
```
- 调试模式开启，请求的所有参数、和响应内容都可以看到。

### 八、中间件
```go
client := resty.New()

// 请求中间件
client.OnBeforeRequest(func(c *resty.Client, req *resty.Request) error {
	fmt.Println("发送请求前:", req.URL)
	// 可以修改请求, 比如 req.SetHeader("New-Header", "value")
	return nil
})

// 响应中间件
client.OnAfterResponse(func(c *resty.Client, resp *resty.Response) error {
	fmt.Println("收到响应后:", resp.Status())
	return nil
})

resp, err := client.R().
	SetHeader("Content-Type", "application/json").
	SetBody(postReq{Title: "foo", Body: "bar", UserId: 1}).
	SetResult(&pr).
	Post("https://jsonplaceholder.typicode.com/posts")
```
它也支持中间件，在发送请求前、请求后做些处理。

