#### mac commands
```
command + space     查询
command + 加号       放大
command + 减号       缩小


command + shift + 5 录屏/开启-关闭
```


##### 配置mac上端口
打开指定的3000端口
```
sudo vim /etc/pf.conf
# 添加 pass in inet proto tcp from any to any port 3000 no state 开放3000 规则

# 写入配置文件
sudo pfctl -f /etc/pf.conf
# 重启防火墙
sudo pfctl -E
```

##### hosts文件位置
/etc/hosts

