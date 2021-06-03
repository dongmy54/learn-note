##### 重置表id下一个id值
```
-- 这里的table替换成自己的表名
-- Get Max ID from table
SELECT MAX(id) FROM table;

-- Get Next ID from table
SELECT nextval('table_id_seq');

-- Set Next ID Value to MAX ID
SELECT setval('table_id_seq', (SELECT MAX(id) FROM table));
```