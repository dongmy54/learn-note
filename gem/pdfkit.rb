# html 转 pdf
# 配置信息获取：
# 命令:   wkhtmltopdf --extended-help
# 查文档:  wkhtmltopdf 
require 'pdfkit'

PDFKit.configure do |config|
  config.default_options = {
    'quiet': true,                # 静默输出
    'margin-top': '0.75in',
    'margin-right': '0.75in',
    'margin-bottom': '0.75in',
    'margin-left': '0.75in',
    'header-font-name': 'Arial',
    'header-font-size': 10,
    'header-center': '页眉',
    'footer-font-name': 'Arial',  # 字体
    'footer-font-size': 10,
    'footer-center': '当前页[page]共[topage]',
    'footer-line': true,          # 页脚上 线条
    'footer-spacing': 0.5,        # 页脚内容距离
    page_size: 'A4',
    print_media_type: true,
    dpi: 400                      # 必须设置 不然显示会很小
  }
end

html = <<-HTML
    <style>
      h1 {
          text-align: center;
          color: red;
          margin-bottom: 100px;
         }
    </style>
    <h1>Hello World!</h1>
HTML

kit = PDFKit.new(html)
kit.to_pdf('hello.pdf')          # 加文件名 生成文件 到当前路径

