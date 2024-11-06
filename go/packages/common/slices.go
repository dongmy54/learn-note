// package slices
// 它提供的是对泛类型的操作 因此适用于多种类型

// ///////// contains 是否包含 ////////////////
fmt.Println(slices.Contains([]string{"dmy", "hello", "world!"}, "hello"))
// true
fmt.Println(slices.Contains([]int{1, 4, 6}, 4))
// true

// ================ 比较 ====================//
// Equal 判断的是 每个索引位是否相同
// 返回的是布尔值
s1 := []string{"hello", "world"}
s2 := []string{"world", "hello"}
s3 := []string{"hello", "world"}
fmt.Println(slices.Equal(s1, s2))
// false
fmt.Println(slices.Equal(s1, s3))
// true

// EqualFunc 自定义检查规则
ss1 := []string{"ab", "cd"}
ss2 := []string{"AB", "cd"}
result := slices.EqualFunc(ss1, ss2, func(i string, j string) bool {
	//return strings.ToLower(i) == strings.ToLower(j)
	return strings.EqualFold(i, j)
})
fmt.Println("自定义比较检查结果为：", result)
// true

// 感觉
// s1 == s2 返回 0
// s1 < s2 返回 -1
// s1 > s2 返回 1
fmt.Println(slices.Compare(s1, s3))
// 0

// ============ 合并 ===========
s1 := []string{"adb", "ded", "wed"}
s2 := []string{"we", "wee"}
concatS := slices.Concat(s1, s2)
fmt.Println(concatS)
// [adb ded wed we wee]

// =============== 插入 ============ //
// insert按照指定索引位插入
ss1 := []string{"hello", "world", "ok"}
insertS := []string{"大", "家", "好"}
ss1 = slices.Insert(ss1, 1, insertS...) // 在索引1的位置插入
fmt.Println(ss1)
// [hello 大 家 好 world ok]

// =============== 替换 ============ //
// Replace 指定要替换索引 [开始，结束) + 元素
s1 := []string{"abc", "ef", "skk", "ef"}
news1 := slices.Replace(s1, 1, 3, "我是", "他们")
fmt.Println(s1)
// [abc 我是 他们 ef]
fmt.Println(news1)
// [abc 我是 他们 ef]

// =============== 删除 ====================== //
// DeleteFunc 按照条件删除
ss := []string{"ab", "sdad", "sdasdk", "d"}
newss := slices.DeleteFunc(ss, func(str string) bool {
	if len(str) > 2 {
		return true
	} else {
		return false
	}
})

fmt.Printf("========删除后原切片为：%#v\n", ss)
// ========删除后原切片为：[]string{"ab", "d", "", ""}
fmt.Printf("=======删除后新切片为：%#v\n", newss)
// =======删除后新切片为：[]string{"ab", "d"}

// Delete 指定要删除的索引 [开始,结束)
// PS：右侧索引不包含哦
s1 := []string{"ab", "cd", "ef", "ghi"}
s1 = slices.Delete(s1, 1, 2)
fmt.Println(s1)

// =============== 去重 ==================== //
s := []string{"ab", "cd", "cd", "ef"}
fmt.Println(slices.Compact(s))
// [ab cd ef]

// ============ 排序 ============//
// 注意Sort没有返回值
s := []int{2, 6, 3, 8}
slices.Sort(s)
fmt.Println(s)
// [2 3 6 8]

// ========= 反转 =============//
ss := []string{"ab", "cd", "ef"}
slices.Reverse(ss)
fmt.Println("反转后为：", ss)
// 反转后为： [ef cd ab]

// ============== 索引位查找 =============
// Index查首个满足的索引
s := []string{"ab", "dwe", "de"}
indexNum := slices.Index(s, "dwe")
fmt.Println("=====indexNum: ", indexNum)
// =====indexNum:  1

// IndexFunc 指定查找规则
ss := []string{"abd", "wee", "weeke"}
inum := slices.IndexFunc(ss, func(i string) bool {
	if len(i) > 3 {
		return true
	} else {
		return false
	}
})
fmt.Println("====IndexFumc索引位：", inum)
// ====IndexFumc索引位： 2

