##### activerecord_import
> 它是一个批量导入数据的gem
> - 优势：它可以用较少的sql语句插入大量的数据，速度、性能不错
> - 缺点：由于它是直接插入sql,所以不会调用创建/更新/删除相关的回调，默认也不会使用验证（除非显示指定）
>  before_validation 和 after_validation除外

##### model用法(推荐-性能不错)
```ruby
users = []
[
  {name: "张三", phone_num: "18224564576"},
  {name: "李四", phone_num: "27344986754"}
].each do |user_hash|
  users << User.new(user_hash)
end

result = User.import(users) # User.bulk_import 等效
=> #<struct ActiveRecord::Import::Result failed_instances=[], num_inserts=1, ids=[9, 10], results=[]>

result.ids # 返回ids数组
=> [9, 10]
result.num_inserts #返回插入sql条数
```

#### hash用法（性能稍差）
```ruby
user_array = [
  {name: "张三", phone_num: "18224564598"},
  {name: "李四", phone_num: "27344986778"}
]

User.import(user_array) # User.bulk_import
```

#### 选项
- batch_size 每次最多插入多少行数据
- validate 是否开启验证（注意这个开启也会跳过唯一性验证）
- validate_uniqueness 是否添加唯一性验证
- recursive 创建关联关系
- on_duplicate_key_ignore 忽略重复
```ruby
result = User.import(valid_users, batch_size: 100, validate: true)
# 可选参数
# batch_size 每条sql最多插入多少行数据
# recursive: true # 用于创建关联关系
# validate: false # 去掉验证
```

#### 关于回调
回调的部分需要单独处理，在创建好后单独来调用方法


