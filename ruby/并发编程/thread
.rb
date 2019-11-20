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
# join 让线程同步(与外层)
hu = 1

a = Thread.new{hu += 1}
b = Thread.new{hu += 2}

a.join
b.join
puts hu 
# 4


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


# join 暂停主线程
a = Thread.new {puts "我是a线程"}
b = Thread.new {puts "我是b线程"}

a.join
puts "当线程join时，主线程被暂停，所以我最后才执行"
b.join

# 我是a线程
# 我是b线程
# 当线程join时，主线程被暂停，所以我最后才执行



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









