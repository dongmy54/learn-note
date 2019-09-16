#### 缓存数据
>Ps: 
> 1. 在开发模式下，不会缓存哦
> 2. 此缓存方式实用于，从数据库中取数据比较费时的情况

```ruby
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