## kafka
由于Linkedin开发，2011年初开源的消息引擎系统，支持发布-订阅模式。

### 安装和配置

配置：
有一些配置参数，但是都很简单

### 优缺点

优：
高吞吐10w级别、高可用、实时性高

缺点：
功能较为简单

### 基本术语
- 消息：最基本的消息单元 record
- 批次：分批次写入kafka的消息，它是一组写入的消息
- 主题（topic）：代表的是一类消息
- 分区（partition)：一个主题可以分成若干个分区（同一个topic的分区可以在不同的机器上）
- 生产者
- 消费者
- broker: 独立的kafka服务器
- broker集群：
- 副本（replica）：消息的备份


### 概念
实时数据处理系统（高可用、水平扩展、速度快）

### 特点
1. 分布式、高伸缩：集群，一个topic的partition可以在不同的broker中。
2. 持久性
3. 高并发
4. 高吞吐、低延迟：每秒几十万，只有几ms延时

### 作用
1. 解耦合（生产者和消费者）
2. 缓冲（消峰平谷）
3. 活动追踪、日志记录

### 数据结构
队列 
offset机制（消费者）

### 引入partition
提供吞吐、解决topic混乱问题

同一个partition可以位于不同的broker，而partition属于一个topic，因此同一个topic也能位于不同的broker上。

### 高可用
partition不只是有一个，有一个leader和多个repica
  
### 集群模式
多个broker

### 生产者消费者
生产者push消息；消费者pull消息

消费者组（consumer group)：同一个topic的多个消费者组成

PS: 消费者不能超过topic分区数量,超过后就相当于闲置了，所以一般情况下建议多加点分区，这样就可以多些消费者，从而实现较高的并发。

可以多个不同的消费者组，消费相同的分区。

每个消费者能消费的分区是指定的

### 重平衡reblance
如果某个消费者宕机，那么会触发broker重新为活跃的消费者分配分区。
**代价**：重平衡是有代价的，在重平衡期间，消费者组的所有消费者都会停止消息（STW）

实现：消费者定期向组织者发送心跳实现。

### 消费者通过轮训
通过轮训检查是否有消息到来（无线循环）


### 消息发送
1. 同步方式
2. 异步方式
   
### 分区策略
1. 顺序轮询（循环分区）- 默认
2. 随机轮训（随机选择分区）
3. key-ordering 按照key 计算出哪个分区

### 特殊的主题_consumer_offset
用于维护记录消费者偏移量，即使消费者宕机重启也能重新断点消费，或者重平衡。


### 日志和记录
1. 记录（record）代表一条消息、一个事件，最基本的数据单元
2. 日志（log 存储记录的数据结构，kafka将记录按照时间顺序形成日志存储。

### 可视化工具
Kafka-Topics-UI

### 配置示例
```shell
# Broker 配置
# broker.id 用于标识每个 Broker 的唯一 ID
broker.id=0

# listeners 定义 Broker 监听的地址和端口
# 可以配置多种协议,如 PLAINTEXT、SSL 等
listeners=PLAINTEXT://localhost:9092,SSL://localhost:9093

# advertised.listeners 定义 Broker 对外公布的地址和端口
# 通常用于 NAT 或负载均衡场景
advertised.listeners=PLAINTEXT://my-kafka.example.com:9092,SSL://my-kafka.example.com:9093

# log.dirs 指定消息日志文件的存储路径
log.dirs=/var/lib/kafka/data


# Topic 配置
# num.partitions 设置每个 Topic 的分区数量
num.partitions=3

# replication.factor 设置每个分区的副本数量
replication.factor=3

# auto.create.topics.enable 控制是否允许自动创建 Topic
auto.create.topics.enable=false


# 压缩与保留配置
# compression.type 指定消息的压缩算法
compression.type=gzip

# retention.ms 设置消息的保留时间(毫秒)
retention.ms=604800000 # 7 days


# 消息大小配置
# max.message.bytes 限制单条消息的最大大小
max.message.bytes=1000000 # 1MB


# 其他配置
# zookeeper.connect 定义 Zookeeper 集群地址
zookeeper.connect=zookeeper1.example.com:2181,zookeeper2.example.com:2181,zookeeper3.example.com:2181

# offsets.topic.replication.factor 设置偏移量 Topic 的副本数
offsets.topic.replication.factor=3

# transaction.state.log.replication.factor 设置事务状态 Topic 的副本数
transaction.state.log.replication.factor=3

# transaction.state.log.min.isr 设置事务状态 Topic 的最小 ISR 数
transaction.state.log.min.isr=2

# log.retention.hours 设置消息的保留时间(小时)
log.retention.hours=168 # 1 week

# log.segment.bytes 设置每个日志段的大小
log.segment.bytes=1073741824 # 1GB

# log.retention.check.interval.ms 设置日志清理检查间隔(毫秒)
log.retention.check.interval.ms=300000 # 5 minutes
```

### kafka为什么这么快？
1. 顺序写入（最大优化磁盘io）
2. 零拷贝（zero-copy）利用操作系统提供的能力，在不复制的情况下，让数据在内存和设备之间流动。
3. 批量处理：（消息的批量写入）
4. 数据压缩

### 常见问题

#### 1. Kafka与传统消息系统（如RabbitMQ、ActiveMQ）有什么区别？
1. 架构上：它是分布式的；其它为集中式
2. 数据存储：以日志形式存储于磁盘；内存队列
3. 水平扩展能力：强；有限
4. 性能：高吞吐、低延迟；中等
5. 场景：大规模实时数据；中小规模企业

#### 2. Kafka是如何保证数据的可靠性和高可用性的？
1. 分区副本（replica）
   每个partition都有多个副本，这些副本位于不同的broker（代理节点）上，即使某个broker挂掉，其它副本还存在
2. leader-follower机制,每个分区都有一个leader和多个follower，follower从leader同步
3. 故障自动转移 leader发生故障，会从follower中选举新的leader

1. 持久化存储：是存储在硬盘上的，而非内存，即使故障重启后不会丢失
2. 幂等性和事物支持：确保多次多次写入，生产者只会处理一次

#### 3. 如何提高Kafka的吞吐量？有哪些关键的配置参数？
生产者：
- 提高批处理大小batch.size
- 使用压缩compression.type
- 提高并发处理能力max.in.flight.requests.per.connection

消费者
- 提高提取子节数fetch.min.bytes
- 每个分区提取最大子节数 max.partition.fetch.bytes
- 每次轮训记录数 max.poll.records
- session过期时间 session.timeout.ms

分区设置
合适的分区数量，通常为2-3倍消费者数量

broker设置：
- 增大日志刷写间隔,减少磁盘io log.flush.interval.ms
- 增加网络线程数量，提高网络处理并发速度：num.network.threads
- 增加io线程数量，提高磁盘io并发速度：num.io.threads

#### 4. Kafka遇到Broker宕机时是如何处理的？
1. 副本机制：如果ledger所在broker宕机，会从follower中选中一个做为新的leader
2. 消费者重平衡：当分区发生变化时，消费者会重新分配分区
3. 数据恢复：如果宕机broker恢复，会自动加入集群，同步缺失数据

这一切都是自动的

### zookeeper
分布式服务中的协调者，分布式面对非常多的计算机，要保证这些计算机之间能协调一致的处理问题，他提供了一种高可用方案，实现诸如，leader选举等方式。

1. 服务注册与发现
2. 分布式配置与管理 
3. 集群管理与监控