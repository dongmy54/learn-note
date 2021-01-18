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

##### ajax
> 这里 void中值不可或缺
`<%= link_to "获取编号", "javascript:void(0)", class: "btn btn-primary btn-small ml10", id: "fetch_platform_code" %>`

```javascript
// 获取主平台供应商编号
$("#fetch_platform_code").click(function(){
  // 集团码
  var group_code = $("#emall_code").val();
  // 供应商名称
  var name = $("#emall_name").val();

  $.ajax({
    url: '/ancient/emalls/fetch_emall_platform_code',
    type: 'get',
    data: {group_code: group_code, name: name},
    dataType: 'json',
    // 发送前
    beforeSend: function(xhr){
      $("#fetch_platform_code").text('获取中...');
    },
    // 发送成功
    success: function(data){
      // 获取到的data 是 请求传回的json数据，其中数据用字符串的方式取出
      console.log(data);
      console.log(data['name']);
    },
    //发送失败
    error: function(xhr){
      alert('服务器错误，请联系技术人员'); // 这里alert 比较好直观 text太快根本看不到
    },
    // 发送完成
    complete: function(xhr){
      $("#fetch_platform_code").text('获取编号');
    }
  })
})
```