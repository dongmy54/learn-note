#### 用户与权限

##### 创建用户
```sql
create user dmy@'%' identified by '12345678';
```

##### 查看用户
```sql
select user,host from mysql.user; -- 这里host代表可访问ip/域名 %代表任意
```


##### 删除用户
```sql
drop user to dmy@'%';
```


##### 授权
```sql
grant all on *.* for dmy@'%';               -- 授予任意数据库任意表权限
grant all on classicmodels.* to dmy@'%';    -- 授予数据库classicmodels的所有权限

FLUSH PRIVILEGES; -- 刷新权限
```


##### 查看权限
```sql
show grants for dmy@'%';
```


##### 撤销权限
```sql
revoke all on *.* from dmy@'%'; -- 撤销所有权限
```


##### 修改用户密码
```sql
set password for dmy@'%' = '123456';
```

