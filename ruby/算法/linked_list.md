##### linked_list
> 线性表
> 1. Node 单独出来（存储、前/后点）
> 2. LinkedList 操作节点（插入/删除）
> 3. 添加头/哨兵节点简化代码（始终有一个头节点）


##### 代码
```ruby
# 单链表
class LinkedList
  def initialize
    @head = Node.new('哨兵节点')
    # 一直都存在 可以简化代码
  end

  # 插入值
  def append(value)
    node = Node.new(value)
    find_tail.next = node
  end
 
  # 删除值
  def delete(value)
    node        = find_node(value)
    before_node = find_before(value)

    before_node.next = node.next if node
  end

  # 尾部节点
  def find_tail
    node = @head

    while(node) do
      return node if !node.next
      node = node.next
    end
  end

  # 查找节点
  def find_node(value)
    node = @head

    while(node) do
      return node if node.value == value
      node = node.next
    end
  end

  # 查找前一个节点
  def find_before(value)
    node = @head

    while(node && node.next) do
      return node if node.next.value == value
      node = node.next
    end
    false
  end

  # 展示所有节点
  def print
    if node = @head
      while(node) do
        node.to_s
        node = node.next
      end
    end
  end
end

class Node
  attr_accessor :next
  attr_accessor :value

  def initialize(value)
    @value = value
    @next  = nil
  end

  def to_s
    puts "current node value: #{value}"
  end
end

list = LinkedList.new

list.append(10)
list.append(20)
list.append(30)
list.append(40)

list.print
# current node value: 哨兵节点
# current node value: 10
# current node value: 20
# current node value: 30
# current node value: 40

list.delete(20)
list.delete(10)
list.delete(30)

list.print
# current node value: 哨兵节点
# current node value: 40
```