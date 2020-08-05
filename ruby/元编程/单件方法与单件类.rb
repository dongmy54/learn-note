# 单件方法：只属于一个对象的方法
# 单件类： 存放单件方法
# 1. 单件类（只属于一个实例）,不能被继承
# 2. extend/include模块，本质是将这些方法，存于对象的单件类中
# 3. 查找方法时,最先查找的是单件方法，然后才是对象模型的顺序查找

str = "hello"

def str.method_a
  puts "我是单件方法a"
end

class << str # 打开单件类
  def method_b
    puts "我是单件方法b"
  end
end

str.method_a
# 我是单件方法a
str.method_b
# 我是单件方法b

puts str.singleton_class
# #<Class:#<String:0x00007fe6ab8b6728>>
puts str.singleton_methods.inspect
# [:method_a, :method_b]
puts str.singleton_class.instance_methods.include?(:method_a)
# true
