# 文件模式   对待文件方式           起始位置           说明
#   r         必须存在               头         最挑剔（不会自己创）
#   w      不存在-创；存在-清空       头         始终从头开始
#   a      不存在-创                 尾         相对安全，追加信息
# -------------------------------------------------------------
# + 表示 功能的增加：r+ 读写 w+ 读写 a+读写


#===================================================================================#
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



#==================================== 新建 VS 删除 ===================================#
new_file = File.new('new_file.txt','w')    # PS: 新建文件必须指定 文件模式 并且要可新建
sleep(5)

File.delete('new_file.txt')



#========================================= 读取 =======================================#
# 单个读取
# each 单行(each_line)
# each_char 单字符
File.open('my_test_file.txt','r') do |f|
  f.each do |line|             # 默认 按 单行(each_line)
    puts line
  end
end


# Four score =HU=
# and se=HU=ven
# yea=HU=rs go


File.open('my_test_file.txt','r') do |f|
  f.each_char do |char|        # 单字符
    print "#{char},"
  end
end


# F,o,u,r, ,s,c,o,r,e, ,=,H,U,=,
# ,a,n,d, ,s,e,=,H,U,=,v,e,n,
# ,y,e,a,=,H,U,=,r,s, ,g,o,
# ,%

File.open('my_test_file.txt','r') do |f|
  f.each do |line|             
    puts line.split.inspect    # 没有每个单词的 方法 这里劈开
  end
end

# ["Four", "score", "=HU="]
# ["and", "se=HU=ven"]
# ["yea=HU=rs", "go"]


# 一次性 读取文件所有内容
# File.read(文件路径)  字符串
file_content = File.read('my_test_file.txt')          
new_content  = file_content.gsub(/第/,'=替换内容=')
# new_content  = file_content.gsub(/=替换内容=/,'第')  # 替换回去

File.open('my_test_file.txt','w') do |f|
  f << new_content
end



#====================================== 写入 =======================================#
# << 和 write 写入文件
File.open('my_test_file.txt','a+') do |f|
  f << "第一行\n"
  f << "第二行\n"
  # f.write "write 写法\n"   # 等价写法
  # f.write "write 写法\n"
end



#==================================== 实例 ===========================================#
# 列出目录下所有 文件(包括：子目录的文件)
def list_all_file_of_directory(directory_path)
  Dir[directory_path + "/*"].each do |path|  # 目录下 所有路径（仅这一层）
    File.open(path,'r') do |f|
      if File.directory? f
        puts "=======================================目录: #{path}"
        list_all_file_of_directory(path)     # 再次回进
      else
        puts path                            # 打印文件(非目录) 路径
      end
    end
  end

end

list_all_file_of_directory("/Users/dmy/learn-note")