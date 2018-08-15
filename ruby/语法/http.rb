require 'net/http'    # 会自动 require 'uri'
require 'json'

#===================================================================================#
# 响应 信息
res.msg    # 等价于 message
# => ok
res.code 
# => 200
res.body   # JSON 格式 
# => {"code":201,"msg":{"desc":"推荐导航已经存在"}}
res.uri  
# http://3232qw.t.yurl.vip/center/navigation/create_recommen
res.to_hash
# => {"date"=>["Fri, 10 Aug 2018 09:13:14 GMT"], "content-type"=>["application/json;charset=utf-8"], 
# "content-length"=>["54"], "connection"=>["keep-alive"], "cache-control"=>["no-store"], 
# "pragma"=>["no-cache"], "x-content-type-options"=>["nosniff"], 
# "set-cookie"=>["_homeland_shop_admin_session=39a44acc745b6b80a8c73c8781944bbffddbcdb33b831d48fba32f9f28807c06; path=/; 
# expires=Fri, 10 Aug 2018 11:13:14 -0000; HttpOnly"], "server"=>["XiaoBaWang"]} 


#===================================================================================#
# GET get_response
uri = URI("https://www.baidu.com/")

res = Net::HTTP.get_response(uri)
puts res.body
# <html>
# <head>
#   <script>
#     location.replace(location.href.replace("https://","http://"));
#   </script>
# </head>
# <body>
#   <noscript><meta http-equiv="refresh" content="0;url=http://www.baidu.com/"></noscript>
# </body>
# </html>


#===================================================================================#
# POST post_form 表单数据
uri = URI("http://account.test.yurl.vip/interface/account/login")

res = Net::HTTP.post_form(uri,:loginid => '182003xxxx6',:password => 'yyyy')

puts res.body
# {"data":{"loginid":"182003xxxx6","is_partner":false,"is_agent":true}}


#===================================================================================#
# Net::HTTP.start 万用型
uri = URI("http://3232qw.t.yurl.vip/center/navigation/create_recommen")

res = Net::HTTP.start(uri.host,uri.port) do |http|
  req          = Net::HTTP::Post.new(uri)        # 选择请求 类型 new 
  req['token'] = 'token xxxxx yyyyy' # 设置头
  req.set_form_data(:type => 'm')                # 表单数据
  # req.body = {:a => 'hh'}.to_json              # draw数据 应用中用 request.body.read 读取
  # req.content_type = 'multipart/form-data'     # 数据类型
  # req.basic_auth 'user', 'password'            # 基本认证
  
  http.request(req)
end

puts res.body
# {"code":202,"msg":{"desc":"推荐导航类型无效"}}


#===================================================================================#
# Net::HTTP.new  出http 不用块 写法
require 'net/http'

uri = URI('http://dmy.t.yurl.vip/marketing/short_url/create')

http = Net::HTTP.new(uri.host, uri.port)  # new http
req = Net::HTTP::Post.new(uri)
req.set_form_data(source_url: 'https://www.baidu.com/?tn=sitehao123_15',name: '测试')
res = http.request(req)

puts res.body
# {"data":{"code":200,"msg":{"id":97}}}


#===================================================================================#
# 响应类型 处理
def res_method(uri)
  uri = URI(uri)
  res = Net::HTTP.get_response(uri)
  
  case res
  when Net::HTTPSuccess      # 所有 2xx
    puts '成功响应'
  when Net::HTTPRedirection  # 所有 3xx
    puts "正在重定向到: #{res['location']}"
  else
    puts "sorry! 发生了错误"
    puts "信息：#{res.value}"
  end
end

res_method("https://www.baidu.com/")
# 成功响应
res_method("http://3232qw.t.yurl.vip/center/main/#/product")
# 正在重定向到: http://account.test.yurl.vip/login?from=3232qw.t.yurl.vip


#===================================================================================#
# 综合示例
# get 登录 取 account_token
uri = URI('http://account.test.yurl.vip/interface/account/login')
res = Net::HTTP.post_form(uri,'loginid' => '18200375876','password' => 'dmy067')

account_set_cookie = res.to_hash['set-cookie'].join('')
account_token      = account_set_cookie[/_homeland_shop_account_session=(.+?);/,1]

# get 后台 取 admin_token
uri = URI("http://3232qw.t.yurl.vip/center/sessions/encrpt_create?token=#{account_token}")
res = Net::HTTP.get_response(uri)
admin_set_cookie = res.to_hash['set-cookie'].join('')
admin_token      = admin_set_cookie[/_homeland_shop_admin_session=(.*?);/,1]

# post 接口
uri = URI('http://3232qw.t.yurl.vip/center/navigation/create_recommen')

res = Net::HTTP.start(uri.hostname,uri.port) do |http|
  req          = Net::HTTP::Post.new(uri)
  req['token'] = admin_token
  req.set_form_data(:type => 'display')

  http.request(req)
end

puts res.body


