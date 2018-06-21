## linux 命令汇集
- `/`  根目录（顶层目录)
- `~`  家目录（每个用户进来的目录）
- `#`  表示 管理员权限 

### 查看命令文档的三种方式
1. `help cd`    help 开头
2. `cd --help`  --help 结尾
3. `man cd`     命令手册页（终端和远端机器都适用）  

### 文件类型
- '-'     普通文件
- 'd'     文件夹

```
===============================基础==========================

cd -            退到上一次目录

mv file1 file2 file3 directory 一次移动多个文件

date            当前日期
cal             本月日历
df              磁盘空间情况
free            空闲内存情况（mac终端没法用）

history         命令行历史

nslookup baidu  通过域名查IP
  
mkdir dir1  创建目录
mkdir -p dir1 创建目录（如果目录已存在也不会报错，它只是默默的不创建）

less 文件名/路径       page up/page down 翻页；g/G 首尾; 

file 文件名/目录       文件的信息

ps                    列出与当前终端相关的进程
ps x                  初略（数据列少）的列出所有进程
ps aux                详细（数据列多）的列出所有进程
ps aux |grep sidekiq  从所有进程中过滤出 sidekiq相关进程

kill 1024             杀死（终止）进程号为1024进程
kill -stop 1024       停止1024号进程
kill -cont 1024       继续1024号进程

id                    用户id信息
chmod 640 foo.text    更改文件权限
                      rwx代表 读 写 执行，数字是 4 2 1
                      640分三位：6 4 0 即是 4 + 2、2、0 也就是 读写、写、无权限
                      对应拥有者、组、其它人权限
> foo.txt             输入信息，换行输入ctrol + D（创建并写入foo.txt文件）
cat > foo.txt         输入信息，换行输入ctrol + D 创建并写入foo.txt          

===============================较少用到======================

type      命令名                查看命令类型（shell的？还是其它）
which     命令名                查看命令可执行档位置
alias foo='cd learn;ls;cd -'   命一个别名代表 一串操作(ps: 关闭终端就失效了)
unalias foo                    去掉别名foo

grep "test" db_test.rb temp.rb      在文件中匹配字符串(这里只支持文件)
grep -i "test" db_test.rb temp.rb   忽略大小写
grep -l "test" db_test.rb temp.rb   列出匹配到的文件

ls learn-not/ruby/语法 | grep rb    过滤出xx目录下 包含rb的文件名

============================== PS ===========================

cd learn;ls;cd -        # 用分号分隔，一次执行多个命令

```