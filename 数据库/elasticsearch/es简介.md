##### elasticsearch
> 用途
> 1. 高性能全文检索，比如商品数据的检索
> 2. 数据统计分析，它相比于关系型数据库，具有相当优秀的统计分析手段

##### 相关url
> 1. 官网 https://www.elastic.co/guide/en/elasticsearch/reference/7.17/index.html
> 2. 中文件教程 https://www.tizi365.com/archives/709.html

##### 手动安装
>1. 安装包[下载链接](https://www.elastic.co/downloads/elasticsearch)
>2. 解压安装包后,`bin/elasticsearch` 启动服务（PS：切到安装包目录下）
>3. `curl http://localhost:9200/`测试服务是否成功
>4. 这里安装 5.0.0 是可以的
>5. 配置文件elasticsearch路径下 `config/elasticsearch.yml`

##### brew 安装
> 1. 地址[链接](https://gist.github.com/evgeniy-trebin/02fafdf03c18df4e03a4eaee1b939f11)
> 2. brew 安装不太建议使用，版本比较旧、下载也慢

##### 重要概念
集群（cluster）
> 对于es来说，一开始就是就是集群的

节点（node)
> 多个节点组成集群

分片（shard）
> 一个索引可能单个节点无法存储，就存到多个节点；可以提高吞吐量

索引（index)
> 名称： 相当于数据库
> 动词： 将数据存储到es中

映射（mapping)
> 1. 相当于关系性数据库的schema,字段类型等定义
> 2. 在es中字段的定义一开始就要定义好，后面没法改字段类型，除非重新索引；加字段是可以的

terms(术语)
> 类似于字典中的词汇表，主要用于精确匹配

文档（document)
> 相当于关系性数据库中行，在es中数据是按照json存储的

##### 中文分词器
> 默认情况下es的分词是针对英文的，我们需要中分分词
> 1. 第一种：smartcn 比较简单`bin/elasticsearch-plugin install analysis-smartcn`
> 2. 第二张：ik支持自定义词库，更流行，具体参考 `https://github.com/medcl/elasticsearch-analysis-ik`
> PS: 安装好后需要指定分词器才会生效
> PS: 两种安装方式
> - 手动下载分词器后，解压后放置到plugins 目录下
> - 利用 `elasticsearch-plugin` 命令





