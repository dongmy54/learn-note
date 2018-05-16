# 利用异常处理来赋值
b = a rescue nil
# b 会 为nil


#===================================================================================#
# e.backtrace
# 异常追溯 可以用在框架中，又不希望直接报错时
def t
  a = 3
  p(a)
rescue => e
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
# test.rb:14:in `q'  从错误发生的行开始冒泡
# test.rb:10:in `p'
# test.rb:3:in `t'
# test.rb:17:in `<main>'