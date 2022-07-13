#### mysql

```ruby
# linux上命令如下（mac上用brew)
service mysql start         # 启动
service mysql stop          # 停止
service mysql restart       # 重启


mysql_secure_installation   # 对已安装mysql安全性进行配置

mysql -u root -p                      # 进入命令行
mysql -h host_name -u root -p         # 连远程数据库
mysql -u root -D classicmodels -p     # 连接数据库 并使用classicmodels

quit                   # 退出

mysql --version        # 查看mysql版本

# 备份指定数据库
mysqldump --user=root --password=12345678 --result-file='/Users/dongmingyan/test.sql' --databases classicmodels
# 备份所有数据库
mysqldump --user=root --password=12345678 --result-file='/Users/dongmingyan/all_test.sql' --all-databases
# 备份指定表
mysqldump --user=root --password=12345678 --result-file='/Users/dongmingyan/table_test.sql' classicmodels employees
# 备份结构（无数据）
mysqldump --user=root --password=12345678 --result-file='/Users/dongmingyan/only_structure_test.sql' --no-data --databases classicmodels

# 导出数据
mysql -uroot -h111.231.22x.13y -pxxx@yyy -e "select * from products limit 4;" zhonghang > products.xls

# 重建
source /Users/dongmingyan/test.sql
```

##### 重置mysql root密码
```shell
# 关掉当前启动的mysql
brew services stop mysql@5.7

# 以非权限校验模式启动
mysqld_safe --skip-grant-tables

# 进入控制台
mysql

# 执行如下语句
FLUSH PRIVILEGES;
SET PASSWORD FOR root@'localhost' = PASSWORD('123456');

# 退出
quite

# 关掉安全模式，以正常模式启动
killall mysql
brew services start mysql@5.7
```


