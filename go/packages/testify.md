## testify
它是一个功能比较全的go语言测试框架，同时支持了断言、mock、套件等功能。原生兼容go语言testing包，单看某个功能可能不是最好的，但是整体上来看，它的综合实力非常强。

### 一、起步
它的使用方式非常简单，基本上和go原生的testing包一样，引入包后直接使用就行，让我们一起看下。

假设我们的main包里有如下代码：
```go
package main

func Add(a, b int) int {
	return a + b
}
```

下面我们针对此Add函数进行测试，添加测试文件`main_test.go`
```go
package main

import (
	"testing"

	"github.com/stretchr/testify/assert"
)

func TestAdd(t *testing.T) {
	// 原生写法
	// got := Add(2, 2)
	// want := 4
	// if got != want {
	// 	t.Errorf("got %q, want %q", got, want)
	// }

	assert.Equal(t, Add(2, 2), 4, "Add(2,2) should be 4")
}
```

上面使用了testify的断言，断言的用法非常简单，直接调用`assert.Equal(t, got, want, "message")`即可。
直接在命令行执行`go test -v`就能看到test相关输出。

非常简单，在使用上基本和go原生的testing包一样。下面我们继续探索。

### 二、断言
#### 1. assert断言
testify提供了方便的断言功能，这相比原生的`got != want`，`got == want`这种断言方式，更加清晰易读。
断言方式特别多，这里仅介绍常用的。

```go
// 特点：最后一个参数都是断言的描述
assert.Equal(t, Add(2, 2), 4, "Add(2,2) should be 4")
// 不等于
assert.NotEqual(t, 3, 5)
// true or false
assert.True(t, true, "should is true")
assert.False(t, false, "should is false")
// nil
assert.Nil(t, nil)
// contains 包含
// 字符串
assert.Contains(t, "hello world", "world")
// 数组
assert.Contains(t, [3]int{1, 2, 3}, 2)
// map
assert.Contains(t, map[string]int{"a": 1, "b": 2}, "a")
// slice
assert.Contains(t, []string{"a", "b", "c"}, "b")
// error
assert.Error(t, errors.New("a error"), errors.New("a error"))
// empty
assert.Empty(t, []string{})
assert.Empty(t, map[string]int{})
assert.Empty(t, "")
// zero 它检查的是 是否为0值
assert.Zero(t, 0)
assert.Zero(t, 0.0)
assert.Zero(t, false)
```

#### 2. require断言
除了`assert`断言外，testify还提供了`require`断言，它和`assert`断言类似，`assert`支持的函数,`require`也都支持。

它们的区别在于，在一个测试函数中，如果断言失败,是否会继续执行
- `assert`断言失败，测试函数继续执行.
- `require`断言失败，测试函数直接退出.

PS：是否继续执行，指的是当前测试函数。而不是影响其它函数是否执行。

我们编写如下测试代码，加以说明
```go
// require_test.go
package main

import (
	"fmt"
	"testing"

	"github.com/stretchr/testify/assert"
	"github.com/stretchr/testify/require"
)

func TestRequire(t *testing.T) {
	require.Equal(t, 2, 1)
	fmt.Println("==由于前面require失败，所以这里不会执行=====")
}

func TestAssert(t *testing.T) {
	assert.Equal(t, 2, 1)
	fmt.Println("===虽然前面assert会失败 但是仍会继续执行===")
}

func TestOther(t *testing.T) {
	assert.Equal(t, 1, 1)
	fmt.Println("====其它测试函数照样执行=======")
}
```

执行结果如下：
```shell
dongmingyan@pro ⮀ ~/go_playground/hello ⮀ go test require_test.go
--- FAIL: TestRequire (0.00s)
    require_test.go:12: 
                Error Trace:    /Users/dongmingyan/go_playground/hello/require_test.go:12
                Error:          Not equal: 
                                expected: 2
                                actual  : 1
                Test:           TestRequire
===虽然前面assert会失败 但是仍会继续执行===
--- FAIL: TestAssert (0.00s)
    require_test.go:17: 
                Error Trace:    /Users/dongmingyan/go_playground/hello/require_test.go:17
                Error:          Not equal: 
                                expected: 2
                                actual  : 1
                Test:           TestAssert
====其它测试函数照样执行=======
FAIL
FAIL    command-line-arguments  0.507s
FAIL
```

符合我们的预期。

#### 3. 断言简写
我们可以看到前面的断言函数在执行时每次都需要传递`testing.T`参数，这有点麻烦，我们可以优化下。
```go
// 先New一个assert
assert := assert.New(t)
// 然后就可以不带t了
assert.Equal(1, 1)
```

### 三、mock
除了断言以外，难能可贵的是，它还支持`mock`；相比于`gomock`的繁琐，它相比来说简单了不少。

#### 1. 什么是mock呢？
其实就是这个mock单词的中文含义——模拟，我们在代码中，通常有很多外部依赖，比如数据库、网络请求等，这些外部的依赖我们无法直接控制，所以需要mock。通过mock来模拟这些依赖，让我们的测试只关心我们代码的功能，而不必关心外部的依赖项。

