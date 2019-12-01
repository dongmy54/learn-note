#### 缓存

##### 注意
> 1. 本地测试缓存需 开启 `config.action_controller.perform_caching = true`
> 2. rails 4默认使用 file_store

##### 清理缓存
> `Rails.cache.clean` 只对某些缓存起作用


##### cache_key
```ruby
Author.first.cache_key
# => "authors/303-20191201030025389597000"
```

