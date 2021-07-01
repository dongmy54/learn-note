##### jbuilder
> 一种方便写json返回的专属语言

用法示例
```ruby
# 直接取值放入hash
json.extract! @user, :id, :name, :phone_num


if @locations.present?
  # 一对多 数组-直接取值
  json.locations @locations, :id, :name
end

if @organizations.present?
  # 一对多 数组-循环定制取值
  json.organizations @organizations do |organization|
    json.speical_id (organization.id / 2) == 0 ? '是' : "否"
    json.name organization.name
  end
end

# {
#   "id": 1,
#   "name": "马文昊",
#   "phone_num": "15671280741",
#   "locations": [
#     {
#       "id": 1,
#       "name": "Location85"
#     }
#   ],
#   "organizations": [
#     {
#       "speical_id": "是",
#       "name": "Space-1-Location85"
#     }
#   ]
# }



# 数组 
# 用法一：和上等价（不建议使用 比较麻烦)
json.locations do
  json.array! @locations, :id, :name
end

# 用法二：和partial使用 - 推荐
json.array! @posts, partial: 'posts/post', as: :post
```