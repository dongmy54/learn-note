#### 同一个database文件配多个数据库
> 实际上在database文件下,我们除了可配置`development`、`test`、`production`外，还可配其它的
1. 这里一个名称：代表一个可用的环境库（比如：`rails c -e evbdup_default`)
2. 使用`establish_connection("evbdup_#{Rails.env}".to_sym)`

```yaml
development: &development
  adapter: mysql2
  encoding: utf8
  host: xx.example.com
  reconnect: false
  database: xdd
  pool: 5
  username: root
  password: 123456

production:
  <<: *development
test:
  <<: *development

# evbdup数据库配置
evbdup_default: &evbdup_default
  adapter: mysql2
  host: xx.example1.com
  database: evdb
  username: root
  password: 123456

evbdup_development:
  <<: *evbdup_default

evbdup_test:
  <<: *evbdup_default

evbdup_production:
  <<: *evbdup_default
```