#### 查询某天
```ruby
Department.where(created_at: '2019-8-22'.to_time..'2019-8-22 23:59:59'.to_time)
```

#### 查询今天
```ruby
Department.where(created_at: Time.now.beginning_of_day..Time.now.end_of_day)
```

##### 关联表查询
```ruby
# 建议采用hash写法；好处1. 支持枚举值； 2: 不用显示写明表名
User.includes(:roles).where(roles: {role: :reservation})

# 这个会报错 缺少表 roles
User.includes(:roles).where("roles.role = ?", 2).first
```

