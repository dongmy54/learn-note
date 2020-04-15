#### savon
> 用于 savon 协议接口

##### 用法
> [参考文档](http://savonrb.com/version2/client.html)

```ruby
# 构建 client
client = Savon.client do
  read_timeout 10
  basic_auth ["luke", "secret"]
  delete_root false
  wsdl url # 关键 url必须 也可用 endpoint、namespace 顶替
end

# 支持的操作
client.operations  
# => [:authenticate, :find_user]

# 响应
response = client.call(:authenticate, message: { username: "luke", password: "secret" })
# 1. authenticate 为操作
# 2. message 为参数

# 响应
response.header  # => { token: "secret" }
response.body  # => { response: { success: true, name: "luke" } }
response.hash  # => { envelope: { header: { ... }, body: { ... } } }
response.to_xml  # => "<response><success>true</success><name>luke</name></response>"
```

