require 'rest-client'
require 'nokogiri'

style = "<style>.frame {
    margin-left: 30px;
    margin-right: 30px;
}

h1, h2, h3, h4, h5, h6 {
    font-weight: normal;
}

.view-count {
    float: right;
    margin-top: -54px;
    color: #9B9B9B;
}

.markdown h2, .markdown h3, .markdown h4 {
    text-align: left;
    font-weight: 800;
    font-size: 16px !important;
    line-height: 100%;
    margin: 0;
    color: #555;
    margin-top: 16px;
    margin-bottom: 16px;
    border-bottom: 1px solid #eee;
    padding-bottom: 5px;
}

  .markdown .figure-code figcaption {
    background-color: #e6e6e6;

    font: 100%/2.25 Monaco, Menlo, Consolas, 'Courier New', monospace;
    text-indent: 10.5px;
    
    -moz-border-radius: 0.25em 0.25em 0 0;
    -webkit-border-radius: 0.25em;
    border-radius: 0.25em 0.25em 0 0;
    -moz-box-shadow: inset 0 0 0 1px #d9d9d9;
    -webkit-box-shadow: inset 0 0 0 1px #d9d9d9;
    box-shadow: inset 0 0 0 1px #d9d9d9;
}

.markdown {
    position: relative;
    line-height: 1.8em;
    font-size: 14px;
    text-overflow: ellipsis;
    word-wrap: break-word;
    font-family: 'PT Serif', Georgia, Times, 'Times New Roman', serif !important;
}

.markdown ol li, .markdown ul li {
    line-height: 1.6em;
    padding: 2px 0;
    color: #333;
    font-size: 16px;
}

.markdown .figure-code {
    margin: 20px 0;
}

.post-content {
    padding-top: 5px;
    padding-bottom: 5px;
}

.markdown code {
    background-color: #ececec;
    color: #d14;
    font-size: 85%;
    text-shadow: 0 1px 0 rgba(255,255,255,0.9);
    border: 1px solid #d9d9d9;
    padding: 0.15em 0.3em;
}

div {
    display: block;
}

.markdown figure.code pre {
    background-color: #ffffcc !important;
}

.code .gi {
    color: #859900;
    line-height: 1.2em;
}

.code .err {
    color: #93A1A1;
}

.markdown a:link, .markdown a:visited {
    color: #0069D6 !important;
    text-decoration: none !important;
}

.markdown p {
    font-size: 16px;
    line-height: 1.5em;
}

.markdown blockquote {
    margin-left: 0 !important;
    margin-right: 0 !important;
    padding: 12px;
    border-left: 5px solid #50AF51;
    background-color: #F3F8F3;
    clear: both;
    display: block;
}

.markdown blockquote>*:first-child {
    margin-top: 0 !important;
}

.markdown blockquote>*:last-child {
    margin-bottom: 0 !important;
}

.markdown blockquote p {
    color: #222;
}

* {
    outline: none !important;
}

a:active, a:hover, a:link, a:visited {
    text-decoration: none;
}

pre {
    margin: 0;
}

.markdown img {
    vertical-align: top;
    max-width:100%;
    height:auto;
}

h1 a {
  color: #071A52;
}

h4 {
  color: #734488;
}

hr {
  border-color: #DEDEDE;
  border-width: 0.8px;
  margin-bottom: auto;
}

.end {
  height: 400px;
}
.end img {
  clear: both; 
  display: block; 
  margin:auto;
  margin-top: -70px; 
}

.end p {
  margin-left: 300px;
  margin-top: -100px;
  color: #FF9D76;
}
</style>"

print "-----------请输入一个开始页面的post编号："
# 获取开始页面的编码 和文件名
start_page = gets.chop
print "--------------------请输入保存的文件名："
file_name  = gets.chop 

# 结束画面
page_end = "<div class='end'>
              <img src='https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1515845318684&di=399b355dd05f4eeb015b087061656115&imgtype=0&src=http%3A%2F%2Fimgsrc.baidu.com%2Fforum%2Fw%253D580%2Fsign%3Dc775b978013b5bb5bed720f606d2d523%2F248ea813632762d018421c6ca2ec08fa503dc64c.jpg'>
              <p>又学完一篇好开森！</p>
            </div>"

# 写入样式
file = File.new("blog-tutorial/app/views/addresses/#{file_name}.html", 'w')
file.write(style)

# 基础链接
basic_url = 'https://fullstack.qzy.camp'
url       = basic_url + '/posts/' + start_page
cookie    = '_quanzhan_session=你的session值'


puts "---------------------------已开始抓取数据：请耐心等候"
while (url != 'end')  
  # 请求数据
  response = RestClient.get url, {Cookie: cookie}
  doc      = Nokogiri::HTML.parse(response.body)
  
  # 当post存在时，解析
  if !doc.css(".post").to_s.empty?
    title              = doc.css(".post-title-h1.markdown h1").to_s
    chapt              = doc.css(".des-text h4").to_s + '<hr>'
    post               = doc.css(".post").to_s + page_end
    content            = title + chapt + post
    page               = "<div class='frame'>#{content}</div>"
    # 写入本page数据
    file.write(page)
    puts "#{url}----------中数据已成功抓取"

    # 计算下一个请求url
    next_relative_path = doc.css("li.next a")[0]['href'].to_s
    # 如果解析出来是 /dashboard 则代表本课结束
    url = next_relative_path == '/dashboard' ? 'end' : (basic_url + next_relative_path) 
  end
end
puts "---------------------------本课数据已全部抓取 😊"




