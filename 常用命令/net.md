### 网络相关
```
ifconfig           查看本机 mac地址 或 分配ip地址
  
ping 域名/ip        查看一个数据包发到指定ip  往返时间  和 丢包情况

traceroute 域名/ip  查看到达指定ip  途中经过的 路由情况

whois 域名          谁注册了这个域名

nslookup 域名       查看域名对应的ip(有时会有多个)

dig baidu.com       详细的查找域名 ip信息

dig @a.root-servers.net baidu.com   从顶层开始查起

curl -v https://www.baidu.com/\?tn\=sitehao123_15                 # 将请求结果打印在终端

curl -o curl_test.txt https://www.baidu.com/\?tn\=sitehao123_15   # 将请求结果保存到 curl_test.txt 文件

curl -O https://www.baidu.com/\?tn\=sitehao123_15   # 将请求结果保存到，url末尾名称（?tn\=sitehao123_15） 这里的 O 是大写

curl -so curl_test.txt https://www.baidu.com/\?tn\=sitehao123_15  # 静静地将结果保存到 curl_test.txt s 表示静默
```