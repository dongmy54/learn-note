#### ajax

##### 主要有两种方式：
> 1. 返回json数据,然后由ajax success处理数据（适合少量html处理情况）
> 2. 返回js模版（xx.js.erb)，链接（`remote: true`)(适合html标签较多,因为可渲染partial、使用helper方法)

##### 两种方式流程
> 1. json格式：
> - a. 确认需要返回数据内容
> - b. 写好请求路由,请求查看返回格式
> - c. 页面衔接ajax(`click`)进js函数
> - d. 写ajax,确认能发请求
> - e. 对返回json数据做后续处理

> 2. js模版
> - a. 改`remote: true`方式
> - b. 写好 action
> - c. 创建js模版
> - d. 完善js模版处理

##### js中使用ruby变量
> 1. `name = '<%= @product.name %>'`
> ps: 
> a. 如果这个字符串要展示页面，需`html_safe`
> b. 要特别注意返回字符串中（单引号/双引号）是否一致,并与外层包裹引号不同。否则js会报错。

##### xx.js.erb中处理渲染/helper字符串
> 页面展示需要转义,用`j`

```ruby
<% current_page_product_content = render partial: 'selling_product', collection: @selling_products,
                                         locals: {commodity: @commodity} %>

$('.othor_prices').append('<%= j current_page_product_content %>');
```

##### 不要企图在ajax返回中，调用需要实例的helper
> 由于ajax返回json中不可能有实例`product`,所以这里`'<%= xx_helper_method(product) %>'`不能用
```html
$.ajax({
  type: 'POST',
  url: 'xxxx',
  data: {hu: 'sd'},
  success: function(data){
    product_info = '<%= xx_helper_method(product) %>';
    }
  });
```


