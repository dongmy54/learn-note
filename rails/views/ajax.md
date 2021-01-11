##### ajax
> 1. 这里说的ajax是返回js这种
> 2. 这种相对来说最为简单

##### 触发view
> 1. 注意这里一定要写 `format: "js"` 且 `在path参数里面`
> 2. 表单里面 不用写format: js

```html
<%= link_to "采购单位优选供应商", excellent_emall_inquiry_projects_path(big_type: @inquiry_project.big_type, format: "js"),remote: true, class: "btn btn-primary" %><
```

##### controller
```ruby
# 优选供应商
def excellent_emall
  @emalls  = Emall.all
  # 这里不需要显示写明任何render 信息
end
```

##### 响应view (excellent_emall.js.erb )
```html
$(".hubar").hide();
```



