## grpc
在分布式系统中,各个服务之间使用了不同的语言的同时，还要保证这些服务之间能高效、可靠的通信；传统的api请求方式，并不能满足高效的性能要求；为了解决这个问题,go语言根据rpc实现了grpc这个框架。

下面我们一起学习下。

### 一、概念（rpc、grpc、protobuf）
#### 1. rpc
rpc(Remote Procedure Call)翻译过来就是——远程程序调用，**它是一种通信协议**（类比于http），它的主要思想是：让远程调用就像调用本地的函数一样简单。

试想下，如果在分布式系统，服务之间的通信，都像调用本地函数一样是不是让人很兴奋呢！

#### 2. grpc
rpc协议有很多种实现方式,grpc只是其中的一种，gprc中的g可以认为它代表——go,它是go语言中实现的rpc框架。
**它是一个rpc框架**。

#### 3. protobuf
protobuf是grpc中定义的**一种数据结构（类比于json）**,它定义了一种数据序列化、反序列化的方式，数据序列化后是二进制——不可读。

由于序列化后是二进制，因此同样的数据在序列化后相比于json的文本会小很多，这是为什么高效的原因之一。

### 二、主要特点
#### 1. 优点
1. **跨语言、跨平台**
虽然我们前面说grpc是go语言的rpc实现，但是并不妨碍它是跨语言的。因为我们使用`xx.proto`文件就可以轻松生成基于各种语言的SDK——流程部分会做说明。

2. **基于http2**
因此它支持io多路复用、双向流，更新节省带宽和资源

3. **高性能**
一方面它使用http2协议，另一方面protobuf在数据编码、解码上更快，且数据更小。

#### 2. 缺点
1. 无法通过浏览器调用grpc、调试不方便
2. 使用protobuf编码性能好，但是二进制不可读

### 三、 `.proto`文件
在开始介绍grpc工作流之间，我们先了解下什么是`.proto`文件，它非常重要，**它是用于定义服务接口和消息结构的语言**

我们先看一眼`.proto`文件内容大概长啥样。
```go
syntax = "proto3";

// 服务定义 service 服务名
service SumService {
  // 这里相当于定义函数名 参数 返回值
  rpc Sum (SumRequest) returns (SumResponse) {}
}

// 消息结构 用于请求/响应内容 后续server/client使用这里定义的数据结构
message SumRequest {
  // 类型 变量名 序号；
  int32 a = 1;
  int32 b = 2;
}

message SumResponse {
  int32 result = 1;
}
```

我们可以根据`.proto`文件生成各种语言的sdk,为了生成我们需要先下载一个protobuf的编译器。
在mac上使用下面命令安装
```shell
$ brew install protobuf
$ protoc --version  # 确保安装成功
# libprotoc 26.1 
```

安装成功后，我们就可以通过`protoc`命令生成各语言sdk,为了生存go语言的sdk可以使用
```shell
# 推荐方式（在.proto中设置option go_package = "proto/;myproto"指定生成的路径和包名，这里代表生成到proto目录下）
$ protoc --go_out=. --go-grpc_out=. xx路径/yy.proto


# 官网方式 这里--go_opt=paths 会覆盖go_package中的路径
# 生成的路径和.proto在同一目录
$ protoc --go_out=. --go_opt=paths=source_relative \
    --go-grpc_out=. --go-grpc_opt=paths=source_relative \
    helloworld/helloworld.proto
```

执行命令后会生成两个文件：
1. `xx_grpc.pb.go` 这里存放client和server使用的函数
2. `xx.pb.go` 这里存放序列化相关代码

特别是`xx_grpc.pb.go`在客户端调用、服务端实现的写时非常有用，可以参考着集成，假设你不清楚服务端这个方法应该如何写，可以直接到里面去查相关函数的实现。

### 四、grpc工作流
经过前面`.proto`文件的讨论，我们应该基本清楚路grpc工作流到底是怎样的，这里梳理下，分为下面几个步骤：

1. 编写`.proto`文件
2. 根据`.proto`文件生成各语言sdk
3. 在server端实现相关接口的结构体
4. client调用server

### 五、实践
理论差不多了，我们来一步步实操下。

#### 1. 加法（非流式）
我们先从最简单的开始，假设我们只是调用另外一个服务的加法功能，实现效果为，传递两个数值，然后返回相加后的和，简单吧。

- **初始化项目**
```shell
$ mkdir sum-grpc
$ cd sum-grpc
$ go mod init dmy/sum-grpc
```

