# open-uri 像打开文件一样获取 html
require 'open-uri'
url      = "http://www.ruby-lang.org/"
filename = "cathedral.html"
File.open(filename, 'w') do |f|
  # 直接 open read
  text = open(url).read
  # 写入 文件
  f.write text
end
# url 内容写入到cathedral.html 中了