# 函数限制次数 自我调用
def m(x,limit = 6)
  raise ArgumentError,'调用次数太多' if limit == 1
  
  return puts x*2 if x % 3 == 2
  m(rand(1000),limit -1)    # 自我调用 次数 -1
end

m(258)
# => 604