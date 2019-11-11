#===================================================================================#
# freeze 冻结不可变
# 1. 字符串、数组、hash都可用
# 2. 减少内存分配
# 3. hash中字符串，自带冻结
str = 'hello'.freeze
str[0] = 'q'      # RuntimeError: can't modify frozen String
str << 'sd'       # RuntimeError: can't modify frozen String

arr = [1,3,9].freeze
arr[0] = 'cdf'    # RuntimeError: can't modify frozen Array
arr << 'we'       # RuntimeError: can't modify frozen Array

hash = {a: 1,b: 2}.freeze
hash[:a] = 'gy'   # RuntimeError: can't modify frozen Hash

person = {'zhangsan' => {id: 1,age: 18}, 'lisi' => {id: 2, age: 24}}
person.keys.first.frozen?  # => true




#===================================================================================#
# clone VS dup
# 1. 都是浅层复制
# 2. clone克隆的更彻底（冻结状态、单例方法）
hash = {a: 1, b: 2}.freeze

hash2 = hash.clone
hash2[:a] = '3'      # RuntimeError: can't modify frozen Hash

hash3 = hash.dup
hash3[:a] = '3'      # => => "3"

# 单例方法dup不能复制
temp_obj = Object.new

def temp_obj.foo
  puts 'hello'
end

obj1 = temp_obj.clone
obj1.foo            # hello

obj2 = temp_obj.dup
obj2.foo            # NoMethodError: undefined method `foo' for #<Object:0x007fa3dc044930>



#===================================================================================#
# 污染对象
# ruby 会把从外界获取的值 自动标为污染对象
# tainted? 是否为污染
# untaint  解除污染 
print "input a value: "
a = gets.chomp

puts a.tainted?  # => true

a.untaint

puts a.tainted?  # => false



#===================================================================================#
# __method__ 当前方法名
# PS: 私有方法
def hu
  puts __method__
end

hu
# hu



#===================================================================================#
# caller 调用堆栈数组
# 第一个参数：从多少层堆栈开始
# PS: 私有方法
def method_a
  puts caller(0).inspect
end

def method_b
  method_a
end

def method_c
  method_b
end

method_c
# [
#  "t2.rb:11:in `method_a'", 
#  "t2.rb:15:in `method_b'", 
#  "t2.rb:19:in `method_c'", 
#  "t2.rb:22:in `<main>'"
#]

