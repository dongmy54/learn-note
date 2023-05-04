## linux 命令汇集
- `/`  根目录（顶层目录)
- `~`  家目录（每个用户进来的目录）
- `#`  表示 管理员权限 

### 命令组成
一般为：`命令名 -选项 参数  文件`
> - ls -a    -代表参数简写
> - ls --all --代表参数全称呼


### 查看命令文档的三种方式
1. `help cd`    help 开头
2. `cd --help`  --help 结尾（在现在的mac上不行）
3. `man cd`     命令手册页（终端和远端机器都适用）  

### 文件类型
- '-'     普通文件
- 'd'     文件夹

### 服务器磁盘空间满
```bash
df -h  # 查看当前空间占用情况
du -h | sort -h | tail -n 10 # 占用最高的10个文件，当前路径下所有文件会当作一个目录-找出占用最大目录

# 详细查看当前目录下所有文件占用大小，并排序
du -h --max-depth 1 * | sort -h | tail -n 10

# 清空
> xxx.log 
```

### 命令展开
> 单双引号
> 单：所见即所得；双：会解析
```bash
echo '$HOME'
# $HOME
echo "$HOME"
# Users/dongmingyan
```
1. echo this $USER is $100.20 and $((2+3));cd                 无引号: 全部展开
2. echo "this is this $USER is $100.20 and $((2+3));cd"       双引号: 部分展开（除 参数展开/算术展开/命令替换）
3. echo 'this is this $USER is $100.20 and $((2+3));cd'       单引号: 不展开
PS: 可在双引号("")中用`/` 转义

### 输入/输出
1. stdin 标准输入（0）
2. stdout 标准输出 （1）
3. stderr 标准错误输出 （2）

* `>`   标准输输出重定向到文件, eg: `cat tp.rb > t.html`
* `>>`  标准输出重定向追加
* `2>`  标准错误输出重定向,    eg: `cat not_exist_file.txt 2> err.txt`
* `2>>` 标准错误输出重定向追加, eg: `cat p.md >> results.txt 2>> err.txt` 分别存储
* `2>&1` 标准输出 和 标准错误输出同一文件, eg: `cat p.md >> results.txt 2>&1`
* `|` 管道, 前一个命令输出 做 后一个命令输入



