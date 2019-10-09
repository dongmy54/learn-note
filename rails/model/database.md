#### 清楚数据库连接
```ruby
Thread.new do
  begin
    User.first
  ensure
    ActiveRecord::Base.clear_active_connections!
  end
end
```