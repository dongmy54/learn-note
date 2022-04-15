#### 系统级查看

###### top
> top 是一个相当全面的命令，可以同时列出进程、任务、cpu、内存的各种信息

示例
```
kuban@kuban-prod-1:~$ top
top - 14:47:36 up 168 days,  2:37,  2 users,  load average: 0.67, 0.54, 0.54
Tasks: 169 total,   1 running, 102 sleeping,   0 stopped,   0 zombie
%Cpu(s):  6.4 us,  2.1 sy,  0.0 ni, 87.1 id,  0.0 wa,  0.0 hi,  4.3 si,  0.0 st
KiB Mem : 14333920 total,  2230052 free, 10929588 used,  1174280 buff/cache
KiB Swap:        0 total,        0 free,        0 used.  3074964 avail Mem

  PID USER      PR  NI    VIRT    RES    SHR S  %CPU %MEM     TIME+ COMMAND
 5463 kuban     20   0 2514740 1.285g   9012 S   8.6  9.4  78:57.12 ruby
 5458 kuban     20   0 4143788 2.759g   9112 S   5.7 20.2  82:42.01 ruby
   11 root      20   0       0      0      0 I   2.9  0.0 463:14.54 rcu_sched
 3315 kuban     20   0  915176  69048  17608 S   2.9  0.5   1787:50 PM2 v4.2.3: God
 4187 kuban     20   0  936168  88128  31228 S   2.9  0.6   3:08.15 node /mnt/sdc/a
 4608 kuban     20   0  921864  72684  32200 S   2.9  0.5   0:53.23 node /home/kuba
 5462 kuban     20   0 4344204 2.951g   8768 S   2.9 21.6  84:10.29 ruby
11297 www-data  20   0  308216  59528   7324 S   2.9  0.4  11:41.61 nginx
11298 www-data  20   0  308124  59524   7184 S   2.9  0.4   8:05.02 nginx
11299 www-data  20   0  308228  59536   7372 S   2.9  0.4   1:53.56 nginx
11300 www-data  20   0  308628  60160   7360 S   2.9  0.4   3:50.32 nginx
12960 kuban     20   0  921376  76392  13592 S   2.9  0.5   1919:11 node /home/kuba
16962 kuban     20   0  633420  56900  12264 S   2.9  0.4 564:27.20 node /home/kuba
18434 kuban     20   0   44528   3960   3308 R   2.9  0.0   0:00.02 top
```

##### 参数说明
```
top - 14:47:36 up 168 days,  2:37,  2 users,  load average: 0.67, 0.54, 0.54
=========================
14:47:36  系统当前时间
up 168 days,  2:37 系统从开机到现在多久啦
2 users 当前两个用户同时在线
load average: 0.67, 0.54, 0.54   1、5、15分钟cpu负载


Tasks: 169 total,   1 running, 102 sleeping,   0 stopped,   0 zombie
=========================
任务(没啥用)
169 total 总共169个进程
其它多少运行、睡眠..


%Cpu(s):  6.4 us,  2.1 sy,  0.0 ni, 87.1 id,  0.0 wa,  0.0 hi,  4.3 si,  0.0 st
=========================
占用cpu时间百分比（意义不大）
us 用户态 进程占用cpu时间百分比
sy 内核态 进程占用cpu时间百分比
id 空闲cpu时间占比
wa 等待IOcpu时间占比


KiB Mem : 14333920 total,  2230052 free, 10929588 used,  1174280 buff/cache
=========================
内存信息 
total - 物理内存总量 
free  - 空闲物理内存量
used - 已使用物理内存量
buff/cache - 内核缓存物理内存量
PS: total = free + used + buff/cache


KiB Swap:        0 total,        0 free,        0 used.  3074964 avail Mem
=========================
交换空间
total - 交换区总量
free  - 空闲交换区量
used  - 使用交换区量
avail mem - 缓存交换区量


PID USER      PR  NI    VIRT    RES    SHR S  %CPU %MEM     TIME+ COMMAND
=========================
PID - 进程id
USER - 进程开启用户
PR - 进程优先级（越小越优先）
VIRT - 虚拟内存用量
RES - 物理内存用量
SHR - 共享内存用量
S - 进程状态
CPU - cpu占比
mem - 内存占比
time - 进程从启用开始后占用cpu的总时间
command - 命令
```

###### 交互
> 1. top 命令开启后，反应的是计算机实时的数据，是可以进行一些交互的
> 2. 这里交互区分大小写哦
> 3. 同一个参数

```
开启top后按
M 按照内存占用排序
P 按照cpu占用排序
T 按占用cpu时间排序
c 展示完整命令

q 退出
==========================（常用的就上面的）=========
m 展示内存总的占比（再次按恢复原来）
1 多核cpu展开每个(再次按可以恢复原来的)
i 只展示正在运行的进程(再次按可以复原)
```


###### 内存
```
free -h 内存总概
```

###### 硬盘
```
f-file 文件系统角度
df -h 
df -h apps 指定路径

u-usage 使用角度
du -h  默认列出当前路径下所有文件/子目录
du -h apps 指定路径
du -h --max-depath=1    当前目录往下一层
echo > production.log   清空文件
```



