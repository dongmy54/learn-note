#### go 命令集合
```
go version 版本
go env     环境
go env GOPATH  单独看某一个环境变量的值

go env -w GOPROXY=https://goproxy.cn,direct  配置环境变量全局

go get -u go.uber.org/zap        拉取库
go get -u go.uber.org/zap@v1.12  指定版本拉取
go mod tidy 清洁项目下go.sum（类似于拉取日志）中不相关版本库

go build ./... 当前文件 及目录下所有文件包括子文件build一遍
go mod init gomodtest  初始化mod文件

GOARCH=amd64 GOOS=linux go build -o bin/data-migration
```

```shell
go clean -cache # 清理编译后缓存条目

# 清理测试缓存结果 保证每次都是最新的
go clean -testcache


# linux build数据
GOARCH=amd64 GOOS=linux go build -o bin/data-migration
```

#### 多版本管理
1. 安装g `curl -sSL https://raw.githubusercontent.com/voidint/g/master/install.sh | bash`

2. 配置.bashrc
```shell
# 将这行添加到你的 .bashrc 或 .zshrc 文件末尾
export PATH="$HOME/.g/bin:$PATH"

# 重新加载配置文件
source ~/.bashrc 
# 或者 source ~/.zshrc
```

3. 常用命令
```shell
g ls # 列出本地版本

g ls-remote # 列出远程版本
g install 1.22.3 # 安装指定版
g use xxx # 使用指定版本
g uninstall 1.22.3 # 卸载
```
