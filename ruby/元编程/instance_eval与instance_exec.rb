# 总体 {instance|class|module}_{eval|exec}

############################################################
# instance_exec 生成单件方法（类方法)
# class_exec    生成实例方法（接收者必须是类）
class A
  def initialize
    @x = 1
  end
end

A.instance_exec{def hu;end} # 单件方法
A.class_exec{def bar;end}   # 实例方法

puts A.singleton_methods.include?(:hu)
# true
puts A.method_defined?(:bar)
# true

obj = A.new
# # 获取/改变实例变量
obj.instance_exec{puts @x}



############################################################
# exec 可以传参数 必须接块
class A;end
a = A.new

A.class_exec("hello") do |param|
  puts param

  def hu
    puts 'hu'
  end
end

A.new.hu



############################################################
# eval 只能传字符串/块  不能传参数
A.class_eval("puts 'hello'")
A.class_eval {puts "hello"}



############################################################
# module和class 可以互用
class A;end
A.class_exec do
  def hu
    puts 'hu'
  end
end

# 和上面等价
A.module_exec do
  def hu
    puts 'hu'
  end
end

A.new.hu



