# __FILE__ VS __LINE__
# 当前文件名 当前列号
a = 2
b = 3
puts __FILE__ 
# => test1.rb
puts __LINE__
# => 4


#===================================================================================#
# 当前文件的目录
puts File.dirname(__FILE__)
# => /Users/dmy/ruby-learn


#===================================================================================#
# 扩展文件路径，注意这里__FILE__下划线是双横线
file_path = File.expand_path('../../test.rb', __FILE__)
puts file_path
# /Users/dmy/ruby-learn/test.rb


#===================================================================================#
# 读取文件
# File.open 方式自动打开 和 关闭
File.open("/Users/dmy/yeezon/shop_pg/lib/shop_pg.rb", 'r') do |f|
  f.each_line do |line|
    puts line.strip
  end
end