#### CORS(Cross-origin resource sharing) 跨域资源共享
> 从浏览器ajax一个请求到服务器,服务器不受理（当前浏览器域名和服务器域名不同）

解决办法：服务器设置响应头
```
Access-Control-Allow-Origin: *                    # 任何域都可以
Access-Control-Allow-Origin: http://172.20.0.206  # 指定域
```

