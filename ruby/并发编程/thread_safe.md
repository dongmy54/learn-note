##### 线程安全
> 1. GIL: 全局解释锁，由于GIL的存在，同一进程的多个线程，必须要获取到GIL锁才能执行；而锁只有一把，所以同一时刻，只会有一个线程在运行，可以做到并发；但是不能做到并行；
> 2. 由于多线程并发执行，而对共享变量的操作非原子操作（底层：会有多个指令），在中途存在离开cpu的情况，当再次回来，原共享变量值已发送变化，所以非线程安全
> 3. 在demo1中，看似没问题，是因为cpu对于io密集型任务，尽量让其执行（不离开cpu)
> 4. 在demo2中，加入了一句 `print`后，相当于io操作，cpu会切换线程，所以可以很明显的看到，线程不安全


###### demo1
```ruby
# demo1
counter = 0
10.times.map do
  Thread.new do
    tmp = counter + 1
    counter = tmp
  end
end.each(&:join)

puts "counter: #{counter}"
# counter: 10 
```

###### demo2
```ruby
# demo2
counter = 0
10.times.map do
  Thread.new do
    tmp = counter + 1
    print "*"
    counter = tmp
  end
end.each(&:join)

puts "counter: #{counter}" # PS: 由于线程非安全，这里的值可能每次都一样
# **********counter: 1
```

###### 互斥锁
```ruby
# 加锁-确保线程安全
# 同一时刻只允许一个线程，进入临界区
mutex = Mutex.new
counter = 0
10.times.map do
  Thread.new do
    mutex.synchronize do
      ################# 临界区 ################
      tmp = counter + 1
      print "*"
      counter = tmp
      ################# 临界区 ################
    end
  end
end.each(&:join)

puts "counter: #{counter}"
# **********counter: 10
```


