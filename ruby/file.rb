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