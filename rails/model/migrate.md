#### migrate
- 迁移中可编写,修复数据，运行迁移顺带修复了数据
##### 存数组类型
```ruby
add_column :game_sublevels, :bets, :integer, array: true, default: []

# 类型：单个元素类型
# array: true 激活

# 存方式
# GameSublevel.create(bets: [12,34,455])
```

##### 整型 与 大整型
```ruby
add_column :video_records, :bet, :integer, limit: 8, comment: '押注'

# limit 8 biginit
# limit 4 init
```

##### 改变已有数据类型
```ruby
change_column :game_sublevels, :bets, :integer, limit: 8, array: true, comment: '分级赌注列表'
```

##### 删除列
```ruby
remove_column :game_sublevels, :min_bet
```

##### 改表名
```ruby
rename_table :bet_records, :bet_choices   # 旧表名 新表名
# 修改后表中数据,会迁移到新表中
```

##### 改列名
```ruby
rename_column :table, :old_column, :new_column
```

##### 唯一索引
```ruby
add_index :table_name, :column_name, unique: true
add_index :table_name, [:column_name_a, :column_name_b], unique: true  # 多列同时索引
```

##### 改字符集
```ruby
def up
  execute "ALTER TABLE `zcl_bid`.`package_bid_notes` CONVERT TO CHARACTER SET utf8;"
end
```
