## binary
它的作用用一句话说就是：**实现数据与二进制之间的双向转换**

它有许多使用场景,比如:
- 读取（解析）网络过来的二进制数据
- 读取一个二进制文件
- 将一个数据写成二进制

### 大小端字节序
开始之前先大概说下，大小端字节序，简单理解就是字节的编码顺序,一个从高位开始，一个从低位开始。

我们使用时候主要需要保证读和写的顺序保持一致就行,如果需要详细了解可以看[这篇](https://www.ruanyifeng.com/blog/2016/11/byte-order.html)

### 1. 单一数据转换
好啦！我们开始来看最简单的,将一个简单数据，比如一个字符、一个数值转换成二进制

对于一些单一的字符读写可以使用,binary提供的`binary.BigEndian`和 `binary.LittleEndian`完成。
```go
package main

import (
	"encoding/binary"
	"fmt"
)

func main() {
	var a uint64 = 56

	// 用于存二进制数据
	bData := make([]byte, 8) // 64位 8个字节
  // a 写入到bData中
	binary.LittleEndian.PutUint64(bData, a)

	// 从bData读取 数据到b中
	b := binary.LittleEndian.Uint64(bData)

	fmt.Println(b)
}

// 56
```

### 2. 复杂（结构体）数据转换
需要注意的是,binary包处理的数据必须要有固定的长度,所以对结构体的字段类型有要求。
```go
package main

import (
	"bytes"
	"encoding/binary"
	"fmt"
)

// 需要注意的是在binary 出来的数据必须要有固定的长度
type Data struct {
	ID         uint16
	Temprature float32
	Records    [4]byte // 4个长度字节数组
}

func main() {
	// 准备好要转换的数据
	datas := []Data{
		{ID: 12, Temprature: 21.8, Records: [4]byte{'A', 'B', 'C', 'D'}},
		{ID: 2, Temprature: 28.8, Records: [4]byte{'B', 'B', 'C', 'A'}},
	}

	// 具有io.Writer 和 io.Reader的 缓冲对象用于存二进制数据
	var buf = new(bytes.Buffer)
	// 将数据写入buf中 记住这里最后一个参数必须是引用（比如指针，这里切片本身就是引用所以无所谓）
	binary.Write(buf, binary.LittleEndian, datas)

	parseData := make([]Data, 2) // 存解析出来的数据
	// 从buf中读取 解析成Data结构体切片
	binary.Read(buf, binary.LittleEndian, parseData)

	fmt.Printf("%#v\n", parseData[0])
	fmt.Printf("%#v\n", parseData[1])
	fmt.Printf("ID: %d , Temprature: %v, Record1: %c\n", parseData[0].ID, parseData[0].Temprature, parseData[0].Records[0])
}

// main.Data{ID:0xc, Temprature:21.8, Records:[4]uint8{0x41, 0x42, 0x43, 0x44}}
// main.Data{ID:0x2, Temprature:28.8, Records:[4]uint8{0x42, 0x42, 0x43, 0x41}}
// ID: 12 , Temprature: 21.8, Record1: A
```

### 3. 写二进制数据到文件
```go
package main

import (
	"bufio"
	"encoding/binary"
	"fmt"
	"os"
)

func main() {
	file, err := os.OpenFile("data.bin", os.O_CREATE|os.O_RDWR, 0666)
	if err != nil {
		fmt.Println("创建文件错误")
		return
	}

	defer file.Close()

	// 封装一层缓冲区
	buf := bufio.NewWriter(file)
	// 写入缓冲中
	binary.Write(buf, binary.LittleEndian, []byte("hello world\n")) // 第一次写入 12个字节
	binary.Write(buf, binary.LittleEndian, []byte("beautiful!\n"))  // 第二次写入11字节

	// 从缓冲写入文件
	buf.Flush()

	// 从 文件中读取
	f, err := os.Open("data.bin")
	if err != nil {
		fmt.Println("打开文件失败：", err.Error())
		return
	}

	// 构造一个读bufio
	reader := bufio.NewReader(f)
	// 第一次读取 12个字节
	a := make([]byte, 12)
	binary.Read(reader, binary.LittleEndian, a)
	fmt.Printf("%s", a)
	// 第二次读取11个字节
	binary.Read(reader, binary.LittleEndian, a[0:11])
	fmt.Printf("%s", a[0:11])
}

// hello world
// beautiful!
```

### 4. 总结
本质上binary包只有两个操作: 一个写，一个读;分别对应两种转换：
1. 写 - (数据->二进制)
2. 读 - (二进制 -> 数据)
