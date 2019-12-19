#### 导入与导出

##### 导入csv
```csv
Id, title, expired date, amount
1, "第一个", 20140502,20
2, "第二个",20160812,45
3, "第三个",20190824,230
```
```sql
-- LOCAL 把本地文件导到远程数据库(PS:导本地去掉LOCAL)
LOAD DATA LOCAL INFILE '/Users/dongmingyan/Desktop/粤商通.csv'
INTO TABLE discounts
FIELDS TERMINATED BY ','     -- 字段分割
ENCLOSED BY '"'              -- 字段结束标记
LINES TERMINATED BY '\n'     -- 行结束
IGNORE 1 ROWS;               -- 忽略第一行
```


