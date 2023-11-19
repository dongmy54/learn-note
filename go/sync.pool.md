### sync.Pool
背景：
在高并发场景下，短时间内会创建大量临时对象，而这些临时对象都一次性的，创建完就等着被GC(垃圾回收),非常的浪费，也占用了大量的内存，性能不好。

比如，在高并发场景下，会有大量的web请求涌入,在对每个请求响应的过程，会涉及反序列化数据到某某结构体中，这会创建大量临时结构体对象，分配大量内存。

用途：
go为了解决上面的问题，提出了`sync.Pool`解决方案。
它的作用一句话概括：
**复用临时对象,减少内存分配，降低GC压力，提高性能**

它的作用看起来和缓存类似，但是不能等效于缓存;
- 它的数据是由GC决定啥时候回收的,缓存我们可以控制到期时间
- 它每次获取（Get）后，需要存入(put)，缓存多少获取，不会影响下次获取

#### 1. 简要使用
前面我们对`sync.Pool`有了一个感性的认识，但是还不清楚代码如何写，下面我们看下：
```go
package main

import (
	"encoding/json"
	"fmt"
	"sync"
)

type Student struct {
	Name  string
	Age   int8
	Score [100]byte
}

func main() {
	// 定义一个student临时对象池
	studentPool := sync.Pool{
		// 内部放一个new 的匿名函数
		New: func() interface{} {
			return &Student{}
		},
	}

	// 准备解析数据
	buf, _ := json.Marshal(Student{Name: "张三", Age: 16})

	// 使用
	s := studentPool.Get().(*Student) // 由于是interface{} 取出后转 *Student
	json.Unmarshal(buf, s)
	studentPool.Put(s) // 再此存入 方便下次复用
	fmt.Printf("name: %s, Age: %d\n", s.Name, s.Age)
}

// name: 张三, Age: 16
```

使用总体分三步：
1. 初始化一个临时对象池（在New中写好匿名函数）
2. Get(从池中获取对象,如果池中存在，从池中取，如果不存在通过New函数创建)
3. Put(放回池中，用完后放回，方便后续使用)

#### 2. 性能测试
上面我们已经知道如何使用，那么他到底有多大的性能提升呢，我们测试下：
```go
// main.go
package main

import (
	"encoding/json"
	"sync"
)

type Student struct {
	Name   string
	Age    int8
	Remark [1024]byte // 这里之所以写的大一点是 因为 sync.Pool对于重性结构体更有效果
}

// 定义一个student临时对象池
var studentPool = sync.Pool{
	// 内部放一个new 的匿名函数
	New: func() interface{} {
		return &Student{}
	},
}

// 准备解析数据
var buf, _ = json.Marshal(Student{Name: "张三", Age: 16})

func main() {
}

// 没有使用池序列化
func UnmarshalWithoutPool() {
	s := &Student{}
	json.Unmarshal(buf, s)
}

// 使用了pool的反序列化
func UnmarshalWithPool() {
	s := studentPool.Get().(*Student)
	json.Unmarshal(buf, s)
	studentPool.Put(s)
}
```

测试文件：
```go
package main

import "testing"

func BenchmarkUnmarshalWithoutPool(b *testing.B) {
	for n := 0; n < b.N; n++ {
		UnmarshalWithoutPool()
	}
}

func BenchmarkUnmarshalWithPool(b *testing.B) {
	for n := 0; n < b.N; n++ {
		UnmarshalWithPool()
	}
}
```

运行测试：
```
dongmingyan@pro ⮀ ~/go_playground/play ⮀ go test -bench . -benchmem
goos: darwin
goarch: amd64
pkg: example/play
cpu: Intel(R) Core(TM) i7-4770HQ CPU @ 2.20GHz
BenchmarkUnmarshalWithoutPool-8             9092            141332 ns/op            1392 B/op          8 allocs/op
BenchmarkUnmarshalWithPool-8                9258            127560 ns/op             240 B/op          7 allocs/op
PASS
ok      example/play    2.809s
```
上面我们可以看出,在使用pool和未使用pool在耗时上优化不太明显，但在内存占用上差了接近6倍（1392/240 = 5.8）;效果还是很明显的；
之所以在时间上不太明显是我们测试的结构体还不够厚重。

#### 3. 使用场景
上面我们测试了性能，那么应该在什么场景下使用呢？
1. 厚重的结构体上（字段多，字段大）
2. 高并发场景（频率高，复用率高）

#### 4. 其它
1. 存在数据丢失（它缓存的数据不稳定，在GC后会丢失，过程不可控）
2. 由于数据存在丢失，不用能用做类似数据库的缓存,只能存一些丢失后，也不影响使用的临时数据
3. `syn.Pool` 线程安全，但是其内部的`New`函数需要自己实现线程安全
