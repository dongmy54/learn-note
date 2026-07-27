## 如果遇到连接过程中ssh连上后日志一直在wait for lock
```
killall windsurf-server 2>/dev/null
pkill -f "windsurf"

# 检查并删除 Windsurf 或 Codeium 的相关锁文件
rm -rf ~/.windsurf-server/cli/servers/Stable-*/.windsurf.*.lock
rm -rf ~/.codeium/windsurf-server/lock*
# 如果找不到，可以尝试清理可能残留的 vscode 相关锁
rm -rf ~/.vscode-server/bin/*/.lock*
```
