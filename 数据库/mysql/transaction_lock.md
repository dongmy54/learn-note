#### 事务与表锁

##### 事务
> 作用：确保几个操作同时成功，否则会滚
> 为了使用事务,需先关掉自动commit `SET autocommit = 0;`

```sql
-- 关掉事务自动提交
SET autocommit = 0;

-- 开始事务
START TRANSACTION;

-- 一些其它sql操作语句
-- 如中途不想提交可 ROLLBACK;
-- 提交事务
COMMIT;
```


##### 表锁
> 1. 读锁：其它session仅能读，不能写（锁表方也不能写）
> 2. 写锁：其它session既不能读、也不能写（锁方不限）

```sql
-- 读锁
LOCK TABLE messages READ;

-- 写锁
LOCK TABLE messages WRITE;

-- 解锁
UNLOCK TABLES;
```



