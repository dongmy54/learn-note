### string、byte、rune
在go中字符串有很多令人困惑的地方，所以查了些资料，搞懂了些，写下此文方便查阅。

#### 1. 从一个困惑开始
```go
package main

import "fmt"

func main() {
	s := "hello 中国"
	fmt.Println(len(s))

	for i := 0; i < len(s); i++ {
		fmt.Printf("%c ", s[i])
	}
}

// 12
// h e l l o   ä ¸ ­ å  %
```
为什么长度是12呢，不应该是8个字符么? 为什么按照序号取出来的数最后乱码了？
有很多困惑，其实是由于我们对字符理解不够导致的，别着急，下面我们一步步来，一一说明。

#### 2. 字符与字符串
在golang中字符和字符串有很大区别,

**表示形式**：
- `字符`是通过单引号表示的
- 字符串是双引好表示的
```go
a := "a" // 这是字符串
b := 'a' // 这是字符
```

**类型区别**：
- 字符串类型为 `string`
- 字符类型则有两种：
  1. byte = uint8(一个字节8位)
  2. rune = int32(这是万国码Unicode可以包含所有国家的字符)
PS: 默认情况下定义一个字符它的类型为rune(更通用)

> 字符在底层都是整数,之所以有`byte`和`rune`;他们的作用相当于别名,相比int8和int32更好区分；rune代表的是通用字符。

我们来验证一下：
```go
package main

import "fmt"

func main() {
	a := 'c'         // 默认字符 类型为rune int32
	var b byte = 'c' // byte字符 byte int8
	c := "c"         // 双引号 字符串

	fmt.Println(a) // 发现了么 这里打印的是数字 因为他说整数类型啊
	fmt.Printf("%T\n", a)

	fmt.Println(b)
	fmt.Printf("%T\n", b)

	fmt.Println(c) // 只有这里会打印出c 字符串
	fmt.Printf("%T\n", c)
}

// 99
// int32
// 99
// uint8
// c
// string
```

#### 3. 快速了解字符编码相关知识
要对rune有很好的了解，需要了解一些字符编码相关知识。

字符编码指的是什么呢？
我们知道在计算机底层使用的是二进制代表数据,一个字符要被计算机识别,需要一个映射：
`字符 -> 对应的二进制数`，我们把这个过程称为字符编码。

有哪些字符编码呢？
ASCII编码:
最早是美国定义的，它主要对于英文符号,英文符号相对比较少,用一个字节（8位）表示,实际使用的是 0 - 127编号（最高位都没用上）

非ASCII编码:
笼统的说，除了ASCII编码的其它编码就是非ASCII编码。

Unicode编码：
俗称万国码,它囊括了世界上所有符号，任何一个国际的语言都包含进去了，这也是万国的来源。由于符号很多，所以它使用4个字节（32位）表示。

编码方式UTF-8:
记住UTF-8它和Unicode不同，它是Unicode的实现方式;

为什么已经有了Unicode编码还要多一个UTF-8呢？
因为Unicode使用4个字节（32）位表示，如果所有字符都完整的按照Unicode去映射二进制,比如一个ASCII字符，本身一个8位就够啦,非要用32去表示，非常浪费，文本文件也会很大。 

所以UTF-8采用可变长的方式表示字符,按需使用长度，比如ASCII码字符仍然按照8位，而其它字符则按实际Unicode值,做二进制映射。它是采用了一种二进制高位1个数来判断字符多少个字节的方式实现，具体细节不做讨论。

PS： 在程序世界中默认都采用UTF-8编码方式。

一个中文字符占用几个字节呢？
答案是3-4个字节。

#### 4. 字符串len代表的是？
代表的是字符串的字节数,现在可以解释一开始困惑中的问题了?

```go
s := "hello 中国"
fmt.Println(len(s))
```
上面的代码打印12是因为"hello "后面有一个空格,一个英文字符占一个字节,这里占6个;后面"中国"一个字符占用3个字节，所以总共12个字节。

#### 5. 如何让字符串按照（人眼的字符打印呢）
1. 使用`range`
```go
package main

import "fmt"

func main() {
	s := "hello 中国"
	// 第一个是索引 第一个才是字符
	for _, c := range s {
		fmt.Printf("%c ", c)
	}
}

// h e l l o   中 国 
```

2. 先转换为rune切片,再循环
```go
package main

import "fmt"

func main() {
	s := "hello 中国"
	// 第一个是索引 第一个才是字符
	ss := []rune(s)

	for i := 0; i < len(ss); i++ {
		fmt.Printf("%c ", ss[i])
	}
}

// h e l l o   中 国 
```

#### 6.如何真实（按照字符）的打印字符串长度呢
用`utf8.RuneCountInString`
```go
package main

import (
	"fmt"
	"unicode/utf8"
)

func main() {
	s := "hello 中国"
	fmt.Println(utf8.RuneCountInString(s))
}

// 8
```

#### 7. 字符串修改
在go中字符串,不能直接修改，不信你看
```go
package main

import "fmt"

func main() {
	s := "hello 中国"
	fmt.Printf("%T\n", s[0])
	s[0] = 'a' // 不能直接修改 报错
	// cannot assign to s[0] (value of type byte)
}
```

那如何做到修改呢？
1. 改成byte/rune切片，改切片，然后再转换回字符串
```go
package main

import "fmt"

func main() {
	s := "hello 中国"
	ss := []rune(s)

	ss[0] = 'a'    // 改h为a
	s = string(ss) // 重新转换为字符串
	fmt.Println(s)
}

// aello 中国
```







