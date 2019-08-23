#### 查询某天
```ruby
Department.where(created_at: '2019-8-22'.to_time..'2019-8-22 23:59:59'.to_time)
```

#### 查询今天
```ruby
Department.where(created_at: Time.now.beginning_of_day..Time.now.end_of_day)
```
