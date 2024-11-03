### 1. goctl protoc命令说明
假设在`app`目录下有一个`pb`文件夹，文件夹里有一个`order.proto`文件；

此时在pb目录下执行，`goctl api go -api *.api -dir ../  --style=goZero'`
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


