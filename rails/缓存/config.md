#### cache 配置
> 1. 配置文件 `config/environments/xx.rb`中
> 2. rails 4 默认缓存方式是文件存储
> 3. 生成环境默认未开启缓存模式


##### file
> 特点：不能跨机器、需要手动清除缓存
```ruby
# 指明文件存储时 需指定存储路径
config.cache_store = :file_store, "/Users/dongmingyan/yg/sztu/tmp/rails_temp"
```

##### memory
> 特点：不能跨机器，由于存在内存中，数据不能太大
```ruby
config.cache_store = :memory_store
```

##### memcached
> 特点：可以共享,不能持久存储
> 1. 需要 `gem dalli` 搭配使用
> 2. 本地需启动服务 `memcached -d`
```ruby
config.cache_store = :mem_cache_store
```

##### redis
> 特点：可以共享,能持久存储
> 1. 需要搭配 `redis` `redis-rails`使用
> 2. 本地需启动服务 `redis-server`
```ruby
config.cache_store = :redis_store, {url: "redis://localhost:6379"}
```
