##################################################################################
# instance_variable_get 获取对象内部实例变量
class Hu
  def initialize
    @x,@y = 1,3
  end
end

hu = Hu.new
puts hu.instance_variable_get("@x")
# 1



##################################################################################
# class_variable_get 类变量获取
class Red
  @@foo = 99
end

Red.class_variable_get(:@@foo)
# => 99



##################################################################################
# tap 调试 检测中间值
(1..10).tap{|x| puts "原本的样子：#{x.inspect}"}
       .to_a
       .tap{|x| puts "转数组后：#{x.inspect}"}
       .select{|x| x % 2 == 2}
       .tap{|x| puts "筛选后: #{x.inspect}"}
       .map{|x| x * x}
       .tap{|x| puts "map后： #{x.inspect}"}
# 原本的样子：1..10
# 转数组后：[1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
# 筛选后: []
# map后： []


# tap 便捷填充数组/hash/字符串
[].tap do |i|
  i << 'hu'
  i << 'bar'
end
# => ["hu", "bar"]

"".tap do |i|
  i << 'hu'
  i << 'bar'
end
# => "hubar"

{}.tap do |i|
  i[:hu]  = 1
  i[:bar] = 2
end
# => {:hu=>1, :bar=>2}



