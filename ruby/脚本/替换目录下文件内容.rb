# 替换目录下 所有符合条件（正则） 的文件内容
def replace_content_of_directory(directory_path)
  Dir[directory_path + "/*"].each do |path|            # 遍历 目录下 所有绝对路径

    if File.directory? path
      replace_content_of_directory(path)               # 目录 回进方法
    else
      File.open(path,'r+') do |f|
        regex       = /where\((["'].*?)\)\./           # 匹配正则
        content_arr = f.readlines                      # 读取所有行

        if content_arr.join =~ regex                   # 文件中有 where(" ). 写法
          puts "====================处理: #{path}文件"
          content_arr.each_with_index do |line,i|      # 行遍历
            line.scan(regex).each do |m|               # 行匹配
              new_content = 'Sequel.lit(' + m[0] + ')' # 新行内容
              puts "-----原行：#{line}"
              puts "-----替换：#{m[0]}"
              puts "-----变成：#{new_content}\n\n"

              line[m[0]] = new_content                 # 修改变量line值
            end
            content_arr[i] = line                      # 将new line值 替换到内容数组
          end
          f.rewind                                     # 回到文件头部（因为此前f.readlines一次）
          f << content_arr.join                        # 重写文件
        end
      end
    end
  end

end

replace_content_of_directory("/Users/dmy/learn-note/ruby/测试文件")
