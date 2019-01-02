#### delayed_job
>1. 服务启动 `rails jobs:work`;`rails jobs:workoff`(执行完就退出); `rails jobs:clear`
>2. 后台管理 `bin/delayed_job start`;`bin/delayed_job -h`
>3. 它会创建一个 delayed_jobs表用于记录，队列运行状态
> PS: 默认没有指定队列名的情况下,就没有队列名

##### 配置
> 安装 gem
```ruby
gem 'delayed_job_active_record'   
gem "daemons"                      # 用于管理后台的启动、重启等

# bundle
# rails g delayed_job:active_record
# rake db:migrate
```

> config 配置
```ruby
# config/application.rb
config.active_job.queue_adapter = :delayed_job
```

> 默认设置(可省)
```ruby
# config/initializers/delayed_job_config.rb
Delayed::Worker.destroy_failed_jobs = false
Delayed::Worker.sleep_delay = 60
Delayed::Worker.max_attempts = 3
Delayed::Worker.max_run_time = 5.minutes
Delayed::Worker.read_ahead = 10
Delayed::Worker.default_queue_name = 'default'
Delayed::Worker.delay_jobs = !Rails.env.test?
Delayed::Worker.raise_signal_exceptions = :term
Delayed::Worker.logger = Logger.new(File.join(Rails.root, 'log', 'delayed_job.log'))
```

##### 使用
>配置好后，可直接按active_job方式使用

##### 特点
> 可对model中具体方法使用delayed_job
```ruby
class Article < ApplicationRecord

  def hu
    puts 'hu'
  end

  # 这句代表，对hu方法默认使用delay_job
  handle_asynchronously :hu, priority: 10, run_at: Time.now + 30.seconds, queue: 'xx_queue'

  # 没有 handle_asynchronously 时
  # Article.first.delay.hu
  # Article.first.delay(queue: 'hh', priority: 0).hu
end
```

> 用于任何一个包含 perform方法的类
```ruby
class NewsletterJob
  attr_accessor :text

  def initialize(text)
    @text = text
  end

  def perform
    puts text
  end
end

# 使用
# Delayed::Job.enqueue NewsletterJob.new('hello')
```

