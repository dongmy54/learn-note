# 函数限制次数 自我调用
def m(x,limit = 6)
  raise ArgumentError,'调用次数太多' if limit == 1
  
  return puts x*2 if x % 3 == 2
  m(rand(1000),limit -1)    # 自我调用 次数 -1
end

m(258)
# => 604


#===================================================================================#
# 块参数 嵌套吧
fruits = %w(banana apple grape)

# 动态定义hu方法  接受块参数
Kernel.send :define_method, :hu do |&block|  
  fruits.each do |fruit|
    block.call(fruit)  # 这个块 也需要参数
  end
end

# 内核方法可以直接调用
hu do |fruit|
  puts "I LOVE #{fruit}"
end
# => I LOVE banana
# => I LOVE apple
# => I LOVE grape


#===================================================================================#
# 类实例变量 返回常量 串起来
require 'time'
class Book
  def initialize(name)
    @name = name
    # 通过类返回 常量串起来
    @time = Book.time.now
  end

  def self.time
    @time ||= Time
  end
end

book1 = Book.new('中国简史')
puts book1.instance_eval { puts @time }
# => 2018-04-22 11:09:36 +0800

# 设置时间 常量
Book.class_eval { @time = DateTime}
book2 = Book.new('中国史纲')
puts book2.instance_eval { puts @time } 
# => 2018-04-22T11:09:36+08:00


#===================================================================================#
# 方法中用eval 定义新放方法
def add_class_instance_method(kclass,method_name)
  eval "
    class #{kclass}

      def #{method_name}
        puts 'Im a instace method create by add_class_instance_method'
      end
    end
  "
end

add_class_instance_method(String,'say_hello')

'asda'.say_hello
# => Im a instace method create by add_class_instance_method


#===================================================================================#
# 与上等价写法
# 用 class_eval 与 define_method
# 更安全
def add_class_instance_method(kclass,method_name)
  # 为了在 deine_method 中能用method_name变量（扁平化处理）
  # 由于kclass 是一个已经存在的类 不用Class.new
  kclass.class_eval do
    define_method method_name do 
      puts "I'm a instance method created by add_class_instance_method"
    end
  end
end

add_class_instance_method(String,'say_hello')

'asda'.say_hello
# => I'm a instance method created by add_class_instance_method
