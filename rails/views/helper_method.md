#### 解析url为controller和action
```ruby
Rails.application.routes.recognize_path '/'
# => {:controller=>"ancient/fountain", :action=>"index"}
```