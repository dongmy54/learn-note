#### 常用范例

```ruby
# 路径 controller action映射
post 'api/areas' => "api#areas" 

resource :site_settings do
  collection do
    post :update_config, action: :update # 集合内部定义 action
  end
end
```