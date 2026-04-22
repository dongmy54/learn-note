##### tmux
> 1. 可以断开sessions去完成耗时任务，后续进行查看
> 2. 可以开多个窗口

```bash
# 新开tmux会话
tmux                  # 直接打开一个tmux 未命名（默认是0）
tmux new -s dmy-test  # 给tmux命名 dmy-test 方便后续重新查看

# 中途离开（用的最多 d - Detach）
ctrl + B 然后 d      # 断开当前tmux 可以中途离开 过一段时间再来看

# 重新回来
tmux a -t dmy-test   # 重新打开之前中途离开的tmux a - attach重新拾起 dmy-test tmux的名称

# 退出tmux/窗口
exit # 简单（有时)

# 列出
tmux ls   # 列出当前的所有session 可以看到tmux窗口名字

# 不用进入tmux就退出方式
tmux kill-sess -t dmy-test # 按名字kill

#========================== 其它 ===========================#
# PS: 发现重新连接的时候，session名称可以完整也可以进入

# 重新命名tmux
tmux rename -t dmy-test dmy-test-1 # 将dmy-test 命名成 dmy-test-1

## 窗口操作
# 打开窗口
ctrl + B 然后 按C      # 新开窗口
                      # 许多操作都是基于ctrl + B 后开始的

# 窗口切换
ctrl + B 然后 按w     # 展示出当前session的窗口列表
                     # 上下选中后 回车切换
```