添加`.proto`文件
```shell
$ mkdir proto
$ touch sum.proto
```

`sum.proto`文件内容为：
```go
syntax = "proto3";

// 指定生成go包文件的路径和包名，必须有
// 代表路径 ; 包名 其中路径必须包含/
option go_package = "proto/;myproto";

service SumService {
  rpc Sum (SumRequest) returns (SumResponse) {}
}

message SumRequest {
	// 类型 变量名 序号；
    int32 a = 1;
    int32 b = 2;
}

message SumResponse {
    int32 result = 1;
}
```

终端执行命令`protoc --go_out=. --go-grpc_out=. proto/sum.proto`
执行成功后，会在proto目录下生成两个文件
1. `proto/sum_grpc.pb.go`
2. `proto/sum.pb.go`

- **服务端**
项目下添加`server.go`文件
```go
package main

import (
	"context"
	"fmt"
	"log"
	"net"

	"google.golang.org/grpc"

	// 引入生成的proto包
	pb "dmy/sum-grpc/proto" // 这里引入的是proto包路径
)

// 需要实现pb.SumServiceServer接口
type server struct {
	// 这个必须引入UnimplementedSumServiceServer
	// 及时没有实现接口的方法也不会报错
	pb.UnimplementedSumServiceServer
}

// 这个函数其实就是我们在proto文件中定义的rpc函数
// 如果不清楚具体参数可以到sum_grpc.pb.go文件中查看
func (s *server) Sum(ctx context.Context, in *pb.SumRequest) (*pb.SumResponse, error) {
	// 这里的SumRequest和SumResponse就是我们在proto文件中定义的message类型
	// 只是变量名变成了首字母大写的驼峰命名法
	return &pb.SumResponse{Result: in.A + in.B}, nil
}

func main() {
	lis, err := net.Listen("tcp", ":50051")
	if err != nil {
		log.Fatalf("failed to listen: %v", err)
	}
	s := grpc.NewServer()
	// 注册服务
	pb.RegisterSumServiceServer(s, &server{})
	fmt.Printf("server started at %s\n", lis.Addr())
	if err := s.Serve(lis); err != nil {
		log.Fatalf("failed to serve: %v", err)
	}
}
```

- **client端**
项目下添加`client.go`
```go
package main

import (
	"context"
	"log"
	"time"

	pb "dmy/sum-grpc/proto"

	"google.golang.org/grpc"
)

// 引入生成的proto
func main() {
	//conn, err := grpc.Dial("localhost:50051", grpc.WithInsecure(), grpc.WithBlock())
	conn, err := grpc.NewClient("localhost:50051", grpc.WithInsecure())
	if err != nil {
		log.Fatalf("did not connect: %v", err)
	}
	defer conn.Close()
	c := pb.NewSumServiceClient(conn)

	ctx, cancel := context.WithTimeout(context.Background(), 3*time.Second)
	defer cancel()
	// 调用服务端的Sum方法 SumRequest同理是.proto定义message的变体
	r, err := c.Sum(ctx, &pb.SumRequest{A: 3, B: 5})
	if err != nil {
		log.Fatalf("could not greet: %v", err)
	}
	log.Printf("Sum: %d", r.Result)
}
```

我们来试下在第一个终端执行`go run server.go`
再开一个终端执行`go run client.go`,将看到如下输出
```
dongmingyan@pro ⮀ ~/go_playground/sum-grpc ⮀ go run client.go
2024/06/01 20:44:25 Sum: 8
```

#### 2. 减法（非流式）
- **更新.proto**
前面我们实现了加法，现在我们实现一个减法,更新`proto/sum.proto`文件
```go
syntax = "proto3";

// 指定生成go包文件的路径和包名，必须有
// 代表路径 ; 包名 其中路径必须包含/
option go_package = "proto/;myproto";

service SumService {
  rpc Sum (SumRequest) returns (SumResponse) {}
	rpc Subtract (SubtractRequest) returns (SubtractResponse) {}  // 新增减法
}

message SumRequest {
	// 类型 变量名 序号；
    int32 a = 1;
    int32 b = 2;
}

message SumResponse {
    int32 result = 1;
}

// 减法请求
message SubtractRequest { 
	int32 a = 1;
	int32 b = 2;
}

// 减法响应
message SubtractResponse {  // 新增的消息类型
	int32 result = 1;
}
```
执行`protoc --go_out=. --go-grpc_out=. proto/sum.proto`重新生成sdk


