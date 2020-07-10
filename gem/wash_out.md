#### wash_out
> 让rails 提供SOAP服务（接口）

##### 用法
```ruby
# config/routes.rb
Rails.application.routes.draw do
  # xxx 其它

  # 1. rumbas 是controller名
  # 2. rumbas 提供一组soap服务（多个action 操作) 
  wash_out :rumbas

  # xxx 其它
end
```

```ruby
# app/controllers/rumbas_controller.rb
class RumbasController < ActionController::Base
  soap_service namespace: 'urn:WashOut'

  # 这里 soap_action 和 action名称要同
  soap_action "integer_to_string",
              :args   => :integer,
              :return => :string
  
  # 这就是一个操作
  def integer_to_string
    render :soap => params[:value].to_s
  end
end
```

经过上面的配置你可以调用接口了
```ruby
require 'savon'

client = Savon::Client.new(wsdl: "http://localhost:3000/rumbas/wsdl")

# 支持的操作
oper = client.operations # => [:integer_to_string]

# 根据操作传参数
result = client.call(:integer_to_string, message: {:value => "123"})

puts result.to_hash.inspect  
# => {:integer_to_string_response=>{:value=>"123"}}
```


