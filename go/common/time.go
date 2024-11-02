// pacakge time

// 当前时间
now := time.Now() // 返回time.Time
fmt.Printf("%#v\n", now)
// time.Date(2024, time.November, 2, 12, 16, 55, 838800000, time.Local)

// 格式化 这里的时间只能是2006年1月2日 下午3点04分05秒
tstr := now.Format("2006-1-2 15:04:05")
fmt.Printf("%#v\n", tstr)
// "2024-11-2 13:07:06"

// 年月日 时分秒
fmt.Printf("年：%d\n", now.Year())
// 年：2024
fmt.Printf("月：%d\n", now.Month())
// 月：11
fmt.Printf("日：%d\n", now.Day())
fmt.Printf("时：%d\n", now.Hour())
fmt.Printf("分：%d\n", now.Minute())
fmt.Printf("秒：%d\n", now.Second())
fmt.Printf("一年中第几天：%d\n", now.YearDay())
fmt.Printf("当前时区：%s\n", now.Location())
fmt.Printf("周几：%d\n", now.Weekday())
// 周几：6

// 字符串解析成时间 PS：这里要保证两者格式一致
// 第一个参数代表 时间格式
t1, err := time.Parse("2006-01-02 15:04:05", "2022-12-03 13:00:06")
if err != nil {
	fmt.Println(err)
}
fmt.Println(t1)
// 2022-12-03 13:00:06 +0000 UTC

// 时区
loc, _ := time.LoadLocation("Asia/Shanghai")

// 根据时区解析
t2, err := time.ParseInLocation("2006-01-02 15:04:05", "2023-10-23 23:34:12", loc)
if err != nil {
	fmt.Println(err)
}
fmt.Println(t2)
// 2023-10-23 23:34:12 +0800 CST

// 时间戳
timeStamp := now.Unix() // 单位秒
fmt.Println(timeStamp)
// 1730525737
tmis := now.UnixMilli() // 豪秒
fmt.Println(tmis)
// 1730525863606
ms := now.UnixMicro() // 微秒
fmt.Println(ms)
// 1730525863606522
ns := now.UnixNano() // 纳
fmt.Println(ns)
// 1730526003547891000

// 时间戳转时间
pt := time.Unix(timeStamp, 0) // 第二个参数是纳秒 一般直接写0
fmt.Printf("秒解析后时间：%s\n", pt)
// 秒解析后时间：2024-11-02 13:47:07 +0800 CST
pt1 := time.UnixMilli(tmis)
fmt.Printf("毫秒解析后时间： %s\n", pt1)
// 毫秒解析后时间： 2024-11-02 13:47:07.686 +0800 CST

// 时间转时区
japanZone, err := time.LoadLocation("Asia/Tokyo")
if err != nil {
	fmt.Println(err)
}
japanTime := now.In(japanZone)

fmt.Printf("UTC时间：%s\n", now.Format("2006-1-2 15:04:05"))
// UTC时间：2024-11-2 13:52:46
fmt.Printf("日本时间：%s\n", japanTime.Format("2006-1-2 15:04:05"))
// 日本时间：2024-11-2 14:52:46

// 返回一天的开始
BeginOfDay := time.Date(now.Year(), now.Month(), now.Day(), 0, 0, 0, 0, now.Location())
fmt.Printf("%s\n", BeginOfDay)
// 2024-11-02 00:00:00 +0800 CST

// 当前时间加1小时
n_time := now.Add(time.Hour)
fmt.Println(n_time)
// 2024-11-02 15:17:00.980928 +0800 CST m=+3600.000133787

// 当前时间减一个小时
s_time := now.Add(-time.Hour)
fmt.Println(s_time)
// 2024-11-02 13:17:00.980928 +0800 CST m=-3599.999866213

// 时间比较 【时间没法直接加/减和比较】
// 同理还有 .After()
if s_time.Before(n_time) {
	fmt.Println("s_time 在 n_time前")
} else {
	fmt.Println("s_time 在 n_time后")
}
// s_time 在 n_time前

// 计算两个时间的差值
duration := time.Since(s_time) // 当前时间 - s_time 返回 time.Duration
fmt.Println(duration)          // 输出的是xhxmxs类似输出
// 1h0m0.000419626s
fmt.Println(duration.Hours())
// 1.0000001036241666
fmt.Println(duration.Minutes())
// 60.00000621745

dur := time.Until(s_time) // s_time - 当前时间
fmt.Println(dur.Hours())
// -1.0000001016408333
fmt.Println(dur.Minutes())
// -60.00000609845

// 构造一个duration 有效的时间单元最大从h开始
myDuration, err := time.ParseDuration("3h4m5s")
if err != nil {
	fmt.Println(err)
}

ntime := now.Add(myDuration)
fmt.Println(ntime)
// 2024-11-02 17:55:57.979225 +0800 CST m=+11045.000159453