- **server端**
新增方法
```go
func (s *server) Subtract(ctx context.Context, in *pb.SubtractRequest) (*pb.SubtractResponse, error) {
	return &pb.SubtractResponse{Result: in.A - in.B}, nil
}
```

- **client端**
添加Subtract调用
```go
func main(){
  //...省略

  // 调用Subtract方法
	// 注意r和r1类型不同 所以要区分开
	r1, err := c.Subtract(ctx, &pb.SubtractRequest{A: 10, B: 5})
	if err != nil {
		log.Fatalf("could not greet: %v", err)
	}
	log.Printf("Subtract: %d", r1.Result)
}
```
分别运行后可以看到如下输出
```shell
dongmingyan@pro ⮀ ~/go_playground/sum-grpc ⮀ go run client.go
2024/06/01 21:09:29 Sum: 8
2024/06/01 21:09:29 Subtract: 5
```

#### 3. 因子（响应流）
前面两个都没有涉及到流，这里我们看一个流的例子，假设我们传一个数进去后，返回一个或多个这个数的因子,每个因子的返回是流。

- **更新.proto**
```go
syntax = "proto3";

// 指定生成go包文件的路径和包名，必须有
// 代表路径 ; 包名 其中路径必须包含/
option go_package = "proto/;myproto";

service SumService {
  rpc Sum (SumRequest) returns (SumResponse) {}
	rpc Subtract (SubtractRequest) returns (SubtractResponse) {}  // 减法
	// 响应流
	rpc Factors(FactorsRequest) returns (stream FactorsResponse) {}  // 计算一个数的因子
}

message SumRequest {
	// 类型 变量名 序号；
    int32 a = 1;
    int32 b = 2;
}

message SumResponse {
    int32 result = 1;
}

// 减法请求
message SubtractRequest { 
	int32 a = 1;
	int32 b = 2;
}

// 减法响应
message SubtractResponse {  
	int32 result = 1;
}

// 因子请求数
message FactorsRequest {
	int32 num = 1;
}

// 因子响应
message FactorsResponse {
	int32 factor = 1;
}
```
执行`protoc --go_out=. --go-grpc_out=. proto/sum.proto`重新生成sdk

- **server端**
```go
// 流的响应，没有返回值 —— 流是在过程中Send的，所以没有返回值
// 流在入参中
func (s *server) Factors(req *pb.FactorsRequest, stream pb.SumService_FactorsServer) error {
	for i := 1; i <= int(req.Num); i++ {
		if int(req.Num)%i == 0 {
			// 这里Send发送流数据
			if err := stream.Send(&pb.FactorsResponse{Factor: int32(i)}); err != nil {
				return err
			}
		}
	}
	return nil
}
```

- **client端**
```go
fun main(){
  // ... 省略

  // 调用Factor方法
	// 先获取stream
	stream, err := c.Factors(ctx, &pb.FactorsRequest{Num: 12})
	if err != nil {
		log.Fatalf("could not greet: %v", err)
	}
	for {
		// 然后Recv()
		factor, err := stream.Recv()
		// 接收流时 根据err判断是否结束
		if err == io.EOF {
			break
		}
		if err != nil {
			log.Fatalf("%v.Factors(_) = _, %v", c, err)
		}
		log.Println(factor)
	}
}
```

执行输出
```shell
 dongmingyan@pro ⮀ ~/go_playground/sum-grpc ⮀ go run client.go
2024/06/01 21:29:08 Sum: 8
2024/06/01 21:29:08 Subtract: 5
2024/06/01 21:29:08 factor:1
2024/06/01 21:29:08 factor:2
2024/06/01 21:29:08 factor:3
2024/06/01 21:29:08 factor:4
2024/06/01 21:29:08 factor:6
2024/06/01 21:29:08 factor:12
```

#### 4. 多数和（请求流）
我们再搞一个请求流，在流中发送多个数到服务端，服务端计算完成后返回他们的和。