#### 2. 怎么用？
假设我们有如下`main.go`代码
```go
package main

import "fmt"

type User struct {
	ID   int
	Name string
}

// 一个外部的接口
type Server interface {
	// 有一个GetUser的方法 返回User
	GetUser(id int) User
}

// 打印用户的信息
func GetUserInfo(server Server, id int) string {
	// 依赖于外部的接口Server的GetUser方法
	user := server.GetUser(id)
	return fmt.Sprintf("user id is %d, name is %s", user.ID, user.Name)
}
```

我们需要测试GetUserInfo这个函数，但是这个函数依赖了一个接口的`GetUser`方法，我们可以通过mock来实现测试。

`main_test.go`代码如下：
```go
package main

import (
	"testing"

	"github.com/stretchr/testify/assert"
	"github.com/stretchr/testify/mock"
)

// 第一步：定义一个mock结构体
type ServerMock struct {
	mock.Mock
}

// 第二步：定义一个mock方式（固定的）
func (m *ServerMock) GetUser(id int) User {
	// 这里Called参数要原封不动给到
	args := m.Called(id)
	// 返回值args.Get(0)是一个interface Get(0)代表第一个参数
	return args.Get(0).(User)
}

func TestPrintUserInfo(t *testing.T) {
	// 创建我们事先定义好的mock对象
	server := &ServerMock{}
	// 第三步：设定mock方法的的传参数和返回值
	server.On("GetUser", 1).Return(User{1, "Tom"})
	uinfo := GetUserInfo(server, 1)

	// 断言
	assert.Equal(t, "user id is 1, name is Tom", uinfo)
}
```
上面的代码已经写了详尽的注释，就不做不过多解释了；我们可以总结的是，它的操作步骤也就三步：
1. step1：**定义一个mock结构体**
2. step2：**定义一个mock方式（固定的）**
3. step3：**设定mock方法的的传参数和返回值**

#### 3. mock代码要求
我们先看一个需要测试的函数：

```go
// 除一个随机数
func divByRand(numerator int) int {
	return numerator / int(rand.Intn(10))
}
```
我们如何测试这个函数呢？由于`rand.Intn(10)`是一个随机数，测试时没法通过一个输入值预测输出值，故无法测试。

试想，如果我们能mock出随机数为一个固定数，那么就可以测试。但是上面的代码生成随机数的所有部分`rand.Intn(10)`都存于函数内部，我们无法mock。

那怎么办呢？可以把随机数的生成部分抽象出来成一个接口，这个接口包含随机数的签名函数即可，优化代码如下：
```go
// mock_example/main.go
package main

import "math/rand"

// 随机数生成器接口
type randGenerator interface {
	randInt(max int) int
}

// 随机数生成器结构体
type standardRand struct{}

// 随机数生成器实现
func (r *standardRand) randInt(max int) int {
	return rand.Intn(max)
}

// 除一个随机数 rg 随机数生成器接口
func divByRand(rg randGenerator, numerator int) int {
	return numerator / int(1+rg.randInt(10))
}

func main() {
	// 创建一个随机数生成器
	rg := &standardRand{}
	// 使用随机数生成器
	divByRand(rg, 100)
}
```

现在我们可以对`divByRand`这个函数进行测试了。
测试代码如下：
```go
// mock_example/main_test.go
package main

import (
	"testing"

	"github.com/stretchr/testify/assert"
	"github.com/stretchr/testify/mock"
)

type MockRandGenerator struct {
	mock.Mock
}

func (m *MockRandGenerator) randInt(max int) int {
	args := m.Called(max)
	return args.Int(0)
}

func TestDivByRand(t *testing.T) {
	mockRand := &MockRandGenerator{}
	mockRand.On("randInt", 10).Return(4)

	result := divByRand(mockRand, 10)
	assert.Equal(t, 2, result)
}
```

由此可见，非常重要的一步是，**把依赖项抽象出来，形成接口，然后mock测试**。这也是为什么go中可以看到大量的interface的原因之一，它便与测试。

#### 4. 一些技巧
mock除了我们上面看到的`on` `return`形式外，还支持一些有意思的技巧。

```go
// 执行一次
xxmock.On("randInt", 10).Return(4).Once()
// 执行二次
xxmock.On("randInt", 10).Return(5).Twice()
// 执行3次
xxmock.On("randInt", 10).Return(6).Times(3)
// 可能被调用，也可能不被调用
xxmock.On("randInt", 10).Return(6).Maybe()
// 任意参数 返回固定值
xxmock.On("MyMethod", mock.Anything).Return("固定返回值")
```

### 四、套件
在go内置的`testing`包中，并没有提供一种将各种测试用例有效组织起来的方式；幸运的是`testify`为了我们提供了套件功能，它是支持的。

