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


##### 重命名
> 对于生产过程需要重新指定定义人
```sql
rename user dmy@'%' to dmy_new@'localhost'; -- 注意这里可以连同host一起修改
```

##### 修改用户密码
```sql
set password for dmy@'%' = '123456';
```

##### 锁定
```sql
alter user dmy@'%' account lock;
```

##### 解锁
```sql
alter user dmy@'%' account unlock;
```