- **更新.proto**
```go
syntax = "proto3";

// 指定生成go包文件的路径和包名，必须有
// 代表路径 ; 包名 其中路径必须包含/
option go_package = "proto/;myproto";

service SumService {
  rpc Sum (SumRequest) returns (SumResponse) {}
	rpc Subtract (SubtractRequest) returns (SubtractResponse) {}  // 减法
	// 响应流
	rpc Factors(FactorsRequest) returns (stream FactorsResponse) {}  // 计算一个数的因子
	// 发送流
	rpc SumStream(stream SumStreamRequest) returns (SumStreamResponse) {}  // 计算data流的和
}

message SumRequest {
	// 类型 变量名 序号；
    int32 a = 1;
    int32 b = 2;
}

message SumResponse {
    int32 result = 1;
}

// 减法请求
message SubtractRequest { 
	int32 a = 1;
	int32 b = 2;
}

// 减法响应
message SubtractResponse {  
	int32 result = 1;
}

// 因子请求数
message FactorsRequest {
	int32 num = 1;
}

// 因子响应
message FactorsResponse {
	int32 factor = 1;
}

// 计算流请求
message SumStreamRequest {
	int32 num = 1;
}

// 计算流响应
message SumStreamResponse {
	int32 sum = 1;
}
```
执行`protoc --go_out=. --go-grpc_out=. proto/sum.proto`重新生成sdk

- **服务端**
```go
// 流的请求，也没有返回值 —— 在Recv完后，SendAndClose发送响应
func (s *server) SumStream(stream pb.SumService_SumStreamServer) error {
	sum := 0
	for {
		req, err := stream.Recv()
		// 通过io.EOF判断是否是流结束
		if err == io.EOF {
			// 结束后返回响应
			return stream.SendAndClose(&pb.SumStreamResponse{Sum: int32(sum)})
		}
		if err != nil {
			return err
		}
		sum += int(req.Num)
	}
}
```

- **客户端**
```go
func main(){
  // ...省略

  // 调用SumStream方法
	// 这里stream和stream1类型不同 所以要区分开
	stream1, err := c.SumStream(ctx)
	if err != nil {
		log.Fatalf("could not greet: %v", err)
	}
	// 先发送数据
	for _, num := range []int32{1, 2, 3, 4, 5} {
		if err := stream1.Send(&pb.SumStreamRequest{Num: num}); err != nil {
			log.Fatalf("%v.Send(%v) = %v", stream1, num, err)
		}
	}
	// 然后调用CloseAndRecv()获取结果
	res, err := stream1.CloseAndRecv()
	if err != nil {
		log.Fatalf("%v.CloseAndRecv() got error %v, want %v", stream, err, nil)
	}
	log.Printf("Sum: %d", res.Sum)
}
```

执行输出
```shell
dongmingyan@pro ⮀ ~/go_playground/sum-grpc ⮀ go run client.go
2024/06/01 21:46:03 Sum: 8
2024/06/01 21:46:03 Subtract: 5
2024/06/01 21:46:03 factor:1
2024/06/01 21:46:03 factor:2
2024/06/01 21:46:03 factor:3
2024/06/01 21:46:03 factor:4
2024/06/01 21:46:03 factor:6
2024/06/01 21:46:03 factor:12
2024/06/01 21:46:03 Sum: 15
```
### 六、流相关方法
| 函数名       | 描述           | 参数  | 返回值 |
| ------------ | -------------- | ----- | ------ |
| Send         | 向另一端发送消息 | 消息  | 错误    |
| Recv         | 从另一端接收消息 | 无    | 消息，错误 |
| CloseSend    | 关闭发送方向的流 | 无    | 错误    |
| SendAndClose | 发送最后一个消息并关闭流 | 消息  | 错误    |
| RecvMsg      | 从另一端接收消息 | 消息的指针 | 错误    |
| SendMsg      | 向另一端发送消息 | 消息  | 错误    |
| Close        | 关闭流，并向另一端发送一个状态和一个元数据 | 状态，元数据 | 错误    |
| CloseAndRecv | 关闭流并接收最后一个消息 | 无    | 消息，错误 |


### 六、完整代码
项目结构：
```shell
├── client.go
├── go.mod
├── go.sum
├── proto
│   ├── sum.pb.go
│   ├── sum.proto
│   └── sum_grpc.pb.go
└── server.go
```

