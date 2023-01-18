#### ssh
> 配置文件：`/etc/ssh`
> rsa配置：`~/.ssh`


##### 登录配置
```
ssh-keygen -t rsa                 # 本地电脑创建密钥对 若存在则不用重新创建
                                  # 如果需要同时创建多对秘钥，可以在输入后提示输入文件路径时候做下改动
                                  # 默认文件位置为：～/.ssh/id_rsa 
                                  # PS：这里还会提示你输入秘钥的密码，这个密码主要用于在其它设备上使用的时候需要输入
ssh-copy-id root@120.79.1xx.yyy   # 将本地 公钥传到服务器(`~/.ssh/authorized_keys`) 成功后直接登录

vim /etc/ssh/sshd_config          # 服务器 修改 PasswordAuthentication 为no 禁用密码登录
systemctl restart ssh             # 服务器重启 ssh服务
```


##### 常用
```bash
ssh root@120.79.1xx.yyy     # 以root身份 登录 120.79.1xx.yyy

# 限制权限
chmod 700 ~/.ssh
chmod 600 ~/.ssh/id_rsa

# 用ssh传递命令到服务器执行； PS:执行完后，会退出服务器
ssh dmy_hw 'command1;command2'
ssh dmy_hw < my.sh # 可以将文件写入文件中
ssh dmy_hw './server.sh' # 运行服务器上文件
```

##### 简化登录
```
# ～/.ssh/config
Host aliyu
  HostName 120.79.1xx.yyy
  User root
  Port 22
  IdentityFile ~/.ssh/id_rsa
```

##### 调整ssh超时时间
```
# /etc/ssh/ssh_config文件

# 多久发送一个空包
ClientAliveInterval  3600 # 秒 这里一个小时
# 最多发送多少个
ClientAliveCountMax  10  

# 上面配置的的总时间为 1 * 10 = 10个小时
重启sshd服务
systemctl restart ssh
```
