# 方法查找链：从类开始 逐级 超类 生成的 祖先链
# 一般为 A < Object < Kernel < BasciObjext


#===================================================================================#
# def 定义方法 
# 方法名 须是确定的
# 动态方法 去定义动态方法名
class A
  hu = 'qwe'

  # def hu      这里方法名 用变量/直接字符串 都不行错误
  #   puts 'hu' 
  # end         ❌
  
  define_method hu do 
    puts 'define_method qwe'
  end

end

A.new.qwe
# => define_method qwe


#===================================================================================#
# 类定义
# 两种等价写法
class MyClass < Array
  def my_method
    puts 'hello friend'
  end
end

# MyClass = Class.new(Array) do  # Class.new 带参数表示 继承于
#   def my_method                # 等于 给类 命名
#     puts 'hello friend'
#   end
# end

MyClass.new.my_method    # => 'hello friend'


#===================================================================================#
# 类实例变量
# 只对类可见 实例方法不可用
class A
  # 类实例变量
  @vv = 123

  def m
    @vv
  end

  def self.m
    @vv
  end
end

puts A.new.m # => nil
puts A.m     # => 123


#===================================================================================#
# 类变量
# 类变量 对类 和 实例 都可见
# PS：会修改顶层的类变量
@@vv = 1
class B
  # 类变量
  @@vv = 123

  def m
    @@vv
  end

  def self.m
    @@vv
  end
end

puts B.new.m # => 123
puts B.m     # => 123
puts @@vv    # => 123（被修改啰）


#===================================================================================#
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
# 别名
# alias 顶层
# alias_methods 类中
def m
  puts "I'm m method"
end

alias :n :m  # alias 中间没逗号分隔
n
# => I'm m method

class A
  def a_m
    puts "I'm a_m method"
  end

  alias_method 'a_n','a_m' # 中间逗号分隔
end

A.new.a_n
# => I'm a_m method


#===================================================================================#
# 环绕别名
# 在复写的方法中
# 利用alias新方法 调用旧方法
class A
  def m(name)
    name.reverse.upcase
  end
end

class B < A
  # B类中已有m方法
  alias_method :m_new,:m
  
  # 重写m方法
  def m(name)
    name = m_new(name)  # 用别名方法调用旧m方法
    name + name[0].downcase  # 新m放添加的内容
  end
end

puts B.new.m('dmy')
# => YMDy


#===================================================================================#
# prepend
# 1、相对于环绕别名更明显、更温和
# 2、prepend下包含 include 上包含
# 3、super 等价于 原方法
class B
  def mm(str)
    str + 'a'
  end
end

module C
  def mm(str)
    str = super(str)  # super 小写 等价于原方法 返回值
    str + str[0].upcase
  end
end

class A < B
  # prepend下包含
  prepend C
end

puts A.new.mm('dmy')
# => dmyaD


#===================================================================================#
# 细化
# 拥有作用域
# 相对于猴子补丁 和 环绕别名安全
module StringExtensions
  # refine 细化的类 后接块
  refine String do
    
    def to_s
      self.reverse
    end
  end
end

puts 'sd'.to_s  
# => 'sd'

# 使用前要启用（有作用域）
using StringExtensions
puts 'sd'.to_s
# => 'ds'


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
  # 扩展自己
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


#===================================================================================#
# 单件方法
# 对单个对象 定义的方法
str = 'a str'

def str.title?
  self.upcase == self
end

# class << str        # 和上面等价
#   def title?        # 实际上类方法 就是单件方法
#     self.upcase == self
#   end
# end

puts str.title?            # => false
puts str.singleton_methods # => title?
puts 'qwer'.title?         # => undefined method `title?' for "qwer":String (NoMethodError)


#===================================================================================#
# extend
# extend 是将模块 放入 单件类 的快捷方式
module A
  def hu
    puts 'hu'
  end
end

class B
  # 类的单件类
  class << self
    include A
  end
end

B.hu # => 'hu'

obj = B.new
# 对象的单件类
class << obj
  include A
end

obj.hu # => hu

# extend 快捷方式（与上等价）
# class B
#   extend A
# end

# B.hu

# obj = B.new
# obj.extend A
# obj.hu


#===================================================================================#
# instance_variable_get VS instance_variable_set
# 取出/设置 实例变量
def add_attribute_method_for_class(kclass,attribute_name)
  kclass.class_eval do
    define_method "#{attribute_name}=" do |value|
      # 设置实例变量
      instance_variable_set("@#{attribute_name}", value)
    end

    define_method attribute_name do
      # 取出实例变量
      instance_variable_get "@#{attribute_name}"
      #instance_eval  "@#{attribute_name}"  和上等价
    end
  end
end

class Person;end
add_attribute_method_for_class(Person,:age)

p = Person.new
p.age = 20
puts p.age
# => 20
