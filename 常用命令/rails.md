##### rails 命令汇总
```
rails new test                                                           创建rails test项目
rails g scaffold article title:string content:string                     脚手架（测试新功能不错）

rails c                                                                  进入控制台
rails c -sb                                                              沙盒模式
rails c -e test                                                          测试环境控制台
RAILS_ENV=staging bundle exec rails c                                    进控制台（带环境）
reload!                                                                  控制台重新加载
rails g controller api::v5::notifications --no-assets --no-view-specs    跳过view 和 assets
rails g job test                                                         新增test job
rails g channel Room                                                     创建Room通道
rails g helper hu_bar                                                    创建页面helper文件
rails db                                                                 进rails 数据库
rails test                                                               运行rails 测试


rake db:reset               去掉数据库 + 新建数据库 + 执行迁移 + 运行(rake db:seed)
rake db:seed                运行种子数据
rake db:rollback            迁移回退一步          


bundle exec sidekiq                                   启动sidekiq服务 (根据 config/sidekiq.yml)
bundle exec sidekiq -q default -q other_queue_name    启动sidekiq服务（队列：default 和 other_queue_name)


sudo kill -9 $(lsof -i :3000 -t)   关闭rails s 进程



#======================================= 控制台下 =================================#
ctrl + a rails c模式回行首
ctrl + e rails c模式回行尾

User.first
user = _          把上一个输出赋值给当前user

app.get '/redeem_code'                                                                  get  请求
app.post '/api/v5/bonus_machine/enter', params: {device_id: 'device_dd'}                post 请求
app.put '/api/v5/bonus_machine/spin', params: {name: 'bronze', device_id: 'device_dd'}  put  请求 

app.session[:user_id]         查看session id
```








