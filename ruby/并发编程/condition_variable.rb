# 1. 条件变量是对互斥的一种补充，它强调的是顺序执行，目的是一个动作在另外一个动作执行之后，再执行
# 2. 解决什么问题：生产者-消费者模型中，消费者需要一直轮训（是否有任务需要处理的情况，性能低下）
# 2. 原理：需要等待资源时，线程进入睡眠状态，当资源释放时，线程再次被唤醒
# 4. 由于对资源的修改需要保证线程安全，因此搭配互斥锁一起使用
# PS：同queue一样这里需要注意，如果join线程的话，会导致死锁哦


mutex = Mutex.new
resource = ConditionVariable.new

th1 = Thread.new do 
  mutex.synchronize do 
    puts "线程1开始执行，现在等待资源释放...."
    resource.wait(mutex) # 互斥作为参数
    puts "线程1继续执行............."
  end
end

th2 = Thread.new do
  mutex.synchronize do
    puts "线程2开始执行......."
    resource.signal # 释放信号-不需要参数
    puts "线程2释放了资源..........."
  end
end

sleep 2 # 延时下确保看到输出

# 线程1开始执行，现在等待资源释放....
# 线程2开始执行.......
# 线程2释放了资源...........
# 线程1继续执行.............





