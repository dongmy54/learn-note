require 'uri'

# URI(字符串)
# 解析出 各个部分
uri = URI("https://example.com/posts/hu?page=2&limit10#time=123456")

puts uri.scheme
# https
puts uri.host
# example.com
puts uri.path
# /posts/hu
puts uri.port
# 443
puts uri.query
# page=2&limit10
puts uri.fragment
# time=123456
puts uri.to_s
# https://example.com/posts/hu?page=2&limit10#time=123456


# encode_www_form 编码 查询字符串
uri = URI("https://example.com")

uri.query = URI.encode_www_form(:page => 2,:limit => 10)
puts uri.to_s
# https://example.com?page=2&limit=10


# decode_www_form 解码 查询字符串
uri = URI("https://example.com?page=2&limit=10")

decode_query_arr = URI.decode_www_form(uri.query)
# => [["page", "2"], ["limit", "10"]]
puts decode_query_hash = decode_query_arr.to_h
# {"page"=>"2", "limit"=>"10"}


# join 将 字符串 串成 uri
# PS：当参数超过两个是 中间者 保证有后续（/posts/)
uri = URI.join("https://example.com","/posts","/hu")
puts uri.to_s
# https://example.com/hu
uri = URI.join("https://example.com","/posts/","hu") # hu 不能加 /
puts uri.to_s
# https://example.com/posts/hu