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
mkdir service/users 
mkdir service/users/{rpc,model,api}

mkdir service/posts
mkdir service/posts/{rpc,model,api}

mkdir service/comments
mkdir service/comments/{rpc,model,api}

mkdir common # 一个公用的目录 用于存放一些通用的代码
```

搭建后目录结构如下：
```
tree
.
├── common
├── go.mod
└── service
    ├── comments
    │   ├── api
    │   ├── model
    │   └── rpc
    ├── posts
    │   ├── api
    │   ├── model
    │   └── rpc
    └── users
        ├── api
        ├── model
        └── rpc

15 directories, 1 file
```

在上面我看到每一个模块都是由三个部分组成，分别是`rpc`、`model`、`api`，他们之间怎么交互呢？在传统的api服务中，只需要api去和model交互就行，但是在微服务中，会多一层那就是rpc,是由rpc去和model交互的，整体关系如下：
**`api` -> `rpc` -> `model`**


### 四、实战
虽然上面列出了三个模块，但是实际上我们只需要完整的实现一个模块就能达到练习的目的，这里使用`users`模块来演示。

#### 4.1 model创建
为了演示方便，我们使用mysql数据库，可以在本地先创建一个`forum`数据库database, 然后创建一个`users`表，为了方便您可以执行以下sql生成：
```sql
CREATE TABLE users (
    id bigint AUTO_INCREMENT,
    name varchar(255) NULL COMMENT 'The username',
    password varchar(255) NOT NULL DEFAULT '' COMMENT 'The user password',
    mobile varchar(255) NOT NULL DEFAULT '' COMMENT 'The mobile phone number',
    gender char(10) NOT NULL DEFAULT 'male' COMMENT 'gender,male|female|unknown',
    nickname varchar(255) NULL DEFAULT '' COMMENT 'The nickname',
    type tinyint(1) NULL DEFAULT 0 COMMENT 'The user type, 0:normal,1:vip, for test golang keyword',
    create_at timestamp NULL,
    update_at timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    UNIQUE mobile_index (mobile),
    UNIQUE name_index (name),
    PRIMARY KEY (id)
) ENGINE = InnoDB COLLATE utf8mb4_general_ci COMMENT 'user table';
```

终端切换到`forum/service/users/model`目录下，在此目录下新建`user.sql`文件。然后将上述sql内容放进去。

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

#### 4.2 rpc创建


#### 4.3 api创建

### 五、套路总结

### 六、相关学习资源推荐






