#### cable
- 定义：主要使rails 便于使用websocket
- 特点：全双工（两边可同时向对方发送消息）
- 用途：聊天、通知、实时通讯等
- 实现：在请求头中加入 upgrade 初始化后,可实时通讯

##### 聊天传统解决方案
- 使用: http: 半双工（只有等一边发送消息结束，另一方才能发送消息）
- 通过：轮训实现
- 缺点：每隔几秒，轮训服务器,服务器压力大


##### 用法流程
- 1. 创建频道（`rails g channel Room`)
- 2. 配置路由（mount ActionCable.server, at: '/cable'）
- 3. 激活频道（开启 stream_from）
- 4. action中broadcast
- 5. 客户端 js处理

##### 示例
```ruby
# config/routes.rb

Rails.application.routes.draw do
  #...

  mount ActionCable.server, at: '/cable'
  
  #...
end
``` 
```ruby
#app/channels/room_channel.rb

# 修改后 必须重启
# subscribe/unsubscribed 属于回调方法
class RoomChannel < ApplicationCable::Channel
  def subscribed
    # 全局性的
    stream_from "room_channel"     # 名称 要对应 RoomChannel
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
```
```ruby
# app/controllers/messages_controller.rb
class MessagesController < ApplicationController
  # ...
  def create
    message = current_user.messages.build(message_params)
    if message.save
      # 广播失败自动忽略
      ActionCable.server.broadcast 'room_channel',
                                    content: message.content,
                                    username: message.user.username
    end
  end

  #...
end
```

```ruby
#app/assets/javascripts/channel/room.coffe

App.room = App.cable.subscriptions.create "RoomChannel",
  connected: ->
    # Called when the subscription is ready for use on the server

  disconnected: ->
    # Called when the subscription has been terminated by the server

  received: (data) ->
    # Called when there's incoming data on the websocket for this channel
    # data 是 broadcast hash
    unless data.content.blank?
      $('#messages-table').append '<div class="message">' +
        '<div class="message-user">' + data.username + ":" + '</div>' +
        '<div class="message-content">' + data.content + '</div>' + '</div>'

# 这里可以放其它js 代码
submit_message = () ->
  $('#message_content').on 'keydown', (event) ->
    if event.keyCode is 13
      # event.target.value 层叠结构哈
      console.log(event)
      $('input').click()
      event.target.value = ""           # 都不用分号结束
      event.preventDefault()

$(document).on 'turbolinks:load', ->
  submit_message()
```

##### 逻辑流程
> broadcast(action中) -> redis -> 频道 -> xx.coffee(app/assets/javascripts/channels/xx.coffee) 



