##### redis
> 一个高性能的键值存储数据库，一般用作缓存

##### 为什么比较快？
> 1. 操作的是内存
> 2. 许多操作时间复杂度都是O(1)
> 3. 利用了IO多路复用(一个线程对应多个socket)
> 4. 工作线程是单线程，线程间上下文切换的开销小

##### 安装及启动
```
brew install redis    安装
brew uninstall redis  卸载

redis-server          启服务
redis-cli             进入console
```

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









