## asynq
```shell
# 总览
asynq dash --uri=xx.aliyuncs.com:6379 --password=yyyCiBd --db=9

# 列出所有队列
asynq queue list --db=9 

# 指定队列查看详情（默认本地redis)
asynq queue inspect msg:retry --db=9 


# 列出 任务（默认每页 30 条）
asynq task list --queue=msg:retry --state=archived --db=9 # archived 任务
asynq task list --queue=msg:retry --state=retry --db=9 # retry任务
asynq task list --queue=msg:retry --state=archived --page=1 --size=2 --db=9  # 分页查询 page从1开始

# 任务详情
asynq task inspect --queue=msg:retry --id=<task_id> --db=9
# => 队列名、任务ID、任务类型、状态、已重试次数、下次执行时间、最后失败时间和错误信息

# 归档
asynq task archiveall --queue=msg:retry --state=retry --db=9  # 按状态归档
asynq task archive --queue=msg:retry --id=26b74372-d89e-411b-a36a-ef8fad2b4893 --db=9 # 按任务id 归档

# 运行
asynq task runall --queue=msg:retry --state=archived --db=9 # 按状态全部运行
asynq task run --queue=msg:retry --id=26b74372-d89e-411b-a36a-ef8fad2b4893 --db=9 # 按任务id 运行

# 删除
asynq task deleteall --queue=msg:retry --state=archived --db=9  # 按状态删除
asynq task delete --queue=msg:retry --id=<task_id> --db=9 # 按id删除

# 队列控制
asynq queue pause msg:retry --db=9 # 暂停队列
asynq queue resume msg:retry --db=9 # 恢复队列
```
