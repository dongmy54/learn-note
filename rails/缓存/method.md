#### 缓存数据
>Ps: 在开发模式下，不会缓存哦

```ruby
Rails.cache.fetch("permissions", expires_in: 1.day) do
  Permission.list
end

Rails.cache.fetch("permissions")
# [["ancient/qualification_templates", "index"], ["ancient/qualification_templates", "destroy"], ["ancient/qualification_templates", "edit"], ["ancient/qualification_templates", "show"], ["ancient/qualification_templates", "update"]]
```