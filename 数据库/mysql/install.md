#### 安装

##### Ubuntu 安装流程
```
apt-get update
apt-get install mysql-server

systemctl start mysql          启动mysql
systemctl enable mysql         开机自启动

vim /etc/mysql/mysql.conf.d/mysqld.cnf  修改配置文件（bind-address 0.0.0.0)
systemctl restart mysql                 重启

mysql -u root -p                        shell进入
```

##### 远程连接注意事项
> 1. 阿里云服务商网络安全组入方向、出方向都需开放 3306端口
> 2. `/etc/mysql/mysql.conf.d/mysqld.cnf` 中 bind-address = 0.0.0.0 远程监听所有ip




