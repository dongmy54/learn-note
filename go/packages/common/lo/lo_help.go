// 常用help

// ======================== IsEmpty 是否为空 ==============
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

// ===================== Try 安全尝试 ================
// Try
// 1. 发生错误/panic 返回false
// 2. 没有错误/panic 返回true
ok := lo.Try(func() error {
	//panic("error")
	return errors.New("error")
})
// false
fmt.Println(ok)

// 没有错误/panic 返回true
ok = lo.Try(func() error {
	return nil
})
// true
fmt.Println(ok)

// ==================== TryCatch try+捕获 ==============
// 发生错误或者panic 都会执行catch
caught := false
lo.TryCatch(func() error {
	panic("error")
	//return errors.New("error")
}, func() {
	fmt.Println("前面发生错误 我这里捕获到啦")
	caught = true
})
// true
fmt.Println(caught)

// ================== AttemptWithDelay 失败重试 ======================
var num int
// 尝试5次 每次间隔1s
iter, duration, err := lo.AttemptWithDelay(5, 1*time.Second, func(i int, duration time.Duration) error {
	tmp := rand.Intn(100)
	if tmp > 50 { // 如果获取到一个大于50的数，则成功
		num = tmp
		return nil
	}

	return fmt.Errorf("failed")
})

fmt.Println(iter, duration, err, num)
// 尝试了2次 用时1.001194962s 成功 获取到的num是59
// 2 1.001194962s <nil> 59





