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