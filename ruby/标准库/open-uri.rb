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


#===================================================================================#
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




