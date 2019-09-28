#### postman

#### 发送form_data 参数
> 1. 嵌套 [a]
> 2. 数组 []

```ruby
Key       Value 
box[n1]    b
box[n2][]  c
box[n2][]  d

# 参数如下
{"box":{"n1":"b","n2":["c","d"]}}
```

#### 带cookie
> 出于安全考虑,google浏览器下载 postman interceptor

```ruby
Key                value
Cookie             _gdddxt_session=84490319ea0ce4bee0xxxxxyyyyy
Cookie             UM_distinctid=16b8c40515ad2-0d89c45e709221-37677e02-13c680-16b8c40515b668
```