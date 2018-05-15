#===================================================================================#
# pack VS unpack
# 压缩 和 解压
# 1、pack 是数组实例方法 unpack是字符串实例方法
# 2、pack 返回字符串 unpack 返回数组
# 3、*（'H*')表示数组元素转换长度  * 3(表示数组元素个数)
# 4、H 是一种模式 H 十六进制，m base64
after_pack = ['61','62','63'].pack('H*' * 3)   # "abc"
after_unpack = after_pack.unpack('H*')        # ["616263"]


#===================================================================================#
# Marshal 数据字节流转换
# dump 转字节流
# load 还原
h = {:a => 'A', :b => 'B'}
# 转换成字节流
byte_stream_data = Marshal.dump(h)
# => "\x04\b{\a:\x06aI\"\x06A\x06:\x06ET:\x06bI\"\x06B\x06;\x06T"
# 转换回来
source_data = Marshal.load(byte_stream_data)
# => {:a => 'A', :b => 'B'}


#===================================================================================#
# Base64 编码与转码
require 'base64'

str = 'abcdef'
puts encode_str = Base64.encode64(str)     # 注意带64 都带
# YWJjZGVm
puts decode_str = Base64.decode64(encode_str)  # 注意带64 都带
# abcdef