# 原理
# 1. 初始化固定数量线程 所有线程无限循环
# 2. 任务加入 jobs队列中
# 3. 线程从jobs中取出任务 并执行
# 4. ruby的Queue是线程安全的

class ThreadPool
  def initialize(size:)
    @size = size
    @jobs = Queue.new
    @pool = Array.new(size) do
      Thread.new do
        catch(:exit) do
          loop do
            job, *arg = @jobs.pop
            job.call(*arg)
          end
        end
      end
    end
  end

  # 加入任务
  def schedule(*arg, &block)
    @jobs << [block, *arg]
  end

  def shutdown
    @size.times do
      schedule {throw :exit}
    end
    
    @pool.each(&:join)
    puts '===============线程池成功关闭================='
  end
end

# 初始化线程池
pool = ThreadPool.new(size: 5) 

# 5次任务加入
5.times do |i|
  pool.schedule do
    sleep 1
    puts "第#{i}次执行"
  end
end

pool.shutdown


