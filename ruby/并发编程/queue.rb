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
