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