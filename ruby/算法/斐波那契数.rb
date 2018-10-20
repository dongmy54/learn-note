# n = 0  0
# n = 1  1
# f(n) = f(n-1) + f(n-2)

# 法一
# 关键自调用
def fib(n)
  return n if n == 0 || n == 1
  f(n-1) + f(n-2)
end

# 法二
# 关键：1、自调用 2、缓存值
def fast_fib(n, men={})
  return n if n == 0 || n == 1
  men[n] ||= fast_fib(n-1) + fast_fib(n-2)
end