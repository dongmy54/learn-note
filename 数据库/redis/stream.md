## stream 流
主要用于解决原pub/sub 无法持久化消息的问题。

它是一个有序追加的消息队列,直观感受下：
```shell
orders:
  1717085310000-0  { "order_no": "A100" }
  1717085315000-0  { "order_no": "A101" }
  1717085319000-0  { "order_no": "A102" }
```
orders：一组消息
`1717085310000-0  { "order_no": "A100" }` ID-消息


### 一、主要概念
1. stream 一些列消息的集合，我们称之为流，类比于Kafka的topic
2. Entry 也就是一条消息(有唯一ID)
3. 生产者 向流添加消息
4. 消费者 从流中读取消息，并处理
5. 消费者组 多个消费者归到一个组内，一条消息只会被消费者组里的一个消费者消费

### 二、演习命令
```shell
# 添加消息(创建流-topic)
127.0.0.1:6379> XADD mystream * user tom price 200
"1763793720848-0"
# mystream 流名称
# * 自动生成ID
# 后面是key - value对

# 读取消息
127.0.0.1:6379> XREAD COUNT 10 STREAMS mystream 0-0
1) 1) "mystream"
   2) 1) 1) "1763793720848-0"
         2) 1) "user"
            2) "tom"
            3) "price"
            4) "200"
# COUNT 最多10条
# 0-0 代表从头开始读取全部消息

# 创建消费者组
127.0.0.1:6379> XGROUP CREATE mystream group1 0-0
OK
# PS mystream必须先存在
# group1 消费者组名称
# 0-0 从头开始读取全部消息

# 使用消费者组读取消息
127.0.0.1:6379> XREADGROUP GROUP group1 consumerA STREAMS mystream >
1) 1) "mystream"
   2) 1) 1) "1763793720848-0"
         2) 1) "user"
            2) "tom"
            3) "price"
            4) "200"
# group1 组名
# consumerA 消费者名
# > 只读取未被消费者处理的消息
# PS 默认情况下上诉命令会尽可能的多的读取消息

# 确认消息被处理
127.0.0.1:6379> XACK mystream group1 1763793720848-0
(integer) 1
# 格式：XACK stream group entry_id


# 查看某个消费者组pending的消息
# pending只被消费者读取了，但是还未被ack的消息
127.0.0.1:6379> XPENDING mystream group1
1) (integer) 1
2) "1763794754206-0"
3) "1763794754206-0"
4) 1) 1) "consumerA"
      2) "1"
# 1 pending消息条数
# 2-3 代表最早和最晚读取的pending消息id
# 4 各个消息者pending消息数量详情

# 消息重投递
# 把pending消息转移到另一个消费者B下
127.0.0.1:6379> XCLAIM mystream group1 consumerB 0 1763795320997-0
1) 1) "1763795320997-0"
   2) 1) "foo"
      2) "bar"
# consumerB 0 1763795320997-0 
# consumerB 消费者名
# 0 o秒代表立即转移
# 1763795320997-0 消息id
```

```shell
# 读取流最新->旧 40条消息
XREVRANGE user-msg-topic + - COUNT 40

# 精确判断一条消息是否在消费组的pending列表中
XPENDING mystream mygroup 1772782598283-0 1772782598283-0 1

# 删掉消费者组
XGROUP DESTROY user-msg-topic default-group_handler_user-msg-topic_websocket_handler
```

### 三、常用命令
```shell
# 查看stream下的消费者组情况
127.0.0.1:6379> XINFO GROUPS mystream
1)  1) "name"
    2) "group1"
    3) "consumers"
    4) (integer) 3
    5) "pending"
    6) (integer) 2
    7) "last-delivered-id"
    8) "1763795383893-0"
    9) "entries-read"
   10) (integer) 4
   11) "lag"
   12) (integer) 0
2)  1) "name"
    2) "group2"
    3) "consumers"
    4) (integer) 0
    5) "pending"
    6) (integer) 0
    7) "last-delivered-id"
    8) "0-0"
    9) "entries-read"
   10) (nil)
   11) "lag"
   12) (integer) 2
# 有两个消费者组
# group1 有3消费者
#        pending的消息数量2
#        entries-read 已读取消息数量4
#        last-delivered-id 消费者组最后一次向该消费者投递的id：1763795383893-0（只是读取可能还未被ack)
#        lag 还需要读取多少条消息（这里为0，代表全部读取完毕）
# group2 没有消费者
#        pending的消息数量0
#        entries-read 未读取消息数量0
#        lag 未消费的消息数量2（落后2个消息）
# 特别说明这里lag 代表消费者组处理消息的健康状态，接近0越好；不要太大挤压太多


# 查看某个stream中 总消息长度
127.0.0.1:6379> XLEN mystream
(integer) 4

# 手动裁剪stream中消息长度
127.0.0.1:6379> XTRIM mystream MAXLEN 2
(integer) 2

# 读取1条消息看看内容
127.0.0.1:6379> XREAD COUNT 1 STREAMS mystream 0-0
1) 1) "mystream"
   2) 1) 1) "1763795320997-0"
         2) 1) "foo"
            2) "bar"
# foo 代表key bar代表值

# 查看pending消息数量
# 127.0.0.1:6379> XPENDING mystream group1
1) (integer) 2
2) "1763795320997-0"
3) "1763795383893-0"
4) 1) 1) "consumer1"
      2) "1"
   2) 1) "consumerB"
      2) "1"
# 按照pending的定义：是代表读取但是还未消费的消息，因此必须带上组名
```



