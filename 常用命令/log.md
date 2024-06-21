## log

nginx日志格式
```
47.93.183.161 - - [21/Jun/2024:06:34:43 +0000] "POST /managements/open/qy_wechat/receive_ticket?msg_signature=153079b87b2257c8c49484d9d5760df084902a86&timestamp=1718951683&nonce=1719066962 HTTP/1.0" 404 1564 "-" "Mozilla/4.0"
47.93.183.161 - - [21/Jun/2024:06:34:43 +0000] "POST /qiye_wechat/callback?msg_signature=02eca7e79aa0f5ec274690c79595a0a79d24a3de&timestamp=1718951683&nonce=1719074365 HTTP/1.0" 404 178 "-" "Mozilla/4.0"
47.93.183.161 - - [21/Jun/2024:06:34:43 +0000] "POST /managements/open/qy_wechat/receive_ticket?msg_signature=8ccb03dc1e763aec0d27acdc00b3331327308dc4&timestamp=1718951683&nonce=1719053955 HTTP/1.0" 404 1564 "-" "Mozilla/4.0"
47.93.183.161 - - [21/Jun/2024:06:34:43 +0000] "POST /managements/open/qy_wechat/receive_ticket?msg_signature=153079b87b2257c8c49484d9d5760df084902a86&timestamp=1718951683&nonce=1719066962 HTTP/1.0" 404 1564 "-" "Mozilla/4.0"
47.93.183.161 - - [21/Jun/2024:06:34:43 +0000] "POST /qiye_wechat/callback?msg_signature=02eca7e79aa0f5ec274690c79595a0a79d24a3de&timestamp=1718951683&nonce=1719074365 HTTP/1.0" 404 178 "-" "Mozilla/4.0"
47.93.183.161 - - [21/Jun/2024:06:34:43 +0000] "POST /managements/open/qy_wechat/receive_ticket?msg_signature=8ccb03dc1e763aec0d27acdc00b3331327308dc4&timestamp=1718951683&nonce=1719053955 HTTP/1.0" 404 1564 "-" "Mozilla/4.0"
47.93.183.161 - - [21/Jun/2024:06:34:43 +0000] "POST /managements/open/qy_wechat/receive_ticket?msg_signature=153079b87b2257c8c49484d9d5760df084902a86&timestamp=1718951683&nonce=1719066962 HTTP/1.0" 404 1564 "-" "Mozilla/4.0"
47.93.183.161 - - [21/Jun/2024:06:43:11 +0000] "GET / HTTP/1.0" 200 1829 "-" "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/92.0.4515.131 Safari/537.36"
47.93.183.161 - - [21/Jun/2024:06:43:12 +0000] "GET / HTTP/1.0" 200 1829 "-" "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/45.0.1559.966 Safari/537.36"
47.93.183.161 - - [21/Jun/2024:06:43:12 +0000] "GET /favicon.ico HTTP/1.0" 200 15406 "-" "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/45.0.1559.966 Safari/537.36"
```


```shell
# 找出一段时间内请求数量大的url
awk -v start="[21/Jun/2024:00:00:00" -v end="[21/Jun/2024:15:43:12" '$4 >= start && $4 <= end {print $6,$7}' /var/log/nginx/access.log | awk -F '?' '{print $1}' | sort | uniq -c | sort -nr | head -10



# awk 默认通过空格分割 -F 可以指定分割符号
# 分割后通过 $+第几个取值（注意它取值是从1开始）
```