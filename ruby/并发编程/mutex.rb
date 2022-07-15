###########################################################################
# 资源竞争
# 同一时间 多个线程访问同一资源
@is_executed = false
def hu
  unless @is_executed
    puts '我正在执行'
    @is_executed = true
  end
end

threads = []
10.times do
  threads << Thread.new{hu}
end

threads.each(&:join) # 这里输出条数是变化的
# 我正在执行



###########################################################################
# synchronize 加锁
@is_executed = false
@mutex       = Mutex.new

def hu
  # synchronize 过程
  # 1. 加锁
  # 2. 执行块中内容
  # 3. 释放锁
  @mutex.synchronize do
    unless @is_executed
      puts '我正在执行'
      @is_executed = true
    end
  end
end

threads = []
10.times do
  threads << Thread.new{hu}
end

threads.each(&:join) # 下方输出仅唯一一次
# 我正在执行





