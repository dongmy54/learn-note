### common 
go老项目，不支持gomod处理方式,


配置gopath和 go111module开关即可，在项目根目录下
```json
{
    "go.gopath": "/home/fussen/fs/dxx/",
    "go.toolsEnvVars": {
      "GO111MODULE": "off"
    }
    // 注意：这里的值是你的GOPATH的根目录，而不是项目代码的路径
}
```

### 理解关系
1. `GOROOT` go安装目录
2. `GOOPATH` go开发目录
在GOOPATH目录下，通常包含三个目录
- bin go install后的可执行文件
- pkg 为加速go编译生成，存放编译后的包归档文件
- src 项目源代码或者用到的第三方库库代码