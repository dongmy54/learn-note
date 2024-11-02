package main

import (
	"fmt"

	"github.com/jinzhu/copier"
)

type User struct {
	Name string
	Age  int
}

type Employee struct {
	Name   string
	Age    int
	Salary float64
}

func main() {
	// copier
	// 1. 必须传递指针进去
	// 2. 结构体复制的是可导出字段
	// 3. 方向 a <- b 后到前
	// 4. 两边字段可以不一样，只影响相同的字段
	// 5. 默认无脑复制，即使是空值，可以采用选项模式

	// ==============结构体 <-> 结构体 ===========
	u := User{}
	e := Employee{Name: "张三", Age: 10, Salary: 23}

	copier.Copy(&u, &e)
	fmt.Printf("===user: %#v\n", u)
	// ===user: main.User{Name:"张三", Age:10}

	u.Name = "李四"
	copier.Copy(&e, &u) // 此时将u拷贝到e
	fmt.Printf("=====拷贝后为: %#v\n", e)
	// =====拷贝后为: main.Employee{Name:"李四", Age:10, Salary:23}

	u1 := User{}
	copier.Copy(&e, &u1) // 由于u1 没有值；这里直接将e置为空了
	fmt.Printf("===%#v\n", e)
	// ===main.Employee{Name:"", Age:0, Salary:23}

	e.Name = "我现在有值了"
	e.Age = 13
	// 带选项模式 IgnoreEmpty 忽略空值
	copier.CopyWithOption(&e, &u1, copier.Option{IgnoreEmpty: true})
	fmt.Printf("===%#v\n", e)
	// ===main.Employee{Name:"我现在有值了", Age:13, Salary:23}

	// =============== slice <-> sice ============
	// 简单切片
	s1 := []string{}
	s2 := []string{"sd", "de", "ef"}
	copier.Copy(&s1, &s2)
	fmt.Printf("=====%#v\n", s1)
	// =====[]string{"sd", "de", "ef"}

	// 结构体切片
	ss1 := []User{}
	ss2 := []Employee{
		{Name: "张三", Age: 18, Salary: 23},
		{Name: "李四", Age: 28, Salary: 28},
	}
	copier.Copy(&ss1, &ss2)
	fmt.Printf("%#v\n", ss1)
	// []main.User{main.User{Name:"张三", Age:18}, main.User{Name:"李四", Age:28}}
}
