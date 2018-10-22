# instance_eval 打开对象
# 用法：和class_eval 基本同

class A
  def initialize
    @x = 1
  end
end


obj = A.new
# 添加方法
obj.instance_eval do
  def m
    puts '这是由instanc_eval 创建的实例方法'
  end
end

obj.m
# 这是由instanc_eval 创建的实例方法


# 获取/改变实例变量
obj.instance_eval { puts @x}


# instance_exec
# 和instance_eval 主要区别在于：它可传递参数
class A;end

A.new.instance_exec('hello') do |y|
  puts y
end
# hello