## wireguard
```shell
brew install wireguard-tools
```

安装后配置
`mkdir /usr/local/etc/wireguard`
`sudo vim wg0.conf`

```
[Interface]
PrivateKey = 自己客户端私钥
Address = 10.10.10.xx/24
Table = off
PostUp = route -n add -net 192.168.15.0/24 -interface utun3
PreDown = route -n delete -net 192.168.15.0/24
 
[Peer]
PublicKey = 公网服务端公钥
AllowedIPs = 10.10.10.0/24, 192.168.15.0/24
Endpoint = 47.109.153.xxx:318xxx // 公网服务器ip/端口
PersistentKeepalive = 25
```

启动
```
alias wg-d='sudo wg-quick down wg0'
alias wg-u='sudo wg-quick up wg0'
alias wg-s='sudo wg'
```

注意自己的私钥、公钥生成要使用它自带的工具
```shell
mkdir ~wgkeys
wg genkey | tee client_private.key | wg pubkey > client_public.key // 生成的公秘提供给服务器端做配置 
```


