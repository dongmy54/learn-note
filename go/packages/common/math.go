// package: math

// =================== Inf / NaN =====================
// go 中除以0并不报错为无穷大
// IsInf 判断是否是无穷大
a := 1.0
divVal := a / 0.0
fmt.Printf("divVal %#v\n", divVal) // 正无穷大
// divVal + Inf
fmt.Println(math.IsInf(divVal, 0))
// true

// IsNaN
zero := 0
zeroDiv := 0.0 / float64(zero) // 0 除以 0
fmt.Println(zeroDiv)
// NaN
fmt.Println(math.IsNaN(zeroDiv))
// true

// ================== 取数 ==========================
// Ceil向上取整数
fmt.Println(math.Ceil(234.45))
// 235

// Floor向下取整数
fmt.Println(math.Floor(234.45))
// 234
fmt.Println(math.Floor(-2.3)) // 注意这里向下取整则这里 向更小的-3取值
// -3

// Round 四舍五入取整数 更通用
fmt.Println(math.Round(234.45))
// 234
fmt.Println(math.Round(-2.3))
// -2

// 绝对值
fmt.Println(math.Abs(-2.3))
// 最大值
// 2.3
fmt.Println(math.Max(2, 4.5))
// 最小值
// 4.5
fmt.Println(math.Min(3, -2))
// -2

// ===================== 小数点保留 ======================
// 保留小数点 方式1: Sprintf
num := 123.456789
result := fmt.Sprintf("%.3f", num) // 保留三位小数
fmt.Println(result)
// 输出: 123.457

// 方式2：通过先乘，再除处理
num1 := 123.456789
ratio := math.Pow(10, 3)              // 计算精度范围，三位小数 = 1000
res := math.Round(num1*ratio) / ratio // 保留三位小数
fmt.Println(res)                      // 输出: 123.457


