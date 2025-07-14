func TestTemplate(t *testing.T) {
	data := struct {
		Smile string
		Heart string
		List  []string
		Name  string
		Age   int
	}{
		Smile: "😊",
		Heart: "❤️",
		List:  []string{"a", "b", "c"},
		Name:  "张三",
		Age:   19,
	}

	// 自定义函数
	hello := func(name string, age int) string {
		return fmt.Sprintf("hello %s, your age is %d", name, age)
	}

	// layout为主模版
	tep, err := template.New("layout").
		Funcs(template.FuncMap{"hello": hello}).
		ParseFiles("./layout.tpl", "./inner.tpl")
	if err != nil {
		t.Error(err)
	}
	// 自定义函数
	r := bytes.Buffer{}
	tep.Execute(&r, data)
	t.Logf("【template is 】%v", *tep)
	t.Logf("【result is 】%s", r.String())
}