# 方法查找链：从类开始 逐级 超类 生成的 祖先链
# 一般为 A < Object < Kernel < BasciObjext

# self 对象
puts self 
# => main
puts self.class
# => Object


#===================================================================================#
# ARGV 是参数值的意思，取值从0开始
# ruby test.rb 0 1    命令行传入参数 0 1
puts ARGV[0]    # 0
puts ARGV[1]    # 1


#===================================================================================#
# next 与 break
(1..10).each do |i|
  next if  i == 5
  # next 跳过本次循环，进入下一次循环
  break if i == 8
  # break 直接终止整个循环
  puts i
end
# 输入1 2 3 4 6 7


#===================================================================================#
# ruby test.rb >> log.text
# >> 符号会将 执行结果输出内容写到某文件中
puts 'first'
puts 'second'
# 如果log.text 文件不存在，则新建
# log.text 中会有 first 和 second


#===================================================================================#
# 一个类方法 调用另一个类方法
class A 
  
  def self.test
    ret = test1('sd')
    # 这里等价于 self.test1('sd')
    # 一个类方法可以直接调用另外一个类方法
    puts ret
  end

  def self.test1(arg)
    "参数是：#{arg}"
  end

end
A.test
# 参数是：sd


#===================================================================================#
# 在条件判断中，两个并列条件，前者把一个实例赋值给它
# 后者用这个被赋值的变量，调用实例方法
# 会报错，a 为空
class A
  def test
    true
  end
end

if a = A.new && a.test      #  猜测 应该是不是从前往后的逐步判定的，前后条件难道是同时去判断？
  puts "sda"
end


#===================================================================================#
# 模块中用 extend self 定义模块中的模块方法
module A
  extend self

  def hu
    puts "This is hu module method"
  end
end

A.hu
# => This is hu module method


#===================================================================================#
# []表示定义 []里面的方法，配和类或模块使用（不能单独使用）
class A

  def [](name)
    puts name.to_s
  end
end

module B
  extend self

  def [](name)
    puts name.to_s
  end
end

A.new['class']  # => class
B['module']     # => module


#===================================================================================#
# 对象 中实例变量是 被封装 不能随便存取
# 虚拟字段则可以
# 操作虚拟字段可借助instance_eval 方法
class A
  attr_accessor :p,:q

  def initialize(h=nil)
    @h = h
  end

end

a = A.new
a.p = 'p'    # 虚拟字段则可以 直接赋值，取值
a.q = 'q'
#a.h = 'h'    # 这里会报错，对象中的实例变量，是没法通过对象直接赋值的 

a.instance_eval { @h = 'h' }   # 赋值可以用 instance_eval
a.instance_eval { puts @h }   # 取值同理
=> 'h'


#===================================================================================#
# 内核方法
# 任何位置 都可用（单独/对象）
# 原因：Kernel 是 Object 中的模块
# PS: puts 也是内核方法，但不可以用对象调用 因为它是私有的
module Kernel
  # 内核中定义一个 公开方法
  def pi
    puts "pi"
  end
end

class A;end
pi   # 直接用
# => pi
A.new.pi # 对象 调用都可以
# => pi



#===================================================================================#
# define_method 
# 在类中定义 和 类.send定义 等价
# 都是实例方法 
class A
  # 直接在类中定义
  define_method :hu do 
    puts 'hu'
  end
end

# 类.send 写
A.send :define_method, :bar do
  puts "bar"
end

A.new.hu   # => hu
A.new.bar  # => bar
