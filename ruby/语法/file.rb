# 文件模式   对待文件方式           起始位置           说明
#   r         必须存在               头         最挑剔（不会自己创）
#   w      不存在-创；存在-清空       头         始终从头开始
#   a      不存在-创                 尾         相对安全，追加信息
# -------------------------------------------------------------
# + 表示 功能的增加：r+ 读写 w+ 读写 a+读写


#===================================================================================#
#  __LINE__  当前行号
puts __LINE__
#  4


#===================================================================================#
# extname 获取文件后缀
puts File.extname('a/b/cd.rb')
# .rb
puts File.extname('asd/sd/ko.image')
# .image



#===================================================================================#
# join  生成路径
# 本质： 用 / 串起
puts File.join("ab","cd","ef")
# ab/cd/ef
puts File.join("a/b","c/d","ef")
# a/b/c/d/ef


#===================================================================================#
# exists? 是否存在
File.exists?('/Users/dongmingyan/Downloads/icon_header.png')
# => true



#====================================================================================#
# 获取路径  文件名
# 1、第二个参数 去掉后缀
# 2、即使这个路径 不存在也没关系
puts File.basename("/home/gumby/work/ruby.rb")
# ruby.rb
puts File.basename("/home/gumby/work/ruby.rb",".rb")   # 去掉 .rb后缀
# ruby 
puts File.basename("/home/gumby/work/ruby.rb",".*")    # 去掉 所有后缀
# ruby
puts File.basename("/home/gumby/work/ruby.txt",".*")
# ruby



#====================================================================================#
# 获取路径  目录
# 路径不存在也 没关系
puts File.dirname("/Users/dmy/learn-note/my_test_file.rb")
# /Users/dmy/learn-note
puts File.dirname("/k/d/my_test_file.rb")
# /k/d



#====================================== 路径 ========================================#
# 当前路径
puts Dir.pwd               # 返回当前  绝对路径
# /Users/dmy/learn-note
puts __FILE__              # 返回当前  相对（终端）路径
# ruby/test.rb 


# expand_path 结合 __FILE__ 切换  任意路径
# PS: 框架中用的多
puts File.expand_path("../语法/arry.rb",__FILE__)
# /Users/dmy/learn-note/ruby/语法/arry.rb



#===================================== 目录下文件 =====================================#
# [绝对路径] 获取 文件（绝对路径）
puts Dir["/Users/dmy/learn-note/*"].inspect      # 所有文件
# ["/Users/dmy/learn-note/js", "/Users/dmy/learn-note/html", ..., "/Users/dmy/learn-note/sql"]
puts Dir["/Users/dmy/learn-note/*.md"].inspect   # 所有 md结尾文件
# ["/Users/dmy/learn-note/README.md", "/Users/dmy/learn-note/markdown_guide.md"]
Dir["/Users/dmy/learn/learn-note/ruby/{**/}"] # 下沉到ruby下-具体文件-目录层
# => ["/Users/dongmingyan/learn/learn-note/ruby/",
#  "/Users/dongmingyan/learn/learn-note/ruby/算法/",
#  "/Users/dongmingyan/learn/learn-note/ruby/测试文件/",
#  "/Users/dongmingyan/learn/learn-note/ruby/元编程/",
#  "/Users/dongmingyan/learn/learn-note/ruby/脚本/",
#  "/Users/dongmingyan/learn/learn-note/ruby/语法/",
#  "/Users/dongmingyan/learn/learn-note/ruby/语法/DSL专属语言/",
#  "/Users/dongmingyan/learn/learn-note/ruby/语法/DSL专属语言/v1/",
#  "/Users/dongmingyan/learn/learn-note/ruby/语法/DSL专属语言/v2/",
#  "/Users/dongmingyan/learn/learn-note/ruby/重构/",
#  "/Users/dongmingyan/learn/learn-note/ruby/标准库/"] 
Dir["/Users/dmy/learn/ruby/语法/**/*"]           # 所有目录下文件 层层递归（包含目录）
["/Users/dongmingyan/learn/learn-note/ruby/语法/string.rb",
 "/Users/dongmingyan/learn/learn-note/ruby/语法/block.rb",
 "/Users/dongmingyan/learn/learn-note/ruby/语法/data_deal.rb",
 "/Users/dongmingyan/learn/learn-note/ruby/语法/array.rb",
 "/Users/dongmingyan/learn/learn-note/ruby/语法/惯用技巧.rb",
 "/Users/dongmingyan/learn/learn-note/ruby/语法/exit.rb",
 "/Users/dongmingyan/learn/learn-note/ruby/语法/temp.rb",
 "/Users/dongmingyan/learn/learn-note/ruby/语法/useag.rb",
 "/Users/dongmingyan/learn/learn-note/ruby/语法/circulate.rb", 
 "/Users/dongmingyan/learn/learn-note/ruby/语法/hash.rb", 
 "/Users/dongmingyan/learn/learn-note/ruby/语法/condition.rb", 
 "/Users/dongmingyan/learn/learn-note/ruby/语法/file.rb", 
 "/Users/dongmingyan/learn/learn-note/ruby/语法/regexp.rb", 
 "/Users/dongmingyan/learn/learn-note/ruby/语法/特殊量.rb", 
 "/Users/dongmingyan/learn/learn-note/ruby/语法/numerical.rb", 
 "/Users/dongmingyan/learn/learn-note/ruby/语法/range.rb", 
 "/Users/dongmingyan/learn/learn-note/ruby/语法/class-module.rb", 
 "/Users/dongmingyan/learn/learn-note/ruby/语法/DSL专属语言", 
 "/Users/dongmingyan/learn/learn-note/ruby/语法/DSL专属语言/v1", 
 "/Users/dongmingyan/learn/learn-note/ruby/语法/DSL专属语言/v1/events.rb", 
 "/Users/dongmingyan/learn/learn-note/ruby/语法/DSL专属语言/v1/dsl.rb", 
 "/Users/dongmingyan/learn/learn-note/ruby/语法/DSL专属语言/v2", 
 "/Users/dongmingyan/learn/learn-note/ruby/语法/DSL专属语言/v2/events.rb", 
 "/Users/dongmingyan/learn/learn-note/ruby/语法/DSL专属语言/v2/dsl.rb", 
 "/Users/dongmingyan/learn/learn-note/ruby/语法/object.rb", 
 "/Users/dongmingyan/learn/learn-note/ruby/语法/system.rb", 
 "/Users/dongmingyan/learn/learn-note/ruby/语法/exception.rb"]


