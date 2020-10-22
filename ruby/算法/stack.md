#### stack 栈
> 1. 栈的实现相对较简单，利用ruby自带的数组（push/pop）就可以
> 2. 利用链表实现（关键在于栈首first)


##### 代码实现
```ruby
module LinkedList
  class Node
    attr_accessor :value
    attr_accessor :next

    def initialize(value, node)
      @value = value
      @next  = node
    end
  end

  class Stack
    attr_accessor :first   # 栈首
    attr_accessor :length  # 栈长度

    def initialize
      @first = nil
      @length = 1
    end

    def push(value)
      @first = Node.new(value, @first) # 好好理解
      @length += 1
    end

    alias_method :"<<", :push

    def pop
      raise '栈已经空了' if is_empty?
      value = @first.value
      @first = @first.next
      @length -= 1
      value
    end

    def is_empty?
      @first.nil?
    end

  end
end


stack = LinkedList::Stack.new
stack << "这"
stack << "是"
stack << "我"
stack << "的"
stack << "栈"

puts "当前栈长度: #{stack.length}"
begin
  puts stack.pop
  puts stack.pop
  puts stack.pop
  puts stack.pop
  puts stack.pop
  puts stack.pop
rescue RuntimeError => e
  puts "错误：#{e.message}"
end

# 当前栈长度: 6
# 栈
# 的
# 我
# 是
# 这
# 错误：栈已经空了
```



