#### 解析url为controller和action
```ruby
Rails.application.routes.recognize_path '/'
# => {:controller=>"ancient/fountain", :action=>"index"}
```

#### sanitize
> 剥离不安全标签（比如：script)

```ruby
helper.sanitize '<p>sdaf</p><script>sdaf</script>'
# => "<p>sdaf</p>sdaf"
```