#### 1. 怎么用？
套件怎么使用呢？其实也很简单：
1. 定义套件(suite)结构体嵌入(suite）
2. 定义套件结构体方法（测试/辅助）
3. 定义套件测试函数（引爆点，套件执行入口）

直接看文字不太容易理解，我们还是直接看代码，假设我们要测试购物车相关的功能，代码如下：
```go
// main.go
package main

// 商品条目
type Item struct {
	ID   int
	Name string
}

// 购物车
type ShoppingCart struct {
	Items []Item // 商品列表
	Count int    // 商品数量
}

// 添加购物车
func (s *ShoppingCart) AddItem(item Item) {
	s.Items = append(s.Items, item)
	s.Count++
}

// 移除购物车
func (s *ShoppingCart) RemoveItem(item Item) {
	for i, v := range s.Items {
		if v.ID == item.ID {
			s.Items = append(s.Items[:i], s.Items[i+1:]...)
			s.Count--
			break
		}
	}
}
```

测试代码：
```go
// main_test.go
package main

import (
	"testing"

	"github.com/stretchr/testify/suite"
)

// =============step1: 定义套件结构体=================
type ShoppingCartSuite struct {
	suite.Suite               // 嵌入套件
	cart        *ShoppingCart // 购物车
}

// ============step2: 定义套件结构体的方法=============
// 初始化套件（套件执行前）
func (s *ShoppingCartSuite) SetupSuite() {
	s.T().Log("=====初始化套件=====")
	s.cart = &ShoppingCart{}
}

// 拆卸套件（套件执行后）
func (s *ShoppingCartSuite) TearDownSuite() {
	s.T().Log("=====拆卸套件=====")
}

// 初始化测试（每个测试执行前 初始化工作）
func (s *ShoppingCartSuite) SetupTest() {
	s.T().Log("=====初始化测试=====")
}

// 拆卸测试（每个测试执行后 清理工作）
func (s *ShoppingCartSuite) TearDownTest() {
	s.T().Log("=====拆卸测试=====")
	s.cart.Count = 0
	s.cart.Items = []Item{}
}

func (s *ShoppingCartSuite) TestAddItem() {
	s.T().Log("=====测试添加商品=====")
	s.cart.AddItem(Item{ID: 1, Name: "apple"})
	s.cart.AddItem(Item{ID: 2, Name: "banana"})
	s.cart.AddItem(Item{ID: 3, Name: "orange"})
	s.Equal(3, s.cart.Count)
}

func (s *ShoppingCartSuite) TestRemoveItem() {
	s.T().Log("=====测试移除商品=====")
	s.cart.AddItem(Item{ID: 1, Name: "apple"})
	s.cart.AddItem(Item{ID: 2, Name: "banana"})
	s.cart.AddItem(Item{ID: 3, Name: "orange"})
	s.cart.RemoveItem(Item{ID: 2, Name: "banana"})
	s.Equal(2, s.cart.Count)
}

// step3: 测试套件引爆点（入口）
func TestShoppingCart(t *testing.T) {
	// 通过suite.Run启动测试
	suite.Run(t, new(ShoppingCartSuite))
}
```

运行测试`go test -v`
```shell
=== RUN   TestShoppingCart
    shopping_cart_test.go:18: =====初始化套件=====
=== RUN   TestShoppingCart/TestAddItem
    shopping_cart_test.go:29: =====初始化测试=====
    shopping_cart_test.go:40: =====测试添加商品=====
    shopping_cart_test.go:34: =====拆卸测试=====
=== RUN   TestShoppingCart/TestRemoveItem
    shopping_cart_test.go:29: =====初始化测试=====
    shopping_cart_test.go:48: =====测试移除商品=====
    shopping_cart_test.go:34: =====拆卸测试=====
=== NAME  TestShoppingCart
    shopping_cart_test.go:24: =====拆卸套件=====
--- PASS: TestShoppingCart (0.00s)
    --- PASS: TestShoppingCart/TestAddItem (0.00s)
    --- PASS: TestShoppingCart/TestRemoveItem (0.00s)
PASS
ok  	command-line-arguments	0.540s
```

#### 2. 层级关系
从上面的例子我们可以看出，测试套件有很多层级的设定，可以在套件开始前、结束后、测试开始前、结束后执行某些操作，这在测试时非常用。

比如：我们希望在测试套件开始前，创建一个数据库连接，测试结束后，关闭数据库连接；在某个测试开始前，清理上一个测试用例创建的数据等等。

那么这些层级到底是怎样的？我们梳理下：
```shell
SetupSuite # 套件开始前
	SetupTest # 测试开始前（每个测试）
		BeforeTest(suiteName, testName) # 测试前 带测试名（每个测试）
			SetupSubTest() # 子测试开始前
			TearDownSubTest() # 子测试结束后
		AfterTest(suiteName, testName) # 测试后 带测试名（每个测试）
	TearDownTest # 测试结束后
TearDownSuite # 套件结束后
```

另外`suite`是支持子测试用法如下：
```go
func (suite *ExampleSuite) TestCase() {
	suite.T().Log("======TestCase=====")

	// 在函数执行后里继续运行就是子测试
	suite.Run("case1-subtest1", func() {
		suite.T().Log("======TestCase.Subtest1=====")
	})
	suite.Run("case1-subtest2", func() {
		suite.T().Log("======TestCase.Subtest2=====")
	})
}
```

