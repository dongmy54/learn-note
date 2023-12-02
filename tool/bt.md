## bt搭建网站

### 1. 域名、云服务准备
购买地址：https://www.vpsor.cn/
香港区可以免备案

### 2. 服务器安装bt
ssh 连上服务器

从bt https://www.bt.cn/new/download.html
选择对应操作系统的命令

到服务器命令行粘贴执行：
比如ubutn选择：`wget -O install.sh https://download.bt.cn/install/install-ubuntu_6.0.sh && sudo bash install.sh ed8484bec`

注意如下端口需要开放： 
请在安装面板前确认以下端口服务是否开启，确保安装和访问正常
SSH连接端口：22 面板地址访问端口：8888
FTP端口：20、21、39000-40000 网站访问端口：80、443
phpmyadmin访问端口：888

中途遇到停顿直接输入Y继续


安装完成后后有如下提示信息：
外网面板地址: http://SERVER_IP:18774/422cf8b4
 内网面板地址: http://172.16.0.34:18774/422cf8b4
 username: xxx
 password: yyy 

将SERVER_IP 换成你的ip然后访问

### 3. 进入bt后台
这里需要注册你自己的bt账号，如果没有先注册一个然后登录

### 4. 安装必要的软件
进来后会有推荐安装，先安装一波（最好是编译安装这样性能好）
```
1. 注意有时候会报错 解析不了 bt的域名 如果不行，现在服务器hosts文件中写上 然后再搞
2. 发现编译安装不行，换成极速安装
```

#### 5. 函数禁用 && 插件安装

#### 6. 添加网站

#### 7. 证书
bt 自带 Let’s Encrypt






