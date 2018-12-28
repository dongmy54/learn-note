# 将markdown字符串 转化为 html
require 'kramdown'

text = "hello **dmy**"

html = Kramdown::Document.new(text).to_html
puts html
# <p>hello <strong>dmy</strong></p>