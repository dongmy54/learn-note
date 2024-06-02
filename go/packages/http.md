## net/http
`net/http`是go语言自带的一个http包，它非常简单、高效；即可以作为客户端发起请求，也可以编写服务端api接口，我们所见的各种web框架，都是在它的基础上建立的，下面我们一起来看下。

### 一、客户端GET
#### 1. 简单的GET请求
```go
package main

import (
	"io"
	"log"
	"net/http"
)

func main() {
	res, err := http.Get("http://www.baidu.com")
	if err != nil {
		log.Fatalf("Error getting URL: %s", err)
	}
	// 确保资源释放
	defer res.Body.Close()

	// 读取响应内容
	body, err := io.ReadAll(res.Body)
	if err != nil {
		log.Fatalf("Error reading response body: %s", err)
	}
	log.Printf("Response body: %s", string(body))
}
```

#### 2. 带参数
```go
package main

import (
	"io"
	"log"
	"net/http"
	"net/url"
)

func main() {
	// 构造请求参数
	params := url.Values{}
	params.Add("name", "dmy")
	params.Add("age", "25")

	// 构造完成的请求URL
	queryStr := params.Encode()
	url := "http://www.baidu.com?" + queryStr

	log.Printf("Sending request to URL: %s", url)
	res, err := http.Get(url)
	if err != nil {
		log.Fatalf("Error getting URL: %s", err)
	}
	// 确保资源释放
	defer res.Body.Close()

	// 读取响应内容
	body, err := io.ReadAll(res.Body)
	if err != nil {
		log.Fatalf("Error reading response body: %s", err)
	}
	log.Printf("Response body: %s", string(body))
}
```

#### 3. 带请求头
带请求头就要复杂些了，需要构造`request`和`client`
```go
package main

import (
	"io"
	"log"
	"net/http"
)

func main() {
	//带请求头需要先构造出一个request对象
	req, err := http.NewRequest("GET", "http://www.baidu.com", nil)
	if err != nil {
		log.Fatalln(err)
	}
	//在request对象上添加请求头
	req.Header.Add("key1", "value1")
	req.Header.Add("key2", "value2")

	// 构造一个客户端
	resp, err := http.DefaultClient.Do(req)
	if err != nil {
		log.Fatalln(err)
	}
	defer resp.Body.Close()
	body, err := io.ReadAll(resp.Body)
	if err != nil {
		log.Fatalln(err)
	}
	log.Println(string(body))
}
```

### 二、客户端POST
#### 1. 表单形式
`content-type: application/x-www-form-urlencoded`

```go
package main

import (
	"io"
	"log"
	"net/http"
	"strings"
)

func main() {
	body := strings.NewReader("city=成都&key=8yyyyy")
	// 下面这种方式也是可以的
	// params := url.Values{}
	// params.Add("city", "成都")
	// params.Add("key", "8yyyyy")
	// body := strings.NewReader(params.Encode())

	resp, err := http.Post("http://apis.juhe.cn/simpleWeather/query", "application/x-www-form-urlencoded", body)
	if err != nil {
		log.Fatalln(err)
	}
	defer resp.Body.Close()
	resBody, err := io.ReadAll(resp.Body)
	if err != nil {
		log.Fatalln(err)
	}
	log.Println(string(resBody))
}
```

#### 2. json形式
`"Content-Type", "application/json"`
```go
package main

import (
	"bytes"
	"encoding/json"
	"io"
	"log"
	"net/http"
)

func main() {
	// 准备一个map来存参数
	params := map[string]string{
		"city": "成都",
		"key1": "value2",
	}

	// json序列化
	jsonParams, err := json.Marshal(params)
	if err != nil {
		log.Fatalln(err)
	}
	// 构造io.Reader
	body := bytes.NewBuffer(jsonParams)
	req, err := http.NewRequest("POST", "http://apis.juhe.cn/simpleWeather/query", body)
	if err != nil {
		log.Fatalln(err)
	}

	req.Header.Set("Content-Type", "application/json")
	resp, err := http.DefaultClient.Do(req)
	if err != nil {
		log.Fatalln(err)
	}
	defer resp.Body.Close()
	bodyBytes, err := io.ReadAll(resp.Body)
	if err != nil {
		log.Fatalln(err)
	}
	log.Println(string(bodyBytes))
}
```

