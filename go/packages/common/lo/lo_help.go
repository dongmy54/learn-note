// 常用help

// ======================== 是否为空 ==============
// IsEmpty 检查的是是否为零值
// PS: 对切片不可用
fmt.Println(lo.IsEmpty(12))
// false
fmt.Println(lo.IsEmpty(0))
// true

fmt.Println(lo.IsEmpty(""))
// true
fmt.Println(lo.IsEmpty("llala"))
// false

fmt.Println(lo.IsEmpty(false))
// true
fmt.Println(lo.IsEmpty(true))
// false

type User struct {
	ID   int
	Name string
	Age  int
}
fmt.Println(lo.IsEmpty(User{}))
// true
fmt.Println(lo.IsEmpty(User{ID: 1}))
// false
