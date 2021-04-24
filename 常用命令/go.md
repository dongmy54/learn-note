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
```