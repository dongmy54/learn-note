### redis
文档： https://redis.uptrace.dev/zh/guide/go-redis.html

```go
package main

import (
	"context"
	"fmt"
	"log"
	"time"

	"github.com/redis/go-redis/v9"
)

func main() {
	// 连接redis
	rdb := redis.NewClient(&redis.Options{
		Addr:     "localhost:6379",
		Password: "", // 没有密码，默认值
		DB:       0,  // 默认DB 0
	})

	// 测试连接
	pong, err := rdb.Ping(context.TODO()).Result()
	if err != nil {
		panic(err)
	}
	log.Println(pong) // 输出 PONG

	// ================== 通过内置函数操作 ==================
	// Result返回对应的类型
	val, err := rdb.Set(context.TODO(), "my_counter", 23, 3*time.Second).Result()
	if err != nil {
		log.Printf("set error: %v\n", err)
	}

	log.Printf("==========设置后值为：%#v", val)
	v1, err := rdb.Get(context.TODO(), "my_counter").Result()
	if err != nil {
		log.Printf("get error: %v", err)
	}
	log.Printf("==========获取后值为：%#v", v1)

	vvv, _ := rdb.SetNX(context.TODO(), "my_counter", 12, 3*time.Second).Result()
	if vvv {
		log.Printf("设置成功啦")
	}
	log.Printf("==========设置后值为：%#v 类型：%T", vvv, vvv)
	// 2024/11/24 21:48:33 ==========设置后值为：false 类型：bool

	sv, _ := rdb.SAdd(context.TODO(), "my_set", "a", "b", "c").Result()
	log.Printf("==========设置set后值为：%#v 类型为：%T", sv, sv)
	// 2024/11/24 21:45:47 ==========设置set后值为：0 类型为：int64

	sv1, _ := rdb.SIsMember(context.TODO(), "my_set", "a").Result()
	log.Printf("==========判断set中是否存在a：%#v 类型为：%T", sv1, sv1)
	// 2024/11/24 21:45:07 ==========判断set中是否存在a：true 类型为：bool

	// ================== 通过Do操作 ==================
	// Do可以执行任意命令
	// 注意这里返回的是interface{} 需要类型断言的哦
	val1, err := rdb.Do(context.TODO(), "get", "my_counter").Result()
	if err != nil {
		log.Printf("get error: %v\n", err)
	}
	fmt.Printf("=====Do Get my_counter值：%#v 类型为：%T\n", val1, val1)

	val2, _ := rdb.Do(context.TODO(), "setnx", "my_counter", 12).Result()
	fmt.Printf("=====Do setnx my_counter值：%#v 类型为：%T\n", val2, val2.(int64))

	// 它提供了需要方法可以直接转对应类型哦
	// s, err := cmd.Text()
	// flag, err := cmd.Bool()

	// num, err := cmd.Int()
	// num, err := cmd.Int64()
	// num, err := cmd.Uint64()
	// num, err := cmd.Float32()
	// num, err := cmd.Float64()

	// ss, err := cmd.StringSlice()
	// ns, err := cmd.Int64Slice()
	// ns, err := cmd.Uint64Slice()
	// fs, err := cmd.Float32Slice()
	// fs, err := cmd.Float64Slice()
	// bs, err := cmd.BoolSlice()
	v, _ := rdb.Do(context.TODO(), "get", "my_counter").Text()
	fmt.Printf("=====Do Get my_counter值：%#v 类型为：%T\n", v, v)
	// =====Do Get my_counter值："23" 类型为：string

	// ==================== lua 脚本 =====================
	var incrBy = redis.NewScript(`
		local key = KEYS[1]
		local change = ARGV[1]

		local value = redis.call("GET", key)
		if not value then
			value = 0
		end

		value = value + change
		redis.call("SET", key, value)

		return value
		`)

	keys := []string{"my_counter"}
	values := []interface{}{1}
	num, err := incrBy.Run(context.TODO(), rdb, keys, values...).Int()
	log.Printf("===========num: %#v  err:%#v", num, err)
	// 2024/11/24 21:41:40 ===========num: 24  err:<nil>
}
```
