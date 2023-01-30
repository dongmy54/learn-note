##### frp
> - 一个自己搭建内网穿透的工具，实现ssh、web服务（连接内网电脑）
> - 原理： 利用一台具有公网ip的服务器做中转，将端口转发到内网机器处理
> - 中文配置文档：`https://gofrp.org/docs/`

##### 安装
> - 需要分别在客户端（内网机器）和 服务端（公网机器）上分别配置
> - 版本下载地址：`https://github.com/fatedier/frp/releases`

##### 文件说明
```
frps.ini: 服务端配置文件
frps: 服务端软件
frpc.ini: 客户端配置文件
frpc: 客户端软件
```

##### 服务端(公网服务器)配置
```bash
# 下载 注意这里的版本 liunx-amd64
wget https://github.com/fatedier/frp/releases/download/v0.42.0/frp_0.42.0_linux_amd64.tar.gz
tar -xvf frp_0.42.0_linux_amd64.tar.gz

# 进入指定目录 打开配置文件编辑
vim frps.ini 
```

这里只是配置一个ssh
```bash
# frps.ini 文件
[common] #必须设置
bind_port = 7000     # 是自己设定的frp服务端端口-供客户端连接使用
# vhost_http_port = 80   # 当设置web服务时使用
# token = 123  # 核实身份用，服务端加的话，客户端也要同时加上
```
启动
```bash
# 在对应的目录 frp_0.42.0_linux_amd64 下
./frps -c frps.ini

# 后台启动 可以用
nohup ./frps -c ./frps.ini &
```

##### 客户端（内网服务器）配置
> - 1. 注意这里下载的版本需要与服务端下载版本号保持一致
> - 2. 下的时候注意客户端环境（mac/linux/windowns)
> - 3. 在客户端需要打开提供服务的端口，比如这里ssh-22端口

我用mac下载版本为： `https://github.com/fatedier/frp/releases/download/v0.42.0/frp_0.42.0_darwin_amd64.tar.gz`

```bash
# frpc.ini
[common]
server_addr = xxx.x.xx.xxx  # 公网ip
server_port = 7000          # 服务端提供服务的端口号

[ssh]
type = tcp
local_ip = 127.0.0.1
local_port = 22
remote_port = 6000         # ssh 连接时用的端口号 
```

启动
```
./frpc -c frpc.ini
```

##### 测试ssh 连接
`ssh -p 6000 dongmingyan@xxx.x.xx.xxx`
PS: 这里用户名是你内网机器用户名，非公网服务器用户名









