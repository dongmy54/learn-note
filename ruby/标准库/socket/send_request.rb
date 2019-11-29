# socket模拟发送请求
require 'socket'
 
host = 'www.baidu.com'
port = 80
path = "/"

# 以\r\n 分割
# 末尾要多一个 \r\n
request = "GET #{path} HTTP/1.1\r\nHost: #{host}\r\n\r\n"

socket = TCPSocket.open(host,port)
socket.print(request)               # 发送请求
response = socket.read

headers,body = response.split("\r\n\r\n", 2) 
print body
socket.close


