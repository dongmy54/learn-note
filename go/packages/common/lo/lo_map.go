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

