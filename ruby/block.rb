# 块的本质：
# 1、打包代码，以后执行
# 2、作为函数变量（可赋值 可传方法）
# PS: 块不是对象


#===================================================================================#
# 定义块有两种基本方式
1、do .. end 或 
2、{ }


#===================================================================================#
# 定义块时 一般而言块的参数都是在{} /  do .. end ||中写
block1 = lambda {|a,b| p a,b }
block2 = lambda do |a,b|
          p a,b
         end

block1.call(1,2)    # => 1,2
block2.call(1,2)    # => 1,2


#===================================================================================#
# 创建 代码块对象 几种方法
object1 = Proc.new { |x| puts x + 1 }
object2 = proc { |x| puts x + 1 }
object3 = lambda { |x| puts x +1 }
object4 = ->(x) { puts x + 1 }  # -> 传递参数在{}外面
#object4 = -> { |x| puts x + 1}  PS: 不能这样写 

object1.call(2) # => 3
object2.call(2) # => 3
object3.call(2) # => 3
object4.call(2) # => 3


#===================================================================================#
# 块 传递 单层方法
# 1、方法中都不需 定义块参数
# 2、呼叫块 直接 yield
def m(x) 
  yield(x) 
end

m(3) { |x| puts "x = #{x}"}
# => x = 3


#===================================================================================#
# 块 传递 多层方法
def m1(x)
  yield(x)
end

def m2(x,&block_object) # 传递多层时 须定义 块参数
  m1(x,&block_object)
end

m2(3) {|x| puts "x + #{x}"}
# => x + 3


#===================================================================================#
# 对象 与 块
# 只有块才能传递
# 对象只能执行
block_object = lambda {|x,y| puts "x: #{x}; y: #{y}"} # 对象

def m1(a,b)
  yield(a,b)
end

m1(1,2,&block_object) # &block_object 是 块（+ &符号）
# => x: 1; y: 2

def m2(&block_object)
  block_object        # 去掉& 变成 对象
end

m2(&block_object).call(2,3) # m2(&block_object) 后得到对象
# => x: 2; y: 3 


#===================================================================================#
# lambda VS proc
# 凡是lambda 创建的就是 lambda 
# 其它全为proc
# 区别一： return
def lambda_test
  block_object = lambda { return 'lambda return'}
  block_object.call     
  'method end'      # lambda 会执行到代码结束 
end

def proc_test
  block_object = proc {return 'proc retrun'}
  block_object.call # proc 对象会 立即返回
  'method end'      # 不执行
end

puts lambda_test
# => method end
puts proc_test
# => proc retrun

def proc_outside_test
  yield        # 进入方法中 不能回到 顶层作用域 所以会报错
end

proc_block_object = proc { return 'proc outside block' }
proc_outside_test # 会报错 proc 的返回 只是能是定义块的地方 
# => LocalJumpError


#===================================================================================#
# lambda VS proc
# 区别二： 参数校验
# 1、lambda 严格校验
# 2、proc 可多可少
# PS: 基于lambda 严格校验参数 和 return返回特性 多用lambda
lambda_object = lambda {|a,b,c| puts a.to_i + b.to_i + c.to_i}
proc_object   = proc {|a,b,c| puts a.to_i + b.to_i + c.to_i}

#lambda_object.call(1,2) # lambda 严格校验参数
# => ArgumentError (given 2, expected 3)

proc_object.call(1,2)     # 参数不够 nil
# => 3  a = 1 b = 2 c = nil 
proc_object.call(1,2,3,4) # 参数多 舍弃
# => 6  a = 1 b = 2 c = 3 


#===================================================================================#
# 方法对象
class A
  def initialize(a)
    @x = a
  end

  def my_method
    puts @x
  end
end

object = A.new(3)
# 方法 变成 方法对象
method_object = object.method :my_method
# 类似于 块的 呼叫
method_object.call
# => 3

# 一般情况下，独立出方法对象 都会用到define_method中
A.send :define_method,:p,method_object # 这send 接受方法对象
object.p
# => 3


#===================================================================================#
# 方法对象 中的 自由方法
module B
  def module_method
    puts "module method"
  end
end

# 获取自由方法（从模块中独立出的自由方法 可用于任何对象，而从类中独立出的 只能用于其子类）
method_object = B.instance_method(:module_method)
puts method_object.class
# => UnboundMethod 自由方法

String.send :define_method, :hu, method_object
"sdas".hu
# => module method