### 三、关于响应的解析
对于接口中响应内容解析我们有两种方式：
1. 通过`json.json.Unmarshal()`接绑到对应结构体，只是这种方式需要定义结构体比较麻烦
2. 使用**类型推断解析**，不用定义结构体比较灵活

比如：
```go
log.Printf("resp body: %s", string(bodyBytes))
// resp body: {"reason":"查询成功!","result":{"city":"成都","realtime":{"temperature":"23","humidity":"67","info":"阴","wid":"02","direct":"东北风","power":"3级","aqi":"35"},"future":[{"date":"2024-06-02","temperature":"18\/23℃","weather":"阴转阵雨","wid":{"day":"02","night":"03"},"direct":"持续无风向"},{"date":"2024-06-03","temperature":"18\/25℃","weather":"阵雨","wid":{"day":"03","night":"03"},"direct":"持续无风向"},{"date":"2024-06-04","temperature":"18\/25℃","weather":"多云转阴","wid":{"day":"01","night":"02"},"direct":"持续无风向"},{"date":"2024-06-05","temperature":"19\/29℃","weather":"多云转小雨","wid":{"day":"01","night":"07"},"direct":"持续无风向"},{"date":"2024-06-06","temperature":"19\/26℃","weather":"阴转小雨","wid":{"day":"02","night":"07"},"direct":"持续无风向"}]},"error_code":0}

// 先解析到map中
var data map[string]interface{}
json.Unmarshal(bodyBytes, &data)
log.Printf("resp.reason: %s", data["reason"])
// resp.reason: 查询成功!

// map[string]interface{} 层层解析
log.Printf("resp.result.temprature: %s", data["result"].(map[string]interface{})["realtime"].(map[string]interface{})["temperature"])
// resp.result.temprature: 23
```

### 三、编写服务端接口
```go
package main

import (
	"encoding/json"
	"log"
	"net/http"
)

func handler(w http.ResponseWriter, r *http.Request) {
	// 返回hello world
	//fmt.Fprint(w, "hello world")
	w.Write([]byte("hello world"))
}

func jsonHandler(w http.ResponseWriter, r *http.Request) {
	r.Header.Set("Content-Type", "application/json")
	data := map[string]string{"message": "hello world"}
	// 序列化json
	jsonData, err := json.Marshal(data)
	if err != nil {
		http.Error(w, err.Error(), http.StatusInternalServerError)
		return
	}
	// 写入
	w.Write(jsonData)
}

// 处理get和post请求
func getPostHandler(w http.ResponseWriter, r *http.Request) {
	switch r.Method {
	case "GET":
		// 处理get请求
		w.Write([]byte("thi is a get request"))
	case "POST":
		w.Write([]byte("this is a post request"))
	default:
		w.Write([]byte("this is a default request"))
	}
}

func main() {
	// 首页
	http.HandleFunc("/", handler)
	// 响应json
	http.HandleFunc("/json", jsonHandler)
	// post和get请求
	http.HandleFunc("/get_post", getPostHandler)

	log.Println("Server is running on port 8080")
	http.ListenAndServe(":8080", nil)
}

// curl http://localhost:8080/
// curl -X POST http://localhost:8080/get_post
// curl -X GET http://localhost:8080/get_post
```

### 四、封装请求调用
在项目中涉及接口调用时，如果每次要用就单独去编写，以来代码会非常冗余，而来也不便于管理，因此通常需要对接口调用进行封装，以后使用的时候，直接调用封装好的方法就行，下面我们进行封装。

