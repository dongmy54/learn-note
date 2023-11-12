### sync
sync包提供了许多功能，比如`sync.WaitGroup`保证所有gorountinue都能执行完
`sync.Once` 保证在多线程情况只执行一次等等。下面分别说下：

#### 1. `sync.WaitGroup` 保证所有gorountine执行完
它主要是通过：
1. `Add()` gorountine计数+1
2. `Done()` 表明 当前gorountine执行完
3. `Wait()` 等待所有gorountine执行完
通过以上三个方法实现,看代码

```go
package main

import (
	"fmt"
	"sync"
	"time"
)

var w sync.WaitGroup

func main() {
	w.Add(1) // 添加一个gorountine，开启gorountine前调用
	go func() {
		defer w.Done() // 保证执行完会标记此gorountine执行过
		for i := 0; i < 10; i++ {
			fmt.Println("i:", i)
			time.Sleep(time.Second)
		}
	}()

	w.Wait() // 等待所有gorountine执行完
	fmt.Println("finished!")
}
```

#### 2. `sync.Once`保证在多线程情况下也只执行一次
在真实项目中，我们会存在许多情况，要求多线程只执行一次（不用多次重复执行）；
比如：
1. 更新缓存（一个线程去更新时，其它线程不要再去更新）
2. 初始化配置数据

虽然通过加锁也达到只执行一次的目的；但是性能不好；go专门为上述场景，设计了`sync.Once`
,它内部提供了一个`Do()`方法，参数是一个函数，来实现。

看代码：
```go
package main

import (
	"fmt"
	"sync"
)

var (
	w    sync.WaitGroup
	once sync.Once
)

// 初始化配置文件
func initConfig() {
	fmt.Println("执行初始化配置文件!")
}

func main() {
	// 添加10个 gorountine
	for i := 0; i < 100; i++ {
		w.Add(1)
		go func() {
			defer w.Done()
			// 虽然有多个gorountine执行，但是只有一个gorountine会真正执行initConfig函数
			once.Do(initConfig) //
		}()
	}

	w.Wait()
}
```

执行后你会看到只打印了一次 "执行初始化配置文件!"；而不是10次；说明once有效；

#### 3. `sync.Map` 线程安全的map
通用的map它是非线程安全的，多个gorountine下会有问题;

比如下面代码：
```go
package main

import (
	"fmt"
	"strconv"
	"sync"
)

var w sync.WaitGroup
var m = make(map[string]int) // 通用map 非线程安全

func main() {
	// 添加10个 gorountine
	for i := 0; i < 10; i++ {
		w.Add(1)
		go func() {
			defer w.Done()
			for j := 0; j < 10; i++ {
				key := strconv.Itoa(i) // 转整数为字符串
				m[key] = j             // 设置值
				fmt.Printf("key: %s; val: %d\n", key, j)
			}
		}()
	}

	w.Wait()
}
```
会报错`fatal error: concurrent map writes` 不允许并发写map

`sync.Map` 提供了`Store`/`Load` 用于存/取等方法，正确代码如下：

```go
package main

import (
	"fmt"
	"strconv"
	"sync"
)

var (
	w sync.WaitGroup
	m sync.Map // 线程安全map
)

func main() {
	// 添加10个 gorountine
	for i := 0; i < 10; i++ {
		w.Add(1)
		go func() {
			defer w.Done()
			for j := 0; j < 10; j++ {
				key := strconv.Itoa(j) // 转整数为字符串
				m.Store(key, j)        // 设置值
				val, _ := m.Load(key)
				fmt.Printf("key: %s; val: %d\n", key, val)
			}
		}()
	}

	w.Wait()
}
```

