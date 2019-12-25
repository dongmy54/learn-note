#### 通用
> 1. utf8 每个字符3个字节 utf8mb4 每个字符4个字节（为保证一些特殊符号比如表情能正常存储，使用utf8mb4)

```sql
SET NAMES 'utf8mb4';         -- 设置字符集
SET foreign_key_checks = 0;  -- 禁用外键检查（导数据时非常有用）
```

#### 各种show
```sql
-- 数据库
show databases; 
show databases like '%schema';  -- 带匹配
show create database test1;     -- 创建信息


-- 表
show tables;
show tables like 'user%';                   -- 匹配
show full tables;                           -- 带表类型
show full tables where table_type = 'view'; -- 视图
SHOW CREATE TABLE employees;


-- 列
show columns from users;
show columns from users like 'e%';  -- 匹配
show full columns from users;       -- 详细
desc users;                         -- 等价


-- 处理列表
show processlist;


-- 警告/错误
show warnings;
```
