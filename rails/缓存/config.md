#### cache 配置
> 1. 配置文件 `config/environments/xx.rb`中
> 2. rails 4 默认缓存方式是文件存储
> 3. 生成环境默认未开启缓存模式


##### file
```ruby
# 指明文件存储时 需指定存储路径
config.cache_store = :file_store, "/Users/dongmingyan/yg/sztu/tmp/rails_temp"
```

##### memory
```ruby
config.cache_store = :memory_store
```

##### memcached
> 1. 需要 `gem dalli` 搭配使用
> 2. 本地需启动服务 `memcached -d`
```ruby
config.cache_store = :mem_cache_store
```

##### redis
> 1. 需要搭配 `gem redis` `gem hiredis`使用
> 2. 本地需启动服务 `redis-server`
```ruby
config.cache_store = :redis_store, {url: "redis://localhost:6379"}
```