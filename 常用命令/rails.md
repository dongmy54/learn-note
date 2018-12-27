##### rails 命令汇总
```
reload!        rails c 模式下，重新加载modle改变
RAILS_ENV=staging bundle exec rails c                                    服务器端(staging环境下)进 控制台
rails g controller api::v5::notifications --no-assets --no-view-specs    跳过view 和 assets
rails g helper hu_bar                                                    创建页面helper文件
rails db                                                                 进rails 数据库
rails test                                                               运行rails 测试
rails g channel Room                                                     创建Room通道



rake db:reset    去掉数据库 + 新建数据库 + 执行迁移 + 运行(rake db:seed)
rake db:seed     运行种子数据

bundle exec sidekiq -q default     查看sidekiq中队列的执行

sudo kill -9 $(lsof -i :3000 -t)   关闭rails s 进程
```