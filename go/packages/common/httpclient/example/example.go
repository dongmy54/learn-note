package main

import (
	"context"
	"errors"
	"fmt"
	"httpclient"
	"net/http"
	"time"

	"github.com/zeromicro/go-zero/core/logx"
)

// curl 'http://192.168.15.188:82/df/dxbi/data/table/query' \
//   -H 'accept: application/json, text/plain, */*' \
//   -H 'accept-language: zh-CN,zh;q=0.9' \
//   -H 'authorization: eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJiZyI6ZmFsc2UsImNvbW1vbmlkIjoiIiwiZXhwIjoxNzM3NjMwMzM4LCJmaWQiOiJiNjlkNzY5OS01MzQ4LTQ4ODMtODA0NC0wMzY4MTVmYTI5N2MiLCJnaWQiOjAsImlhdCI6MTczNzU5NDMzOCwiaXNzIjoiZnVzc2VuZHgyIiwicm9sZSI6ImFkbWluIiwidXNlcmlkIjoiMSIsInVzZXJ0eXBlIjoiIn0.9B1utd-OS3Fg5JrhfDvuJerFqtEv3NcrJTtlUzyupmM' \
//   -H 'cache-control: no-cache' \
//   -H 'content-type: application/json' \
//   -H 'origin: https://dxrtc.yayi360.com' \
//   -H 'pragma: no-cache' \
//   -H 'priority: u=1, i' \
//   -H 'referer: https://dxrtc.yayi360.com/' \
//   -H 'sec-ch-ua: "Google Chrome";v="131", "Chromium";v="131", "Not_A Brand";v="24"' \
//   -H 'sec-ch-ua-mobile: ?0' \
//   -H 'sec-ch-ua-platform: "macOS"' \
//   -H 'sec-fetch-dest: empty' \
//   -H 'sec-fetch-mode: cors' \
//   -H 'sec-fetch-site: same-site' \
//   -H 'token: eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJiZyI6ZmFsc2UsImNvbW1vbmlkIjoiIiwiZXhwIjoxNzM3NjMwMzM4LCJmaWQiOiJiNjlkNzY5OS01MzQ4LTQ4ODMtODA0NC0wMzY4MTVmYTI5N2MiLCJnaWQiOjAsImlhdCI6MTczNzU5NDMzOCwiaXNzIjoiZnVzc2VuZHgyIiwicm9sZSI6ImFkbWluIiwidXNlcmlkIjoiMSIsInVzZXJ0eXBlIjoiIn0.9B1utd-OS3Fg5JrhfDvuJerFqtEv3NcrJTtlUzyupmM' \
//   -H 'user-agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36' \
//   --data-raw '{"id":"recharge_list","params":[{"k":"startDate","v":"1736438400"},{"k":"endDate","v":"1737561600"}],"page":0,"size":50}'

