# 测量不同代码执行时间

def fib(n)
  return n if n == 0 || n == 1
  fib(n-1) + fib(n-2)
end

def fast_fib(n, men={})
  return n if n == 0 || n == 1
  men[n] ||= fast_fib(n-1, men) + fast_fib(n-2, men)
end

require 'benchmark'

n = 50_000 # 等价于 50000

Benchmark.bm do |benchmark|

  benchmark.report('fib') do
    n.times do 
      fib(12)
    end
  end

  benchmark.report('fast_fib') do
    n.times do
      fast_fib(12)
    end
  end
end

# 结果 执行代码时间                        实际时间
#       user     system      total        real
# fib  1.080000   0.010000   1.090000 (  1.081766)
# fast_fib  0.250000   0.000000   0.250000 (  0.261164)



