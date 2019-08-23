#### 相关method

##### assign_attributes
> 赋值属性
`self.assign_attributes(from_type: 1, status: 1, check_status: 1, change_to_status: 2)`

##### 全部更新
```ruby
# Modle.updata_all
JavaBaseSupplier.update_all(status: 3)
```

##### where
- 可接数组
```ruby
condition = "name = ? and scene = ?", 'classic', 'ClassicMachine'
GameType.where(condition)
```
##### decrement VS decrement!
1. decrement 不会将数据立马更新到数据库, decrement! 会将数据立马更新到数据库
2. decrement!默认情况下，不会更新updated_at; 更新写法为 `user.decrement!(post_count, 5, touch: true)`

- 'Model.column_names'  等价于  `Model.attribute_names` 展示model字段列表
- 'object.as_json' 等价于 'object.serializeble_hash' 对象转json格式序列
- 'Model.pluck(:attribute)' 只能用于Modle 或 where 关系

##### update VS update_all
1. user.update(yy) 单个 返回 true/false
2. User.where(name: 'xx').update(yy) 关系 返回对象数组，不管成功与否
3. update 验证 回调都会触发
4. update_all 验证回调都不会触发

##### order 
对具体某表排序
- usage: `GameType.includes(:game_sublevels).order('game_sublevels.name')`
按优先级别对多个字段排序
- `GameType.all.order(:name).order(:id)` 名字优先,然后id

##### group vs group_by
- group_by是ruby方法
- group 和 group_by得出都是hash
- group_by接块

```ruby
# group 搭配 聚合方法
TaskList.group(:task_type).count  # => {1=>11, 2=>13, 3=>53}

# group_by 按什么分组（接块）,注意不能直接接model后（需先all)
TaskList.all.group_by(&:task_type)
# => {1=> [tasklist 实例数组],
#     2=> [tasklist 实例数组],
#     3=> [tasklist 实例数组]} 
```

##### deletate
```ruby
class User < ActiveRecord::Base
  has_many :posts

  def title
    "bud-#{title}"
  end
end

class Post < ActiveRecord::Base
  belongs_to :user

  delegate :title, to: :user # to 委托于另外关联对象
                             # 直接将 user 中方法引入到 post 中
end

Post.first.title             # 可这样用
```

##### find_by_sql 方法
- 1. 数据会被实例化
- 2. 可用占位符（用数组写法）

```ruby
sql =<<-SQL
  select * from game_types where name = ?
SQL

GameType.find_by_sql([sql, "classic"])
```

##### exists? 可与 where搭配使用
> PS: exists?为复数

```ruby
User.first.used_codes.where(tag: 'fb').exists?
```

##### first_or_create
> 1、没有记录则，创建一条
> 2、拥有 `first_or_create!` 方法

```ruby
User.where(nickname: 'zhangsan').first_or_create                   # 与where搭配
PromotionItem.bronze.where(user_id: 1).first_or_create             # 与 enum（bronze为促销条目状态）搭配
PromotionItem.bronze.where(user_id: 2).first_or_create(times: 2)   # 外部还可接参数
```

##### xxfield_changed?
> 某某字段改变了？

```ruby
u = User.first
u.age_changed?
# => false
u.age = 12
u.age_changed?
# => true
```

##### attributes 
> 1. 查看对象所有字段值
> 2. 相比于 `as_json`更完整

```ruby
a = Article.first

a.attributes

# => {"id"=>1,
#  "title"=>"测试800",
#  "quote"=>"9999",
#  "content"=>"<p>99999</p>",
#  "published"=>true,
#  "position"=>0.0,
#  "cover"=>nil,
#  "user_id"=>1,
#  "created_at"=>Mon, 20 Feb 2017 13:06:05 CST +08:00,
#  "updated_at"=>Mon, 20 Feb 2017 13:06:05 CST +08:00,
#  "ptype"=>0,
#  "plan_project_id"=>nil,
#  "status"=>nil,
#  "nopass_reason"=>nil,
#  "land_haus_code"=>nil,
#  "file_names"=>nil,
#  "cgxs"=>nil,
#  "yx_article_remake"=>nil}
```

##### unscoped
> 移除此前所有,查询条件

```ruby
Project.where(name: 'hu').order(:created_at).select(:id).unscoped
# sql
# Project Load (31ms)  SELECT `zcl_bid`.`projects`.* FROM `zcl_bid`.`projects`
```

##### unscope
> 比unscoped力度稍弱,只移除指定的

```ruby
Project.where(name: 'hu').order(:created_at).select(:id).unscope(:order, where: :name)
# sql
# Project Load (10.6ms)  SELECT `zcl_bid`.`projects`.`id` FROM `zcl_bid`.`projects` WHERE `zcl_bid`.`projects`.`is_deleted` = FALSE
```

