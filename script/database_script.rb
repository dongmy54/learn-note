require 'sequel' 
require 'pg'
require "rexml/document" 

DB = Sequel.postgres(:host => '121.xxx.xx.xxx', 
           :port => xxxx, 
           :user => 'xxxx', 
           :password => 'xxxx', 
           :database => 'xxxx', 
           :max_connections => 20, 
           :pool_timeout => 30 
           )


table_num = 0
index_num = 0 

table_sql = "SELECT table_name FROM information_schema.tables WHERE table_schema = 'public'"
#所有表名
all_tables = DB[table_sql].all 
#创建xml文件
file = File.new(File.join("test.xml"), "w+")
#创建xml内容
doc = REXML::Document.new 
#创建xml根节点
doc_element = doc.add_element('database', {'name'=>'yeeshop_v1', 'desc'=>'pg数据库索引统计'})
#写入内容  循环每张表 
all_tables.each do |table|
   table_num += 1
   #获取该table的全盘扫描和索引扫描总数
   idx_scan_sql = 'SELECT 100 * idx_scan / (seq_scan + idx_scan) as inx_scan_percent,
                          (seq_scan + idx_scan) as all_scan_counts,
                          n_live_tup
                   FROM pg_stat_user_tables 
                   WHERE relname = ?
                   AND seq_scan + idx_scan > 0 
                   ORDER BY n_live_tup DESC'
   idx_scan_data = DB[idx_scan_sql, table[:table_name].to_s].first
   idx_scan_data = {:inx_scan_percent=>0,:all_scan_counts=>0,:n_live_tup=>0} if idx_scan_data.nil? 
   #创建xml节点 - table
   table_element = doc_element.add_element('table', {'name'=>table[:table_name],
                                                     'all_scan_counts'=>idx_scan_data[:all_scan_counts],
                                                     '索引扫描占百分比'=>idx_scan_data[:inx_scan_percent],
                                                     '被使用数据行数'=>idx_scan_data[:n_live_tup] })
   #查询table所有索引
   index_sql = "select indexname,indexdef from pg_indexes where tablename = ? "
   all_indexes = DB[index_sql, table[:table_name].to_s].all 
   #table下创建索引节点- index
   all_indexes.each do |i|
    index_num += 1
    index_element = table_element.add_element('index', {'name'=>i[:indexname]})
    #index下创建索引类型节点 - tpye
    index_column_arr = i[:indexdef].split('(')[1].split(',')
    index_column_arr.push(index_column_arr.pop.split(')')[0])
    index_type = i[:indexdef].split('INDEX')[0].split(' ')[1].to_s
    index_type = '唯一索引' if index_type == 'UNIQUE' 
    index_type = '复合索引' if index_column_arr.size > 1
    index_type = '普通索引' if index_type.empty? 
    index_element.add_element('type').add_text "#{index_type}"
    #index下创建索引列名节点 - column
    index_column_arr.each do |column|
         if column.include?('name') || column.include?('title')
            col_index = index_element.add_element('column', {'tip'=>'加表达式索引'}) 
         else
            col_index = index_element.add_element('column')
         end
      col_index.add_text "#{column}"
    end
   end
end
# 写入文件 
file.puts doc.write
# 表达式索引主要用于在查询条件中存在基于某个字段的函数或表达式的结果与其他值进行比较的情况，如：
# SELECT * FROM test1 WHERE lower(col1) = 'value';
# 此时，如果我们仅仅是在col1字段上建立索引，那么该查询在执行时一定不会使用该索引，而是直接进行全表扫描。如果该表的数据量较大，那么执行该查询也将会需要很长时间。解决该问题的办法非常简单，在test1表上建立基于col1字段的表达式索引，如：
# CREATE INDEX test1_lower_col1_idx ON test1 (lower(col1));
# 如果我们把该索引声明为UNIQUE，那么它会禁止创建那种col1数值只是大小写有区别的数据行，以及col1数值完全相同的数据行。因此，在表达式上的索引可以用于强制那些无法定义为简单唯一约束的约束