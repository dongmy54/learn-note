# 利用异常处理来赋值
b = a rescue nil
# b 会 为nil


#===================================================================================#
# ensure 返回
# 并不会返回其中处理
def test
  a = 2
ensure
  b = 3   # ensure中的内容不会返回
end

test 
# => 2


#===================================================================================#
# message 信息 
# backtrace 路径
# 异常追溯 可以用在框架中，又不希望直接报错时
def t
  a = 3
  p(a)
rescue => e
  puts e.message
  puts "-------------------------"
  puts e.backtrace  # 追溯错误
end

def p(a)
  b = 2
  q(a,b)
end

def q(a,b)
  a + b + c
end

t
# undefined local variable or method `c' for main:Object    信息
# -------------------------
# test.rb:16:in `q'                                         路径
# test.rb:12:in `p'
# test.rb:3:in `t'
# test.rb:19:in `<main>'    