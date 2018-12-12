#### db
##### 存数组类型
```ruby
add_column :game_sublevels, :bets, :integer, array: true, default: []

# 类型：单个元素类型
# array: true 激活

# 存方式
# GameSublevel.create(bets: [12,34,455])
```