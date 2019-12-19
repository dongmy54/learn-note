#### 通用
> 1. utf8 每个字符3个字节 utf8mb4 每个字符4个字节（为保证一些特殊符号比如表情能正常存储，使用utf8mb4)

```sql
SET NAMES 'utf8mb4';         -- 设置字符集
SET foreign_key_checks = 0;  -- 禁用外键检查（导数据时非常有用）
show warnings;               -- 再次展示警告/错误信息
```

