##### sidekiq
> 用途： 主要用于处理异步任务，把一些比较慢的任务放到任务异步中
> PS: 需要搭配redis一起使用，用于数据存储
> 文档： https://github.com/mperham/sidekiq/wiki


##### 如何与rails集成
1. 添加gem，此处省略

2. 添加适配器
```ruby
# config/application.rb
module Blog
  class Application < Rails::Application
    # 放在初始化文件中也可以
    config.active_job.queue_adapter = :sidekiq
    # ...
  end
end
```

3. 配置文件
队列线程相关配置
```ruby
# config/sidkieq.yml
---
:pidfile: tmp/pids/sidekiq.pid
:logfile: log/sidekiq.log # 可以不设置默认在log下

development:
  :concurrency: 4 # 开启的任务线程数量（一般不要超过数据库连接池连接数量 database.yml pool值）
  :queues:        # 默认当上面队列任务空了才执行下面，也可设置优先级
    - high
    - default     # 在local需要注意需要设置一个default 不然default不会执行
    - low
    # - ["tasks", 100] 优先级写法 数值大-优先级高
test:
  # ...
production:
  # ...
```

连接相关配置
```ruby
# config/initializers/sidekiq.rb
Sidekiq.configure_server do |config|
  config.redis = { url: 'redis://redis.example.com:7372/0' }
end

Sidekiq.configure_client do |config|
  config.redis = { url: 'redis://redis.example.com:7372/0' }
end
```

4. 添加worker并使用
PS： 当前按照sidekiq 5.2.9测试，最新用法有改动
`rails g job myworker`
```ruby
# app/jobs/myworker_job.rb
class MyworkerJob < ApplicationJob
  queue_as :default # 队列名

  def perform(*args)
    # Do something later
  end
end
```
使用worker
```ruby
MyworkerJob.perform_now 
MyworkerJob.perform_later
MyworkerJob.set(wait: 1.minute).perform_later
```

5. 启动sidekiq
- 1. rails 项目路径下直接：sidekiq就可以启动
- 2. 也可以用命令启动 sidekiq -C config/sidekiq.yml 等等

##### 管理后台查看
```ruby
Rails.application.routes.draw do
  require 'sidekiq/web'
  mount Sidekiq::Web => '/sidekiq'
end
```
打开 domain/sidekiq 可以进入后台

##### 异步扩展
> - 在初始化文件中配置添加 `Sidekiq::Extensions.enable_delay! `
> - 可以把类方法变成异步的
```ruby
User.delay.delete_old_users('some', 'params')
User.delay_for(2.weeks).whatever
User.delay_until(2.weeks.from_now).whatever
```

##### 批处理
> 我们可以将多个异步任务当作一个批次进行处理，对批次处理状态进行追踪回调等
回调类
```ruby
# 这个方法必须要加载到sidekiq中也就是和rails绑定加入后要重启sidekiq
class TestSidekiqCallback
  # 这里的status是sidekiq的一个固有参数
  # opts 回调时候的选项
  def on_success(status, opts={})
    Rails.logger.info "Now, success opts: #{opts}"
  end

  def on_complete(status, opts={})
    Rails.logger.info "Now, complete opts: #{opts}"
  end
end
```
创建批
```ruby
batch = Sidekiq::Batch.new
batch.description = "这是一个批处理哦"
batch.on(:success, TestSidekiqCallback, :to => "hello success")
batch.on(:complete, TestSidekiqCallback, to: "now complete")
batch.jobs do
  # 这里放多个异步
  1.times do |i|
    MyWorker.perform_async(i)
  end
end

# 批状态查询
bid = batch.bid
status = Sidekiq::Batch::Status.new(bid)
status.complete?
```


##### 消息积压如何处理
> 1. 增加并发线程数里（调整concurrency-重新启动sidekiq）
> 2. 排查消息队列是哪些消息较多，然后反向推断，是什么问题导致消息数量暴增切断不合理消息源头
> 3. 清空部分队列消息

消息队列清空
```ruby
queue = Sidekiq::Queue.new("high")
queue.each do |job|
  job.klass # => 'MyWorker'
  job.args # => [1, 2, 3]
  # 通过这里的删除job 用某些条件判断
  job.delete if job.jid == 'abcdef1234567890'
end
```

###### 一些公开api
> `https://github.com/mperham/sidekiq/wiki/API`