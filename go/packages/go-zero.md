## go zero
go-zero 是一个非常受欢迎的go语言微服务框架，截止到目前为止github上拥有高达28k的star;它由国内大神Kevin Wan主导开发，因此它的中文文档非常丰富。它提供了许多开箱即用的功能，比如：限流、熔断、链路追踪、缓存、api参数自动校验、命令行代码生成等等。如果用go做微服务相关的开发，强烈建议学习下go-zero.

### 一、本文适合哪些人？
如果你是一个`go-zero`的新手，那么本文适合你。如果你已经是`go-zero`的开发者，那么本文不太适合，这里介绍的都是偏向`go-zero`的新手介绍。

### 二、怎么学习go-zero
go-zero作为一个微服务框架，既然它是一个框架，那么它就一定有某些套路。我们只要找到它的常见套路，然后遵循这些套路，理清各个部分之间的关系，做到心中有数就能很快掌握。

那么怎么找到go-zero的常见套路呢？复杂的事情都是从简单的事情开始的，麻雀虽小但是五脏俱全。我们只需要做一个最小、最简单的应用，然后吃透它。虽然不能做到完全掌握，但是至少能掌握和理解其中最重要核心的套路,以后即使面对比它更复杂的应用，也能快速掌握。

那么我们做一个什么应用呢？
我们做一个论坛吧，这个比较简单，涉及的的表也比较少，类似于百度贴吧。任何用户都可以去发表言论，然后其它用户可以评论。

