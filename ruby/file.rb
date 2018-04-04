# 扩展文件路径，注意这里__FILE__下划线是双横线
file_path = File.expand_path('../../test.rb', __FILE__)
puts file_path
# /Users/dmy/ruby-learn/test.rb