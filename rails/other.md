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


# 默认情况下 params是不能直接转换成hash的
params.to_unsafe_h # 允许任意参数 不经过permit
```

#### 启动服务
指定到0.0.0.0 方便本地局域网请求到 默认rails s 不行
`rails s -b 0.0.0.0` 


