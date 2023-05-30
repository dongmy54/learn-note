# 获取一个临时文件
require 'open-uri'
url = "https://gimg3.baidu.com/search/src=http%3A%2F%2Fpics3.baidu.com%2Ffeed%2F37d3d539b6003af38f12854fc8b0f8501138b698.jpeg%40f_auto%3Ftoken%3De17921d43e686f3008fa04da6195e125&refer=http%3A%2F%2Fwww.baidu.com&app=2021&size=f360,240&n=0&g=0n&q=75&fmt=auto?sec=1685552400&t=3ceb316d6a1ea4c36b75f718a4412253"
# 这就是一个临时文件 文件对象
temp_file = open(url)


#===================================================================================#
# 读取url内容直接写入文件
require 'open-uri'

url = "https://gimg3.baidu.com/search/src=http%3A%2F%2Fpics3.baidu.com%2Ffeed%2F37d3d539b6003af38f12854fc8b0f8501138b698.jpeg%40f_auto%3Ftoken%3De17921d43e686f3008fa04da6195e125&refer=http%3A%2F%2Fwww.baidu.com&app=2021&size=f360,240&n=0&g=0n&q=75&fmt=auto?sec=1685552400&t=3ceb316d6a1ea4c36b75f718a4412253"

file_name = "/Users/dongmingyan/Downloads/test_open_uri.jpg"
open(file_name, "wb") do |file|
  file << open(url).read
end



#===================================================================================#
# 按行读取
require 'open-uri'

open("http://www.ruby-lang.org/") do |f|
  f.each_line {|line| puts line}
end

# <!DOCTYPE html>
# <html>
#   <head>
#     <meta charset="utf-8">
#     <title>Ruby Programming Language</title>
#     <script type="text/javascript">
#       var languages = {
#         "bg":    "bg",
#         "de":    "de",
#         "es":    "es",
#         "fr":    "fr",
#         "id":    "id",
#         "it":    "it",
#         "ja":    "ja",
#         "ko":    "ko",
#         "pl":    "pl",
#         "pt":    "pt",
#         "ru":    "ru",
#         "tr":    "tr",
#         "vi":    "vi",
#         "zh-CN": "zh_cn",
#         "zh-TW": "zh_tw"
#       };

#       var code = window.navigator.language || window.navigator.userLanguage || "en";
#       if (code.substr(0,2) !== "zh") { code = code.substr(0,2); }

#       var language = languages[code];
#       if (!language) { language = "en"; }

#       document.location = "/" + language + "/";
#     </script>
#     <noscript>
#       <meta http-equiv="refresh" content="0; url=/en/">
#     </noscript>
#   </head>
#   <body>
#     <p><a href="/en/">Click here</a> to be redirected.</p>
#   </body>
# </html>







