##### activerecord_import
> 它是一个批量导入数据的gem
> - 优势：它可以用较少的sql语句插入大量的数据，速度、性能不错
> - 缺点：由于它是直接插入sql,所以对callback的支持相当差

##### 用法
```ruby
users = []
[
  {name: "张三", phone_num: "18224564576"},
  {name: "李四", phone_num: "27344986754"}
].each do |user_hash|
  users << User.new(user_hash)
end

# 做验证
# PS: 如果不做手动验证，只有before/after_validation会触发【普通验证如（validates都是不会触发）】、
valid_users   = []
invalid_users = []
users.each do |user|
  if user.valid?
    valid_users << user
  else
    invalid_users << user
  end
end

result = User.import(valid_users, batch_size: 100)
# 可选参数
# batch_size 每条sql最多插入多少行数据
# recursive: true # 用于创建关联关系
# validate: false # 去掉验证


# 由于回调没有触发，可以根据这里的返回值做些处理
result.ids 
# => [38, 39]
result.num_inserts
# => 1 sql条数
```

