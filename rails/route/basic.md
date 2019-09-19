#### 查看路由
```ruby
# 字符串路由
app.gys_jj_bids_path
# => "/gys/jj_bids"

# 得到controller 和 action
Rails.application.routes.recognize_path app.gys_jj_bids_path
# => {:controller=>"gys/jj_bids", :action=>"index"}

# post方式
Rails.application.routes.recognize_path app.ancient_audit_path, method: :post
# => {:action=>"audit", :controller=>"ancient/fountain"}
```