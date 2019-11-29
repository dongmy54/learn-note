# 客户端
require 'socket'
require_relative 'common.rb'

# TCPSocket
s = TCPSocket.new('localhost', 2000)

# 轮播 接收到的服务端消息
Thread.new do
  while line = s.gets # 默认一次读取一行的内容
    server_said(line.to_utf8)
  end
end

# 客户端 随时发送信息到服务端
# 当收到 exit时退出
loop do
  begin
    c_msg = gets.chomp
    break if c_msg == 'exit'
    s.puts c_msg
  rescue Errno::EPIPE
    puts "对方已关闭聊天连接"
    break
  end
end

s.close
