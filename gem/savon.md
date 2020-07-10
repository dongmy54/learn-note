#### savon
> 发送soap请求

##### 用法
> [参考文档](http://savonrb.com/version2/client.html)

```ruby
require 'savon'

# 构建 client
client = Savon::Client.new(wsdl: "http://localhost:3000/rumbas/wsdl")
# 下面这种写法也支持
# client = Savon.client do
#   read_timeout 10
#   basic_auth ["luke", "secret"]
#   delete_root false
#   wsdl url # 关键 url必须 也可用 endpoint、namespace 顶替
# end

# 支持的操作
oper = client.operations # => [:integer_to_string]

# 根据操作传参数
result = client.call(:integer_to_string, message: {:value => "123"})

# 返回整个响应
puts result.inspect
# => #<Savon::Response:0x00007fdd4f1562e0 @http=#<HTTPI::Response:0x00007fdd4f1565b0 @code=200, @headers={"x-frame-options"=>"SAMEORIGIN", "x-xss-protection"=>"1; mode=block", "x-content-type-options"=>"nosniff", "content-type"=>"text/xml; charset=utf-8", "etag"=>"W/\"6d075509c3aeaf1164e83943352f334b\"", "cache-control"=>"max-age=0, private, must-revalidate", "x-request-id"=>"d6709f1d-10e3-402f-9b06-0082750def97", "x-runtime"=>"0.092253", "connection"=>"close", "server"=>"thin"}, @raw_body="<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n<soap:Envelope xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:tns=\"urn:WashOut\">\n  <soap:Body>\n    <tns:integer_to_string_response>\n      <value xsi:type=\"xsd:string\">123</value>\n    </tns:integer_to_string_response>\n  </soap:Body>\n</soap:Envelope>\n", @body="<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n<soap:Envelope xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:tns=\"urn:WashOut\">\n  <soap:Body>\n    <tns:integer_to_string_response>\n      <value xsi:type=\"xsd:string\">123</value>\n    </tns:integer_to_string_response>\n  </soap:Body>\n</soap:Envelope>\n">, @globals=#<Savon::GlobalOptions:0x00007fdd4dac7d58 @option_type=:global, @options={:encoding=>"UTF-8", :soap_version=>1, :namespaces=>{}, :logger=>#<Logger:0x00007fdd4dac7c90 @progname=nil, @level=0, @default_formatter=#<Logger::Formatter:0x00007fdd4dac7c68 @datetime_format=nil>, @formatter=nil, @logdev=#<Logger::LogDevice:0x00007fdd4dac7bf0 @shift_size=nil, @shift_age=nil, @filename=nil, @dev=#<IO:<STDOUT>>, @mon_owner=nil, @mon_count=0, @mon_mutex=#<Thread::Mutex:0x00007fdd4dac7b78>>>, :log=>false, :filters=>[], :pretty_print_xml=>false, :raise_errors=>true, :strip_namespaces=>true, :delete_namespace_attributes=>false, :convert_response_tags_to=>#<Proc:0x00007fdd4dac7b00@/Users/dongmingyan/.rvm/gems/ruby-2.3.7/gems/savon-2.11.2/lib/savon/options.rb:86 (lambda)>, :convert_attributes_to=>#<Proc:0x00007fdd4dac7ad8@/Users/dongmingyan/.rvm/gems/ruby-2.3.7/gems/savon-2.11.2/lib/savon/options.rb:87 (lambda)>, :multipart=>false, :adapter=>nil, :use_wsa_headers=>false, :no_message_tag=>false, :follow_redirects=>false, :unwrap=>false, :host=>nil, :wsdl=>"http://localhost:3000/rumbas/wsdl", :endpoint=>#<URI::HTTP http://localhost:3000/rumbas/action>}>, @locals=#<Savon::LocalOptions:0x00007fdd4d9b5050 @option_type=:local, @options={:advanced_typecasting=>true, :response_parser=>:nokogiri, :multipart=>false, :message=>{:value=>"123"}, :soap_action=>"integer_to_string"}>>

#  真正可能用到的hash部分 等同 result.body
puts result.to_hash.inspect  
# => {:integer_to_string_response=>{:value=>"123"}}

# xml格式
puts result.to_xml
# <?xml version="1.0" encoding="UTF-8"?>
# <soap:Envelope xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:tns="urn:WashOut">
#   <soap:Body>
#     <tns:integer_to_string_response>
#       <value xsi:type="xsd:string">123</value>
#     </tns:integer_to_string_response>
#   </soap:Body>
# </soap:Envelope>

# 比to_hash 稍详细hash
puts result.hash.inspect
# => {:envelope=>{:body=>{:integer_to_string_response=>{:value=>"123"}}, :"@xmlns:soap"=>"http://schemas.xmlsoap.org/soap/envelope/", :"@xmlns:xsd"=>"http://www.w3.org/2001/XMLSchema", :"@xmlns:xsi"=>"http://www.w3.org/2001/XMLSchema-instance", :"@xmlns:tns"=>"urn:WashOut"}

# 头信息
puts result.header.inspect
# => nil
```

