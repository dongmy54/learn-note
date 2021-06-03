### pg 相关命令
> `psql --help` 帮助
> * createdb mydb 创建数据库
> * dropdb mydb 删除数据库
> * psql -U dmy mydb 已dmy身份进入数据库
> * psql mydb 进入数据库console(默认方式);这里mydb 是指进入其中的mydb数据库
> * \d 列出表信息
> * \l 列出数据库信息
> * \q 退出

```
# 默认用户登录终端
# psql postgres 

# 创建数据库
create database kuban_development;

# 导入数据 命令
# 导入数据的时候 可以不指定用户名
psql -U username dbname < dbexport.pgsql

# 添加用户和密码 
CREATE USER admin WITH PASSWORD 'dmy067';

# 列出所有数据库
\l 不加冒号

# 列出所有用户
\du

# 进入数据库
\c dmydb;

# 当前数据库所有表名
\dt
```
