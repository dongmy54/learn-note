### mysql 相关
>1. `brew install mysql` 安装mysql
>2. `mysql.server start` 启动mysql
>3. `brew services start mysql` 启动mysql
>4. `mysql -uroot` 用户名进控制台
>5. `mysql -uroot -p1234` 用户名 密码进入控制台
>6. `mysql --version`版本查看
>PS: 启动后不要关闭(重新启动会报错)，进程默认在后台启动

### mysql 卸载
```
brew remove mysql
sudo rm /usr/local/mysql
sudo rm -rf /usr/local/mysql*
sudo rm -rf /Library/StartupItems/MySQLCOM
sudo rm -rf /Library/PreferencePanes/My*
vim /etc/hostconfig  (如果这一行则删除： MYSQLCOM=-YES-)
rm -rf ~/Library/PreferencePanes/My*
sudo rm -rf /Library/Receipts/mysql*
sudo rm -rf /Library/Receipts/MySQL*
sudo rm -rf /var/db/receipts/com.mysql.*
brew cleanup
```

### image not found (Mysql2::Error)错误
>Authentication plugin 'caching_sha2_password' cannot be loaded: dlopen(/usr/local/Cellar/mysql@5.6/5.6.42/lib/plugin/caching_sha2_password.so, 2): image not found (Mysql2::Error)

解决办法：
`'yourusername'@'localhost' IDENTIFIED WITH mysql_native_password BY 'youpassword';`


#### 常用命令
>1. `mysql --version` 版本
>2. `mysql -u root`进默认localhost console
>3. `show databases;`所有databse
>4. `use database_name`使用xx数据库
>5. `show tables;`
>6. `show columns from tabale_name;`一个表有哪些列
>7. `\q`退出

#### 导入数据
> 第一种一步到位（前提：数据库已存在）
> `mysql -h xx_host_name -u user_name -p database_name < sql_path/xx.sql`

> 第二种
>1. 进入console `mysql -h xx_host_name -u user_name -p`
>2. 创建database `create database database_name;`
>3. 使用database `use database_name;`
>4. 导入`source sql_path/xx.sql`



