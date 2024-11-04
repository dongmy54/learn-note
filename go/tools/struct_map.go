package main

import (
	"database/sql"
	"errors"
	"fmt"
	"reflect"

	"golang.org/x/exp/maps"
)

func main() {
	// 使用示例
	var x int
	if IsZero(x) {
		fmt.Println("x 是零值")
	}

	fmt.Println("字符串: ", IsZero("hello"))
	fmt.Println("字符串: ", IsZero(""))
	fmt.Println("整数: ", IsZero(0))
	fmt.Println("bool: ", IsZero(false))

	u := User{Id: 10, Name: "zhangsan", Age: 10}
	r1, _ := StructEffectiveMap(u)
	fmt.Printf("user effective map: %#v\n", r1)

	u2 := User{}
	r2, _ := StructEffectiveMap(u2)
	fmt.Printf("user effective map: %#v\n", r2)

	sql1 := sql.NullString{String: "hello", Valid: true}
	sql2 := sql.NullString{String: "", Valid: false}
	fmt.Println("sql.NullString: ", IsZero(sql1))
	fmt.Println("sql.NullString: ", IsZero(sql2))

	u3 := User{Id: 23, Name: "", Age: 0}
	fmt.Println("user3: ", StructUpdateMap(u3))
	u4 := User{Id: 23, Name: "xx", Age: 0}
	fmt.Println("user4: ", StructUpdateMap(u4))
}

type User struct {
	Id   int
	Name string
	Age  int
}

// 一个值是否是0值
func IsZero(v interface{}) bool {
	return reflect.ValueOf(v).IsZero()
}

// 结构体转有效map
func StructEffectiveMap(v any) (results map[string]interface{}, err error) {
	rt := reflect.TypeOf(v)
	rv := reflect.ValueOf(v)

	if rt.Kind() != reflect.Struct {
		return nil, errors.New("only support struct")
	}

	results = make(map[string]interface{})
	for i := 0; i < rt.NumField(); i++ {
		value := rv.Field(i)
		if IsZero(value.Interface()) {
			continue
		}
		results[rt.Field(i).Name] = value.Interface()
	}
	return results, nil
}

// 结构体转更新Map（检查时要过滤掉仅仅id的情况）
func StructUpdateMap(v any) map[string]interface{} {
	results, err := StructEffectiveMap(v)
	if err != nil {
		return nil
	}

	keys := maps.Keys(results)
	if len(keys) == 1 && keys[0] == "Id" {
		return nil
	}
	return results
}
