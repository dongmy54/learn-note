### rspec mock
有些时候我们的代码依赖于外部代码，而外部代码我们不太方便直接测试；但又想达到测试的目的，我只需要专注我们的代码逻辑能正常运行；默认认为外部依赖能正常返回；此时我们可以通过mock-模拟方式来写写测试代码。

在rspec中mock主要有三种方式：
1. double - 通用mock（替身）
2. instance_double - 实例mock(替身)
3. class_double - 类mock(替身)

PS: 通常而言，一般是设置mock出对象后，然后给此对象添加allow/expect；但这不是必须的；直接添加allow/expect也是可以的。

行为主要通过:
1. allow 允许谁 接收xx 方法，返回yy值
2. expect 期望 谁 接收xx 方法，返回yy值（必须要有真实调用，否则会报错）

下面通过具体示例，来仔细体会上述描述

#### 1. double通用mock
它是通用的，所以是随便写都可以，它不关心对象上是否真正的有xx方法；
而instance_double/class_double会在mock的同时验证,是否有实例/类方法。

```ruby
# 直接运行 rspec xx.rb立即执行
require 'rspec'

class WeatherReport
  # 天气服务-外部的
  def initialize(weather_service)
    @weather_service = weather_service
  end

  def generater(city)
    # 天气服务通过 get_weather调用
    result = @weather_service.get_weather(city)
    "#{city} weather: #{result}"
  end
end

describe WeatherReport do
  it 'get weather report should return' do
    city = "成都"
    weather_service = double("weather service") # 这里参数名随便写
    
    # expect 期望了如果没有真实调用get_weather会报错；
    # 同理写成allow则不会验证是否有真正调用
    expect(weather_service).to receive(:get_weather).with(city).and_return("出太阳")

    report = WeatherReport.new(weather_service)
    expect(report.generater(city)).to eq("成都 weather: 出太阳")
  end
end
```

#### 2. instance_double实例mock
1. 它和double不同，它用于模拟实例对象;
2. 它会去检查真实的类中是否有此实例方法；因此验证更完善，更安全，应用返回更普遍。
3. 需要注意的是,mock出的对象，只能调用allow/expect中规定的方法，即使在类中已经定义了此实例方法也不行，特别注意、特别注意哦。

```ruby
require 'rspec'
class User
  attr_accessor :name, :email

  def initialize(name, email)
    @name = name
    @email = email
  end

  def send_email(message)
    # 模拟外部发送邮件有时间耗费
    sleep 1
    "#{name} send message: #{message}"
  end
end

class EmailSender
  def self.send_welcome(user)
    user.send_email("welcome to our contry")
  end
end

describe "EmailSender" do
  it 'send welcome message' do
    user = instance_double(User, name: "zhangsan", email: "zhangsan@gmail.com")
    # instance_double **会验证是否真的存在send_email 方法，如果不存在报错
    allow(user).to receive(:send_email).and_return("zhangsan send message: welcome to our contry")

    expect(EmailSender.send_welcome(user)).to eq("zhangsan send message: welcome to our contry")
  end
end
```

#### 3. class_double 类mock
它的用法和instance_double差不多，不同之处在于它的实用范围是类方法；
同理它会对类中是否存在对应的类方法进行验证；
它的示例省略

#### 4. 其它补充
```ruby
# 1.任何实例
# 在有些时候，不方便一开始就创建出mock对象，程序在运行中会new出对象，因此非常方便
allow_any_instance_of(Database).to receive(:huu).and_return("huu")
# 定义后任何Database实例都会有xx方法
Database.new.huu # 返回 huu

# 2.非mock出的对象也能用allow/expect
# 且不会干扰正常实例中的方法（PS：mock出的对象，默认只能使用allow/expec中的方法）
user = User.new
allow(user).to receive(:bar).and_return("bar")

# 3. 用with指定其中的参数
expect(mock).to receive(:method_name).with(1, "param").and_return(42)
```

