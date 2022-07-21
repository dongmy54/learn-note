#### lua 脚本
> 1. lua脚本执行的时候，是相当于把这个脚本当作一个命令整体去执行的
> 2. 但是需要记住的是，脚本中多个命令，如果执行过程中有错误，也不是原子的哦
PS： lua是一门语言

##### 为什么有了事务还需要lua脚本
> 虽然我们有了事务，可以保证多个命令打包一起执行没，但是对于一些包含逻辑判断等复杂的操作，事务并不能满足要求

##### 应用场景
> 主要用于高并发的，比如秒杀、抢红包等业务场景

##### redis中使用方式
> `EVAL lua_script 键数量 [key1] [key2] 参数1 参数2 `
> - 键数量 不可省-没有就是0
> - key 没有可以省，脚本中通过KEYS[1] 第一个key
> - 参数 没有可省，脚本中通过ARGV[1] 第一参数

```shell
127.0.0.1:6379> EVAL "return 'hello'" 0 
"hello"

127.0.0.1:6379> eval "return {ARGV[1],ARGV[2]}" 0 100 101
1) "100"
2) "101"

127.0.0.1:6379> eval "return {KEYS[1],KEYS[2],ARGV[1],ARGV[2]}" 2 key1 key2 first second
1) "key1"
2) "key2"
3) "first"
4) "second"

127.0.0.1:6379> eval "redis.call('SET', KEYS[1], ARGV[1]);redis.call('EXPIRE', KEYS[1], ARGV[2]); return 1;" 1 test 10 60
(integer) 1
```

缓存脚本-返回sha校验字符串后续可执行
好处：性能比较高，可以任意地方使用
```shell
127.0.0.1:6379> SCRIPT LOAD "return 'hello'"
"1b936e3fe509bcbc9cd0664897bbe8fd0cac101b"
127.0.0.1:6379> EVALSHA "1b936e3fe509bcbc9cd0664897bbe8fd0cac101b" 0
"hello"
127.0.0.1:6379> EVALSHA "1b936e3fe509bcbc9cd0664897bbe8fd0cac101b" 0
"hello"
127.0.0.1:6379> SCRIPT FLUSH                                              # 清除脚本
OK
127.0.0.1:6379> EVALSHA "1b936e3fe509bcbc9cd0664897bbe8fd0cac101b" 0
(error) NOSCRIPT No matching script. Please use EVAL.
127.0.0.1:6379> SCRIPT EXISTS 1b936e3fe509bcbc9cd0664897bbe8fd0cac101b    # 检查脚本是否存在
1) (integer) 0
```

##### 命令行执行lua脚本
> `redis-cli --eval lua_file key1 key2 , arg1 arg2 arg3`

注意：
> 1. eval 后面参数是lua脚本文件,.lua后缀
> 2. 不用写键数量 用逗号分隔

##### lua脚本简单语法




