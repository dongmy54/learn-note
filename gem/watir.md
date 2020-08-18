#### watir
> 1. 一个web自动化测试的gem,还可以做许多其它有意义的事
> 2. 参考： http://watir.com/guides/elements/
> 3. PS: 使用需要下载浏览器的可执行文件到系统环境变量可搜目录中

##### 示例
```ruby
require 'watir'

url = 'https://passport.jd.com/new/login.aspx?ReturnUrl=https%3A%2F%2Fwww.jd.com%2F%3Fcu%3Dtrue%26utm_source%3Dbaidu-pinzhuan%26utm_medium%3Dcpc%26utm_campaign%3Dt_288551095_baidupinzhuan%26utm_term%3D0f3d30c8dba7459bb52f2eb5eba8ac7d_0_7e3ae7eb1b2242d6b90fcab13930f2bc'


browser = Watir::Browser.new(:chrome)

######## 登录开始 #########
browser.goto url
sleep 1
browser.link(text: '账户登录').click
form = browser.form(id: 'formlogin')

puts browser.title
form.text_field(name: 'loginname').set('xxxxyyy')
form.text_field(name: 'nloginpwd').set('zzzhhhh')
sleep 1
browser.link(id: 'loginsubmit').click

# 多留点时间
# 如果遇到验证 手动操作下 通过验证
sleep 5  
# browser.screenshot.save("/Users/dongmingyan/test.jpg") # 存储页面快照
######## 登录结束 #########


######## 搜索开始 #########
b = browser.text_field id: 'key' # 返回的是输入框
puts "搜索输入框是否存在: #{b.exists?}"
b.set '小米手机'
browser.button(aria_label: '搜索').click
######## 搜索结束 #########


######## 点击商品开始 #########
sleep 3
# 注意这个a标签 会新开tab
browser.link(href: "//item.jd.com/100014348478.html").click
######## 点击商品结束 #########


######## 加入购物车开始 #########
sleep 1
# 目的是当前浏览器有两个tab 为了用新开的商品tab
# 用最后一个窗格
browser.windows.last.use

puts browser.url # 打印当前browser对象 url
cart_link = browser.link(text: '加入购物车')
cart_link.click if cart_link.exists?
######## 加入购物车结束 #########


sleep 3
browser.close
```

