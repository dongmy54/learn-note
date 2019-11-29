# PS: 由于socket祖先类中包含IO,所以能调用puts gets等方法

# 服务端
require 'socket'
require_relative 'common.rb'         # 通用方法


# TCPServer
server = TCPServer.new 'localhost', 2000
puts "==========服务启动成功...."

loop do
  client = server.accept              # 等待客户端连接(监听)
  client.puts "恭喜你 已成功连接哦"
  client.puts "下面我们开始聊天吧......"

  # 轮播 收到的客户端消息
  # 开线程目的: 保证同时轮播收到消息和发送消息
  Thread.new do
    while c_msg = client.gets
      client_said(c_msg.to_utf8)
    end
  end
  
  # 随时发送消息 给客户端
  loop do
    begin
      s_msg = gets.chomp
      break if s_msg == 'exit'     # exit退出
      client.puts s_msg
    rescue Errno::EPIPE
      puts "对方已关闭聊天连接"
      break
    end
  end

  client.close                  # 自动关闭客户端
  puts '-----本次服务成功结束-----'
end


