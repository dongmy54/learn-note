## lo
go语言的理念是“少即是多”，虽然简化了入门的门槛。但是在实际开发中，我们会发现很多其它语言里非常常见的api在go里居然没有，都需要自己去实现。所以多多少还是有些不太便捷。lo这个包就是为了解决这个问题而生，它拥有高达18K的星星。由此可见受欢迎的程度。今天推荐给大家。

### 一、推荐理由
主要有两点：
1. 它能让我**写代码时更便捷**,不用自己动手去实现其它语言里提供的api,**能大大节省代码量和清晰度**。
2. 它基于**泛类**实现，**性能非常好**

#### 举例1：切片转map
比如，在项目里我们经常要操作结构体切片。
假设我们有一个User结构体，如下：
```go
type User struct {
  ID int
  Name string
  Phone string
}
```
我们从数据库获取到了一个`[]User`切片，我们想要转化成以ID为Key，User为Value的Map通常需要按照如下方式处理
```go
users := []User{
		{ID: 1, Name: "John", Phone: "1234567890"},
		{ID: 2, Name: "Jane", Phone: "0987654321"},
	}

uMaps := make(map[int]User)
for _, u := range users {
  uMaps[u.ID] = u
}
fmt.Println(uMaps)
```
但是使用`lo` 我们直接这样就可以了
```go
// 是不是简洁了很多呢
uMaps := lo.KeyBy(users, func(u User) int {
		return u.ID
	})
```

#### 举例2:  切片过滤
比如我们要找出User切片中名字以`Jo`开头的人，我们通常按照需要这样做。
```go
us := make([]User, 0)
	for _, u := range users {
		if strings.HasPrefix(u.Name, "Jo") {
			us = append(us, u)
		}
	}
```
那么用`lo`怎么写呢？
```go
us := lo.Filter(users, func(u User, _ int) bool {
  return strings.HasPrefix(u.Name, "Jo")
})
// 是不是清晰了很多
```

它有非常多好用的api,这里就不一一演示了。下面按照类型分类，我挑选了一些自己觉得非常好用的api，您可以看看。

