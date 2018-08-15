# 块的本质：
# 1、打包代码，以后执行
# 2、作为函数变量（可赋值 可传方法）
# PS: 块不是对象


#===================================== block/proc/lambda ==========================#
#====================== block ===================#
# 1、do..end {} 两种创建块方式
# 2、块不能单独存在 只能寄生于 proc/lambda对象
# 3、方法末尾的块 会被转换为proc 对象
3.times do
  puts 'hello'
end
# hello
# hello
# hello

3.times { puts 'hello'}
# hello
# hello
# hello

[1,3,6].each do |x|
  puts x
end
# 1
# 3
# 6

[1,3,6].each {|x| puts x}
# 1
# 3
# 6

a = {puts 'hello'}   # 块不能单独 存在
# syntax error, unexpected tSTRING_BEG, expecting keyword_do or '{' or '('


#====================== proc ==========================#
# 1、它是 对象
# 2、由 Proc.new + 块 产生
p = Proc.new {puts 'qwert'}
p.call
# qwert


#====================== lambda =========================#
# 1、它是 对象
# 2、由 lambda + 块 产生
# 3、等价 写法 ->
l = lambda {puts 'sdfg'}
l.call
# sdfg

l = -> {puts 'sdfg'}     # ->  <=> lambda 写法
l.call
# sdfg

l = ->(x) {puts 'asd'}   # 注意传参位置 -> {|x| puts 'asd'} ❌
l.call('p')
# asd


#================ lambda/proc 调用 =======================#
# 四种：
# 1、call (推荐)
# 2、[]
# 3、()
# 4、===
l = lambda {|x| puts "x: #{x}"}

l.call(2)      # x: 2
l[2]           # x: 2
l.(2)          # x: 2
l.===(2)       # x: 2


#====================== proc VS lambda ===================#
# 相同： 同属于 Proc
# 不同：
# 1、proc 不验证参数 lambda 验证
# 2、方法中定义的块：proc 会退出 整个方法
# PS: lambda 更接近一个方法，推荐使用 
p = Proc.new {|x,y| puts "x: #{x};y: #{y}"}
l = lambda {|x,y| puts "x: #{x};y: #{y}"}

# ========同类
p.class      
# => Proc
l.class              # lambda 属 Proc
# => Proc

# =========参数
p.call()             # proc 不验证 参数(没有：nil,多：忽略)
# x: ;y:
l.call()             # lambda 验证            
# wrong number of arguments (given 0, expected 2) (ArgumentError)

# =========return
def proc_test
  puts "这是proc_test"
  p = Proc.new {return "proc会整个退出方法"}
  p.call
  puts "这句不会执行"
end

def lambda_test
  puts "这是lambda_test"
  l = lambda {return "lambda 不会退出方法"}
  l.call
  puts "这句会执行"
end

proc_test
# 这是proc_test
# 这是lambda_test
lambda_test
# 这句会执行



#===================================== yield =====================================#
# 1、yield 会捕获 方法末尾/最后参数 块
# 2、yield 快捷 调用块
# 3、常与 block_given? 配合
def test1
  yield
end

test1 do                # 末尾 块
  puts 'test1 yield'
end
# test1 yield

def test2(a,&block)
  yield
end

block = lambda {puts 'test2 yield'} 
test2('a',&block)       # 最后参数 块
# test2 yield

def test3
  yield if block_given? # 是否有块
end

test3
test3 {puts 'test3 yield'}
# test3 yield



#===================================== 闭包特性 ====================================#
# 1、可以绑定外部作用域 变量
# 2、但外部 不能获取块 内部变量(局部)
def test(x,&block)
  yield(x)
end

number = 10
l = lambda do |x|
  puts x * number     # 引用外部 number
  a   = 3             # 内部定义 局部变量
  @hu = 4             # 内部定义 实例变量 
  $h = 2
end

test(2,&l)
# 20
puts @hu
# 4
puts a   # 不能获取 块内局部变量
# undefined local variable or method `a' for main:Object (NameError)



#===================================== 方法中 ========================================#
# ======= test(block) VS test(&block) ===========#
# 1、既可以传 对象(proc/lambda) 也 可传块
# 2、&block 含义： 对象 转 块
# 3、参数中 &block 表示 明确接收块
# PS: 传对象时  block_given? 方法为 false
def test1(block)
  block.call
end

l1 = lambda {puts 'test1'}
test1(l1)
# test1

def test2(&block)
  block.call
end

l2 = lambda {puts 'test2'}
test2(&l2)
# test2



#===================================== 类似 ===============================================#
# 方法对象 类似 块对象
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




