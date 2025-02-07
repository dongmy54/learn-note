package main

import (
	"fmt"

	"github.com/go-resty/resty/v2"
)

func main() {
	client := resty.New()

	// curl 'http://192.168.15.188:82/df/dxbi/data/table/query' \
	// -H 'accept: application/json, text/plain, */*' \
	// -H 'accept-language: zh-CN,zh;q=0.9' \
	// -H 'authorization: eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJiZyI6ZmFsc2UsImNvbW1vbmlkIjoiIiwiZXhwIjoxNzM3NjMwMzM4LCJmaWQiOiJiNjlkNzY5OS01MzQ4LTQ4ODMtODA0NC0wMzY4MTVmYTI5N2MiLCJnaWQiOjAsImlhdCI6MTczNzU5NDMzOCwiaXNzIjoiZnVzc2VuZHgyIiwicm9sZSI6ImFkbWluIiwidXNlcmlkIjoiMSIsInVzZXJ0eXBlIjoiIn0.9B1utd-OS3Fg5JrhfDvuJerFqtEv3NcrJTtlUzyupmM' \
	// -H 'cache-control: no-cache' \
	// -H 'content-type: application/json' \
	// -H 'origin: https://dxrtc.yayi360.com' \
	// -H 'pragma: no-cache' \
	// -H 'priority: u=1, i' \
	// -H 'referer: https://dxrtc.yayi360.com/' \
	// -H 'sec-ch-ua: "Google Chrome";v="131", "Chromium";v="131", "Not_A Brand";v="24"' \
	// -H 'sec-ch-ua-mobile: ?0' \
	// -H 'sec-ch-ua-platform: "macOS"' \
	// -H 'sec-fetch-dest: empty' \
	// -H 'sec-fetch-mode: cors' \
	// -H 'sec-fetch-site: same-site' \
	// -H 'token: eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJiZyI6ZmFsc2UsImNvbW1vbmlkIjoiIiwiZXhwIjoxNzM3NjMwMzM4LCJmaWQiOiJiNjlkNzY5OS01MzQ4LTQ4ODMtODA0NC0wMzY4MTVmYTI5N2MiLCJnaWQiOjAsImlhdCI6MTczNzU5NDMzOCwiaXNzIjoiZnVzc2VuZHgyIiwicm9sZSI6ImFkbWluIiwidXNlcmlkIjoiMSIsInVzZXJ0eXBlIjoiIn0.9B1utd-OS3Fg5JrhfDvuJerFqtEv3NcrJTtlUzypmM' \
	// -H 'user-agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36' \
	// --data-raw '{"id":"recharge_list","params":[{"k":"startDate","v":"1736438400"},{"k":"endDate","v":"1737561600"}],"page":0,"size":50}'

	type Result struct {
		Code int         `json:"code"`
		Msg  string      `json:"msg"`
		Data interface{} `json:"data"`
	}

	r := Result{}
	resp, err := client.R().
		SetHeader("Content-Type", "application/json").
		SetAuthToken(
			"eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJiZyI6ZmFsc2UsImNvbW1vbmlkIjoiIiwiZXhwIjoxNzM3NzE3MTU0LCJmaWQiOiJiNjlkNzY5OS01MzQ4LTQ4ODMtODA0NC0wMzY4MTVmYTI5N2MiLCJnaWQiOjAsImlhdCI6MTczNzY4MTE1NCwiaXNzIjoiZnVzc2VuZHgyIiwicm9sZSI6ImFkbWluIiwidXNlcmlkIjoiMSIsInVzZXJ0eXBlIjoiIn0.At_ZUoacDlMEoSPF4wKtvpqX4zxdm4IwEzuEFTEsJsg",
		).
		SetBody(`{"id":"bill_list","params":[{"k":"startDate","v":"1736438400"},{"k":"endDate","v":"1737561600"}],"page":0,"size":50}`).
		SetResult(&r).
		Post("http://192.168.15.188:82/df/dxbi/data/table/query")

	fmt.Printf("err: %v\n", err)
	fmt.Printf("res: %#v\n", resp.StatusCode())
	fmt.Printf("resbody: %s\n", resp.Body())
	fmt.Printf("r: %#v\n", r.Code)
}
