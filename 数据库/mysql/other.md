#### 其它

##### 字符集
> 1. utf8 每个字符3个字节 utf8mb4 每个字符4个字节（为保证一些特殊符号比如表情能正常存储，使用utf8mb4)

```sql
SET NAMES 'utf8mb4';         -- 设置字符集
SET foreign_key_checks = 0;  -- 禁用外键检查（导数据时非常有用）

-- 批量更新字符集
ALTER DATABASE databasename CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
ALTER TABLE tablename CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
```

##### 准备语句（PREPARED)
> 1. 将查询语句内置在服务器中
> 2. 从而减少多次查询发送过程中服务器解析字符所花费的时间
> 3. 由于采用占位符，还提高了安全性

```sql
-- 用法
--step1 准备语句
PREPARE stmt1 FROM
    'SELECT
           productCode,
            productName
    FROM products
        WHERE productCode = ?';

--step2 设置变量，执行语句
SET @pc = 'S10_1678';
EXECUTE stmt1 USING @pc;

-- 多次使用结束后 释放
DEALLOCATE PREPARE stmt1;
```


