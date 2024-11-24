## go-zero开发指南
前面介绍了go-zero框架如何快速上手，帮助大家形成一个整体认知；但是对于实际开发中的内容涉及的较少，相信你看完前篇后，心中还有很多的疑问。本篇是从工程化的角度进一步介绍go-zero开发的方方面面，特别是很多小技巧，希望能帮到你。

本篇需要有一定基础，如果您还没有看过前一篇，强烈建议您先看前一篇——[快速掌握go-zero开发](https://juejin.cn/post/7390682536744386594)

### 一、vscode插件安装
默认情况下`.api`不支持代码高亮，在vscode中可以安装`gctl`来提供语法高亮和提示。

### 二、 api文件
api文件中一个api一般写两个参数：一个请求`xxReq`结构体、一个`xxRes`响应结构体；
PS：如果没有参数可以省略

api文件参考如下：
```go
type (
  // 注册请求
  RegisterRequest {
    Name     string `json:"name"`
    Mobile   string `json:"mobile"`
    Gender   string `json:"gender"`
    Password string `json:"password"`
  }
  // 注册响应
  RegisterResponse {
    ID     int64  `json:"id"`
    Name   string `json:"name"`
    Mobile string `json:"mobile"`
    Gender string `json:"gender"`
  }
)

// api定义的地方
service user {
  @handler Register // 注册接口请求的方法名
  post /api/user/register (RegisterRequest) returns (RegisterResponse)
}
```
#### 1. 简化api生成
我们写好api文件后，就是去执行`goctl`命令生成对应的代码；这本身没有什么问题，但是每次都这么做很麻烦，我们可以通过别名来简化操作。

添加别名`alias genapi='goctl api go -api *.api -dir ../  --style=goZero'`;
到xx.api同一目录下执行`genapi`即可，会在此上层目录生成文件

#### 2. 导多文件api
一般在真实的项目中都会有很多的api，如果都写在同一个文件内，会非常杂乱，庆幸的是go-zero api支持`import`;

比如一个订单服务，的api文件路径如下
```shell
$tree desc
desc
├── order
│   └── order.api
└── order.api
```

orderm目录内放各种子文件，然后在外层`order.api`主api文件中依次import, 主api文件内容如下：
```api
import (
  "order/order.api" // 导入order目录下的order.api文件
)
```


### 三、rpc 文件
一般而言我们是在每个rpc服务路径下，创建一个`pb`目录，在此目录下，创建xx.proto文件，文件内容参考如下
```go
syntax = "proto3";

package pb;
// go_package指定生成go包（也就是生成的.pb.go文件）的路径
// PS: 路径中要带/
// 在同级目录下执行 goctl rpc protoc *.proto --go_out=../ --go-grpc_out=../  --zrpc_out=../ --style=goZero 生成
option go_package = "./pb";

// 注册请求
message RegisterRequest {
  string Name = 1;
  string Mobile = 2;
  string Gender = 3;
  string Password = 4;
}

// 注册响应
message RegisterResponse {
  int64 Id = 1; // 注册完返回ID信息
  string Name = 2;
  string Mobile = 3;
  string Gender = 4;
}

// 这里命名为User 它生成客户端代码时，会生成一个userclient的目录
service User {
  rpc Register(RegisterRequest) returns (RegisterResponse);
}
```

#### 1. 简化rpc生成
同理api一样，也添加一个别名`alias genrpc='goctl rpc protoc *.proto --go_out=../ --go-grpc_out=../  --zrpc_out=../ --style=goZero'`；
添加完成后在proto文件所在目录执行`genrpc`即可，会在此上层目录生成相应文件

#### 2. 简化proto文件生成
一般而言proto文件里的内容都是根据数据表字段来的，如果我们每次都手写还是很繁琐，感谢大佬`Mikael`开发了一个根据数据库生成pb的工具。

1. sql2pb自动生成pb
安装`go install github.com/Mikaelemmmm/sql2pb@latest`

安装完后，搭配shell脚本使用，脚本内容如下：
PS：数据库地址、用户名啥的记得替换成您自己的哦！
```shell
#!/usr/bin/env bash

# 使用方法：
# ./genPb.sh usercenter user
# ./genPb.sh usercenter user_auth
# ./genPb.sh usercenter user_auth,user # 多个表逗号分隔
# 添加权限 chmod +x genPb.sh
# 再将./genPb下的文件剪切到对应服务的pb目录里面,如果需要改下服务名
# 当然也可以在创建下的pb目录下执行，这样就不用多去做一步复制了

#生成的表名
tables=$2

# 数据库配置
host=127.0.0.1
port=3306
dbname=$1
username=root
passwd=12345678

sql2pb -go_package ./pb -host="${host}" -package pb -password="${passwd}" -port="${port}" -schema="${dbname}" -service_name="${tables}" -table="${tables}" -user="${username}"> "${tables}".proto
```

#### 3. 关于proto的import
自己当前的结论是，非常弱。原因有两点：
1. 请求体和响应体都必须在主proto中（那么在子proto中写的message没法直接在主proto service中使用）
```go
syntax = "proto3";

package greet;

import "base.proto"

service demo{
  // 这里引入子proto的message 是没法用的 ❌
  rpc (base.DemoReq) returns (base.DemoResp);
}
```

2. 不支持service引入（引入的只能是message）
具体可以看官网介绍: https://go-zero.dev/docs/tutorials/proto/faq



### 四、model
#### 4.1. 通过表生成model
老办法，我们也使用脚本去生成，脚本位置生成后，然后移动到对应目录。
脚本文件如下：
```shell
#!/usr/bin/env bash

# 使用方法：
# ./genModel.sh usercenter user
# ./genModel.sh usercenter user_auth
# 添加权限 chmod +x genModel.sh
# 再将./genModel下的文件剪切到对应服务的model目录里面，记得改package


#生成的表名
tables=$2
#表生成的genmodel目录
modeldir=./genModel

# 数据库配置
host=127.0.0.1
port=3306
dbname=$1
username=root
passwd=12345678


echo "开始创建库：$dbname 的表：$2"
goctl model mysql datasource -url="${username}:${passwd}@tcp(${host}:${port})/${dbname}" -table="${tables}"  -dir="${modeldir}" -cache=true --style=goZero
# 样式指文件样式，保持统一
# gozero/goZero/go_zero 三种
```

#### 4.2 添加自定义查询
`goctl model`生成的文件主要有三个：
1. `xxxModel.go`：自定义数据库操作文件
2. `xxxModel_gen.go`：默认数据库操作文件（不要去编辑）
3. `vars.go`：model的包常量、变量

我们**要去`xxxModel.go`中添加自定义查询才不会被覆盖哦**，记住啦～


### 五、项目结构
项目目录结构体应该如何划分呢？可以参考如下结构
1. 大体上
```shell
$ tree
.
├── app        # 各个服务、消息队列
├── common     # 通用逻辑代码
├── deploy     # 部署相关
└── go.mod
```

2. 细看服务（服务划块）
```shell
# 一个order 服务
$ tree order -L 2

order
├── cmd
│   ├── api
│   ├── mq
│   └── rpc
└── model    # model是放在外层的 供它们api/rpc使用
    ├── homestayOrderModel.go
    ├── homestayOrderModel_gen.go
    └── vars.go


$ tree order/cmd/api -L 2
order/cmd/api
├── desc         # 注意api特殊，这里有一个desc文件夹，api通过目录管理起来
│   ├── order
│   └── order.api
├── etc
│   └── order.yaml
├── internal
│   ├── config
│   ├── handler
│   ├── logic
│   ├── svc
│   └── types
└── order.go

$ tree order/cmd/api -L 2
order/cmd/rpc
├── etc
│   └── order.yaml
├── internal
│   ├── config
│   ├── logic
│   ├── server
│   └── svc
├── order
│   └── order.go
├── order.go
└── pb
    ├── order.pb.go
    └── order.proto
```
我们各种生成脚本放到deploy/script目录下


### 六. 日志
```yaml
Log: 
  Mode: console
  Encoding: plain # 打开这个方便查看日志
```

### 七、自定义中间件
中间件非常有用，大体分两类：
1. api中间件
2. rpc拦截器

#### 1.api中间件
```go
server.Use(middleware) // 注意这个是在api.go中

// 自定义的中间件
func middleware(next http.HandlerFunc) http.HandlerFunc {
  return func(w http.ResponseWriter, r *http.Request) {
    w.Header().Add("X-Middleware", "static-middleware")
    fmt.Println("========这是我的中间件========")
    next(w, r)
  }
}
```

#### 2.rpc拦截器
rpc里我们叫拦截器
```go
func main() {
  flag.Parse()

  //...
  s.AddUnaryInterceptors(exampleUnaryInterceptor)
  //...
  s.Start()
}

func exampleUnaryInterceptor(ctx context.Context, req interface{}, info *grpc.UnaryServerInfo, handler grpc.UnaryHandler) (resp interface{}, err error) {
  // TODO: fill your logic here
  logx.Error("这是我自己的rpc中间件哦")
  return handler(ctx, req)
}
```

### 八、数据
数据查询，在go-zero里分了：
1. sqlx 
2. sqlc（带缓存）
在**goctl 生成的时候可以指定具体生成的sqlx还是sqlc（`-cache=true`）**

数据相关的操作，总体上分为
- 查询（QueryRow）
- 修改（ExecCtx）
其它都是这些的变体，了解上面两种后，您就能很快上手其它的函数了。
```go
// ========== QueryRow 查询操作 ===============
// QueryRowCtx 查询单行数据


// 查询一个计算总数的
query := fmt.Sprintf("select count(*) from %s", m.table)
var cnt int64
err := m.QueryRowNoCacheCtx(ctx, &cnt, query)

// QueryRowsCtx 查询多行数据
query := fmt.Sprintf("select  from %s limit 10", m.table)
var posts []*Post
err := m.QueryRowsNoCacheCtx(ctx, &posts, query)


// ======== ExecCtx 执行增删改 ==================
sql_str := fmt.Sprintf("insert into %s (title, content, user_id) values (?,?,?)", m.table)
result, err := m.ExecNoCacheCtx(ctx, sql_str, "标题", "内容", 1)


// =============== TransactCtx事务 =====================
m.TransactCtx(ctx, func(ctx context.Context, s sqlx.Session) error {
  // 只要其中一个报错 则失败
  _, err := s.ExecCtx(ctx, "insert into post (title, content, user_id) values (?,?, ?)", "标题1", "内容1", 1)
  if err != nil {
    return err
  }

  // 这里user_id必填会为空
  _, err = s.ExecCtx(ctx, "insert into post (title, content, user_id) values (?,?,?)", "标题1", "内容1", 11)
  if err != nil {
    return err
  }

  return nil
})
```
补充：
1. 分布式项目不同于单体项目，它的查询一般都是对单张表做操作，一般不会涉及类似joins这种情况，因此对orm的需求其实并不强。
2. 在一个rpc中既可以调用其它rpc也可以直接调用model做数据查询；很多时候一个rpc是要依靠几个rpc或者model才能完成业务需要。


### 九、自定义模版
有两种方式：
1. 生成模版到家目录，然后修改对应的模版
```shell
goctl template init #  初始化模版到本地
# 它会在你的家目录下生成一个.goctl目录，里面就有对应的模版文件
# 只需要在这个目录下的文件做修改，goctl生成对应的命令就会生效了

goctl template clean # 删除本地模版
```
2. 在命令执行过程中指定要使用的是哪个模版,提供路径
`goctl model mysql ddl --src $sql_path --dir $out/$file_name --home ./template/1.4.2/` 这里指定了--home路径


### 十、api参数校验
go-zero本身也提供了参数校验，但是比较简单有限，因此如果要做比较复杂的验证推荐使用[validator](https://github.com/go-playground/validator) 这个库

### 十一、其它
go-zero默认是通过编写sql进行数据查询的，如果你习惯使用orm,你可以使用包`github.com/Masterminds/squirrel`用它来生成sql语句，然后通过`sqlx`执行sql语句。





