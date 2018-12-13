##### rails 命令汇总
```
RAILS_ENV=staging bundle exec rails c                                    服务器端(staging环境下)进 控制台
rails g controller api::v5::notifications --no-assets --no-view-specs    跳过view 和 assets
rails db                                                                 进rails 数据库

rake db:reset    去掉数据库 + 新建数据库 + 执行迁移 + 运行(rake db:seed)
rake db:seed     运行种子数据
```