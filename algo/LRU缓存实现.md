#### LRU缓存
要求：
1. 任何时候存入、删除、获取缓存,时间复杂度都是O(1)
2. 当缓存到达最大容量时候，优先删除最近最少使用的缓存
3. 每次获取键，那么就会标记为最近使用

##### 思考
存入、删除、获取键要求时间复杂度为O（1），hash就可以满足；但是在获取一个键的时候，标记为最近使用，其实也就是这些键得有顺序，每次获取、添加的时候，都要满足有序性；

而hash是无序的，链表可以实现，键之间的顺序；但是时间复杂度达不到O(1),因此我们采用结合hash和链表的方式实现；

具体也就是，在hash中映射键到结点，然后通过结点的双向指针进行操作

##### 实现
 PS：这里最重要的是要明确每个类他们的职责是什么；需要些什么方法

```ruby
### LRU算法
# 最近最少使用被移除
# 数据结构采用 链表、hash的结合体——链表hash
# 链表采用双向链表
class Node
  attr_accessor :key, :val, :prev, :next

  def initialize(key,val)
    @key = key
    @val = val
  end
end

# 双向链表
class DoubleList
  attr_accessor :head, :tail, :size

  def initialize
    @head = Node.new(nil, nil)
    @tail = Node.new(nil, nil)
    @head.next = @tail
    @tail.prev  = @head
    @size = 0
  end

  # 添加-加到尾部
  def add(node)
    # node自己指针
    node.prev = self.tail.prev
    node.next = self.tail
    # node前结点指针
    node.prev.next = node
    # 尾部指针
    self.tail.prev = node
    @size += 1
  end

  # 删除
  def remove(node)
    node.prev.next = node.next
    node.next.prev = node.prev
    @size -= 1
  end
end

# 链表hash-中间抽象出一个数据结构以达到时间复杂度要求
class LinkListHashMap
  attr_accessor :map, :list

  def initialize
    @map = {}  # key -> node
    @list = DoubleList.new
  end

  # 添加
  def add(key, val)
    node = Node.new(key, val)
    @list.add(node)
    @map[key] = node
  end

  # 更新
  def update(key,val)
    node = @map[key]
    node.val = val
  end

  # 删除
  def remove(key)
    node = @map[key]
    @list.remove(node)
    @map.delete(key).val
  end

  # 获取
  def get(key)
    @map[key].val
  end

  # 删除第一个
  def remove_first
    first = @list.head.next
    remove(first.key) if first != @list.tail
  end

  # 是否存在
  def exists?(key)
    @map.keys.include?(key)
  end

  def size
    @list.size
  end
end

# LRU
class LruCache
  attr_accessor :capacity, :cache

  def initialize(capacity = 5)
    @capacity = capacity
    @cache    = LinkListHashMap.new
  end

  def put(key, val)
    if @cache.exists?(key) # 存在直接更新
      @cache.update(key,val)
    else
      # 不存在新增
      if beyond_capacity?
        remove_least_recently
        @cache.add(key,val)
      else
        @cache.add(key,val)
      end
    end
  end

  def get(key)
    if @cache.exists?(key)
      make_recently(key)
      @cache.get(key)
    else
      nil
    end
  end

  private
  # 标记为最近使用
  def make_recently(key)
    val = @cache.remove(key)
    @cache.add(key,val)
  end

  # 移除最少使用
  def remove_least_recently
    @cache.remove_first
  end

  # 达到容量极限
  def beyond_capacity?
    cache.size >= @capacity
  end
end


################## 使用 #################
cache = LruCache.new(3)
cache.put('a', '12')
cache.put('b', '23')
cache.put('c', '45')

cache.get('a')
# => "12"
cache.get('b')
# => "23"
cache.get('c')
# => "45"
cache.put('a', '8')
# => "8"
cache.get('a')
# => "8"
cache.cache.size
# => 3
cache.put('d', 'sd')
cache.get('b')
# => nil
```






