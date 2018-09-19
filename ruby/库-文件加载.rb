# 后缀可省
# 不可重复加载
require 'rake'               # gem
require 'rake/file_list'     # gem下文件

require './tp.rb'            # 文件 相对(当前必须./ 且与终端相关) 
require '/Users/dmy/tp.rb'   # 文件 绝对

# 后缀可省
# 不可重复加载
# 只能 文件
# 只能 相对路径 
require_relative 'tp'       # 相对 （可省./)

# 只能文件
# 不能省 后缀
# 可重复加载
load 'tp.rb'             # 相对时（ 与终端相关）
load '/Users/dmy/tp.rb'  # 绝对



#===================================================================================#
# 加载某目录下所有 .rb文件
# File.dirname(__FILE__) 当前文件夹
# "/load/*.rb" 具体路径
Dir[File.dirname(__FILE__) + "/load/*.rb"].each {|file| require file}
# => 3_load.rb
# => 4_load.rb








