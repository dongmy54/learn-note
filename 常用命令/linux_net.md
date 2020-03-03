### 网络相关
```
curl myip.ipip.net  查看出口网络ip<公网ip>
ifconfig           查看本机 mac地址 或 分配ip地址
  
ping 域名/ip        查看一个数据包发到指定ip  往返时间  和 丢包情况

traceroute 域名/ip  查看到达指定ip  途中经过的 路由情况

whois 域名          谁注册了这个域名

nslookup 域名       查看域名对应的ip(有时会有多个)

dig baidu.com       详细的查找域名 ip信息

dig @a.root-servers.net baidu.com   从顶层开始查起

curl https://www.baidu.com/\?tn\=sitehao123_15                    # 只将返回内容打印在终端

curl -I https://www.baidu.com/\?tn\=sitehao123_15                 # 只返回请求头

curl -v https://www.baidu.com/\?tn\=sitehao123_15                 # 将请求结果打印在终端(包含请求、响应头等信息)

curl -o curl_test.txt https://www.baidu.com/\?tn\=sitehao123_15   # 将请求结果保存到 curl_test.txt 文件

curl -O https://www.baidu.com/\?tn\=sitehao123_15                 # 将请求结果保存到，url末尾名称（?tn\=sitehao123_15） 这里的 O 是大写

curl -so curl_test.txt https://www.baidu.com/\?tn\=sitehao123_15  # 静静地将结果保存到 curl_test.txt s 表示静默

curl -u user_name:password https://example.com                    # 可以登录服务器 或 破除网页基本认证

curl -d 'loginid=dmy&password=123456' https://example.com         # 发送 post 提交表单参数

curl -c cookie.txt  https://example.com                           # 将cookie 信息保存到本地 cookie.txt

curl -X<请求方式> '请求url' -d '<请求body>'
比如：
curl -XGET 'http://localhost:9200/_count?pretty' -d '
{
    "query": {
        "match_all": {}
    }
}
'
```


### 其它
```
ufw status        # 防火墙状态
ufw allow ssh     # 允许 ssh连接
ufw allow tcp     # 允许tcp
ufw allow mysql   # 允许mysql
ufw allow udp     
sudo ufw enable   # 激活
sudo ufw disable  # 禁用
```