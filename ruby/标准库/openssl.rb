# 开源 安全通信软件包
# 提供许多 对称加密（aes/des等等）/非对称加密，摘要加解密算法
require 'openssl'

data = "Very, very confidential data"

# 加密
cipher = OpenSSL::Cipher::AES.new(128, :CBC)
cipher.encrypt
key = cipher.random_key
iv  = cipher.random_iv

encrypted = cipher.update(data) + cipher.final
# 解密
decipher = OpenSSL::Cipher::AES.new(128, :CBC)
decipher.decrypt
decipher.key = key
decipher.iv  = iv

plain = decipher.update(encrypted) + decipher.final
puts plain
# Very, very confidential data
puts data == plain 
#=> true

