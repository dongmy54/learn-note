#### 其它

##### 判断代码运行环境
* `Rails.const_defined? 'Console'` 在console中运行
* `Rails.const_defined? 'Server'`  在服务器上运行

##### 获取controlle名
`controller_name` (来自actionpack)