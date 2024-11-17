### retry 是一个方便重试api的包

```go
package main

import (
	"errors"
	"fmt"
	"io/ioutil"
	"log"
	"net"
	"net/http"
	"time"

	"github.com/avast/retry-go/v4"
)

func main() {
	customErr := errors.New("custom error")
	url := "http://localhost:8080/homestay/detail?id"
	var body []byte

	// 匿名函数
	callFun := func() error {
		resp, err := http.Get(url)

		if err == nil {
			defer func() {
				if err := resp.Body.Close(); err != nil {
					panic(err)
				}
			}()
			body, err = ioutil.ReadAll(resp.Body)
		}

		// 通过类型断言判断是否为某个错误
		if netErr, ok := err.(net.Error); ok {
			log.Printf("network error: %#v\n", netErr)
			return customErr
		}

		fmt.Printf("error: %#v\n", err)
		return err
	}

	err := retry.Do(callFun,
		retry.RetryIf(func(err error) bool {
			return err == customErr // retry only network error
		}),
		retry.Attempts(2),
		retry.Delay(1*time.Second), // 重试延迟1s
	)

	if err != nil {
		log.Println("重试完后仍然没有成功")
	} else {
		fmt.Println(string(body))
	}
}
```