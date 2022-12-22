##### redis
> 一个高性能的键值存储数据库，一般用作缓存

##### 为什么比较快？
> 1. 操作的是内存
> 2. 许多操作时间复杂度都是O(1)
> 3. 利用了IO多路复用(一个线程对应多个socket)
> 4. 工作线程是单线程，线程间上下文切换的开销小

##### redis是单线程么
> 1. 在 6.0以前是完全的单线程
> 2. 6.0开始对于io的处理改成了多线程，但工作线程（命令的处理）始终是单线程

##### 安装及启动
```
brew install redis    安装
brew uninstall redis  卸载

redis-server          启服务
redis-cli             进入console
```

##### 日志
`tail -f /var/log/redis/redis-server.log -n 100`

##### 共用console命令
```
keys *              # 列出所有key
flushall            # 清除所有key

ttl mykey           # 键剩余时间（s) 
# -1 未设置过期时间
# -2 已经过期
# 正数 剩余秒
expire mykey 10     # 设置过期时间
del mykey           # 删除key
exists mykey        # key 是否存在
```

##### 常用数据类型
> 1. string-字符串（用于存储简单的键值对数据，比如某款商品的销量）
> 2. hash （适合用于存储对象数据比如商品对象）
> 3. set - 集合（适合存储不重复的多个对象）
> 4. list - 列表（适合用于队列操作，这里元素可以重复）
> 5. sort set - 有序集合（适合存储不重复且要求排序的对象，比如学生根据成绩排序）

PS:
> - 同一个key，在某种类型中用了，就不能再其它类型再此使用
> - redis还支持一些其它的数据类型


##### string 命令
```
set product_1_sales_num 88        # 设置商键值
# OK
set product_1_sales_num 88 ex 60  # 设置键同时设置过期时间 60s
# OK
get product_1_sales_num           # 获取键值
# 88


setnx ic_card_uuid 1              # 如果键不存在才设值
# 1
setnx ic_card_uuid 1              # 第二次不会覆盖第一次的值
# 0
get ic_card_uuid
# 1


incr product_1_sales_num          # 单次增销量
# 1
incrby product_1_sales_num 2      # 指定数量增加
# 3


set product_1_amount 85.5         
# OK
incrbyfloat product_1_amount 2.8  # 增加浮点数
# 88.3


decr product_1_sales_num          # 单减
# 2
decrby product_1_sales_num 2      # 指定数量减少
# 0


set user_1_view_times 86
# OK
getset user_1_view_times 0        # 获取值同时将值置为空
# 86


mset key1 val1 key2 val2          # 一次设置多个键值对
# OK
mget key1 key2                    # 一次获取多个键对应值
# val1
# val2
```

##### hash
```
hset user_1 name 张三            # 设置name字段值
# 1
hset user_1 age 18              # 设置age字段值（PS:一次只能设置一个字段）
# 1
hget user_1 name                # 获取键对应字段值
# 张三
hgetall user_1                  # 获取键所有字段-属性
# name
# 张三
# age
# 18


hmset user_2 name 王武 age 18    # 一次设置多个属性对（PS: 一般m代表多）
# OK
hgetall user_2
# name
# 王武
# age
# 18


hkeys user_1                    # 获取键对应的所有字段
# name
# age
hvals user_1                    # 获取键对应的所有值
# 张三
# 18


hdel user_1 name                # 删除某一个字段
# 1
hexists user_1 name             # 检查键字段存在
# 0
hkeys user_1 
# age
```


##### set 集合命令
```
sadd myset a                    # 一次添加一个元素
# 1
sadd myset b c d                # 一次添加多个元素
# 3
smembers myset                  # 集合中所有成员
# 1) "d"
# 2) "c"
# 3) "b"
# 4) "a"
srem myset d                    # 从集合中删掉元素
# 1
smembers myset 
# 1) "c"
# 2) "b"
# 3) "a"
# scard myset                     # 元素个数
# (integer) 3

sismember myset f               # 判断集合中是否有xx元素
# 0 
sismember myset a
# 1

sadd myset1 a b c f
# 4
sdiff myset1 myset              # 集合求差（myset1 - myset)
# 1) "f"
sdiffstore myset2 myset1 myset  # 不同的存储下来
# 1
smembers myset2
# 1) "f"

sadd myset3 a b c
sadd myset4 a b
sinter myset3 myset4            # 集合求交集
# 1) "b"
# 2) "a"
sinterstore myset5 myset1 myset # 集合求交存储
# 3
smembers myset5 
# 1) "c"
# 2) "b"
# 3) "a"

sunion myset3 myset4                   # 集合合并
sunionstore myset6 myset3 myset4       # 集合合并存储
smembers myset6
# 1) "c"
# 2) "b"
# 3) "a"

spop myset3                     # 随机弹出元素
# "b"
scard myset3                    
# 2
spop myset3 2                   # 指定弹出元素数量
# 1) "c"
# 2) "a"
scard myset3
# 0
```

##### list-列表
> 由于左右队列有许多相似的命令，着重看一边就行
```
rpush mylist a b c d e f g        # 从右边 推入多个元素入队
# (integer) 7
lrange mylist 0 -1                 # 列出队列中所有元素
# 1) "a"
# 2) "b"
# 3) "c"
# 4) "d"
# 5) "e"
# 6) "f"
# 7) "g"
llen mylist                       # 队列元素个数
# (integer) 7
lpop mylist                       # 从左弹出一个元素
# "a"


lpush mylist a
ltrim mylist 0 5                  # 裁剪（保留索引是0-5的元素）可用于日志的删除
# OK
lrange mylist 0 -1
# 1) "a"
# 2) "b"
# 3) "c"
# 4) "d"
# 5) "e"
# 6) "f"


lrem mylist 5 a                   # (由于5>0，负数相反）从头到尾最多删除五个a元素
# 1
lset mylist 1 "hello"             # 按索引编号设置值
# OK
lindex mylist 1                   # 指定索引获取值
# "hello"


# 将一个队列中的元素弹出，同时装入另外一个队列（待处理队列）；保证安全，不丢失元素
rpoplpush mylist mylist1     
# "f"
rpoplpush mylist mylist1
# "e"
lrange mylist1 0 -1
# 1) "e"
# 2) "f"
rpoplpush mylist mylist           # 队列名相同，则自旋转；可用于循环去检查监控场合
# "d"
rpoplpush mylist mylist
# "hello"

lpushx mylist bc                  # 推入队列时检查队列是否存在 ，存在才推入
# 4
lpushx mylist2 bcd                # mylist2 不存在
# 0

blpop mylist 10                   # 阻塞弹出（如果没有元素弹出会阻塞）超时10s,有时候避免循环
```





