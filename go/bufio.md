## bufio
它的作用用一句话表述就是:
> 利用缓冲区减少io操作次数，提升读写性能。

### 1. 为什么要用`bufio`?
开始之前我们先来看一段代码：
```go
package main

import (
	"fmt"
	"io"
	"os"
)

func main() {
	// 读取当前目录 data.txt文件内容
	file, err := os.Open("./data.txt")
	if err != nil {
		fmt.Println("打开文件错误：", err)
		return
	}
	defer file.Close()

	data := make([]byte, 3)
	// 读取10次 每次读取3个字节
	for i := 0; i < 10; i++ {
		_, err := file.Read(data)

		// 遇到文件结束
		if err == io.EOF {
			fmt.Println(err)
			break
		}
		fmt.Println(string(data))
	}
}
```

上面实现了一个简单的文件读取功能,能正常工作，但是有一个有一个问题,每次从文件读取3个字节，而且读取了10次，也就是读取了3 * 10 = 30个字节的数据，却做了10次io操作，性能可想而知。

那么我们如何优化呢？
请出我们的主角`bufio`,它的主要作用是：**减少io操作次数,提供读写性能**。

我们用`bufio`优化下
```go
package main

import (
	"bufio"
	"fmt"
	"io"
	"os"
)

func main() {
	// 读取当前目录 data.txt文件内容
	file, err := os.Open("./data.txt")
	if err != nil {
		fmt.Println("打开文件错误：", err)
		return
	}
	defer file.Close()

	// 用bufio封装一层 返回一个reader
	reader := bufio.NewReader(file)

	data := make([]byte, 3)
	// 读取10次 每次读取3个字节
	for i := 0; i < 10; i++ {
		_, err := reader.Read(data) // 这里改成从reader中读

		// 遇到文件结束
		if err == io.EOF {
			fmt.Println(err)
			break
		}
		fmt.Println(string(data))
	}
}
```
优化很简单总共两步：
1. 用`bufio`封装一层返回一个reader
2. 用`bufio.Reader`去替换原来的直接文件（`io.Reader`）读

### 2. bufio缓冲区读写原理
首先`bufio`的主要对象是`缓冲区`,操作主要有两个：
1. 读
2. 写

记住，它底层的所有东西都围绕读、写展开。

原理上，我们也按照读、写来分别说明：
> PS: 下面流程只是一个大概参考，不代表全部逻辑

- 读
```
 
 读取长度小于缓冲区大小,从缓冲区读取
 1.----------------->
                    当缓冲区为空，直接从文件读取，填满缓冲区
                    2. -------------->
 【程序】           【缓冲区】           【文件（io.Reader）】
  
  3. 读取长度超过缓冲区大小,直接从文件读取
  ----------------------------------> 
```

- 写
```
 写长度小于缓冲大小，先写入缓冲区
 1.----------------->
                    当缓冲区满，触发写入到文件
                    2. -------------->
 【程序】           【缓冲区】           【文件（io.Reader）】
  
  3. 写长度超过缓冲区大小，直接写入文件
  -----------------------------------> 
```

在bufio内部实现的reader和writer，大致是按照上述逻辑处理的，还有些细节的东西，没有在上面画出，但是做为初学者，了解下就行。

### 3. bufio读
在介绍之前，先说明一点，无论是读还是写，其构造过程都是差不多的：
1. `NewReader`/`NewWriter`构造一个读/写对象
2. 传入一个实现了`io.Reader`/`io.Writer`的对象


#### 1. 构造`bufio`读对象
只要是实现了`io.Reader`对象都可以,比如：

```go
// =================1.从文件==============
file, err := os.Open("./data.txt")
if err != nil {
fmt.Println("打开文件错误：", err)
return
}
defer file.Close()

reader := bufio.NewReader(file)

// =================2. 从字符串=========
strReader := strings.NewReader("hello world")
bufio.NewReader(strReader)

// =================3. 从网络链接=======
bufio.NewReader(conn)
```
这里就不一一列举了。

#### 2. Read读
和直接从原始对象读一样
```go
package main

import (
	"bufio"
	"fmt"
	"strings"
)

func main() {
	strReader := strings.NewReader("hello world")
	buf := bufio.NewReader(strReader)

	// 读前要构造一个切片 用于存放读取的内容
	data := make([]byte, 5)
	// 读取数据到data
	_, err := buf.Read(data)

	if err != nil {
		fmt.Println(err)
		return
	}
	fmt.Println(string(data)) // 转字符串打印
}

// hello
```