```go
package main

import (
	"bytes"
	"encoding/json"
	"fmt"
	"io"
	"mime/multipart"
	"net/http"
	"net/url"
	"os"
	"path/filepath"
)

// ResponseData 响应数据结构
type ResponseData struct {
	Code    int    `json:"code"`
	Success bool   `json:"success"`
	Data    string `json:"data"`
}

// DataType 请求数据类型
type DataType int

// 以枚举的方式定义请求数据类型
const (
	JSONType DataType = iota
	QueryType
	FormType
	MultipartFormType
)

// 返回枚举的字符串表示
func (d DataType) String() string {
	return [...]string{"JSON", "Query", "Form", "MultipartForm"}[d]
}

// RequestOption 请求选项函数
// 我们通过它实现对请求的各种参数设置, 在SendRequest中我们通过下面的代码运行这些option
//
//	for _, option := range options {
//		err = option(req)
//		if err != nil {
//			return nil, err
//		}
//	}
type RequestOption func(*http.Request) error

// WithHeaders 设置请求头
func WithHeaders(headers map[string]string) RequestOption {
	return func(req *http.Request) error {
		for key, value := range headers {
			req.Header.Set(key, value)
		}
		return nil
	}
}

// WithQueryParams 设置查询参数
func WithQueryParams(params map[string]string) RequestOption {
	return func(req *http.Request) error {
		queryValues := url.Values{}
		for key, value := range params {
			queryValues.Add(key, value)
		}
		req.URL.RawQuery = queryValues.Encode()
		return nil
	}
}

// WithJSONBody 设置JSON请求体
func WithJSONBody(data interface{}) RequestOption {
	return func(req *http.Request) error {
		jsonData, err := json.Marshal(data)
		if err != nil {
			return err
		}
		req.Body = io.NopCloser(bytes.NewBuffer(jsonData))
		req.Header.Set("Content-Type", "application/json")
		return nil
	}
}

// WithFormBody 设置表单请求体
func WithFormBody(data map[string]string) RequestOption {
	return func(req *http.Request) error {
		formValues := url.Values{}
		for key, value := range data {
			formValues.Add(key, value)
		}
		req.Body = io.NopCloser(bytes.NewBufferString(formValues.Encode()))
		req.Header.Set("Content-Type", "application/x-www-form-urlencoded")
		return nil
	}
}

// WithMultipartFormBody 设置多部分表单请求体
func WithMultipartFormBody(data map[string]string, filePath string) RequestOption {
	return func(req *http.Request) error {
		body := &bytes.Buffer{}
		writer := multipart.NewWriter(body)

		// 添加请求数据
		for key, value := range data {
			_ = writer.WriteField(key, value)
		}

		// 添加文件
		file, err := os.Open(filePath)
		if err != nil {
			return err
		}
		defer file.Close()

		part, err := writer.CreateFormFile("file", filepath.Base(filePath))
		if err != nil {
			return err
		}
		_, err = io.Copy(part, file)
		if err != nil {
			return err
		}

		// 关闭多部分表单数据写入器
		err = writer.Close()
		if err != nil {
			return err
		}

		req.Body = io.NopCloser(body)
		req.Header.Set("Content-Type", writer.FormDataContentType())
		return nil
	}
}

// SendRequest 发送请求
func SendRequest(urlStr string, method string, options ...RequestOption) (*ResponseData, error) {
	// 创建一个新的请求
	req, err := http.NewRequest(method, urlStr, nil)
	if err != nil {
		return nil, err
	}

	// 应用请求选项
	for _, option := range options {
		err = option(req)
		if err != nil {
			return nil, err
		}
	}

	// 发送请求
	resp, err := http.DefaultClient.Do(req)
	if err != nil {
		return nil, err
	}
	defer resp.Body.Close()

	// 读取响应数据
	body, err := io.ReadAll(resp.Body)
	if err != nil {
		return nil, err
	}

	// 创建响应数据
	responseData := ResponseData{
		Code:    resp.StatusCode,
		Success: resp.StatusCode >= 200 && resp.StatusCode < 300,
		Data:    string(body),
	}

	return &responseData, nil
}

func main() {
	url := "http://apis.juhe.cn/simpleWeather/query"
	method := "POST"
	headers := map[string]string{
		"Content-Type": "application/x-www-form-urlencoded",
	}
	requestData := map[string]string{
		"city": "深圳",
		"key":  "xxxx",
	}
	//filePath := "/path/to/file"

	responseData, err := SendRequest(
		url,
		method,
		WithHeaders(headers),
		WithQueryParams(requestData),
	)
	if err != nil {
		fmt.Println("Error:", err)
		return
	}

	fmt.Println("Response Code:", responseData.Code)
	fmt.Println("Response Success:", responseData.Success)
	fmt.Println("Response Data:", responseData.Data)
}
```



