# 开源 安全通信软件包
# 提供许多 对称加密（aes/des等等）/非对称加密，摘要加解密算法


########################################## 消息认证码 ############################################
# Message Authentication Code 消息认证码
require 'openssl'

key     = "key"                          # 密钥
message = "message-to-be-authenticated"  # 密文信息
mac = OpenSSL::HMAC.hexdigest("SHA256", key, message)
puts mac
#=> "cddb0db23f469c8bf072b21fd837149bd6ace9ab771cceef14c9e517cc93282e"

# 从文件读取
message = File.read('/Users/dongmingyan/data.txt') # 从文件中读取
digest  = OpenSSL::Digest::SHA256.new
hmac    = OpenSSL::HMAC.new(key, digest)
hmac << message
mac = hmac.digest
puts hmac  # 注意这里是hamac
#=> "cddb0db23f469c8bf072b21fd837149bd6ace9ab771cceef14c9e517cc93282e"




########################################## 对称加密 ############################################
require 'openssl'

# 支持的对称加密列表（名称-长度-模式）
puts OpenSSL::Cipher.ciphers
# AES-128-CBC
# AES-128-CBC-HMAC-SHA1
# AES-128-CFB
# .....


# 含义:
# iv（initialization vector) 初始矢量
# key 密钥
# final 作用是：避免解密报错(建议都加上)
# PS：ECB模式没有iv


# ase-128-cbc加密
require 'openssl'

data = "Very, very confidential data"

# 加密
cipher = OpenSSL::Cipher.new('aes-128-cbc')
# cipher = OpenSSL::Cipher::AES.new(128, :CBC)
# cipher = OpenSSL::Cipher::AES128.new(:CBC) 等价

cipher.encrypt # 在一开始就说明 加密/解密
key = cipher.random_key
iv  = cipher.random_iv

encrypted = cipher.update(data) + cipher.final
# 解密
decipher = OpenSSL::Cipher::AES.new(128, :CBC)
decipher.decrypt # 在一开始就说明 加密/解密
decipher.key = key
decipher.iv  = iv

plain = decipher.update(encrypted) + decipher.final
puts plain
# Very, very confidential data
puts data == plain 
#=> true


#------------------------------------------------------------------------------------------#
require 'openssl'
require 'cgi'

key    = "NRg6nHXGfI8u"       # 密钥
params = "platform_code=aecc&group_code=aecc&login_name=glycs&dep_name=中航金网（北京）电子商务有限公司-综管部"

context = CGI::escape(params) # 转码

# DES加密, mode: ECB || CBC
def encrypt(context, key: key, mode: 'ECB')
  # key 和 iv 相同
  cipher = OpenSSL::Cipher::DES.new(mode).encrypt.tap { |obj| obj.key = obj.iv = key }
  # PS：这里可以不用转大写，解密时去掉unpack('C*').pack("c*")
  # unpack('H*') 目的将十六进制解码成可读字符串
  (cipher.update(context) + cipher.final).unpack('H*')[0].upcase
end

# DES解密, mode: ECB || CBC
def decrypt(context, key: key, mode: 'ECB')
  cipher = OpenSSL::Cipher::DES.new(mode).decrypt.tap { |obj| obj.key = obj.iv = key } 
  cipher.update([context].pack('H*').unpack("C*").pack("c*")) + cipher.final
end

# 测试
data = encrypt(context, key: key)  # 加密测试
puts data.inspect
result = decrypt(data, key: key)    # 解密测试
result == context                     
params_after = CGI::unescape(result)    # 解码
puts params_after == params                




########################################## 非对称加密 ############################################
# 非对称加解密过程
require 'openssl'

# 公钥加密
key         = OpenSSL::PKey::RSA.new 1024
text        = "hello world"
secret_text =  key.public_encrypt(text)
private_key = key.to_pem 
# => "-----BEGIN RSA PRIVATE KEY-----\nMIICXAIBAAKBgQC5f0jO96eozPHzDdZ3WMQRvq9eFOiLFLaqxfprw+xuUzxKDXkQ\nydrewPwy1F5CRRs8rk6UDHvyAEsbZl2Dt8xoG0b4rpReZOqOjs6tAoXpt3BDC6f6\nGxMbObTa9FisWsXXG3CBPAWzGoVOFMKJJVVi60/c3ERrxwDgWYO5/99qpwIDAQAB\nAoGAXcQhob0+Wu1+QEZ2as3MDsw9CWm4QtWtoJWDCIZ5NSuOBkDZOctPf9o9odQH\n8afNJNdXkS7eWG4diTQtgS+fewQpCSmpSyhzD3BnYdr7O5H9DBNHS9UEYMY6fWn7\nuiIoEVukBx9ArilLkfou1l+77kScL/P9cLToqDCGG7iJ64ECQQDgJ2r5l72XCqKS\nI80owinGi1KU7Vbtf3cDtA9lxdBJzoISdnkCdI5qOzRvE650N8vA4Hb1AZmXfH5g\nMGaG1/upAkEA09nm9JTbBqPVNcyMnx6DkEN6cgEujPbxV9sOaZiTwJUCiZWNTLui\nWubKaQfPY8KLOuweAR9MskHyoCGW3i+lzwJBAI5yflj/RUynRYj5l3c/bKzv/RsH\neSaUyl1gICjc/PDqe16gS2Z0C80WssukBkl069c2zmIFEkZipy0ZlQ48U4ECQDY9\n+JBu/JV6pUCdGvQyz+TEIjnGa7DUGX8xK0OGOW55uKiZjhAziqJTrUevJD6atSNl\nCVmoNe7+S60MbKB++qkCQDts9LgOThcLFMnMirnJU6Pa4i21ikdlBuYtSwjcUWzg\nCcjPVG6/dIRljtiKHeL7eJL22RLvmxee60nH5sT08yM=\n-----END RSA PRIVATE KEY-----\n"

# 私钥解密
p_key = OpenSSL::PKey::RSA.new private_key
p_text = p_key.private_decrypt(secret_text)

# 验证正确性
puts text == p_text
# true



# 从模数、指数构建rsa 实例对象
require 'openssl'
require 'Base64'

key1           = OpenSSL::PKey::RSA.new 1024
public_key_str1 = key1.public_key.to_s
# => "-----BEGIN PUBLIC KEY-----\nMIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQCwBPN7OyooAf14n60tTUbMSXuN\n1bZ8ENqlBinZh4rfLap6ba48TMMy9qGoXTP/5WdJeXaLgWatUjDwNgKjMGRzPHlg\nran5p82rOp9h5wlnpvgsBeN4G0OXXQ0sg52ygMYLH0yb/69ML+sr2i4G6e2MBtz8\nmZDQ8Fj+m2W1yExtZwIDAQAB\n-----END PUBLIC KEY-----\n"

modulus = key1.public_key.n.to_s(16)  # 模数16代表进制
exponse = key1.public_key.e.to_s(16)  # 指数

# 构建公钥
key2   = OpenSSL::PKey::RSA.new
key2.e = OpenSSL::BN.new(exponse, 16) 
key2.n = OpenSSL::BN.new(modulus, 16)
public_key_str2 = key2.public_key.to_s

puts public_key_str1 == public_key_str2
# true





