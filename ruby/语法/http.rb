# GET 带查询参数 get_response
require 'net/http'

uri = URI('http://hhhhh.t.yurl.vip/api/v1/account/favorite')
params = { :id_type => 2 }
uri.query = URI.encode_www_form(params)

res = Net::HTTP.get_response(uri)
puts res.body
# => {"code":212,"message":"账号未登录，无操作权限"}


#===================================================================================#
# 获取 响应信息
require 'net/http'

uri = URI('http://baidu.com')
res = Net::HTTP.get_response(uri)

# 获取响应所有头部
puts res.each_header.to_h
# => {"date"=>"Tue, 10 Apr 2018 10:31:25 GMT", "server"=>"Apache", "last-modified"=>"Tue, 12 Jan 2010 13:48:00 GMT", "etag"=>"\"51-47cf7e6ee8400\"", "accept-ranges"=>"bytes", "content-length"=>"81", "cache-control"=>"max-age=86400", "expires"=>"Wed, 11 Apr 2018 10:31:25 GMT", "connection"=>"Keep-Alive", "content-type"=>"text/html"}

#获取单个头部 
puts res['last-modified']
# => Tue, 12 Jan 2010 13:48:00 GMT

#获取状态码
puts res.code
# => 200

# 获取响应信息
puts res.message
# => OK

# 获取响应body
puts res.body
# => <html> 
# <meta http-equiv="refresh" content="0;url=http://www.baidu.com/">
# </html>


#===================================================================================#
# 常规 POST 请求 
require 'net/http'
require 'json'

# 获取uri 对象
uri = URI('http://account.test.yurl.vip/interface/account/login')
# post_form(参数 字符串/符号 都行) 请求
res = Net::HTTP.post_form(uri, {:loginid => '18200375xxx',:password => 'dmyxxx'})
# 解析成hash
puts JSON.parse(res.body)
# => {"data"=>{"loginid"=>"18200375xxx", "is_partner"=>false, "is_agent"=>false}}


#===================================================================================#
# GET 请求 带cookie
require 'net/http'
require 'json'

uri = URI('http://hhhhh.t.yurl.vip/api/v1/account/favorite')
params = { :id_type => 2 }
uri.query = URI.encode_www_form(params)
# 初始化请求
req = Net::HTTP::Get.new(uri)
# 设置请求cookie
req['Cookie'] = '_homeland_shop_customer_session=xxxxx'
# 响应
res = Net::HTTP.start(uri.hostname, uri.port) do |http|
  http.request(req)
end
puts JSON.parse(res.body)
# => {"code"=>200, "message"=>"", "favorites"=>[{"id"=>5, "favorite_id"=>4675, 
# "id_type"=>2, "status"=>nil, "customer_id"=>16993, "add_time"=>"2018-03-19T15:30:20.132+08:00"}, 
# {"id"=>6, "favorite_id"=>4671, "id_type"=>2, "status"=>nil, "customer_id"=>16993, "add_time"=>"2018-03-19T15:31:01.491+08:00"}]}


#===================================================================================#
# POST 带 cookie 带 表单参数
require 'net/http'

uri = URI('http://hhhhh.t.yurl.vip/api/v1/account/favorite/create')
# POST GET 都是 Net::HTTP模块下的类
req = Net::HTTP::Post.new(uri)
# set_from_data 直接在req 上调用
req.set_form_data({:favorite_id => 2, :type_id => 2})
req['Cookie'] = '_homeland_shop_customer_session=xxxxxx'
# Net::HTTP.start 通用
res = Net::HTTP.start(uri.hostname, uri.port) do |http|
  http.request(req)
end

puts res.body
# => {"code":201,"message":"收藏对象不存在"}


#===================================================================================#
# 串起来
# 先：一个请求获取token码
# 后：带着token 发下一个请求
require 'net/http'
require 'json'
# 先获取token码
uri_pre = URI('http://hhhhh.t.yurl.vip/api/v1/account/login')
# post_form 快捷方式 post 数据
res_pre = Net::HTTP.post_form(uri_pre, {:account => '1820037xxxx', :password => 'dmxxxx'})
token = JSON.parse(res_pre.body)["token"]

uri = URI('http://hhhhh.t.yurl.vip/api/v1/account/favorite/create')
# POST GET 都是 Net::HTTP模块下的类
req = Net::HTTP::Post.new(uri)
# set_from_data 直接在req 上调用
req.set_form_data({:favorite_id => 2, :type_id => 2})
req['Cookie'] = "_homeland_shop_customer_session=#{token}"
# Net::HTTP.start 通用
res = Net::HTTP.start(uri.hostname, uri.port) do |http|
  http.request(req)
end

puts res.body
# => {"code":201,"message":"收藏对象不存在"}


#===================================================================================#
# Net::HTTP.start 万能的
# 不同的请求 指定不同的类 
# Net::HTTP::Get / Post / Put ...
require 'net/http'

uri = URI('http://api.test.yurl.vip/v1/product_types/850')
req = Net::HTTP::Put.new(uri)
# 指定类型
req.content_type = 'application/json'
req.body = '{
  "product_types":{
    "name":"厨具",
    "handle":"sqwee"
  }
}'
req['X-API-ACCESS-TOKEN'] = 'd1748cf1a1e94c38xxxxx'

res = Net::HTTP.start(uri.hostname,uri.port) do |http|
  http.request(req)
end

puts res.body
# => {"code":422,"errors":{"common":["product_type不存在"]}}


#===================================================================================#
# 基本认证 （basic_auth)
require 'net/http'

uri = URI('http://www.test.yurl.vip/')
req = Net::HTTP::Get.new(uri)
req.basic_auth('xxxxx','xxxxx')

res = Net::HTTP.start(uri.hostname,uri.port) do |http|
  http.request(req)
end

puts res.body
# => 返回页面html ....