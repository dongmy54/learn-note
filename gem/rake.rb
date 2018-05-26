# 执行rake 任务必须在当前目录的下一层（只能是一层） 有Rakefile 文件
require 'rake'

task :my_task, [:a,:b] do |t,args|         # t 是task 的缩写 代表 task对象，并没有其它的含义
  puts args[:a], args[:b]                  # 传入参数可以简单理解为 在hash中 
end
# rake my_task[1,2]  参数放入方括号中

task :my_task1, :a, :b do |t,args|         # 这种写法和上面等价
  puts args[:a], args[:b]
end

task :invoke_my_task do
  Rake::Task[:my_task].invoke('dmy',4)          # 通过中间去,激活另一个任务
end

namespace :dmy do            # 在一个块里面

  task :say_hello, :name do |t, args|
    puts "hello #{args[:name]}" 
  end
  # rake dmy:say_hello[dmy]
end