##### ransack
>原理： 利用传入参数名的不同，实现动态sql查询

##### 用法
```ruby
# model
class User
  has_many :ransack
end

class LoginLog
  belongs_to :user
end
```
```ruby
# controller
class LoginLogsController
  def index
    # 传入参数 放入q中 比如：
    # {"utf8"=>"✓", "q"=>{"user_loginname_cont"=>"yx_admin", "operate_eq"=>"0", "created_at_gteq"=>"2019-04-11", "created_at_lteq"=>"2019-04-12"}}
    @query      = LoginLog.ransck(params[:q])
    @login_logs = @query.result.incldues(:user) # result后才会执行sql
  end
end
```
```html
<%= from_for @query, url: login_logs_path do |f| %>
  <span>
    用户名：<%= f.text_field :user_loginname_cont %> <!-- 关联前为关联名 -->
  </span>

  <span>
    开始时间：<%= f.text_field :created_at_gteq, class: 'Wdate my97_date', placeholder: '开始时间', readOnly: true %> <!-- _gteq 大于等于 -->
  </span>
  
  <span>
    开始时间：<%= f.text_field :created_at_lteq, class: 'Wdate my97_date', placeholder: '开始时间', readOnly: true %> <!-- _gteq 小于等于 -->
  </span>

  <span>
    操作：<%= f.select :operate_eq, LoginLog.operates, {include_blank: '不限'} %>
  </span>
<% end %>
```
