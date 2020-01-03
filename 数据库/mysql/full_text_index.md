#### 全文索引
> 1. 用于文章等大量数据的搜索
> 2. 一定程度上可替换`like`匹配,性能高许多倍

##### 创建全文索引
```sql
CREATE TABLE articles(
  id INT AUTO_INCREMENT PRIMARY KEY,
  title VARCHAR(255) NOT NULL,
  content TEXT,
  FULLTEXT KEY title_index(content)
)ENGINE=InnoDB DEFAULT CHARSET=utf8;
```

##### 使用
```sql
select * from articles where match(title) against('中国');
select * from articles where match(title) against('中国*' in boolean mode);
```

##### 删除全文索引
```sql
drop index content_index on articles;
```

##### 添加全文索引
```sql
ALTER TABLE articles ADD fulltext index title_index(title);
```

##### 其它
> 1. 默认情况下全文索引有最短长短要求（4个）,可配置my.cnf
```
innodb_ft_min_token_size = 1
ft_min_word_len = 1
```
> 重启mysql服务，然后console中修复`repair table table_name quick;`

