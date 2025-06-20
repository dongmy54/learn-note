### 1. protoc命令
单独的protoc命令，是这样`protoc --proto_path=./ --go_out=./ --go-grpc_out=./ pb/sim.proto`

选项含义：
- --proto_path=./ 指定proto文件所在路径
  1. import时根据此路径去找
  2. 搜索proto文件根据此路径搜索，上面的会去搜索`./ + pb/sim.proto`

- --go_out=./ 指定生成go文件(xx.pb.go)的路径
  需要注意的是，go文件生成路径是，由此选项路径 + go_package选项中路径共同组成；比如`option go_package = "./pb;mypackage";` 对于上面的命令路径为: `./ + ./pb` 也就是当前文件夹下pb文件夹下

- --go-grpc_out=./ 指定生成grpc文件(xx_grpc.pb.go)的路径
  同上，由此选项路径 + go_package选项中路径共同组成；

### 2. goctl protoc命令说明
假设在`app`目录下有一个`pb`文件夹，文件夹里有一个`order.proto`文件；

此时在pb目录下执行，`goctl rpc protoc *.proto --go_out=../ --go-grpc_out=../ --zrpc_out=../ --style=goZero -m=true`
会生成如下文件：
```
├── internal
│   ├── config
│   │   └── config.go
│   ├── logic
│   │   ├── createHomestayOrderLogic.go
│   │   ├── homestayOrderDetailLogic.go
│   │   ├── updateHomestayOrderTradeStateLogic.go
│   │   └── userHomestayOrderListLogic.go
│   ├── server
│   │   └── orderServer.go
│   └── svc
│       └── serviceContext.go
├── order
│   └── order.go  // zrpc （rpc直接对外文件，go-zero的文件；客户端调用的这里）
├── pb
│   ├── order.pb.go // pb结构文件
│   ├── order.proto
│   └── order_grpc.pb.go // grpc文件（zrpc调用后来这里中转到pb）
└── order.go // 启动rpc文件
```

它是由protoc命令和goctl命令的集合体组成，组成方式如下：
`goctl rpc protoc pb/*.proto 【--proto_path=./ --go_out=./ --go-grpc_out=./】  --zrpc_out=./ --style=goZero -m=true`
上面【】中为protoc命令。

### 3. goctl import
假设在我的mytest目录下，有如下文件
```
.
├── base
│   └── base.proto
└── pb
    └── sim.proto
```

mytest/base/base.proto内容如下
```go
syntax = "proto3";

// 1. proto 引用包名 base;在.proto文件中通过base.Base饮用此文件下Base
package base;

// 2. 生成 golang 代码后的包名 mypackage; 
// 如果不写默认为路径名比如./pb; 则包名为pb
option go_package = "./pb;mypackage";

message Base{
  int32 code = 1;
  string msg = 2;
}
```

```go
syntax = "proto3";
// 引用包名import时使用
package pb;

// 这里写路径 PS：这里不能写../形式
import "base/base.proto";

// 生成go包路径./pb; go包名为mypackage
option go_package = "./pb;mypackage";

// 到上层目录去执行
// protoc --proto_path=./ --go_out=./ pb/sim.proto
// goctl rpc protoc pb/*.proto --proto_path=./ --go_out=./ --go-grpc_out=./  --zrpc_out=./ --style=goZero -m=true

// 具体来看这里
// https://www.lixueduan.com/posts/protobuf/01-import/#4-%E5%B0%8F%E7%BB%93

// --go_out 用于生成基本的 Protocol Buffers Go 代码（即 *.pb.go）。
// --go-grpc_out 用于生成 gRPC 相关的代码（即 *_grpc.pb.go）。

message SendMessageReq{
  base.Base base = 1; // 通过base.Base引用
  string data = 2;
}

message SendMessageRes {
	int32 Id = 1;
}

service comment {
	// 创建评论
	rpc CreateComment(SendMessageReq) returns (SendMessageRes);
}
```


### other
```go
// 获取traceId
traceID := trace.TraceIDFromContext(l.ctx)
```
