# require VS load
# 1、require 一般用于加载库,load 用于加载文件
# 2、require 不能重复加载，load可以
# 3、require 加载时可不写后缀名，load必须写
# 4、require 加载文件时（必须显示的写明路径）
# 相同点： 加载文件 并 执行文件
puts require 'uri'
# => true
puts require 'uri'
# false
require './1_load.rb'  # 必须显示写名路径（./)
# => 1_load.rb 
require './1_load'     # 可不写后缀
# => 1_load.rb

load '1_load.rb'       # 默认当前路径
# => 1_load.rb
load '2_load.rb'
# => 2_load.rb
load 'load/3_load.rb' 
# => 3_load.rb


