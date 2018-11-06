require 'logger'


#################### 初始化 ######################
logger = Logger.new(STDOUT)
# logger = Logger.new('foo.log') 将日志记录到文件
# logger = Logger.new('foo.log', 'daily') weekly monthly 日志按周期更新


##################### 设定级别 ####################
logger.level = Logger::DEBUG
# DEBUG < INFO < WARN < ERROR < FATAL < UNKNOWN 
# 只有日志等级 大于/等于 设置等级才会被记录


#################### 写入日志 #####################
logger.info("logger message tesgt")
# I, [2018-11-06T17:03:57.498275 #5794]  INFO -- : logger message tesgt
logger.add(Logger::WARN, '动态设定日志级别')
# W, [2018-11-06T17:09:06.563167 #5909]  WARN -- : 动态设定日志级别
logger.error("MainApp") {"传递了progname 即这里的MainApp"}
# E, [2018-11-06T17:09:06.563185 #5909] ERROR -- MainApp: 传递了progname 即这里的MainApp


#################### 格式化输出 ####################
logger.formatter = proc do |severity, datetime, progname, msg|
  # 参数含义 日志等级缩写 日期 程序名 信息
  puts severity,datetime,progname,msg

  "#{datetime}-#{msg}-我定义的"
end 

logger.warn('程序名') {'这里是消息'}
# WARN
# 2018-11-06 17:14:58 +0800
# 程序名
# 这里是消息
# 2018-11-06 17:14:58 +0800-这里是消息-我定义的