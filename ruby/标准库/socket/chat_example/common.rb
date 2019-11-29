# 聊天共用方法
def server_said(msg)
  puts "服务端：#{msg}"
end

def client_said(msg)
  puts "客户端：#{msg}"
end

class String
  def to_utf8
    self.force_encoding('UTF-8')
  end
end