### 三、准备工作
在开始前，如果你还不清楚什么是rpc建议先看这篇[手把手教你使用rpc](https://juejin.cn/post/7375386125814546470)

#### 1. 安装`protoc`编译器
它是一个根据proto文件生成代码的工具，我们使用它来生成rpc的代码，在mac上可以在终端执行`brew install protobuf`安装，安装完成后可以通过`protoc --version`查看是否安装成功。
如果不是mac环境可以到[github](https://github.com/protocolbuffers/protobuf/releases) assets下载对应版本的安装包。

#### 2. 安装go插件
安装了`protoc`编译器后还需要安装两个go相关的插件，`protoc-gen-go`、`protoc-gen-go-grpc`用于生成go语言的grpc代码。

```shell
$ go install google.golang.org/protobuf/cmd/protoc-gen-go@v1.28
$ go install google.golang.org/grpc/cmd/protoc-gen-go-grpc@v1.2
```

#### 3. 安装`gctl`
它是go-zero提供的一个命令行工具，用于快速生成微服务相关代码。
```shell
$ go install github.com/zeromicro/go-zero/tools/goctl@latest
```
安装完后通过`goctl --version`查看是否安装成功。


好啦！做完准备工作，我们开始实战环节。

### 四、项目结构搭建
我们做的是一个论坛系统，简单分析我门禁就可以得出需要用户（users）、帖子(posts)、评论(comments)三个模块。我们把每个模块做为一个服务，每个服务我们分为api、rpc、model三个主要的部分。

```shell
mkdir forum && cd forum
go mod init forum

mkdir service
mkdir service/user 
mkdir service/user/{rpc,model,api}

mkdir service/post
mkdir service/post/{rpc,model,api}

mkdir service/comment
mkdir service/comment/{rpc,model,api}

mkdir common # 一个公用的目录 用于存放一些通用的代码
```

搭建后目录结构如下：
```
tree
.
├── common
├── go.mod
└── service
    ├── comment
    │   ├── api
    │   ├── model
    │   └── rpc
    ├── post
    │   ├── api
    │   ├── model
    │   └── rpc
    └── user
        ├── api
        ├── model
        └── rpc

15 directories, 1 file
```

在上面我看到每一个模块都是由三个部分组成，分别是`rpc`、`model`、`api`，他们之间怎么交互呢？在传统的api服务中，只需要api去和model交互就行，但是在微服务中，会多一层那就是rpc,是由rpc去和model交互的，整体关系如下：
**`api` -> `rpc` -> `model`**


### 五、实战
虽然上面列出了三个模块，但是实际上我们只需要完整的实现一个模块就能达到练习的目的，这里使用`user`模块来演示。

#### 5.1 model创建
为了演示方便，我们使用mysql数据库，可以在本地先创建一个`forum`数据库database, 然后创建一个`users`表，为了方便您可以执行以下sql生成：
```sql
CREATE TABLE users (
    id bigint AUTO_INCREMENT,
    name varchar(255) NOT NULL DEFAULT '' COMMENT 'The username',
    password varchar(255) NOT NULL DEFAULT '' COMMENT 'The user password',
    mobile varchar(255) NOT NULL DEFAULT '' COMMENT 'The mobile phone number',
    gender char(10) NOT NULL DEFAULT 'male' COMMENT 'gender,male|female|unknown',
    nickname varchar(255) NULL DEFAULT '' COMMENT 'The nickname',
    type tinyint(1) NULL DEFAULT 0 COMMENT 'The user type, 0:normal,1:vip, for test golang keyword',
    create_at timestamp NULL DEFAULT CURRENT_TIMESTAMP,
    update_at timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    UNIQUE mobile_index (mobile),
    UNIQUE name_index (name),
    PRIMARY KEY (id)
) ENGINE = InnoDB COLLATE utf8mb4_general_ci COMMENT 'user table';
```

终端切换到`forum/service/user/model`目录下，在此目录下新建`user.sql`文件。然后将上述sql内容放进去。

命令行终端执行: `goctl model mysql ddl --src user.sql --dir .`
看到`Done`则表示model代码生成成功了。

它会在当前目录下生成三个文件：
1. `vars.go` 存放一些常量
2. `usermodel.go` model初始化入口
3. `usermodel_gen.go` 数据库操作具体实现 

这里我们着重关注下`usermodel.go`中
```go
// 我们到时候通过model.NewUserModel(sqlConn)就可以初始化model啦
func NewUserModel(conn sqlx.SqlConn) UserModel {
	return &customUserModel{
		defaultUserModel: newUserModel(conn),
	}
}

// 这里返回的UserModel是一个接口类型，这个接口需要实现Insert、FindOne、FindOneByMobile、FindOneByName、Update、Delete等方法

// 这些方法的实现是通过defaultUserModel这个结构体去实现的
```

除了上面的通过sql去生成model外，go-zero还可以通过当前的数据库中的表去生成model代码，使用如下命令：
`goctl model mysql datasource --url="root:12345678@tcp(127.0.0.1:3306)/forum" --table=users --dir=./`

需要注意的是，执行`goctl model`命令并不会直接到我们本地的数据库创建表，因此我们需要手动到数据库中去新建表或增减字段。虽然我们可以通过本地数据库直接生成model，但是为了别人拿到项目后能快速初始化表结构，还是建议在model层下放置完整的表sql文件。

#### 5.2 rpc结构初始化
下面我们来开始创建rpc层，创建rpc首先需要创建proto文件，在`forum/service/user/rpc`目录下新建`user.proto`文件。

文件内容如下：
```go
syntax = "proto3";

package user;
// go_package指定生成go包（也就是生成的.pb.go文件）的路径
// PS: 路径中要带/
// 在同级目录下执行 goctl rpc protoc user.proto --go_out=./ --go-grpc_out=./ --zrpc_out=. --client=true 生成
option go_package = "./user";

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

// 登录请求
message LoginRequest {
  string mobile = 1;
	string password = 2;
}

// 登录响应
message LoginResponse {
	// 注意，登录后我们需要返回token的授权信息，但是这里并没有返回token
	// 是因为我们的token应该是api层去做的事，放在api层更合适
  int64 Id = 1;    
	string Name = 2;
	string Mobile = 3;
	string Gender = 4;
}

// 用户信息请求
message UserInfoRequest {
  int64 Id = 1;
}

// 用户信息响应
message UserInfoResponse {
  int64 Id = 1;
	string Name = 2;
	string Mobile = 3;
	string Gender = 4;
}

/*
  service 定义服务
  rpc 定义方法
  返回值类型
*/

// 这里命名为User 它生成客户端代码时，会生成一个userclient的目录
service User {
  rpc Register(RegisterRequest) returns (RegisterResponse);
	rpc Login(LoginRequest) returns (LoginResponse);
	rpc UserInfo(UserInfoRequest) returns (UserInfoResponse);
}
```

这个文件是用于约定rpc请求和响应格式的,我们后续用这个文件来生成rpc代码。从上面我们可以看出，约定了三个rpc服务：注册、登录、用户信息。

一般而言，**我们命名格式为`xxRequest`和`xxResponse`，其中`xx`为方法名。而对server端的rpc方法，我们一般命名格式为`xx`，其中`xx`为方法名。字段名大写**

如果不清楚proto文件如何写，可以查看[此文](https://www.zhangjiee.com/topic/grpc/write-proto-spec.html#org9cd8b2a)

好啦，我们继续，现在我们就可以通过命令生成rpc代码了,在`forum/service/user/api`目录下执行`goctl rpc protoc user.proto --go_out=./ --go-grpc_out=./ --zrpc_out=. --client=true`

看到`Done`则表示rpc代码生成成功了。

让我们大概看下都生成了些什么？
```shell
.
├── etc           # 配置文件存放 
│   └── user.yaml
├── internal      # 内部代码重点关注，我们需要改动代码基本都在这里
│   ├── config    # 配置层
│   │   └── config.go
│   ├── logic     # 业务逻辑层(业务具体实现位置)
│   │   ├── loginlogic.go
│   │   ├── registerlogic.go
│   │   └── userinfologic.go
│   ├── server   # 用于构建rpc server服务，转发logic处理
│   │   └── userserver.go
│   └── svc      # 服务上下文（里面封装了config)
│       └── servicecontext.go
├── user         # proto生成的中间代码，无需修改
│   ├── user.pb.go
│   └── user_grpc.pb.go
├── user.go      # rpc启动入口，rpc的main就在这里
├── user.proto  
└── userclient   # api层调用rpc入口
    └── user.go

9 directories, 12 files
```

对生成文件有一个大概认识后，我们来编写我们的代码，在开始前我们先`go mod tidy`一下，拉取必要的依赖。

#### 5.3 rpc配置model关联
前面我们已经说了，api不与model直接交互，与之交互的是rpc，因此我们在生成rpc代码后，第一要做的就是配置数据库连接。

1. etc数据库配置
在`service/user/rpc/etc/user.yaml`中配置mysql的连接地址。
```yaml
Name: user.rpc
ListenOn: 0.0.0.0:8080
Etcd:
  Hosts:
  - 127.0.0.1:2379
  Key: user.rpc

### 配置的是这部分
Mysql:
  DataSource: root:12345678@tcp(127.0.0.1:3306)/forum?charset=utf8mb4&parseTime=true&loc=Asia%2FShanghai
```

2. config数据库配置
在`service/user/rpc/internal/config/config.go`中修改config结构体如下：
```go
type Config struct {
	zrpc.RpcServerConf

	// 这里引入mysql数据库配置 后面svc.ServiceContext中会用到
	// 这里的结构和etc配置文件中保持一致
	Mysql struct {
		DataSource string
	}
}
```

3. svc服务上下文配置
在`service/user/rpc/internal/svc/servicecontext.go`中修改svc.ServiceContext结构体，引入model字段，同时修改其工厂方法
```go
type ServiceContext struct {
	Config    config.Config
	UserModel model.UsersModel // 添加model层关联
}

func NewServiceContext(c config.Config) *ServiceContext {
	return &ServiceContext{
		Config:    c,
    // 添加UserModel字段关联
		UserModel: model.NewUsersModel(sqlx.NewMysql(c.Mysql.DataSource)),
	}
}
```
配置完成！我们继续。

#### 5.4 rpc用户注册实现
有了前面的配置，实现逻辑就比较简单了，我们只需要在`service/user/rpc/internal/logic/registerlogic.go`中实现`RegisterLogic`方法即可。

```go
func (l *RegisterLogic) Register(in *user.RegisterRequest) (*user.RegisterResponse, error) {
	// 注册时 先去数据库查找下是否已经有这个人
	_, err := l.svcCtx.UserModel.FindOneByMobile(l.ctx, in.Mobile)
	if err == nil {
		return &user.RegisterResponse{}, status.Error(400, "该手机号已注册")
	}

	// 加这个判断是为了避免其它错误导致去创建
	if err == model.ErrNotFound {
		res, err := l.svcCtx.UserModel.Insert(l.ctx,
			&model.Users{
				Name:     in.Name,
				Mobile:   in.Mobile,
				Password: in.Password,
				Gender:   in.Gender,
			})

		if err != nil {
			return &user.RegisterResponse{}, status.Error(400, err.Error())
		}

		id, err := res.LastInsertId()
		if err != nil {
			return &user.RegisterResponse{}, status.Error(400, err.Error())
		}

		return &user.RegisterResponse{
			Id:     id,
			Name:   in.Name,
			Gender: in.Gender,
			Mobile: in.Mobile,
		}, nil
	}

	// 如果不是ErrNotFound，则说明数据库查询出错,这里报错500
	return &user.RegisterResponse{}, status.Error(500, err.Error())
}
```

上面的代码整体比较简单，我们就是利用l变量-逻辑层去调用model层，做一些数据处理。

现在我们来试下，是否能跑通注册功能。在测试前面有两个地方需要注意：
1. 由于我们的配置文件中是配置了etcd，因此需要先启动etcd服务。mac电脑可以通过brew 安装。
2. 我们通过grpcurl工具来测试rpc服务，默认是不能调试的，需要先开启dev模式，我们在`service/user/rpc/etc/user.yaml`中添加`Mode: dev`即可。

```yaml
Name: user.rpc
ListenOn: 0.0.0.0:8080
Mode: dev # 添加它

# ....
```

我们在`service/users/rpc`下启动服务。
```shell
$ go run user.go
Starting rpc server at 0.0.0.0:8080...
```

然后在再开一个终端，用于测试
```shell
$ grpcurl -plaintext 127.0.0.1:8080 list # 查看有哪些服务
grpc.health.v1.Health
grpc.reflection.v1.ServerReflection
grpc.reflection.v1alpha.ServerReflection
user.User
```

```shell
$ grpcurl -plaintext 127.0.0.1:8080 list user.User # 查看某个服务下的方法
user.User.Login
user.User.Register
user.User.UserInfo
```

```shell
# 这里需要注意字段名要和proto文件一致
$ grpcurl -plaintext -d '{"Name": "李四", "Mobile": "18200365766", "Password": "123456"}' 127.0.0.1:8080 user.User/Register # 调用服务的方法
{
  "Id": "3",
  "Name": "李四",
  "Mobile": "18200365766"
}
```

我们再去数据库查看，发现users表已经有数据了。

简单回顾下整个过程：
1. 根据proto文件生成rpc组织结构代码
2. rpc关联model修改（etc/config/svc 三个相关文件）
3. 到logic下编写业务逻辑

可以看出在架子搭起后，编写业务逻辑还是很快捷简单的。

#### 5.4 rpc用户登录实现
#### 5.5 rpc用户信息实现


#### 5.3 api创建

### 五、套路总结

### 六、相关学习资源推荐






