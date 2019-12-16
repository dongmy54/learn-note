#### mysql

```ruby
mysql_secure_installation   # 对已安装mysql安全性进行配置

mysql -u root -p                      # 进入命令行
mysql -h host_name -u root -p         # 连远程数据库
mysql -u root -D classicmodels -p     # 连接数据库 并使用classicmodels

source xxdatabase.sql  # 导入数据
show databases;        # 展示当前数据库
show tables;           # 展示表列表
use xxdatabase;        # 使用xx数据库

quit                   # 退出


mysql --version        # 查看mysql版本
```
