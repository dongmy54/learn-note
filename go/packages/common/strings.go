// 包：strings
// 字符串基本操作

// 字符串中%q代表的是 原始字符串输出（字面输出）带双引号
// %s是字符串打印值
// /////////////// 高效拼接字符串 //////////////////
// 方式1: Join
str := strings.Join([]string{"hello", "world!", "您好"}, " ")
fmt.Printf("%#v\n", str)

// 方式2: builder-它同时也是一个io.Writer
builder := strings.Builder{}
// 高效拼接字符串
for _, istr := range []string{"hello", "world!", "您好"} {
	builder.Write([]byte(istr)) // 这里是字节
}

// builder完成后
str = builder.String()
fmt.Printf("%#v\n", str)

// ///////////////   字符串分割    //////////////////
// 字符串分割
strSlice := strings.Split("ab.cd.ef.gh", ".")
fmt.Printf("%#v\n", strSlice)
// []string{"ab", "cd", "ef", "gh"}

// 只分割成多少部分
strSlice = strings.SplitN("ab.cd.ef.gh", ".", 2) // 分割成两部分
fmt.Printf("%#v\n", strSlice)
// []string{"ab", "cd.ef.gh"}

// 如果不足两部分 可以少于
strSlice = strings.SplitN("ab", ".", 2)
fmt.Printf("%#v\n", strSlice)
// []string{"ab"}

// 自定义分割方式
orginal := "我，来! 自*四川"
sliceStr := strings.FieldsFunc(orginal, func(r rune) bool {
	if r == '，' || r == '!' || r == '*' || r == ' ' {
		return true
	}
	return false
})

fmt.Printf("%#v\n", strings.Join(sliceStr, ""))
// "我来自四川"

// 分割时保留分割符
strSlice = strings.SplitAfterN("ab.cd.ef.gh", ".", 4)
fmt.Printf("%#v\n", strSlice)
// []string{"ab.", "cd.", "ef.", "gh"}

// ///////////////////// 字符串包含 /////////////////////
// 字符串 包含  xx字符串
fmt.Println(strings.Contains("中国人民万岁！", "万岁"))
// true
fmt.Println(strings.Contains("中国人民！", "万岁"))
// false

// 对于字符级 的包含
fmt.Println(strings.ContainsRune("我的来深圳", '的'))
// true

// 前缀包含
fmt.Println(strings.HasPrefix("中国人民万岁！", "中国人民"))
// true
// 后缀包含
fmt.Println(strings.HasSuffix("中国人民万岁！", "万岁"))
// true

// ///////////////////// 字符串裁剪 /////////////////////
// 去除掉字符串  前后空格
str := strings.TrimSpace(" 我来自四川成都   ")
fmt.Printf("%#v\n", str)
// "我来自四川成都"

// 去掉字符串两端的 特定字符 PS：它处理的是两端
str = strings.Trim("******我来自四川成都的中心*****", "*")
fmt.Printf("%#v\n", str)
// "我来自四川成都的中心"

// 这里裁剪的是右侧的所有 * (非整体，而是可重复的)
str = strings.TrimRight("******我来自四川成都的中心*****", "*")
fmt.Printf("%#v\n", str)
// "******我来自四川成都的中心"

// 这里裁剪的是左侧所有的 * (非整体, 而是可重复的)
str = strings.TrimLeft("******我来自四川成都的中心*****", "*")
fmt.Printf("%#v\n", str)
// "我来自四川成都的中心*****"

// 去掉前缀(作为整体去去除，这里是我来)
str = strings.TrimPrefix("我来自四川成都", "我来")
fmt.Printf("%#v\n", str)
// "自四川成都"

// 去掉后缀 (作为整体去去除，这里是成都)
str = strings.TrimSuffix("我来自四川成都", "成都")
fmt.Printf("%#v\n", str)
// "我来自四川"

// ////////////////// 字符串索引查找 /////////////////////
// 子字符串 在原字符串中出现的 首次 索引位
fmt.Println(strings.Index("abcdeefcd", "cd"))
// 2

// 子字符串 在原字符串中出现的 最后 索引位
fmt.Println(strings.LastIndex("abcdeefcd", "cd"))
// 7

// 字符 在原始字符串中出现的 首次 索引位<<注意这里第二个参数是字符>>
fmt.Println(strings.IndexByte("abcdeefcd", 'c'))
// 2

// 字符 在原始字符中出现的 最后 索引位<<第二参数位 字符>>
fmt.Println(strings.LastIndexByte("abcdeefcd", 'c'))

// /////////////////// 字符串替换 ///////////////////////
// 替换 所有 字符串中的 a 成 b
str := strings.ReplaceAll("我爱他，他不我", "我", "你")
fmt.Printf("%#v\n", str)
// "你爱他，他不你"

// 指定替换数量（最后一个参数）
str = strings.Replace("我爱他，他不我", "我", "你", 1)
fmt.Printf("%#v\n", str)
// "你爱他，他不我"

// -1代表替换所有
str = strings.Replace("我爱他，他不我", "我", "你", -1)
fmt.Printf("%#v\n", str)
// "你爱他，他不你"

// //////////////// 重复与计数 ///////////////////////
// 重复10次
str := strings.Repeat("abc", 10)
fmt.Printf("%#v\n", str)
// "abcabcabcabcabcabcabcabcabcabc"

// 计算子字符串 出现次数
cnt := strings.Count("abcabcabcabcabcabcabcabcabcabc", "abc")
fmt.Println(cnt)
// 10

// /////////////// 大小写 //////////////////////////
fmt.Println(strings.ToUpper("abcdef"))
// ABCDEF

fmt.Println(strings.ToLower("abcDFef"))
// abcdfef

// 忽略大小些比较两个是否相等
strings.EqualFold("ABCD", "abCd")
// true