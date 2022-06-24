#### count Vs length VS size

##### count
> 1. 如果有计数缓存，则优先使用计数缓存
> 2. 否则，生成一条sql语句到数据库中查询`select count(*) from table_names`
> PS：也就是基本上（无计数缓存）都会，到数据库中去查

##### length
> 1. 如果数据已经加载到内存中，则在内存中用ruby方式计算数量
> 2. 如果没有加载到内存，则将所有数据一次加载到内存，生成类似`select * from table_names`;然后用ruby方式计算
> PS： 特别危险，将数据全部加载到内存；如果已经在内存，如user.roles已经includes还好
>    它的致命弱点是，始终使用ruby方式计算，完全不用sql语句的 count方式

##### size
> 1. 结合count 和 lenght；
> 2. 如果数据在内存中，则用length;如果不在，则用count;此时结合了二者的有点
> 3. 非常安全，此为首推方法




