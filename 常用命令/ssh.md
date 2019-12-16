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
```
ssh root@120.79.1xx.yyy     # 以root身份 登录 120.79.1xx.yyy

# 限制权限
chmod 700 ~/.ssh
chmod 600 ~/.ssh/id_rsa
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