服务端
```go
package main

import (
	"context"
	"fmt"
	"io"
	"log"
	"net"

	"google.golang.org/grpc"

	// 引入生成的proto包
	pb "dmy/sum-grpc/proto" // 这里引入的是proto包路径
)

// 需要实现pb.SumServiceServer接口
type server struct {
	// 这个必须引入UnimplementedSumServiceServer
	// 及时没有实现接口的方法也不会报错
	pb.UnimplementedSumServiceServer
}

// 这个函数其实就是我们在proto文件中定义的rpc函数
// 如果不清楚具体参数可以到sum_grpc.pb.go文件中查看
func (s *server) Sum(ctx context.Context, in *pb.SumRequest) (*pb.SumResponse, error) {
	// 这里的SumRequest和SumResponse就是我们在proto文件中定义的message类型
	// 只是变量名变成了首字母大写的驼峰命名法
	return &pb.SumResponse{Result: in.A + in.B}, nil
}

func (s *server) Subtract(ctx context.Context, in *pb.SubtractRequest) (*pb.SubtractResponse, error) {
	return &pb.SubtractResponse{Result: in.A - in.B}, nil
}

// 流的响应，没有返回值 —— 流是在过程中Send的，所以没有返回值
// 流在入参中
func (s *server) Factors(req *pb.FactorsRequest, stream pb.SumService_FactorsServer) error {
	for i := 1; i <= int(req.Num); i++ {
		if int(req.Num)%i == 0 {
			// 这里Send发送流数据
			if err := stream.Send(&pb.FactorsResponse{Factor: int32(i)}); err != nil {
				return err
			}
		}
	}
	return nil
}

// 流的请求，也没有返回值 —— 在Recv完后，SendAndClose发送响应
func (s *server) SumStream(stream pb.SumService_SumStreamServer) error {
	sum := 0
	for {
		req, err := stream.Recv()
		// 通过io.EOF判断是否是流结束
		if err == io.EOF {
			// 结束后返回响应
			return stream.SendAndClose(&pb.SumStreamResponse{Sum: int32(sum)})
		}
		if err != nil {
			return err
		}
		sum += int(req.Num)
	}
}

func main() {
	lis, err := net.Listen("tcp", ":50051")
	if err != nil {
		log.Fatalf("failed to listen: %v", err)
	}
	s := grpc.NewServer()
	// 注册服务
	pb.RegisterSumServiceServer(s, &server{})
	fmt.Printf("server started at %s\n", lis.Addr())
	if err := s.Serve(lis); err != nil {
		log.Fatalf("failed to serve: %v", err)
	}
}
```

客户端
```go
package main

import (
	"context"
	"io"
	"log"
	"time"

	pb "dmy/sum-grpc/proto"

	"google.golang.org/grpc"
)

// 引入生成的proto
func main() {
	//conn, err := grpc.Dial("localhost:50051", grpc.WithInsecure(), grpc.WithBlock())
	conn, err := grpc.NewClient("localhost:50051", grpc.WithInsecure())
	if err != nil {
		log.Fatalf("did not connect: %v", err)
	}
	defer conn.Close()
	c := pb.NewSumServiceClient(conn)

	ctx, cancel := context.WithTimeout(context.Background(), 3*time.Second)
	defer cancel()
	// 调用服务端的Sum方法 SumRequest同理是.proto定义message的变体
	r, err := c.Sum(ctx, &pb.SumRequest{A: 3, B: 5})
	if err != nil {
		log.Fatalf("could not greet: %v", err)
	}
	log.Printf("Sum: %d", r.Result)

	// 调用Subtract方法
	// 注意r和r1类型不同 所以要区分开
	r1, err := c.Subtract(ctx, &pb.SubtractRequest{A: 10, B: 5})
	if err != nil {
		log.Fatalf("could not greet: %v", err)
	}
	log.Printf("Subtract: %d", r1.Result)

	// 调用Factor方法
	// 先获取stream
	stream, err := c.Factors(ctx, &pb.FactorsRequest{Num: 12})
	if err != nil {
		log.Fatalf("could not greet: %v", err)
	}
	for {
		// 然后Recv()
		factor, err := stream.Recv()
		// 接收流时 根据err判断是否结束
		if err == io.EOF {
			break
		}
		if err != nil {
			log.Fatalf("%v.Factors(_) = _, %v", c, err)
		}
		log.Println(factor)
	}

	// 调用SumStream方法
	// 这里stream和stream1类型不同 所以要区分开
	stream1, err := c.SumStream(ctx)
	if err != nil {
		log.Fatalf("could not greet: %v", err)
	}
	// 先发送数据
	for _, num := range []int32{1, 2, 3, 4, 5} {
		if err := stream1.Send(&pb.SumStreamRequest{Num: num}); err != nil {
			log.Fatalf("%v.Send(%v) = %v", stream1, num, err)
		}
	}

	// 然后调用CloseAndRecv()获取结果
	res, err := stream1.CloseAndRecv()
	if err != nil {
		log.Fatalf("%v.CloseAndRecv() got error %v, want %v", stream, err, nil)
	}
	log.Printf("Sum: %d", res.Sum)
}
```

