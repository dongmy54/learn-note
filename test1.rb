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