#### sqlite
一个小巧、轻量的数据库，通常用于单机，数据量较小的情况

#### 命令
```
# 命令行
sqlite3 # 会创建一个临时的数据库 再退出时删除
sqlite3 xx.sqlite_file # 打卡xx数据库的文件

# 进入后
.help 帮助
.tables 表信息
.schema schema信息
PRAGMA table_info(permissions); # 查看表permissions字段
.exit 退出
```

```sql
ALTER TABLE permissions
ADD COLUMN user_floors VARCHAR(255);


ALTER TABLE permissions
ADD COLUMN user_name VARCHAR(255);


ALTER TABLE patients
ADD COLUMN id VARCHAR(50);
```

备份
```
-- 设置输出文件
.output patients_backup.sql
-- 指定导出表
.dump patients
-- 关闭输出文件
.output stdout
-- 退出后查看 备份sql
.quit
```
