#### 窗口函数
> 主要用于解决
> 1. 聚合函数会缩减行数，不能展示细分行
> 2. 数据的排名、累计分布等问题
> 3. 常用于，聚合函数、rank()、cume_dist ()、row_number()等等
> PS: 从8.0开始才支持

##### 使用
```sql
SELECT
    fiscal_year,
    sales_employee,
    sale,
    SUM(sale) OVER (PARTITION BY fiscal_year) total_sales
FROM
    sales;
```
