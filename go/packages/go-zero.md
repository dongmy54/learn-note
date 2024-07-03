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
### 四、实战

### 五、套路总结

### 六、相关学习资源推荐






