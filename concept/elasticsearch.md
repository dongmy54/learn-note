### elasticsearch

#### 可以做什么？
>1. 电商网站，只能搜索
>2. 商业数据挖掘、分析
>3. 价格低于某一个值，向客户通知

#### 手动安装
>1. 安装包[下载链接](https://www.elastic.co/downloads/elasticsearch)
>2. 解压安装包后,`bin/elasticsearch` 启动服务（PS：切到安装包目录下）
>3. `curl http://localhost:9200/`测试服务是否成功
>4. 这里安装 5.0.0 是可以的

#### brew 安装
> 1. 地址[链接](https://gist.github.com/evgeniy-trebin/02fafdf03c18df4e03a4eaee1b939f11)
> 2. @5.6是可以的
```
brew tap homebrew/versions
brew cask install java
brew search elasticsearch
brew install elasticsearch@2.3
brew services start elasticsearch@2.3
brew services stop elasticsearch@5.6
brew services restart elasticsearch@5.6

brew uninstall elasticsearch@2.3
```

#### NoMethodError: undefined method get_aliases' for #<Elasticsearch::API::Indices::IndicesClient:0x007ffaf84d7ee8
> 解决办法：`gem 'elasticsearch', '6.2.0'` 高版本会有问题

#### 相关操作
```
curl 'localhost:9200/_cat/indices?v'                    查有哪些索引
curl -XDELETE 'localhost:9200/你的索引名?pretty'          删除某些索引

Good.reindex                       对modle索引
Good.first.reindex                 对单个实例索引
Good.reindex(resume: true)         rails c打断的情况下，重新执行索引
                                   PS: 对relation对象执行索引，会重新建新的索引（需要注意）

rake searchkick:reindex CLASS=Product  rake 更新索引
```