func main() {
	client := httpclient.NewBase(
		httpclient.WithBaseURL("http://192.168.15.188:82"),
		httpclient.WithMaxRetries(3),
		httpclient.WithRetryCondition(func(req *http.Request, resp *httpclient.Response, err error) bool {
			// 自定义逻辑示例：404状态码也重试
			if resp != nil && resp.StatusCode == 401 {
				return true
			}
			return false
		}),
		httpclient.WithLogger(logx.WithContext(context.TODO())),
	)

	body := struct {
		ID     string `json:"id"`
		Params []struct {
			K string `json:"k"`
			V string `json:"v"`
		} `json:"params"`
		Page int `json:"page"`
		Size int `json:"size"`
	}{
		ID: "recharge_list",
		Params: []struct {
			K string `json:"k"`
			V string `json:"v"`
		}{
			{K: "startDate", V: "1736438400"},
			{K: "endDate", V: "1737561600"},
		},
		Page: 0,
		Size: 50,
	}

	resp, err := client.NewRequest("POST", "/df/dxbi/data/table/query").
		Header("Accept", "application/json").
		Header("authorization", "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJiZyI6ZmFsc2UsImNvbW1vbmlkIjoiIiwiZXhwIjoxNzM3NjMwMzM4LCJmaWQiOiJiNjlkNzY5OS01MzQ4LTQ4ODMtODA0NC0wMzY4MTVmYTI5N2MiLCJnaWQiOjAsImlhdCI6MTczNzU5NDMzOCwiaXNzIjoiZnVzc2VuZHgyIiwicm9sZSI6ImFkbWluIiwidXNlcmlkIjoiMSIsInVzZXJ0eXBlIjoiIn0.9B1utd-OS3Fg5JrhfDvuJerFqtEv3NcrJTtlUzyupm").
		Body(body).
		Timeout(5 * time.Second).
		Do()

	if err != nil {
		var httpErr *httpclient.HTTPError
		if errors.As(err, &httpErr) {
			// 处理 HTTP 错误
			fmt.Println(httpErr)
		} else {
			// 处理其他错误
			fmt.Println(err)
		}
	}

	// 处理响应
	var tmpStruct struct {
		Code int    `json:"code"`
		Msg  string `json:"msg"`
		Data struct {
			Header []struct {
				K string `json:"k"`
				V string `json:"v"`
			} `json:"header"`
			List []struct {
				CreatedAt     string `json:"CreatedAt"`
				Remarks       string `json:"Remarks"`
				ThirdPartyID  string `json:"ThirdPartyId"`
				Amount        string `json:"amount"`
				Channel       string `json:"channel"`
				Currency      string `json:"currency"`
				GroupName     string `json:"group_name"`
				ID            string `json:"id"`
				OwnerID       string `json:"owner_id"`
				PayerID       string `json:"payer_id"`
				PaymentAmount string `json:"payment_amount"`
				Status        string `json:"status"`
				UserID        string `json:"user_id"`
				UserName      string `json:"user_name"`
				WalletID      string `json:"wallet_id"`
				WalletType    string `json:"wallet_type"`
			} `json:"list"`
		} `json:"data"`
	}

	fmt.Println(resp)
	fmt.Println(resp.Text())
	if err = resp.DecodeJSON(&tmpStruct); err != nil {
		fmt.Println(err)
	}

	fmt.Printf("%#v\n", tmpStruct)
}

// 初始化客户端
// client := httpclient.NewBase(
// 	httpclient.WithBaseURL("https://api.example.com"),
// 	httpclient.WithMaxRetries(3),
// )

// // 执行请求
// resp, err := client.NewRequest("GET", "/users/{id}").
// 	PathParam("id", "123").
// 	QueryParam("verbose", "true").
// 	Header("Accept", "application/json").
// 	Timeout(5 * time.Second).
// 	Do()

// if err != nil {
// 	var httpErr *httpclient.HTTPError
// 	if errors.As(err, &httpErr) {
// 		fmt.Printf("请求失败: %s\n", httpErr)
// 	}
// 	// 处理其他错误...
// }

// // 处理响应
// var user User
// if err := resp.DecodeJSON(&user); err != nil {
// 	// 处理解码错误...
// }
// fmt.Printf("用户信息: %+v\n", user)

// body其它用法
// 表单
// formData := url.Values{}
// formData.Set("username", "johndoe")
// formData.Set("password", "secret")

// resp, err := builder.Body(formData).Do() // 自动编码为表单

// 原始字节
// binaryData := []byte{0x48, 0x65, 0x6c, 0x6c, 0x6f} // "Hello"的二进制
// resp, err := builder.Body(binaryData).Do()

// 流式
// file, _ := os.Open("data.txt")
// defer file.Close()

// resp, err := builder.Body(file).Do() // 流式传输大文件

// 文件传输
// 打开文件
// file, err := os.Open("report.pdf")
// if err != nil {
//     log.Fatal(err)
// }
// defer file.Close()

// // 读取文件信息
// fileInfo, _ := file.Stat()
// fileSize := fileInfo.Size()

// // 发送请求
// resp, err := client.NewRequest("PUT", "/uploads").
//     Body(file). // 直接使用文件流
//     Header("Content-Type", "application/pdf").
//     Header("Content-Length", fmt.Sprintf("%d", fileSize)).
//     Do()
