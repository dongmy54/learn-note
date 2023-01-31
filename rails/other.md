#### 其它

##### 判断代码运行环境
* `Rails.const_defined? 'Console'` 在console中运行
* `Rails.const_defined? 'Server'`  在服务器上运行

##### 获取controlle名
`controller_name` (来自actionpack)

##### model中用helper
`ActionController::Base.helpers.sanitize content, tags: []`
`ApplicationController.helpers.get_jc_way(xj.cg.try(:bzj_type))`


##### model中用render
`ApplicationController.new.render_to_string(partial: "/shared/template/zzyq_show", locals: {xj: self.xj}, :layout => false)`


##### 构建params参数
```ruby
ActionController::Parameters.new(hash)
```
