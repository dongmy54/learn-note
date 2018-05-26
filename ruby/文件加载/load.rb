# require VS load VS require_relative
# 1、require 一般用于加载库,load 用于加载文件,require_relative 用于加载相对路径的文件
# 2、require 不能重复加载，load可以
# 3、require 加载时可不写后缀名，load必须写
# 4、require 加载文件时（必须显示的写明路径）
# 5、require_relative 属性与require基本一致（不会重复加载 可不写后缀）,但不能加载库
# 相同点： 加载文件 并 执行文件
# PS：
# 1、load 相对路径, 执行本文件时，终端要到对应目录下（file_load)
# 2、load 绝对路径 终端任意目录下 
# 3、require 加载文件时 也需要终端到对应目录
# 4、require_relative 是唯一一个 可在任何时候 执行相对目录的(所以 如果是根据相对路径加载   还是用require_relative吧)   
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
load '/Users/dmy/ruby-learn/file_load/1_load.rb'   # 绝对路径(任意目录都可执行)
# => 1_load.rb
require_relative '1_load.rb'     # 是唯一一个 仅依赖于相对路径的（任意目录执行）


#===================================================================================#
# 加载某目录下所有 .rb文件
# File.dirname(__FILE__) 当前文件夹
# "/load/*.rb" 具体路径
Dir[File.dirname(__FILE__) + "/load/*.rb"].each {|file| require file}
# => 3_load.rb
# => 4_load.rb


#===================================================================================#
# 加载当前目录下的 所有 .rb 文件
# PS: 
# 1、当前目录下 目录是不会进去的哦
# 2、推荐 用 File.dirname 方式（对路径没有要求）
Dir[File.dirname(__FILE__) + "/*.rb"] {|file| require file}
# => 1_load.rb
# => 2_load.rb








