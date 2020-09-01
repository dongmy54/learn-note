#### tcp

##### 三次握手
client -- server
> 1. client --syn--> server

> 2. client <--ack-- server

> 3. client --ack--> server

##### 为什么是三次而不是两次?
> 假设两次，服务端在发送ack后，就认为连接已经建立，而实际上这个ack可能会丢失的，
> 当丢失的时候，客户端并没有收到ack，也就是客户端认为连接还未建立，而服务端认为连接已经建立
> 于是开始发送数据，客户端会拒绝收除ack外的包的


##### 四次挥手
> 1. client --FIN--> server

> 2. client <--ACK-- server

> 3. client <--FIN-- server

> 4. client --ACK--> server


##### 为什么是四次挥手？
> 因为当客户端发送FIN，服务端ACK时，仅代表服务端没有东西传给服务端了
> 但是服务端可能还有包需要传递给客户端，所以需要单独发送一个FIN（然后等待客户端ACK)

#####为什么客户端发出ACK后不会立马close，而是会等待2MSL（Max Segment Lifetime)最大报文生存时间
> 因为客户端发出ACK之后，这个包可能会走丢，留着等待2MSL是为了留下走丢后，服务端重发FIN的时间
> 以便服务端能收到

