#### 安装

##### Ubuntu 安装流程
```
apt-get update
apt-get install mysql-server

systemctl start mysql          启动mysql
systemctl enable mysql         开机自启动

vim /etc/mysql/mysql.conf.d/mysqld.cnf  修改配置文件（bind-address 0.0.0.0)
systemctl restart mysql                 重启

mysql -u root -p      shell进入
```


##### 创建用户
```sql
INSERT INTO mysql.user (User,Host,authentication_string,ssl_cipher,x509_issuer,x509_subject)
VALUES('dongmingyan','localhost',PASSWORD('12345678'),'','','');
```


##### 查看用户
```sql
SELECT User, Host, authentication_string FROM mysql.user; -- 查看用户列表

show GRANTS FOR 'dongmingyan'@'localhost';  -- 查看单个用户权限
```


##### 授权用户
```sql
GRANT ALL PRIVILEGES ON demodb.* to demouser@localhost; -- 授权demodb权限

FLUSH PRIVILEGES;  -- 刷新权限
```


##### 修改密码
```sql
ALTER USER 'user'@'hostname' IDENTIFIED BY 'newPass';
```


##### 远程连接注意事项
> 1. 阿里云服务商网络安全组入方向、出方向都需开放 3306端口
> 2. 需要创建远程用户(PS: Host设置成 %,让任何ip都能访问)
> 3. `/etc/mysql/mysql.conf.d/mysqld.cnf` 中 bind-address = 0.0.0.0 远程监听所有ip




