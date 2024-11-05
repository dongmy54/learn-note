## grpcui 
安装homebrew就行

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


```