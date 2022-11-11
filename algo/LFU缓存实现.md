#### LFU缓存实现
LFU其中f指的是频率，当到达缓存容量后，优先删除频率最低的缓存，相同频率的缓存删除，最久没用的；

其难点也在于频率上，具体实现到手次要，重要的是要学会分析问题，建立正确的数据及结构；

##### 分析
1. 由于需要根据key查val，O(1)复杂度，我们建立key->val hash表（KV表）
2. 当我们查询/更新某个key,我们需要增加某个key的频率，因此需要记录某个key的频率，我们建立key->freq hash表（KF表）
3. 当容量达到容量极限时候，我们需要删除最小频率的key,由于同一个频率对应多个key,方便我们查询我们建立 freq -> keys列表 hash表（FK表）；同时要保证keys列表的查询/删除/插入时间同样为O(1),我们选用LRU中构建的LinkHashMap数据结构
4. 由于我们需要，记住当前最小频率，而不是到时候遍历去查，我们实现记录，用一个字段记录

##### 实现
```ruby
# LFUCache
# 当容量满时候，按照谁使用频次进行删除；如果多个key对应频次相同，则按照最远未使用做删除
# 这里还是借用LRU算法里的数据结构 LinkHashMap来实现，频率->keys列表的的访问删除
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

# 链表hash
class LinkListHashMap
  attr_accessor :map, :list

  def initialize
    @map = {}  # key -> node
    @list = DoubleList.new
  end

  # 添加
  def add(key, val=nil)
    node = Node.new(key, val)
    @list.add(node)
    @map[key] = node
  end

  # 更新
  def update(key,val=nil)
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

  # 第一个key(便于LFU使用)
  def first_key
    first = @list.head.next
    first.key
  end

  # 是否存在
  def exists?(key)
    @map.keys.include?(key)
  end

  def size
    @list.size
  end
end


class LFUCache
  attr_accessor :key_to_val, :key_to_freq, :freq_to_keys, :capacity, :min_freq

  def initialize(capacity)
    @key_to_val   = {} # key -> val
    @key_to_freq  = {} # key -> freq 频率
    @freq_to_keys = {} # 频率 -> keys列表（这里用LinkListHashMap实现)
    @capacity     = capacity # 容量
    @min_freq     = 0 # 当前最小频率
  end

  def get(key)
    if key_exists?(key)
      increase_freq(key)
      @key_to_val[key]
    else
      -1
    end
  end

  def put(key, val)
    if key_exists?(key)
      # 更新KV
      @key_to_val[key] = val
      increase_freq(key)
    else
      if self.capacity <= size
        remove_min_freq_key
      end

      # 更新kV
      @key_to_val[key] = val
      # 更新KF
      @key_to_freq[key] = 1
      # 更新FK
      add_or_update_fk(1,key)
      # 更新min_freq
      self.min_freq = 1
    end
  end

  private
  # key是否存在
  def key_exists?(key)
    @key_to_val.keys.include?(key)
  end
  
  # 增加某个key使用频次
  def increase_freq(key)
    freq = @key_to_freq[key]
    # 更新KF频次
    @key_to_freq[key] = freq + 1    
    # 更新FK
    key_list = @freq_to_keys[freq]  # 频率键列表
    key_list.remove(key)            # 删除旧频率对应list中key
    if key_list.size == 0 # 如果删除key后，list为空
      @freq_to_keys.delete(freq) # 删除旧频率

      if freq == @min_freq # 刚好等于最低频率（只有当为key_list为空时需要做此判断，不空没影响）
        @min_freq += 1 
      end
    end
    # 添加新的频率(freq+1)到FK
    add_or_update_fk(freq+1,key)
  end

  # 添加or更新fk
  def add_or_update_fk(freq,key)
    if @freq_to_keys.keys.include?(freq)
      key_list = @freq_to_keys[freq]
      key_list.add(key)
    else
      list = LinkListHashMap.new
      list.add(key)
      @freq_to_keys[freq] = list
    end
  end

  # 移除最小频率key
  def remove_min_freq_key
    key_list = @freq_to_keys[self.min_freq]
    delete_key = key_list.first_key
    # 更新kV
    self.key_to_val.delete(delete_key)
    # 更新kF
    self.key_to_freq.delete(delete_key)
    # 更新FK
    key_list.remove(delete_key)
    if key_list.size == 0 # 删除key后空了
      @freq_to_keys.delete(self.min_freq)
      # 需要更新min_freq?
      # PS: 由于只有在新增的时候才会触发remove_min_freq_key,而新增key,min_freq 为1，
      # 所以没必要更新，即使更新那么只能遍历，时间复杂度也就上去了
    end
  end

  # 当前容量
  def size
    @key_to_val.keys.size
  end

end
```
