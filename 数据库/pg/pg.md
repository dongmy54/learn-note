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

# 列出当前数据 以lock_events开头的表名
\dt lock_events*;

# 以dongmingyan身份 查看kuban_dev 库 users表信息
pg_dump kuban_dev -t users -U dongmingyan --schema-only
```

##### 常用
```sql
-- 添加索引
CREATE INDEX lock_events_2022_space_id_location_id_action_user_id ON public.lock_events_2022 USING btree (space_id, location_id, action, user_id);
CREATE INDEX lock_events_2022_created_at ON public.lock_events_2022 USING btree (created_at);

-- 查看表中索引
select * from pg_indexes where tablename = 'lock_events';

--- 性能分析
explain SELECT  "lock_events".* FROM "lock_events" WHERE (lock_events.created_at >= '2022-01-01') AND "lock_events"."space_id" = 50495 AND "lock_events"."action" IN (0, 1) AND "lock_events"."location_id" = 72712 AND "lock_events"."user_id" = 2759906 AND (lock_events.created_at >= '2022-01-01 00:00:00') ORDER BY space_id,location_id,action,lock_events.created_at desc LIMIT 10 OFFSET 0;
```


