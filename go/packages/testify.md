## testify
它是一个功能比较全面的go语言测试框架，同时支持了断言、mock、套件等功能。并且兼容go语言自带的testing包，单看某个功能可能不是最好的，但是整体上来看，它的综合实力还是很强。

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
testify提供了方便的断言功能，这相比原生的`got != want`，`got == want`这种断言方式，更加清晰易读。
断言有很多这里介绍常用的。

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

### 三、mock
除了断言以外，难能可贵的是，它还支持`mock`；相比于`gomock`的mock使用的繁琐，它相比来说简单了不少。

#### 1. 什么是mock呢？
其实就是这个mock单词的中文含义——模拟，我们在代码中测试中，有很多部分是依赖外部的，比如数据库、网络请求等，这些外部的依赖我们无法直接控制，所以需要mock。通过mock来模拟这些依赖，让我们的测试只关心我们代码的功能，而不必关心外部的依赖项。

#### 2. 怎么用？
假设我们如下`main.go`代码
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


### 四、套件
### 五、总结
