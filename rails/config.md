#### 配置相关
##### 表单错误信息
```ruby
# config/application.rb

config.action_view.field_error_proc = Proc.new { |html_tag, instance|
        "<div class=\"field_errors\">#{html_tag}</div>".html_safe
    }
```