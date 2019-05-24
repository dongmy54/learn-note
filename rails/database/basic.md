#### 基本配置
> 1. 一般我们通过`config/database.yml`做配置
> 2. 一般我们的开发/生产/测试数据库名称要区分开


```yaml
# config/database.yml

# 定义默认部分 也就是通用部分
default: &default
  adapter: mysql2         # 适配器
  encoding: utf8          # 编码方式
  reconnect: false        # 是否重连
  pool: 5                 # 连接池个数
  host: xx.example.com    # 数据库服务器 域名/ip
  username: root          # 数据库服务器 用户名
  password: 123456        # 数据库服务器 密码

development:
  <<: *default               # << 代表共享配置即（default)
  database: xx_development   # 开发数据库

production:
  <<: *default
  database: yy_production    # 生产环数据库

test:
  <<: *default
  database: zz_test          # 测试环境数据库
```