### mysql 相关
>1. `brew install mysql` 安装mysql
>2. `mysql.server start` 启动mysql
>3. `brew services start mysql` 启动mysql
>4. `mysql -uroot` 用户名进控制台
>5. `mysql -uroot -p1234` 用户名 密码进入控制台
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
