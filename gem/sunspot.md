#### sunspot
> 1. 全文检索
> 2. 也依赖于java

##### 用法
```ruby
# Gemfile
gem 'sunspot_rails'
gem 'sunspot_solr' # 本地开发使用，是一个solr的分发包，因此装了后，无需单独去拉solr的包
```

##### 常用命令及说明
```
# 项目下 执行 会创建 config/sunspot.yml文件
# 跑起来后 可在 http://localhost:8982/solr/ 看到管理页面
rails generate sunspot_rails:install

# 项目下 执行 开启solr服务 首次会创建一个 /solr文件夹及其信息
rake sunspot:solr:start

# rake 重建索引
rake sunspot:reindex
```

##### model操作
> 我们在删除、保存的时候都会触发索引的更新

```ruby
# 批量更新索引
Product.reindex

# 单个索引
product.index!
```

##### 参阅文档
> 1. sunspot 搜索相关写发 `https://github.com/sunspot/sunspot#readme`
> 2. solr本身 `https://lucene.apache.org/solr/guide/8_5/installing-solr.html#solr-examples`


