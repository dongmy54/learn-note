## go-zero开发指南

### vscode插件安装
`gctl`提供语法高亮和提示。

### 一. api
创建api文件
```api
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

1. 添加别名`alias genapi='goctl api go -api *.api -dir ../  --style=goZero'`;
到xx.api同一目录下执行`genapi`即可，会在此上层目录生成文件

2. 所有api文件统一放到一个目录下比如：`desc`，下面有一个主文件，通过`import`方式导入
```
import (
  "order/order.api" // 导入order目录下的order.api文件
)
```


### 二、rpc
1. 创建一个`pb`目录，在此目录下，创建xx.proto文件
```proto
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

2. 添加别名`alias genrpc='goctl rpc protoc *.proto --go_out=../ --go-grpc_out=../  --zrpc_out=../ --style=goZero'`

3. sql2pb自动生成pb
安装`go install github.com/Mikaelemmmm/sql2pb@latest`

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

### 三、model
#### 3.1. 通过表生成model
现在脚本位置生成后，然后移动到对应目录
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

#### 3.2 添加自定义查询
在`xxxModel.go`中添加自定义查询才不会被覆盖


### 四、项目结构
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


### 五. 日志
```yaml
Log: 
  Mode: console
  Encoding: plain # 打开这个方便查看日志
```

### 六、自定义中间件
```go
server.Use(middleware)

// 自定义的中间件
func middleware(next http.HandlerFunc) http.HandlerFunc {
  return func(w http.ResponseWriter, r *http.Request) {
    w.Header().Add("X-Middleware", "static-middleware")
    fmt.Println("========这是我的中间件========")
    next(w, r)
  }
}
```

### 七、数据
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
分布式项目不同于单体项目，它的查询一般都是对单张表做操作，一般不会涉及类似joins这种情况，因此对orm的需求其实并不强。


### 七、rpc拦截器
### 八、api参数校验

### 九、其它
1. 为了便于编写sql语句可以使用包`github.com/Masterminds/squirrel`
2. 为了数据之间便于拷贝使用`github.com/jinzhu/copier`




