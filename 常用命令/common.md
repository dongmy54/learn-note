### 命令通识

##### 选项 和 选项同行分隔
```
-r, --require PATH`

含义：逗号分隔号以后,一般为非缩写
```

##### 选项 和 选项以下行
```
-O, --options PATH                 Specify the path to a custom options file.
    --order TYPE[:SEED]            Run examples by the specified order type.

含义：第一行以后,代表近似选项
``` 

##### 大写名称
```
--require PATH
--seed SEED
--format FORMATTER

含义：为可变部分（非命令本身选项）
比如：--format j / --format d 
```

#### 选项后 多行说明
```
--order TYPE[:SEED]     Run examples by the specified order type.
                           [defined] examples and groups are run in the order they are defined
                           [rand]    randomize the order of groups and examples
                           [random]  alias for rand
                           [random:SEED] e.g. --order random:123

含义：一般为可选项（多种模式用法）
```