## 基准测试
我们写了一段程序，但是不知道性能怎么样,就需要用到基准测试。又或者你和同事争论实现同一种功能的不同写法谁优谁劣，比要费口舌，直接跑个基准测试。

基准测试的基本原理是，通过将程序多次执行,然后计算出一个平均值（时间/内存占用）做为性能指标。

另外，跑基准测试时，为了让数据更准确，尽量保证最小的干扰，比如此时机器尽量不要运行跑其它任务，保持环境的影响尽量小。

### 1. 快速尝试
好啦！我们开始吧！

首先，go的基准测试和普通测试是放在同一个文件`xx_test.go`中的,运行的命令也是`go test`开头,go对他俩一视同仁。

假设我们在main.go文件如下
```go
// main.go
package main

// 菲波拉切数列求和
// PS：实际上这个函数直接放到xx_test.go也是能测试的，但是为了规范放到main.go中
func fib(n int) int {
	if n == 0 || n == 1 {
		return n
	}
	return fib(n-2) + fib(n-1)
}
```

基准测试代码如下
```go
package main

import (
	"testing"
)

// 测试fib函数的性能
// 以Benchmark开头 命名遵从 Benchmark + 函数名（当然自己随意也行） 唯一参数 testing.B
func BenchmarkFib(b *testing.B) {

	// 内部是一个循环 执行b.N次 b.N由go程序自动计算
	for i := 0; i < b.N; i++ {
		fib(20)
	}
}
```

运行：
```shell
dongmingyan@pro ⮀ ~/go_playground/play ⮀ go test -bench=.
goos: darwin
goarch: amd64
pkg: example/play
cpu: Intel(R) Core(TM) i7-4770HQ CPU @ 2.20GHz
BenchmarkFib-8             28788             41322 ns/op
PASS
ok      example/play    2.481s
```
解释下：
1. `goos: darwin` 代表操作系统mac操作系统
2. `amd64`代表为X86-64架构
3. `pkg: example/play` 代表程序的的module名为 example/play
4. `cpu: Intel(R) Core(TM) i7-4770HQ CPU @ 2.20GHz`cpu相关信息
5. `BenchmarkFib-8` BenchmarkFib 代表基准测试名 -8代表8核数
6. ` 28788             41322 ns/op` 代表程序执行28788次，平均每次耗时 41322 纳秒
7. `ok      example/play    2.481s`本次总耗时2.481s

看起来简单吧。

补充知识：
我们在基准测试中使用了`b.N`，这个值是go自行计算的,那具体是怎么计算的呢？如果程序在1s内可以执行完成，那么这个值就会增加，最开始是1, 2, 3, 5, 10, 20, 30, 50, 100 这样越到最后增加越快。

### 2. 高频选项使用
前面我们已经写了一个基准测试，也运行了，但是基准测试的相关命令参数没介绍,这里介绍下：
1. ` go test -bench='Fib' `指定要执行的基准测试，这里接受正则
2. `go test -bench=. -count=3`执行3次基准测试
3. `go test -bench=. -benchtime=3s` 指定基准测试的执行时间，默认是时间是1s
4. `go test -bench=. -benchtime=3000x` 执行测试代表3000次，（注意这个和count不同，count指的是三次基准测试，这里是一次基准测试中执行的代码次数）
5. `go test -bench=. -benchmem` 同时查看内存占用和分配次数

```shell
dongmingyan@pro ⮀ ~/go_playground/play ⮀ go test -bench=. -benchmem
goos: darwin
goarch: amd64
pkg: example/play
cpu: Intel(R) Core(TM) i7-4770HQ CPU @ 2.20GHz
BenchmarkFib-8             28486             42039 ns/op               0 B/op          0 allocs/op
PASS
ok      example/play    2.191s
```

- `0 B/op` 内存占用多少字节
- `0 allocs/op` 进行了多少次内存分配


### 3. 提升时间准确度
#### 3.1 时间重置

有时候我们的基准测试，在测试前需要做些准备工作，但是这个比较耗费时间，我们可以用`b.ResetTimer()`来重置时间，具体代码如下

```go
// main_test.go
package main

import (
	"testing"
	"time"
)

// 测试fib函数的性能
// 以Benchmark开头 唯一参数 testing.B
func BenchmarkFib(b *testing.B) {
	// 耗费时间的准备操作
	expenseTime()
	// 利用ResetTimer来重置时间
	b.ResetTimer()
	for i := 0; i < b.N; i++ {
		fib(20)
	}
}

// 模拟耗费时间的操作
func expenseTime() {
	time.Sleep(100 * time.Nanosecond)
}
```

#### 3.2 终止计时和开始计时
如果我们的耗费时间的操作在循环内部咋办呢？有办法看代码。

```go
package main

import (
	"testing"
	"time"
)

// 测试fib函数的性能
// 以Benchmark开头 唯一参数 testing.B
func BenchmarkFib(b *testing.B) {

	for i := 0; i < b.N; i++ {
		b.StopTimer() // 停止时间计算
		// 耗费时间
		expenseTime()
		b.StartTimer() // 开始时间计算
		fib(20)
	}
}

// 模拟耗费时间的操作
func expenseTime() {
	time.Sleep(100 * time.Nanosecond)
}
```