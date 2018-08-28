# class_eval 打开类
# 用法1: 添加方法
# 用法2: 获取/改变实例变量

class A        # 已定义类
  @var = 2     # 类实例变量
end     

# 定义方法
A.class_eval do
  def m
    puts '这个方法 由class_eval 创建'
  end
end

A.new.m
# 这个方法 由class_eval 创建


puts A.instance_variables.inspect   # [:@var]
#  获取/改变实例变量
A.class_eval do
  @var = 3
  @bar = 2
end

puts A.instance_variables.inspec    # [:@var, :@bar]