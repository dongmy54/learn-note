# binding 关键字
# 运行中获取 局部变量
a,b,c = 1,2,3
puts binding.local_variables
# => a
# => b
# => c 


#===================================================================================#
# eval（一个参数时）
# eval 字符串 当作代码运行
eval("puts 2 + 2") 
# => 4

printf "please input a method name: "
# 取出最后一个字符串
method_name = gets.chomp  
# eval 定义方法
eval("def #{method_name};puts 'This is a method defined by eval';end")
# 执行eval 定义的方法
eval("#{method_name}")
# => This is a method defined by eval


#===================================================================================#
# eval 与 binding 一起
# 两个参数时：
# 第一个参数：执行字符串
# 第二个参数：获取变量值
def use_eval_method(b)
  # 从第二个参数那里 获取了 变量 str
  eval("puts str",b)
end

str = "I'm string variable"
# binding 获取当前局部变量
use_eval_method(binding)
# => I'm string variable


#===================================================================================#
# instance_eval
# 两点：
# 1、执行其中的 字符串 / 块
# 2、在块中 self 是 instanc_eval的接收者 
# PS： 常用于 操作 对象中的 实例变量 
instance_eval("puts 'hello dmy'")
# => hello dmy
instance_eval {puts "hello dmy"}
# => hello dmy

class Person
  def initialize(&block)
    #block.call  会报错 执行时 当前对象为 main
    instance_eval(&block) #执行时 块中当前对象 为Person的实例
  end

  def name(name=nil)
    @name ||= name
  end

  def age(age=nil)
    @age ||= age
  end
end

person = Person.new do
  name 'my'
  age 24
end

puts person.name # => my
puts person.age  # => 24


#===================================================================================#
# 相比于instance_eval instance_exec 可传参数
class A
  def initialize
    @x = 'x'
  end
end

class B
  def b_method
    @y = 'y'
    A.new.instance_exec do 
      puts "@x: #{@x}; @y: #{@y}" # 这里不能获取到实例变量@y,因为实例变量和对象绑定在一起      
    end                           # 这里的当前对象是由 A 类生成的
  end
end

B.new.b_method
# @x: x; @y: (并没有打印出@y)

# 用instance_exexc 传参数就行,如
def b_method
  @y = 'y'
  A.new.instance_exec(@y) {|y| puts "@x: #{@x}; @y: #{@y}" }
  # 下面等价
  # A.new.instance_exec(@y) do |y|
  #   puts "@x: #{@x}; @y: #{y}"
  # end
end