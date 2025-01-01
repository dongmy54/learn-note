## 快速开始elasticsearch

### 一、环境搭建
我们通过docker开始启动elasticsearch、和kibana
`docker-compose.yml`文件如下：
```yaml
services:
  elasticsearch:
    image: elasticsearch:8.10.1
    environment:
      - discovery.type=single-node # 单节点开发环境
      - xpack.security.enabled=true # 启用安全认证
      - ELASTIC_PASSWORD=your_elastic_password # 设置一个强密码
      - "ES_JAVA_OPTS=-Xms512m -Xmx512m" # 根据需要调整内存
    ports:
      - "9200:9200"
      - "9300:9300"
    networks:
      - elastic
    healthcheck: # 改进的健康检查
      test: ["CMD-SHELL", "curl -s http://localhost:9200/_cluster/health >/dev/null || exit 1"]
      interval: 10s
      timeout: 5s
      retries: 5
    volumes:
      - esdata:/usr/share/elasticsearch/data # 持久化数据

  kibana:
    image: kibana:8.10.1
    environment:
      ELASTICSEARCH_HOSTS: http://elasticsearch:9200
      ELASTICSEARCH_USERNAME: kibana_system # 这个用户是es默认创建的
      ELASTICSEARCH_PASSWORD: abcdefg # 设置成你自己的密码
      ELASTICSEARCH_SSL_VERIFICATIONMODE: none
      XPACK_SECURITY_ENABLED: "true"
      XPACK_ENCRYPTEDSAVEDOBJECTS_ENCRYPTIONKEY: "something_at_least_32_characters"
    ports:
      - "5601:5601"
    depends_on:
      - elasticsearch
    networks:
      - elastic
    healthcheck:
      test: ["CMD-SHELL", "curl -s http://localhost:5601 >/dev/null || exit 1"]
      interval: 30s
      timeout: 10s
      retries: 3

networks:
  elastic:

volumes:
  esdata:
```

由于8.10.1版本kibana不能通过默认的elastic（超级用户）账户登录，这里我们通过另外一个非超级用户的账号kibana_system做登录。
这个用户es默认已经创建好了，我们只需要初始化它的密码就行。

按如下步骤操作
#### 1. 启动 Elasticsearch
首先只启动 Elasticsearch 服务：
```bash
docker-compose up elasticsearch -d
```

等待 Elasticsearch 完全启动（大约需要 1-2 分钟）。

#### 2. 重置密码
执行命令`docker-compose exec elasticsearch bin/elasticsearch-reset-password -u kibana_system -i`进入交互界面

大概这样
```bash
dongmingyan@pro  ⮀ docker-compose exec elasticsearch bin/elasticsearch-reset-password -u kibana_system -i
This tool will reset the password of the [kibana_system] user.
You will be prompted to enter the password.
Please confirm that you would like to continue [y/N]y


Enter password for [kibana_system]: 
Re-enter password for [kibana_system]: 
Password for the [kibana_system] user successfully reset.
```
这里需要注意的一点是密码要设置成字符串，不要设置成纯数字——它不支持。
这里我把密码设置成abcdefg了，如果你是其它密码记得去`docker-compose.yml`改`ELASTICSEARCH_PASSWORD`密码哦

#### 3. 启动完整服务
启动所有服务：
```bash
docker-compose up -d
```
这里启动过程需要点时间，耐心等待下。

#### 5. 访问服务
可以开始访问啦！
- Elasticsearch: http://localhost:9200
- Kibana: http://localhost:5601

PS: 直接用,默认用户名为 `elastic`，密码用docker-compose.yml中环境变量写的`your_elastic_password`直接登录即可。