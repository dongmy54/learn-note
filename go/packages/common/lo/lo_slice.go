// lo 是一个非常便捷的库，提供了许多类似js中对集合数组相关的操作
// 地址：https://github.com/samber/lo

type User struct {
	ID   int
	Name string
}

users := []User{
	{ID: 1, Name: "Alice"},
	{ID: 2, Name: "Bob"},
	{ID: 3, Name: "Charlie"},
}

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



