# File.open("/Users/dmy/yeezon/shop_pg/lib/shop_pg.rb", 'r') do |f|
#   f.each_line do |line|
#     puts line.strip
#   end
# end


# 写入新文件 这个文件 创建位置 和 ruby 执行有关
# open('myfile.out', 'w+') do |f|
#   f << "Four score\n"
#   f << "and seven\n"
#   f << "years ago\n"
# end

# open('myfile.out', 'r+') do |f|
#   # f.write("Four score\n")          # write 等价于 <<
#   # f.write("and seven\n")
#   # f.write("years go\n")
  
#   f.each_line do |line|
#     line << 'sda'
#   end

# end

# f = File.new("new_file.text",'w')          # 创建文件必须指定模式
# f <<  "qwe\n"
# f <<  "ji\n"
# f.close

# content = File.read('myfile.out')            # 读取文件一次读取所有内容
# # replace = content.gsub(/D/,'=HU=')           # 替换文件内容
# # open('myfile.out','w') do |f|
# #   f << replace
# # end
# puts replace = content.split("\n").inspect


# puts Dir["/Users/dmy/learn-note/*"]               #  数组 只包含了 下一层级 绝对路径
# puts Dir[Dir.pwd.to_s + "/*"].class                # 数组

# Dir.foreach('/Users/dmy/learn-note') do |item|     # 返回文件名 枚举型
#   #next if item == '.' or item == '..'             # 会包含 . 和 ..
#   puts item
#   # do work on real items
# end

#File.delete('myfile.out')                           #  删除文件

# f = File.open('new_file.text','r+')
# puts f.read(2)                         # 移动性 行读取 一行
# f.close

# puts Dir.home
# # => /Users/dmy

# puts File.absolute_path("current")      # 和终端执行有关 
# => /Users/dmy/learn-note/current

# puts __FILE__                              # 相对路径
# # ruby/test.rb
# puts File.expand_path(".")                 # 和终端有关
# # /Users/dmy/learn-note

# puts Dir.pwd                               # 当前路径 绝对 终端
# /Users/dmy/learn-note


# puts Dir.glob("*.md")                       # 数组 当前文件下所有文件名


# File.open('myfile.out','r+') do |f|
#   # puts f.readlines.inspect                # 将所有列 展示出来
#   5.times {puts f.readline }                # 每次读一行
# end

# ruby_dir = Dir.open(".")                      # 目录下的文件
# ruby_dir.each do |file|
#   print "dir---" if File.directory? file
#   puts file
# end

# puts ruby_dir.entries.inspect                 # 目录下文件条目
# # [".", "..", "new_file.text", "js", "html", "常用命令", "README.md", "markdown_guide.md", "myfile.out", ".git", "ruby", "gem", "sql"]

# puts File.basename("/users/andrew/Documents/plans.txt", ".txt") # => "plans"

# Dir.open(Dir.pwd).each do |file|
#   next puts "dir-" if File.directory? file     # next 里面的内容会执行
#   # file.each_line do |line|
#   #   puts line
#   # end

#   puts file.class
# end

#puts File.new("testfile",'w').path             # 相对路径


# Dir.foreach(Dir.pwd) do |file|
#   next puts "dir-" if File.directory? file     # next 里面的内容会执行
  
#   puts file.class
# end

# puts File.new("testfile",'w').class

# def list_all_file_of_directory(directory_path)
#   Dir[directory_path + "/*"].each do |path|
#     File.open(path,'r') do |f|
#       if File.directory? f
#         puts "=======================================目录: #{path}"
#         list_all_file_of_directory(path)     # 再次回进
#       else
#         puts path                            # 打印文件(非目录) 路径
#       end
#     end
#   end

# end

# list_all_file_of_directory("/Users/dmy/learn-note")

# new_file = File.new('new_file.txt','w')    # PS: 新建文件必须指定 文件模式 并且要可新建
# sleep(10)
# File.delete('new_file.txt')
















