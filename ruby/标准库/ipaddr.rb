require 'ipaddr'

# 可以是网段
net1 = IPAddr.new("192.168.5.0/24")
net2 = IPAddr.new("192.168.5.34")
net3 = IPAddr.new("192.168.9.23")

puts net1.include?(net2)
# true
puts net1.include?(net3)
# false
puts net2.include?(net3)
# false
