#### HomBrew
> 开机自启动项，放在 `~/Library/LaunchAgents`下

```
brew help                    帮助

brew list memcached          查询已安装包路径

brew search mysql            查询可用包
brew install wine            安装xx包
brew update                  更新
brew uninstall --force mysql 卸载
brew remove postgresql@9.4   移除（和uninstall 等效）
brew info memcached          已安装包信息（包含一些启动命令等）

brew services list                  后台启动列表
brew services start mysql@5.7       后台自动启动（以后开机）mysqk@5.7（可替换成memcached等其它项)
brew services restart mysql@5.7     重启
brew services stop  mysql@5.7       停止
```
