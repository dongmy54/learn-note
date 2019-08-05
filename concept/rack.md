#### webserver
>指puma webrick等

#### rack
>1. 首先,它是一个ruby gem
>2. 其次,它是webserver 与 rack应用之间的桥梁

#### rack应用
> 指rails、sinatra等

满足条件
>1. 接收一个环境（env)参数
>2. 响应`call`方法
>3. ruby 对象
>4. 返回数组[状态码, 请求头, body内容]

#### 最简单的例子
```ruby
# config.ru

run Proc.new {|env| [200, {'Content-Type' => 'text/html'}, ['hello sample rack']]}
```
运行 `rackup config.ru`
![Snip20181020_1.png](https://i.loli.net/2018/10/20/5bca9081cd052.png)

#### 中间件
> 1. 可在上层改变http 响应和请求
> 2. 由 initialize 和 call 方法组成的类

一个中间件
```ruby
class StatusLogger
  # 先初始化 再调用call方法
  def initialize(app, options = {})
    @app = app
  end

  def call(env)
    status, headers, body = @app.call(env)
    puts status
    [status, headers, body]
  end
end

use StatusLogger
run Proc.new {|env| [200, {'Content-Type' => 'text/html'}, ['use status logger']]}

# 运行 $rackup config.ru
```
两个中间件
```ruby
class StatusLogger
  # 先初始化 再调用call方法
  def initialize(app, options = {})
    @app = app
  end

  def call(env)
    status, headers, body = @app.call(env)
    puts status
    [status, headers, body]
  end
end

class BodyTansformer
  def initialize(app, options = {})
    @app   = app
    @count = options[:count] 
  end

  def call(env)
    status, headers, body = @app.call(env)
    body = body.map {|i| i[0...@count].upcase + i[@count..-1]}
    puts body
    [status, headers, body]
  end
end

use StatusLogger
use BodyTansformer, count: 3

run Proc.new {|env| [201, {'Content-Type' => 'text/html'}, ['use two middleware']]}

# 运行 $rackup config.ru
```

#### 中间件与应用关系
> 1. 一个请求过来，经由中间件处理，一个中间件再调用其它中间件或应用；
> 2. 返回响应后，再经由中间件按来时方向，反向处理

![Snip20181020_2.png](https://i.loli.net/2018/10/20/5bca985140f9e.png)

> 3. 一个应用，由 一堆中间件 和 rack应用的集合组成
```ruby
#$ rake middleware
use Rack::Sendfile
use ActionDispatch::Static
use ActionDispatch::Executor
use ActiveSupport::Cache::Strategy::LocalCache::Middleware
use Rack::Runtime
use ActionDispatch::RequestId
use ActionDispatch::RemoteIp
use Rails::Rack::Logger
use ActionDispatch::ShowExceptions
use ActionDispatch::DebugExceptions
use ActionDispatch::Reloader
use ActionDispatch::Callbacks
use ActiveRecord::Migration::CheckPending
use Rack::Head
use Rack::ConditionalGet
use Rack::ETag
run ApplicationName::Application.routes
```


