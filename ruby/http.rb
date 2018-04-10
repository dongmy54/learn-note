# GET 带查询参数 get_response
require 'net/http'

uri = URI('http://hhhhh.t.yurl.vip/api/v1/account/favorite')
params = { :id_type => 2 }
uri.query = URI.encode_www_form(params)

res = Net::HTTP.get_response(uri)
puts res.body
# => {"code":212,"message":"账号未登录，无操作权限"}


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
req['Cookie'] = '_homeland_shop_customer_session=e0ab8ec558d6b8fbfc00880f08a8dd1c513ac3ec307ef90bdc76426053389e27'
# 响应
res = Net::HTTP.start(uri.hostname, uri.port) do |http|
  http.request(req)
end
puts JSON.parse(res.body)
# => {"code"=>200, "message"=>"", "favorites"=>[{"id"=>5, "favorite_id"=>4675, 
# "id_type"=>2, "status"=>nil, "customer_id"=>16993, "add_time"=>"2018-03-19T15:30:20.132+08:00"}, 
# {"id"=>6, "favorite_id"=>4671, "id_type"=>2, "status"=>nil, "customer_id"=>16993, "add_time"=>"2018-03-19T15:31:01.491+08:00"}]}


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