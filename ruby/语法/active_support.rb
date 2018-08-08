require 'active_support'
require 'active_support/core_ext'

# 数组中 不包含
%w(sda sdaf sdaf).exclude?('qw') 
# => true

# 字符串中 不包含
"sdaf".exclude?('sd')
# => false

# 字符串转常量
'Module'.constantize
# Module 常量

#驼峰命令
'active_record'.camelize
# => "ActiveRecord"