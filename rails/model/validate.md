#### 相关验证
##### uniqueness 同时和 另外一个字段 保持唯一
```ruby
validates :name, uniquness: {scope: :game_type_id} 

# 条件验证
validate :check_time, if: ->{ self.status == 0}

# 邮箱验证
validates :email, allow_blank: true, email: true, on: :create
```