```bash
===============================基础==========================

cd -            退到上一次目录

mv ~/temp.rb ~/tp.rb             # 更改文件名（相同目录时）
                                 # 如果，在更改目录下已有，这个新名字的文件，会只保留现在的这个文件
mv file1 file2 file3 directory   # 一次移动多个文件
mv aa.rb{,.bak}                  # 复制出一个 aa.rb.bak文件

cp cp -a /Users/dongmingyan/yg/emall_interface/* vendor/emall_interface # 复制一个文件中的所有内容（文件/目录）到另外一个目录

rm -rf uploads/attachment/file/*  删除目录下所有文件

date            当前日期
cal             本月日历
df              磁盘空间情况
free            空闲内存情况（mac终端没法用）

ctrl + R        搜索之前使用的命令
history         命令行历史（列出命令后！+ 编号）调出命令

ctrl + U    光标当前位置到行首剪切
ctrl + K    光标当前位置到行尾剪切
ctrl + Y    粘贴剪切内容
  
mkdir dir1  创建目录
mkdir -p dir1 创建目录（如果目录已存在也不会报错，它只是默默的不创建）

less 文件名/路径       page up/page down 翻页；g/G 首尾; 

file 文件名/目录       文件的信息

find ~                                                  # 列出家目录下所有文件和目录
find ~ -name learn-note                                 # 列出家目录下 文件名/目录名是 learn-note的 文件/目录
find learn-note -name '*test.rb'                        # 列出learn-note 目录下 文件名/目录 是test.rb结尾的文件
find learn-note -type d -name '*s*'                     # 列出learn-note 目录下 名字中包含s 的目录
find learn-note -type f -name '*s*'                     # 列出learn-note 目录下 名字中包含s 的文件
find learn-note -type f -name '*s*' | wc -l             # 计算learn-note 目录下 名字中包含s 的文件 个数
find learn-note -type f -name '*s*' -exec cat '{}' +    # 将learn-note目录下 名字中包含s 的文件找出，然后所有文件执行 cat 操作
                                                        # {} 代表 当前路径；+表示这些文件全部(整体）找到后,执行一次cat


ps                    # 列出与当前终端相关的进程
ps x                  # 初略（数据列少）的列出所有进程
ps aux                # 详细（数据列多）的列出所有进程
ps aux |grep sidekiq  # 从所有进程中过滤出 sidekiq相关进程
ps aux | less         # 太长分页查看

kill 1024             # 杀死（终止）进程号为1024进程
kill -stop 1024       # 停止1024号进程
kill -cont 1024       # 继续1024号进程
kill -9 1024          # 确认1024进程是否存在,若存在强制删除

lsof -i               # 列出所有网络连接
lsof -i :3000         # 列出端口3000占用情况
lsof -i :3000 -t      # 端口3000所占用的进程id
lsof -p 4523          # 查看5423进程打开文件情况
sudo lsof -i -P -n    # 查看打开了哪些端口监听等
lsof | grep delete # 列出打开的已删除进程
ls -l | sort -nrk 5   # 按照文件大小排序

id                    # 用户id信息
chmod 640 foo.text    # 更改文件权限
                      # rwx代表 读 写 执行，数字是 4 2 1
                      # 640分三位：6 4 0 即是 4 + 2、2、0 也就是 读写、写、无权限
                      # 对应拥有者、组、其它人权限

tail -n 5 temp.rb     # 打印出temp.rb文件的 最后 5行(默认10行)
tail -n +5 temp.rb    # 打印出temp.rb文件 第5行 开始的内容
sed '5d' temp.rb      # 和上等价
tail -100f temp.rb    # 动态追踪temp.rb 最后100行

nproc        # 查看系统是几个核心
ulimit -n    # 每个核心允许打开文件最大数

echo > foo.txt            # 清空文件
cat > foo.txt             # 输入信息，换行输入ctrol + D（创建并写入foo.txt文件） 什么也不写 清空文件
                          # 输入信息，换行输入ctrol + D 创建并写入foo.txt
cat > foo.txt <<EOF       # 创建文件 写入内容，方便发给其它人
sdafhusdaf
sdahf
EOF
ls >> foo.txt             # 追加信息 到foo.txt 末尾       


# PS: scp命令针对的是本地端（非服务器）
scp scp_test.rb kuban_dev:.             # 将本地scp_test.rb 传到配置好的kuban_dev服务器家目录
scp kuban_dev:scp_test.rb scp_test_2.rb # ssh kuban_dev 是配置好的（将scp_test.rb 下载到本地scp_test_2.rb 文件）
scp kuban_pro:{2021投诉,2022投诉,2021报修,2022报修}.csv ./Downloads # 一次下载多个文件

scp hu.txt root@120.69.192.128:.        # 将本地   hu.txt 文件 上传到服务器 当前目录(.)
scp root@120.68.192.128:hu.txt hu.txt   # 将服务器 hu.txt 文件 下载到本地 文件（hu.txt）
scp -P 9032 kuban@39.105.140.xxx:syslog.1 ./Downloads # 端口要用大写P

# 过滤时间范围日志
# PS：1. 注意这里如果截止时间不能匹配，开始之后的所有将返回
#     2. 当匹配到首个2020-06-13T00:00:05则终止向下查询，所以会返回一行 2020-06-13T00:00:05
sed -n '/2020-06-13T00:00:02/,/2020-06-13T00:00:05/p' log/web_sandbox_console.log

wc -l < log/development.log    # 统计行数


ln file1 file2    #硬链接
ln -s file1 file2 #软链接（file2指向file1 file2->file1 类型于快捷方式；目标在前）
# 链接的作用：
# 文件共享，不同的文件或路径可以访问、编辑相同的内容
# 不同点：
# 硬-删除之间相互不影响
# 软-删除了源文件后，快捷文件（也就是失效了）

# 这两种写法在重启系统后，进程都会丢失
nohup cmd & # 退出终端后仍然执行
(cmd &)     # 这样也行

wget -O p.jpg  https://gimg2.baidu.com/image_search/xx.jpg # 下载某个文件并命名
# ===============================较少用到======================
du                             # 列出当前目录下 所有文件
du -h file                     # 人类可读方式 查看文件大小

sort t.html                    # 对文件内容排序
sort -nr t.html                # n(数字排序) r(倒叙)

cut -d , -f 1 notes.csv        # 将notes.csv 文件内容（1、以逗号分隔 2、取首列）
head                           # 默认取前十行
 

type      命令名                # 查看命令类型（shell的？还是其它）
which     命令名                # 查看命令可执行档位置
alias foo='cd learn;ls;cd -'   # 命一个别名代表 一串操作(ps: 关闭终端就失效了)
unalias foo                    # 去掉别名foo

grep 'test' db_test.rb temp.rb      # 在文件中匹配字符串(这里只支持文件)
grep -i 'test' db_test.rb temp.rb   # 忽略大小写
grep -l 'test' db_test.rb temp.rb   # 列出匹配到的文件
grep hu -Ir log                     # I（忽略二进制文件）r（递归文件） 检索hu
grep -A 10 -B 10 self.product_klass.find_by /Users/dongmingyan/t.rb  # 过滤匹配内容的前后10行
grep -rnw ./src/ -e KUBAN_BASE_URL  # 在src目录下所有文件中，查文件内容中包含KUBAN_BASE_URL字符串的文件
# -r 递归
# -n 行号
# -w 完整匹配
grep -a xx file_name # Binary file 提示，前面加-a


zgrep 'test' production.gz # 过滤gz文件
zless production.gz        # 查看gz文件内容

ls learn-not/ruby/语法 | grep rb    # 过滤出xx目录下 包含rb的文件名

seq 1 1000000 > lines.txt  # 产生一个 1000000行的文件
time wc -l lines.txt       # 查看命令执行时间

# 清空日志
> staging.log
truncate -s 10 staging.log # 缩小/扩大文件大小

#============================== PS ===========================

cd learn;ls;cd -                               # 用分号分隔，一次执行多个命令

touch photo-{2010..2018}-{0{1..9},{10..12}}    # {} 展开 创建 类似 phtoto-2010-01文件
                                               # .. 表示范围   , 表示多个 可嵌套

ls b*                                          # 通配符 列出 b 开头文件 其下目录
ls blog/*/models                               # 列出 文件路径 符合 blog/任意/models 文件

# 出口ip
curl cip.cc

# 时区调整-ubuntu
sudo timedatectl set-timezone Asia/Shanghai

# 以root身份登录（对于类似重定向的操作简单sudo是不起作用的）
sudo -i

ifconfig      # 查看网络接口配置
ifconfig eth0 # 查看网卡eth0 网络配置
ip addr add 192.168.0.127/24 dev eth0 # 添加ip到 eth0网卡 dev代表设备
ip addr show eth0                     # 查看eth0 配置ip信息
#=============================== crontab ======================
crontab crontab.txt  # 加载写好的定时任务   # PS：加载后需要 crontab -e 才会生效
crontab -e           # 为当前用户添加定时任务(打开编辑界面)
crontab -l           # 列出当前定时任务
crontab -r           # 删除所有定时任务

# 任务写法
# 分 时 天 月  周(0-6) Command_to_execute

0 0 * * * pwd > /Users/dongmingyan/test.md          # 每天00:00分
*/5 * * * * pwd > <command-to-execute>              # 每五分（PS: / 代表每多少）
0,5,10 * * * * pwd > <command-to-execute>           # 每个小时中0、5、10分（PS：, 代表多个）
0 0 * * 1-5 <command-to-execute>                    # 每个工作日00:00分
15 16 1 * * <command-to-execute>                    # 每月1日16:15分
```





