# 1. 它是线程安全的
# 2. 如果我们直接join 一个线程内部（queue.pop)会报死锁，所以不能用于阻塞主线程的情况

queue = Queue.new

puts queue.size   # 0
puts queue.empty? # true
puts queue.pop    # 空队列会报错(PS: 线程中不会)
# No live threads left. Deadlock? (fatal) 

queue << 'first'
queue << 'second'
queue << 'third'
puts queue.size     # 2
puts queue.empty?   # false
puts queue.pop
# first
puts queue.pop
# second

queue.clear
puts queue.empty?  # true

queue << 'sdaf'
queue.close
queue.closed?  # true

puts queue.pop # close后仍可pop 
# sdaf
queue << 'saf' # close后不可追加
# queue closed (ClosedQueueError)


# 限制队列长度可用
queue = SizedQueue.new(3)
queue.max # 最大长度
# => 3

