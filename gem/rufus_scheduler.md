#### rufus_scheduler
> 可用作定时任务或异步任务

#### 特点
> 1. 多线程

##### rails 示例
```ruby
# xxx_controller.rb中

def xx_action
  # 延时任务: 让高耗时过程,后面慢慢处理,缩短请求响应时间
  # in 代表 5s后处理
  Rufus::Scheduler.new.in '5s' do
    # 使用多线程 必须防止连接泄漏
    ActiveRecord::Base.connection_pool.with_connection do
      # some active record operation
    end
  end
end
```



