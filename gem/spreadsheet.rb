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