#### 3. ReadLine 按照行读取
有两点需要注意：
1. 它返回三个参数 line、isPrefix、err
2. 如果一行太长本次没读取完，则isPrefix会是`true`
3. 返回的文本不包括行尾（"\r\n"或"\n"）
  
ps: 官方更推荐使用`ReadString`/`ReadBytes`/`Scaner`

```go
package main

import (
	"bufio"
	"fmt"
	"io"
	"strings"
)

func main() {
	str := `
	 大家好
	 非常好
	 非常非常好
	`
	strReader := strings.NewReader(str)
	buf := bufio.NewReader(strReader)

	for {
		// 返回三个参数 line、是否前缀、错误
		line, _, err := buf.ReadLine()
		// 结束直接返回
		if err == io.EOF {
			fmt.Println("结束啦")
			break
		}

		// 字符串直接打印
		fmt.Println(string(line))
	}
}

// 大家好
// 非常好
// 非常非常好
// 结束啦
```


#### 4. ReadString 直接读出字符串
它有两个好处：
1. 直接返回字符串，省得转换
2. 不用事先构造一个切片来装读取到的数据

注意它**读取后的内容里是包含分割符号的**

```go
package main

import (
	"bufio"
	"fmt"
	"io"
	"strings"
)

func main() {
	str := `
	 大家好
	 非常好
	 非常非常好
	`
	strReader := strings.NewReader(str)
	buf := bufio.NewReader(strReader)

	for {
		// 这里是一个分割符
		s, err := buf.ReadString('\n')
		// 结束直接返回
		if err == io.EOF {
			fmt.Println("结束啦")
			break
		}

		// 字符串直接打印
		fmt.Printf(s)
	}
}

// 大家好
// 非常好
// 非常非常好
// 结束啦
```

这里还有几个类似的方法，非常接近，就不单独演示了
区别在于,`ReadBytes` 它返回一个字节切片（[]byte）

#### 5. Scanner 扫描
特点：
1. 自己定义一个扫描函数，然后按照规则扫描；如果不指定扫描器，它和单独按照行读取类型；
2. 返回内容不包含换行符

```go
package main

import (
	"bufio"
	"fmt"
	"strings"
)

func main() {
	str := `
	 大家好
	 非常好
	 非常非常好
	`
	strReader := strings.NewReader(str)
	// 先生成一个Scanner
	scanner := bufio.NewScanner(strReader)

	// 扫描每行
	for scanner.Scan() {
		// 返回的是一个字符串
		content := scanner.Text()
		fmt.Println(content)
	}

	// 检查扫描过程是否报错
	if err := scanner.Err(); err != nil {
		fmt.Println("扫描过程发生了错误：", err.Error())
	}
}
```

### 4. bufio 写
缓冲区默认大小为4K（4096字节）
这里需要注意的是，如果缓冲区没有满，不会自动写入io；
我们可以手动`Flush` 完成写入

先看下代码：
```go
package main

import (
	"bufio"
	"fmt"
	"os"
)

func main() {

	// os.O_RDWR|os.O_CREATE 读写 如果不存在则创建
	file, err := os.OpenFile("data.txt", os.O_RDWR|os.O_CREATE, 0666)
	if err != nil {
		fmt.Println(err)
		return
	}

	defer file.Close()
	// 构造缓冲写
	buf := bufio.NewWriter(file)

	// 三次write写入缓冲
	buf.Write([]byte("hello world\n"))
	buf.Write([]byte("非常美丽\n"))
	buf.Write([]byte("不错吧\n"))

	// 直接写入文件
	buf.Flush()
}
```

#### 1. 构造writer
```go
//直接用io.Writer构造
buf := bufio.NewWriter(file)

// 指定缓冲大小 （最小是16字节）
buf := bufio.NewWriterSize(file, 30)
```

#### 2. 各种wirter方式
主要有以下几种方式：
```go
// 以字符串方式写入
buf.WriteString("来吧来吧来\n")
	
// 一次写一个rune字符 返回实际占用的字节数
n, _ := buf.WriteRune('中')
c, _ := buf.WriteRune('\n')

// 一次写入一个byte
buf.WriteByte('a')
buf.WriteByte('A')
```

#### 3. Flush写入io
```go
// 直接写入io
buf.Flush()
```

#### 4. 其它
```go
// 重置buf 此前缓冲中的数据都被清理掉 
buf.Reset(os.Stdout)

// 缓冲区大小（总大小）
buf.Size()
// 缓冲区可用大小
buf.Available()
```





  