# 后缀可省
# 不可重复加载（第二次可以返回false)
require 'rake'               # gem
require 'rake/file_list'     # gem下文件

require './tp.rb'            # 文件 相对(当前必须./ 且与终端相关) 
require '/Users/dmy/tp.rb'   # 文件 绝对

# 后缀可省
# 不可重复加载
# 只能 文件
# 只能 相对路径 
require_relative 'tp'       # 相对 （可省./)

# autoload 惰性加载
# 不可重复加载
# 第一个参数必须为常数符号
autoload :RestClient, 'rest-client'
autoload :A,'/Users/dongmingyan/t4.rb'
# 惰性加载：当执行了autoload后，文件并非就执行了，只有等到真正使用的（常量）时，才真正执行

# 只能文件
# 不能省 后缀
# 可重复加载(每次加载都实时执行代码)
load 'tp.rb'             # 相对时（ 与终端相关）
load '/Users/dmy/tp.rb'  # 绝对


# 总结
# 1. require 推荐使用（介于autoload和load之间）
# 2. autoload 惰性-要等到真正用到这个常量时才去加载（PS：底层其实是用的require）
# 3. load 实时加载-每次都去做加载


#===================================================================================#
# 加载某目录下所有 .rb文件
# File.dirname(__FILE__) 当前文件夹
# "/load/*.rb" 具体路径
Dir[File.dirname(__FILE__) + "/load/*.rb"].each {|file| require file}
# => 3_load.rb
# => 4_load.rb








