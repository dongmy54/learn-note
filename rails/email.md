##### 邮件相关
```ruby
SalesReminderMailer.remind_invoice(1007, nil, "13@qq.com").deliver_now   # 同步
SalesReminderMailer.remind_invoice(1007, nil, "13@qq.com").deliver_later # 异步
```