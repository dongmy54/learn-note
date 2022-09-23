######################################################################################
# 通用版本
# PS：中规中矩不多做评论
def hu(a, b = 'b', c = {})
  puts "a: #{a.inspect}; b: #{b.inspect}; c: #{c.inspect}"
end

hu('a', 'b')
# a: "a"; b: "b"; c: {}


######################################################################################
# *arg —— 传入当作数组处理
# PS: 可以
def hu(*arg)
  puts "arg: #{arg}"
end

hu # 啥也不传为[]
# arg: []

hu('a', 'b', {c: 'sd'})
# arg: ["a", "b", {:c=>"sd"}]

#----------- 常用场景：开始-----------#
class Hu
  attr_accessor :name

  def initialize(*arg)
    opts = extract_options!(arg)
    @name = opts.shift
    # 这里根据opts中键值做些处理..省略
  end

  # 取尾部hash
  def extract_options!(array)
    array.last.is_a?(::Hash) ? array.pop : {}
  end
end
#----------- 常用场景：结束-----------#


######################################################################################
# **arg -- 传入hash
# PS: 显示的说明此处传入hash
def hu(**arg)
  puts "arg: #{arg}"
end

hu # 啥也不传
# arg: {}

hu(a: 'a', b: 'b', c: 'cc')
# arg: {:a=>"a", :b=>"b", :c=>"cc"}

#----------- 常用场景：开始-----------#
# 最后一个参数是hash
def hu(a, b, **c)
  puts "a: #{a}; b: #{b}; c: #{c}"
end
#----------- 常用场景：结束-----------#


######################################################################################
# a: 我把它叫做冒号写法
# 1. 传入的是hash
# 2. 相比于 **arg写法；清楚的标注了key情况（支持？是否必填）可读性也较高
# 3. 相比于(a, b = 'b', c = {}) 传统写法；参数顺序更灵活
# PS：推荐多用
def hu(a:, b: 'b', c: nil)
  puts "a: #{a}; b: #{b}; c: #{c}"
end

hu  # 如果没有默认值则必填
# ArgumentError: missing keyword: a

hu(a: 'a', d: 'd') # 多传了key直接不支持
# ArgumentError: unknown keyword: d

hu(b: 'a', a: 's')   # 由于传入的是hash所以顺序无所谓
# a: s; b: a; c:

hu(b: 'a', a: 's', c: {a: 'sd'}) # hash嵌套也是可以的
# a: s; b: a; c: {:a=>"sd"}


