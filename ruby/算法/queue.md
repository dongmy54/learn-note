#### queue 队列
> 1. ruby 已经实现了队列
> 2. 关键点（head、tail、count-数量、capacity-容量、enqueue-入队、dequeue-出队）

##### 代码
```ruby
# 用数组实现简单队列
class MyQueue
  attr_accessor :elements # 队列中元素数组
  attr_accessor :capacity # 容量
  
  def initialize(capacity)
    @elements = []
    @capacity = capacity
  end

  # 入队
  def enqueue(value)
    raise '队列已满，当前不能入队' if self.capacity == self.count
    self.elements << value
  end

  alias_method :"<<", :enqueue

  # 出队
  def dequeue
    return nil if empty?
    self.elements.shift
  end

  # 数量
  def count
    elements.count
  end

  # 为空？
  def empty?
    elements.empty?
  end

  # 展示
  def print
    elements.each do |e|
      puts e.inspect
    end
  end
end

begin
  queue = MyQueue.new(3)
  queue << 5
  queue << 3
  queue << 1
  queue.print
  queue << 0
rescue RuntimeError => e
  puts "错误：e.message"
end

# 5
# 3
# 1
# 错误：e.message
```


