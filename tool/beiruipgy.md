## 贝锐蒲公英组网
注册账号后，多端登录同一个账号就可以自动组网
PS：多端都是客户端,不要下载错了

组网教程地址：https://service.oray.com/question/10258.html


### 1. mac上下载软件登录
登录后进入,进入控制台，异地组网 > 网络成员 > 添加成员
添加时注意选择类型为客户端，这里自动会生成成员的Uid/Sid 


### 2. linux服务器下载
来这里下载：https://pgy.oray.com/download/
```shell
wget https://pgy.oray.com/download/
dpkg -i PgyVisitor-6.9.0-amd64.deb
pgyvisitor # 使用1中添加的账号去登录即可
```

### 3. 最后
多端登录成功后，mac APP上可以看到linux服务器公网IP了，要用ssh直接像局域网一样直接用即可




### 如何利用ssh实现浏览器访问内网ip
方案： ssh 配置代理 + chrome插件SwitchyOmega
```shell
Host fsbr-proxy
  HostName 172.16.1.xx # 这里应该填写您的公网IP地址
  User fuxxxx
  DynamicForward 8181   # 在连接时自动开启SOCKS代理
  ServerAliveInterval 60 # 每60秒发一个心跳包，防止连接断开
```

上面会实现一个本地的代理 SOCKS5: 127.0.0.1:8181
