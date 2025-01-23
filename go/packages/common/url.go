// url 解析
u, _ := url.Parse("https://example.com:92/path?name=hello&age=18&name=world")
fmt.Println(u)
fmt.Println(u.Host)                // example.com:92 同时包含域名和端口
fmt.Println(u.Port())              // 92
fmt.Println(u.Scheme)              // https
fmt.Println(u.Path)                // /path（解码后的路径-人类可读）
fmt.Println(u.RawPath)             // /path（未解码路径）
fmt.Println(u.EscapedPath())       // 转义后的路径
fmt.Println(u.RawQuery)            // 原始的查询字符串 name=hello&age=18&name=world
fmt.Println(u.Query())             // 返回的是map
fmt.Println(u.Query().Get("name")) // 取查询字符串
fmt.Println(u.Query().Has("name")) // 是否有此查询字符串

// 反向构建查询字符串
v := url.Values{}
v.Set("name", "hello") // set是设置key只有一个value
v.Add("name", "world") // add如果val已经存在则追加后为多个value
fmt.Println(v.Get("name"))
// hello 多个取的第一个
fmt.Println(v.Has("name"))
// true
fmt.Println(v.Encode())
// name=hello&name=world

var a map[string]string
fmt.Println(a == nil) // 未初始化的map是nil