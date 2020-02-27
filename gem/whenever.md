#### whenever
> 用途：主要用作定时任务
> 原理：先用ruby写法配置好后，翻译成crontab 写法，再写入crontab

##### schedule.rb 写法
```ruby
# config/schedule.rb
RAILS_ROOT = File.dirname(__FILE__) + '/..'
set :output, "#{RAILS_ROOT}/log/whenever.log"       # 执行的输出查看

# 每隔多久
every 3.hours do # 1.minute 1.day 1.week 1.month 1.year
  runner "Model.some_process"            # ruby 代码
  rake "my:rake:task"                    # rake 任务
  command "/usr/bin/my_great_command"    # 命令
end

# 每天 具体时间点
every 1.day, at: '00:01 am' do
  rake "emall_interface:officemate"
end

# 每天 多个时间点
every 1.day, at: ['08:00 am', '18:00 am'] do
  rake "emall_interface:qixin"
end
```

##### 主要步骤
项目路径下
> 1. `wheneverize`  初始化配置文件 `config/schedule.rb`(没有会创建)
> 2. `whenever`     翻译 `config/schedule.rb`成crontab写法
> 3. `whenever --update-crontab`  更新定时任务

