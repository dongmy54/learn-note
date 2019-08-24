#### 清楚数据库连接
```ruby
# 方式一
Thread.new do
  begin
    User.first
  ensure
    ActiveRecord::Base.clear_active_connections!
  end
end

# 方式二
Thread.new do 
  ActiveRecord::Base.connection_pool.with_connection do
    User.first
  end
end
```
