## test
在编写程序中测试非常重要
- 保证程序的正确性
- 提高开发效率（有了测试、对改动更有信心、更早发现问题）

go中原生支持测试——（`testing`库）,总的来说还是比较好用，下面我们一步步看看。

假设我们的main包有下代码需要测试
PS: 之所以这里用main包，纯粹是为了方便，换成做其它包不受影响。
```go
// main.go
package main

// 非常简单的一个加法
func Add(a, b int) int {
	return a + b
}
```

### 1. 简单测试
在go中测试遵循如下方式：
1. 测试文件和测试代码在同一目录下（`属于同一个包`）
2. 测试文件和测试代码文件关系,一般按照测试代码文件名+`_test.go`,比如需要测试main.go，则测试文件为`main_test.go`
3. 测试函数以`Test`开头 + 需要测试函数的名，比如需要测试`Add`，则测试函数推荐命名为`TestAdd`(当然不用这个名字也可以，但不推荐)

好啦！规则介绍完，看代码，我们在`main.go`同一目录下新建`main_test.go`文件，内容为：
```go
// main_test.go
package main

import "testing"

// 所有的测试文件都需要传唯一的参数 *testing.T
func TestAdd(t *testing.T) {
	got := Add(1, 2)
	if got != 3 {
		t.Errorf("got %v, want %v", got, 3)
	}
}
```

直接运行`go test .` 开始执行测试, 使用`go test -v`输出详细信息
```shell
dongmingyan@pro ⮀ ~/go_playground/play ⮀ go test .
ok      example/play    0.587s
 dongmingyan@pro ⮀ ~/go_playground/play ⮀ go test -v
=== RUN   TestAdd
--- PASS: TestAdd (0.00s)
PASS
ok      example/play    0.117s
```
简单吧，我们继续

### 2. 子测试
我们做测试时，一个函数我们很多时候，需要从不同的方面去测试，所以这时候就需要用到子测试，比如这里分别需要测试正数和负数相加的情况。

子测试是通过`t.Run()`实现的，我们看代码。

```go
package main

import "testing"

// 所有的测试文件都需要传唯一的参数 *testing.T
func TestAdd(t *testing.T) {
	// 第一个参数描述 子测试名称 第二个参数匿名函数 执行的测试内容
	t.Run("正数", func(t *testing.T) {
		got := Add(2, 3)
		if got != 5 {
			// PS: t.Error会打印失败信息 但是不会终止整个测试过程
			t.Errorf("2 + 3 expected: %v got: %v", 5, got)
		}
	})

	t.Run("负数", func(t *testing.T) {
		got := Add(-1, -3)
		if got != -4 {
			t.Errorf("-1 + (-3) expected: %v got: %v", -4, got)
		}
	})
}
```

### 3. table-driven 测试
啥叫`table-driven`,简单点说就是，直接列出各种测试场景，然后调用统一方法做测试就行，这么说可能有点抽象，看代码

```go
package main

import "testing"

// 所有的测试文件都需要传唯一的参数 *testing.T
func TestAdd(t *testing.T) {
	// 将测试case集中写好
	testCases := []struct {
		name           string
		a, b, expected int
	}{
		{"正数", 1, 2, 3},
		{"负数", -1, -3, -4},
	}

	// 循环调用测试
	for _, tc := range testCases {
		t.Run(tc.name, func(t *testing.T) {
			got := Add(tc.a, tc.b)
			if got != tc.expected {
				t.Errorf("%v + %v expected %v got %v", tc.a, tc.b, tc.expected, got)
			}
		})
	}
}
```

这是不是比上面单独写t.Run好了很多，这是go推荐的写法。

### 4. helper
我们可以把一些通用的部分提取出来成一个helper
```go
package main

import "testing"

// 测试case结构体
type testCase struct {
	name           string
	a, b, expected int
}

// 构建一个test helper函数
func createTestCase(t *testing.T, tc *testCase) {
	t.Run(tc.name, func(t *testing.T) {
		got := Add(tc.a, tc.b)
		if got != tc.expected {
			t.Errorf("%v + %v expected %v got %v", tc.a, tc.b, tc.expected, got)
		}
	})
}

// 所有的测试文件都需要传唯一的参数 *testing.T
func TestAdd(t *testing.T) {
	createTestCase(t, &testCase{"正数", 2, 3, 5})
	createTestCase(t, &testCase{"负数", -2, -1, -3})
}
```

### 5. 构建测试环境
在测试中，我们通常需要在运行测试前和测试后执行一些操作，go提供了一个`TestMain`的函数,如果在测试文件中包含了这个函数，那么其它测试函数都必须通过它（TestMain）才会执行。

具体看代码：
```go
package main

import (
	"fmt"
	"os"
	"testing"
)

func TestAdd(t *testing.T) {
	got := Add(1, 3)
	if got != 4 {
		t.Errorf("1 + 3 expected 4 got %v", got)
	}
}

// 设置运行前测试环境
func setup() {
	fmt.Println("在开始前准备好测试环境...")
}

// 执行完测试做善后操作
func teardown() {
	fmt.Println("测试后清理测试现场...")
}

// 注意这里的参数 是 testing.M 不是 testing.T了哦
func TestMain(m *testing.M) {
	setup()
	code := m.Run() // 运行其它测试代码
	teardown()

	os.Exit(code)
}
```

运行测试结果为：
```shell
dongmingyan@pro ⮀ ~/go_playground/play ⮀ go test -v
在开始前准备好测试环境...
=== RUN   TestAdd
--- PASS: TestAdd (0.00s)
PASS
测试后清理测试现场...
ok      example/play    0.489s
```

### 6. 测试覆盖率
有些时候我们需要知道测试覆盖率，非常简单。
我们运行`go test -coverprofile=coverage.out`会输出覆盖率，这里将覆盖率信息放到coverage.out文件中,可以直接看到覆盖率。
```shell
dongmingyan@pro ⮀ ~/go_playground/play ⮀ go test -coverprofile=coverage.out
在开始前准备好测试环境...
PASS
        example/play    coverage: 100.0% of statements
测试后清理测试现场...
ok      example/play    0.480s
```

由于已经生成了覆盖率文件（coverage.out）我们可以打开在浏览器中查看，可以看哪些覆盖了-绿色，那些没有覆盖-红色，命令为：`go tool cover -html=coverage.out`

### 7. example示例
example有两层含义：
1. 展示给别人，让别人知道你的函数/方法如何使用
2. 测试的时候example也是会执行的哦
3. 以Example开头，函数不需要传任何参数

我们看一下：
```go
package main

import (
	"fmt"
	"testing"
)

func TestAdd(t *testing.T) {
	got := Add(1, 3)
	if got != 4 {
		t.Errorf("1 + 3 expected 4 got %v", got)
	}
}

// 以Example开头
func ExampleAdd() {
	// PS: 下面output的值是被测试检查的哦 如果不写4 测试会失败的哈
	// 程序会把Output后面的内容都当作expect内容哦
	fmt.Println(Add(1, 3))
	// Output: 4
}
```

```shell
dongmingyan@pro ⮀ ~/go_playground/play ⮀ go test -v
=== RUN   TestAdd
--- PASS: TestAdd (0.00s)
=== RUN   ExampleAdd
--- PASS: ExampleAdd (0.00s)
PASS
ok      example/play    0.517s
```