# foreach  遍历  文件名
# 包含隐藏文件
Dir.foreach('/Users/dmy/learn-note') do |file_name|
  next if file_name.start_with?('.')        # 跳过隐藏文件 和 父目录

  if File.directory? file_name
    print "目录: "
  else
    print "文件: "
  end

  puts file_name
end
# 目录: js
# 目录: html
# 目录: 常用命令
# 文件: README.md
# 文件: markdown_guide.md
# 文件: my_test_file.txt
# 目录: ruby
# 目录: gem
# 目录: sql


# entries(绝对路径) 获取 文件名（数组）
# 包含隐藏文件
puts Dir.entries('/Users/dmy/learn-note').inspect
# [".", "..", "js", "html", "常用命令", "README.md", "markdown_guide.md", ".git", "my_test_file.txt", "ruby", "gem", "sql"]


# glob("匹配模式")  获取   文件名（数组）
# 它的路径 即 当前运行路径
# PS: 感觉不太好用
puts Dir.glob("**").inspect                # 所有 文件名
# ["js", "html", "常用命令", "README.md", "markdown_guide.md", "my_test_file.txt", "ruby", "gem", "sql"]
puts Dir.glob("*.md").inspect              # md结尾 文件名
# ["README.md", "markdown_guide.md"]



#==================================== 新建 VS 删除 ===================================#
# 文件
new_file = File.new('new_file.txt','w')    # PS: 新建文件必须指定 文件模式 并且要可新建
sleep(4)

File.delete('new_file.txt')


# 文件夹
Dir.mkdir('k',0644)
sleep(4)

Dir.delete('k')


#========================================= 读取 =======================================#
# 单个读取
# each 单行(each_line)
# each_char 单字符
File.open('ruby/测试文件/my_test_file.txt','r') do |f|
  f.each do |line|             # 默认 按 单行(each_line)
    puts line
  end
end


# Four score =HU=
# and se=HU=ven
# yea=HU=rs go


File.open('ruby/测试文件/my_test_file.txt','r') do |f|
  f.each_char do |char|        # 单字符
    print "#{char},"
  end
end


# F,o,u,r, ,s,c,o,r,e, ,=,H,U,=,
# ,a,n,d, ,s,e,=,H,U,=,v,e,n,
# ,y,e,a,=,H,U,=,r,s, ,g,o,
# ,%

File.open('ruby/测试文件/my_test_file.txt','r') do |f|
  f.each do |line|             
    puts line.split.inspect    # 没有每个单词的 方法 这里劈开
  end
end

# ["Four", "score", "=HU="]
# ["and", "se=HU=ven"]
# ["yea=HU=rs", "go"]


# 一次性 读取文件所有内容
# File.read(文件路径)  字符串
file_content = File.read('ruby/测试文件/my_test_file.txt')          
new_content  = file_content.gsub(/第/,'=替换内容=')
# new_content  = file_content.gsub(/=替换内容=/,'第')  # 替换回去

File.open('ruby/测试文件/my_test_file.txt','w') do |f|
  f << new_content
end



#====================================== 目录 =======================================#
# 如果目录不存在 则创建（可多层目录）
require 'fileutils'

dir_path = "/Users/dongmingyan/sandbox/tmp"
FileUtils.mkdir_p(dir_path)  unless File.directory?(dir_path)



#====================================== 写入 =======================================#
# << 和 write 写入文件
File.open('ruby/测试文件/my_test_file.txt','a+') do |f|
  f << "第一行\n"
  f << "第二行\n"
  # f.write "write 写法\n"   # 等价写法
  # f.write "write 写法\n"
end



#==================================== 实例 ===========================================#
# 列出目录下所有 文件(包括：子目录的文件)
def list_all_file_of_directory(directory_path)
  Dir[directory_path + "/*"].each do |path|  # 目录下 所有路径（仅这一层）
    if File.directory?(path)
      puts "=======================================目录: #{path}"
      list_all_file_of_directory(path)     # 再次回进
    else
      puts path                            # 打印文件(非目录) 路径
    end
  end

end

list_all_file_of_directory("/Users/dmy/learn-note")