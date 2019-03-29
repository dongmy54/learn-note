# 参考链接： https://github.com/zdavatz/spreadsheet/blob/master/GUIDE.md
require 'spreadsheet'

# 准备
Spreadsheet.client_encoding = 'UTF-8'
book = Spreadsheet::Workbook.new
sheet1 = book.create_worksheet name: '测试spreadsheet'

# 写数据
sheet1.row(0).concat %w(名字 国家 学历)

sheet1.row(1).concat %w(dmy china bk)
sheet1[2,0] = 'zhanglong'
sheet1[2,1] = 'japan'
sheet1[2,2] = 'bk'

row = sheet1.row(3)
row.push 'huawugui'
row.push 'china'
row.push 'bk'

sheet1.row(4).push 'hh', 'armerica', 'ss'

# 样式
sheet1.row(0).height = 18
format = Spreadsheet::Format.new :color => :blue,
                                 :weight => :bold,
                                 :size => 18
sheet1.row(0).default_format = format

book.write '/Users/dmy/Downloads/test.xls'


