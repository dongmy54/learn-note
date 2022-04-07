#### devise 登录认证gem

##### 更新用户邮箱跳过邮箱确认
```ruby
class User
  def postpone_email_change?
    false 
  end
end
```