#### 底层缓存
> 实用于查询比较耗时的情况

##### 自定义键名
```ruby
# 指定键名
Rails.cache.fetch("permissions", expires_in: 1.day) do
  Permission.list
end

Rails.cache.fetch("permissions")
# [["ancient/qualification_templates", "index"], ["ancient/qualification_templates", "destroy"], ["ancient/qualification_templates", "edit"], ["ancient/qualification_templates", "show"], ["ancient/qualification_templates", "update"]]

# id + updated_at 可以及时获取到最新数据
Rails.cache.fetch("/product/#{id}-#{updated_at}/comp_price", :expires_in => 12.hours) do
  # do some thing
end
```

##### 利用cache_key自动键
```ruby
def level_cache_example
  Rails.cache.fetch self do
    # do some thing
  end
end
```
