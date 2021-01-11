# 参考链接： https://github.com/zdavatz/spreadsheet/blob/master/GUIDE.md
require 'spreadsheet'

# 准备
Spreadsheet.client_encoding = 'UTF-8'
book = Spreadsheet::Workbook.new
sheet1 = book.create_worksheet name: '测试spreadsheet'

# 首行标题
sheet1[0,0] = '我是合并单元格,合并了一行三列'
sheet1.merge_cells(0,0,0,2) # 开始行 开始列 结束行 结束列
# 写数据
sheet1.row(1).concat %w(名字 国家 学历)

sheet1.row(2).concat %w(dmy china bk)
sheet1[3,0] = 'zhanglong'
sheet1[3,1] = 'japan'
sheet1[3,2] = 'bk'

row = sheet1.row(4)
row.push 'huawugui'
row.push 'china'
row.push 'bk'

sheet1.row(5).push 'hh', 'armerica', 'ss'

# 样式
sheet1.row(0).height = 18
format = Spreadsheet::Format.new :color => :blue,
                                 :weight => :bold,
                                 :size => 18
sheet1.row(0).default_format = format

book.write '/Users/dmy/Downloads/test.xls'


# 一个文件 写多个sheet 
(1..12).each do |month|
  month  = (month < 10) ? "0#{month}" : month
  sheet  = book.create_worksheet(:name => "#{month}月") # 每次创建 就是一个sheet
  orders = Order.where(index_month: "#{2020}#{month}".to_i, workflow_state: "finished")
  write_excel(orders, sheet)
end

book.write "#{Rails.root}/订单数据.xls"


