#### 缓存

##### 本地测试缓存
```ruby
# config/environments/development.rb
config.action_controller.perform_caching = true
```
log中可看到
```ruby
# 第一次
Read fragment views/mall_info/e5e0c53ff74d316d816974d3991adc45 (0.1ms)
  Rendered home/_mall_info_notice.html.erb (1.2ms)
Write fragment views/mall_info/e5e0c53ff74d316d816974d3991adc45 (1.2ms)

# 第二次
Read fragment views/mall_info/e5e0c53ff74d316d816974d3991adc45 (0.2ms)
```


