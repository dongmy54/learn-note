# 执行rake 任务必须在当前目录的下一层（只能是一层） 有Rakefile 文件
require 'rake'


####################################### 任务带参数 ######################################
task :my_task, [:a,:b] do |t,args|         # t 是task 的缩写 代表 task对象，并没有其它的含义
  puts args[:a], args[:b]                  # 传入参数可以简单理解为 在hash中 
end
# rake my_task[1,2]  参数放入方括号中

task :my_task1, :a, :b do |t,args|         # 这种写法和上面等价
  puts args[:a], args[:b]
end


#################################### 任务触发另外任务 ######################################
task :invoke_my_task do
  Rake::Task[:my_task].invoke('dmy',4)          # 通过中间去,激活另一个任务
end


####################################### 任务命名参数 ######################################
namespace :dmy do            # 在一个块里面

  task :say_hello, :name do |t, args|
    puts "hello #{args[:name]}" 
  end
  # rake dmy:say_hello[dmy] 单冒号
end


##################################### 任务（前置回调） #####################################
task :prereq1 do
  puts 'prereq1'
end

task :prereq2 do
  puts 'prereq2'
end

# 这种写法表示：执行name 这个任务前，需先执行 prereq1 和 prereq2
task name: [:prereq1, :prereq2] do |t|
  puts 'name task'
end

# rake name
# prereq1
# prereq2
# name task


