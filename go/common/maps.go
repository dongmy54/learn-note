// package: maps
// 有一个标准库需要 1.23版本才能用
// 非标准库

// ================= 获取keys ================
m := map[string]int{
	"ab": 1,
	"bc": 2,
	"cd": 3,
}

keys := maps.Keys(m)
fmt.Printf("keys: %#v\n", keys)
// keys: []string{"ab", "bc", "cd"}

// ================== 获取valus =============
vals := maps.Values(m)
fmt.Printf("vals: %#v\n", vals)
// vals: []int{1, 2, 3}

// ================== 比较相等 ===============
m1 := map[int]string{1: "a", 2: "c", 3: "e"}
m2 := map[int]string{2: "c", 1: "a", 3: "e"}
fmt.Println(maps.Equal(m1, m2))
// true

// =================== 删除 =================
mm := map[int]string{1: "a", 2: "c", 3: "e"}
maps.DeleteFunc(mm, func(k int, v string) bool {
	if k >= 3 {
		return true
	}
	return false
})
fmt.Printf("删除后maps为：%#v", mm)
