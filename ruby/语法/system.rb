##### system 
# 作用：让ruby可以执行外部命令
# 返回值 
# true 成功执行
# false 执行错误
# nil 命令不存在


system('ruby t.rb')
# 1 打印内容
# => true


system('ls')
# Gemfile   Gemfile.rb  Rakefile  bin   config.ru lib   public    tmp
# Gemfile.lock  README.rdoc app   config    db    log   test    vendor
# => true


file_path = "/Users/dongmingyan/短信.rb"  # 反斜杠
`rm #{file_path}`