### 二、切片类
```go
// ========================= 切片转map ======================= //
// 1. 只提供key value默认为元素
usermaps := lo.KeyBy(users, func(user User) int {
	return user.ID
})

fmt.Println(usermaps)
// map[1:{1 Alice} 2:{2 Bob} 3:{3 Charlie}]

// 2. 提供key value
result := lo.SliceToMap(users, func(user User) (int, string) {
	return user.ID, user.Name
})
fmt.Println(result)
// map[1:Alice 2:Bob 3:Charlie]

// ========================== 切片过滤 ===================== //
// Filter过滤出
results := lo.Filter(users, func(user User, _ int) bool {
	return user.ID%2 != 0
})

// [{1 Alice} {3 Charlie}]

// ========================== 切片排除 ===================== //
// Reject 和 Filter相反
result := lo.Reject(users, func(u User, _ int) bool {
	return u.Age == 18
})
fmt.Println(result)

// ========================== 切片分组 ===================== //
// GroupBy 根据某个函数分组
results := lo.GroupBy(users, func(user User) int {
	return user.Age // 按照年龄分组
})

fmt.Println(results)
// map[18:[{1 Alice 18} {3 Charlie 18}] 20:[{2 Bob 20}]]

// Chunk 按照指定大小分组
// 2两两分组
results := lo.Chunk(users, 2)
fmt.Println(results)
// [[{1 Alice 18} {2 Bob 20}] [{3 Charlie 18}]]

// ========================== 切片Map出新map ===================== //
// Map构建出一个新的切片
results := lo.Map(users, func(user User, _ int) User {
	user.ID *= 2
	return user
})

fmt.Println(results)
// [{2 Alice 18} {4 Bob 20} {6 Charlie 18}]

// Map + 过滤
results = lo.FilterMap(users, func(user User, _ int) (User, bool) {
	if user.ID%2 == 0 {
		user.ID *= 2
		return user, true
	} else {
		return user, false
	}
})
fmt.Println(results)
// [{4 Bob 20}]

// ====================== 切片随机 ========================= //
// Sample 随机取一个元素
i := lo.Sample([]int{1, 2, 3, 4, 5, 6, 7, 8, 9, 10})
fmt.Println(i)
// 6
i = lo.Sample([]int{1, 2, 3, 4, 5, 6, 7, 8, 9, 10})
fmt.Println(i)
// 5

// samples 随机多个元素
i := lo.Samples([]int{1, 2, 3, 4, 5, 6, 7, 8, 9, 10}, 2)
fmt.Println(i)
// [8, 4]

// 随机打乱
i := lo.Shuffle([]int{1, 2, 3, 4, 5, 6, 7, 8})
fmt.Println(i)
// [8 4 7 6 3 2 1 5]

// ====================== 切片去重 ========================= //
// Uniq 去重
i := lo.Uniq([]int{1, 2, 4, 1, 2, 4, 6})
fmt.Println(i)
// [1,2,4,6]

// ===================== 切片去除零值 ===================== //
// Compact 去除其中的零值
i := lo.Compact([]string{"a", "a", "", "b"})
fmt.Println(i)

// ===================== 切片摊平 ===================== //
// Flatten 多维变一维
result := lo.Flatten([][]int{{1, 2}, {3, 4}})
fmt.Println(result)
// [1 2 3 4]

// ===================== 切片条件判断 ===================
// Contains 判断是否包含
fmt.Println(lo.Contains([]int{1, 2, 3, 0, 4, 5}, 2))
// true

// EveryBy 所有元素都满足条件
result := lo.EveryBy([]int{1, 2, 3, 5, 6, 7}, func(i int) bool {
	return i < 10
})
fmt.Println(result)
// true

// SomeBy 任何一个元素满足条件
result = lo.SomeBy([]int{1, 2, 3, 5, 6, 7}, func(i int) bool {
	return i < 5
})
fmt.Println(result)
// true

// ====================== 交/差/并集 ====================== //
// Intersect 交集
result := lo.Intersect([]int{0, 1, 2, 3, 6}, []int{2, 3, 4})
fmt.Println(result)
// [2 3]

// Difference 差集
// left, right 代表左右独有的
left, right := lo.Difference([]int{0, 1, 2, 3, 6}, []int{2, 3, 4})
fmt.Println(left, right)
// [0 1 6] [4]

// Union 并集
result = lo.Union([]int{0, 1, 2, 3, 6}, []int{2, 3, 4})
fmt.Println(result)
// [0 1 2 3 6 4]
```

### 三、 map类
```go
// lo map相关的东西

// ================== keys/Values ===================
m1 := map[string]int{
	"foo": 1,
	"bar": 2,
}
result := lo.Keys(m1)
fmt.Println(result)
// [foo bar]

result1 := lo.Values(m1)
fmt.Println(result1)
// [foo bar]

// ================= 是否有key =======================
fmt.Println(lo.HasKey(map[string]int{"a": 1, "b": 2}, "a"))
// true

// ================== 筛选 ============================
m := map[string]int{
	"apple":  5,
	"banana": 3,
	"pear":   2,
}
// 筛选出符合条件的
result := lo.PickBy(m, func(key string, value int) bool {
	return len(key) > 4 || value > 3
})

fmt.Println(result)
// map[apple:5 banana:3]

// ================== key/value反转 ==================
// Invert key/value互换
result := lo.Invert(map[string]int{"a": 1, "b": 2, "c": 3})
fmt.Println(result) // Output: map[1:"a" 2:"b" 3:"c"]

// ================== map转slice ==================
result := lo.MapToSlice(map[string]int{
	"Alice":   18,
	"Bob":     20,
	"Charlie": 18,
}, func(k string, v int) string {
	return fmt.Sprintf("name_%s_age_%d", k, v)
})
fmt.Println(result)
// [name_Alice_age_18 name_Bob_age_20 name_Charlie_age_18]

// ================== 合并 ==================
m1 := map[string]int{
	"foo": 1,
	"bar": 2,
}
m2 := map[string]int{
	"foo":  3,
	"kaka": 4,
}

// m2会覆盖 m1
result := lo.Assign(m1, m2)
fmt.Println(result)
// map[bar:2 foo:3 kaka:4]
```

### 四、help类
```go
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
```

### 五、最后说明
上面列举的只是些常用的部分api，如果没有找到适合您的api，也可以去它的代码仓库[这里](https://github.com/samber/lo?tab=readme-ov-file#synchronize)看看。好啦，本篇到此结束，希望能帮到您。



