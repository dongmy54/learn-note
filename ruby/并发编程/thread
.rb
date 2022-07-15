# 线程一旦创建,当cpu资源有空闲时，自动后台执行
# 所以执行过程是异步

# 结构关系
# 线程1 # 正在执行
# Thread.new do
#   # 线程2 
# end
# 线程1 # 正在执行


###########################################################################
# 线程 异步的
hu = 1
a = Thread.new{hu += 1}
b = Thread.new{hu += 2}

puts hu 
# 1



###########################################################################
# 1. 会阻塞主线程的执行，等子线程执行完
# 2. [线程1，线程2].all(&:join)多个线程join,是多个线程并发执行，并非线程1执行完、线程2执行
# 3. 由第二点知道，阻塞主线程的时间，是由耗时最长的线程决定的
thrs = []
10.times do |i|
  thrs << Thread.new do
    sleep 10
    puts "我是子线程：#{i}"
  end
end

thrs.each(&:join) # 1. 阻塞主线程 2. 多个线程同时执行

puts "======等子线程执行完我才执行======"
# 我是子线程：9
# 我是子线程：1
# 我是子线程：2
# 我是子线程：3
# 我是子线程：4
# 我是子线程：5
# 我是子线程：7
# 我是子线程：6
# 我是子线程：0
# 我是子线程：8
# ======等子线程执行完我才执行======


# join 多个线程同时执行
def func1
  i = 0
  while i <= 2
    puts "func1当前执行时间：#{Time.now}"
    i +=1
    sleep 2
  end
end

def func2
  j = 0
  while j <= 2
    puts "func2当前执行时间：#{Time.now}"
    j += 1
    sleep 1
  end
end

puts "========开始执行多线程#{Time.now}=========="
a = Thread.new{func1}
b = Thread.new{func2}

a.join
b.join
puts "========结束多线程#{Time.now}============="

# ========开始执行多线程2019-11-18 10:52:05 +0800==========
# func1当前执行时间：2019-11-18 10:52:05 +0800
# func2当前执行时间：2019-11-18 10:52:05 +0800
# func2当前执行时间：2019-11-18 10:52:06 +0800
# func1当前执行时间：2019-11-18 10:52:07 +0800
# func2当前执行时间：2019-11-18 10:52:07 +0800
# func1当前执行时间：2019-11-18 10:52:09 +0800
# ========结束多线程2019-11-18 10:52:11 +0800=============



###########################################################################
# main/current 主/当前线程
puts "主线程：#{Thread.main}"
puts "当前线程：#{Thread.current}"

a = Thread.new do
  puts "当前线程：#{Thread.current}"
  puts "主线程：#{Thread.main} <无论什么地方主线程不变>"
end

a.join
# 主线程：#<Thread:0x007fb2ea8672a8>
# 当前线程：#<Thread:0x007fb2ea8672a8>
# 当前线程：#<Thread:0x007fb2eb02da78>
# 主线程：#<Thread:0x007fb2ea8672a8> <无论什么地方主线程不变>



###########################################################################
# Thread.current[:xx] 线程变量
a = Thread.new do
  Thread.current[:name] = '我只是一个线程'
end

a.join
puts "a[:name] 是 #{a[:name]}"
puts "a[:age] 是 #{a[:age]} "
# a[:name] 是 我只是一个线程
# a[:age] 是



###########################################################################
# 线程状态
# PS：stop 也是sleep
a = Thread.new{sleep 10}
b = Thread.new{Thread.stop}
c = Thread.new{1_000.times {puts i}}

puts c.status # run
puts a.status # sleep
puts b.status # sleep



###########################################################################
# 线程是否活着
a = Thread.new{sleep 10}
b = Thread.new{puts '我执行了'}

a.alive?
# true
b.alive?
# false



###########################################################################
# 线程列表
# 1. 返回当前所有活着的线程
# 2. 返回的是数组
a = Thread.new do 
  Thread.current[:name] = 'A线程'
  sleep 10
end
b = Thread.new {Thread.current[:name] = 'B线程'}

Thread.list # 此时B线程已经死了
# => [#<Thread:0x00007fd77686f2b8 run>, #<Thread:0x00007fd7768444a0@(irb):9 sleep>]

# 重新找到A线程
Thread.list.find{|thr| thr[:name] == 'A线程'}
# => #<Thread:0x00007fd7768444a0@(irb):2 sleep>



###########################################################################
# value 线程块返回值
# PS: 线程未执行完会等待
a = Thread.new do
  sleep 3
  3 + 1
end

puts a.value # 会等待3s
# 4



###########################################################################
# priority 优先级
count1 = 1
a = Thread.new do
  loop do
    count1 += 1
  end
end

count2 = 1
b = Thread.new do
  loop do
    count2 += 1
  end
end

a.priority = -1 # 优先级 比b高
b.priority = -2 # 优先级 比a低

sleep 2 # 等2s后 查看执行状态
a.kill  # 终止
b.kill  # 终止

puts "count1: #{count1}"  # count1 更多机会增加
puts "count2: #{count2}"  # count2 机会相对更少
# count1: 26474824
# count2: 24547794



###########################################################################
# 默认 Thread.abort_on_exception = false 
# 默认：线程后台执行异常 不会中断外层线程
first_thr = Thread.new do
  puts "第一层线程执行开始"
  nesting_thr = Thread.new {raise '子线程错误'} # 不会中断外层线程
  sleep 1 # 给子线程后台执行时间
  puts "第一层线程执行结束"
end

first_thr.join
# 第一层线程执行开始
# 第一层线程执行结束


# abort_on_exception 控制线程异常
# PS：即是类方法也是实例方法
Thread.abort_on_exception = true # 线程异常中止外层
first_thr = Thread.new do
  puts "第一层线程执行开始"
  nesting_thr = Thread.new {raise '子线程错误'} 
  sleep 1 # 给子线程后台执行时间
  puts "第一层线程执行结束"
end

first_thr.join
# 第一层线程执行开始
# t3.rb:4:in `block (2 levels) in <main>': 子线程错误 (RuntimeError)









