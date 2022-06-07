###### udp #########
# 1. 相对于tcp而言，简单、不可靠的传输
# 2. socket 相对于http而言更底层，可以实现各种协议



##################### 简单的数据传输 ################### 
# server
require 'socket'
u1 = UDPSocket.new
# 如果在云服务上 这里host不要填 localhost/外网ip
# 这里可以填内网ip/空字符串
u1.bind("192.168.0.126", 4913) # 监听此端口消息 
u1.recvfrom(4) # 这里如果没有消息会阻塞 4代表获取信息长度


# client
require 'socket'
u2 = UDPSocket.new
u2.connect("139.9.52.xx", 4913) # 链接某个端口
u2.send("hello", 0)             # 发送消息
##################### 简单的数据传输 ################### 



##################### 双向数据传输 ################### 
# server
require 'socket'
server_socket = UDPSocket.new
server_socket.bind "", 4913
reply, from = server_socket.recvfrom( 20, 0 )
# from[2]-host from[1]-port
puts "received #{reply} from #{from[2]}:#{from[1]}"
server_socket.send("you said: #{reply}", 0, from[2],from[1]) # 服务端也可以可以回复
server_socket.close


# client
require 'socket'
client_socket = UDPSocket.new
client_socket.connect("139.9.52.xx", 4913)
client_socket.puts "hello"
reply, from = client_socket.recvfrom( 20, 0 )
puts reply
client_socket.close
##################### 双向数据传输 ################### 


