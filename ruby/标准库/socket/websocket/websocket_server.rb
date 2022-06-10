require 'socket'
require 'openssl'

server = TCPServer.new('localhost', 2345)
loop do

  # Wait for a connection
  socket = server.accept
  #puts "Incoming Request"

  # 一个请求是许多行 以\r\n为一次请求的结束 一次sockets.gets 每次取的仅仅是一行
  http_request = ""
  puts "get bytes:#{ socket.getbyte}"
  while (line = socket.gets) && (line != "\r\n")
    http_request += line
  end
  #puts http_request

  # 获取其中key
  if matches = http_request.match(/^Sec-WebSocket-Key: (\S+)/)
    websocket_key = matches[1]
    STDERR.puts "Websocket handshake detected with key: #{ websocket_key }"
  else
    STDERR.puts "Aborting non-websocket connection"
    socket.close
    next
  end
  
  # 这是约定的加密手段 258EAFA5-E914-47DA-95CA-C5AB0DC85B11 是固定的
  response_key = Digest::SHA1.base64digest([websocket_key, "258EAFA5-E914-47DA-95CA-C5AB0DC85B11"].join)
  puts "Responding to handshake with key: #{ response_key }"

  # 握手需要给出一个响应
  # PS: 1. 请求头顶格写 2. 最后要多一个空行
  socket.write <<-eos
HTTP/1.1 101 Switching Protocols
Upgrade: websocket
Connection: Upgrade
Sec-WebSocket-Accept: #{ response_key }

eos

  STDERR.puts "Handshake completed. Starting to parse the websocket frame."

  # 升级成websocekt后 数据的的传输最小单位是数据帧
  # 每个帧的数据格式都是协议规定好的，我们按照协议每次按照1个字节获取（8位）来取数
  # 每个字节对应的位都有特别的含义
  first_byte = socket.getbyte
  fin = first_byte & 0b10000000
  opcode = first_byte & 0b00001111

  raise "We don't support continuations" unless fin
  raise "We only support opcode 1" unless opcode == 1

  second_byte = socket.getbyte
  is_masked = second_byte & 0b10000000
  payload_size = second_byte & 0b01111111

  raise "All incoming frames should be masked according to the websocket spec" unless is_masked
  raise "We only support payloads < 126 bytes in length" unless payload_size < 126

  STDERR.puts "Payload size: #{ payload_size } bytes"

  mask = 4.times.map { socket.getbyte }
  STDERR.puts "Got mask: #{ mask.inspect }"

  data = payload_size.times.map { socket.getbyte }
  STDERR.puts "Got masked data: #{ data.inspect }"
  
  # 从客户端发到服务端的数据 进行了异或加密
  unmasked_data = data.each_with_index.map { |byte, i| byte ^ mask[i % 4] }
  STDERR.puts "Unmasked the data: #{ unmasked_data.inspect }"

  # C代表无符号整数 * 代表根据后续判断长度
  STDERR.puts "Converted to a string: #{ unmasked_data.pack('C*').force_encoding('utf-8').inspect }"

  response = "Loud and clear!"
  STDERR.puts "Sending response: #{ response.inspect }"

  output = [0b10000001, response.size, response]
  socket.write output.pack("CCA#{ response.size }")

  socket.close
end
