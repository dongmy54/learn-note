#### mechanize
> 1. 可以请求页面，填入表单、提交表单
> 2. 参考地址： http://docs.seattlerb.org/mechanize/GUIDE_rdoc.html

##### 用法
```ruby
require 'mechanize'

agent = Mechanize.new
page  = agent.get('http://www.baidu.com')
form  = page.form('f')
# pp form
form.wd = "将要去何方"   # 填入输入框 此wd为input name
page = agent.submit(form, form.buttons.first)
pp page
```
