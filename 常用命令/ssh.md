#### ssh
> 配置文件：`/etc/ssh`
> rsa配置：`~/.ssh`


##### 登录配置
```
ssh-keygen -t rsa                 # 本地电脑创建密钥对 若存在则不用重新创建
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

