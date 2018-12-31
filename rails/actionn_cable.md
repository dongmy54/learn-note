#### cable
- 定义：主要使rails 便于使用websocket
- 特点：全双工（两边可同时向对方发送消息）
- 用途：聊天、通知、实时通讯等
- 实现：在请求头中加入 upgrade 初始化后,可实时通讯
- 部署：线上需redis

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

# 服务端 建立频道
# PS: 修改后,必须重启
class RoomChannel < ApplicationCable::Channel

  def subscribed
    stream_from "room_channel"                           # 常量 所有人订阅 全局
    stream_from "room_channel_user_#{message_user.id}"   # 变量 仅对应用户订阅
    stream_for message_user                              # model对象 对应用户端 代表对象订阅

    # 1、客户端订阅规则：客户端环境下,上面订阅的频道参数
    # 2、客户端一旦连接,会自动订阅，sever有log
    
    # log 如下：
    # RoomChannel is streaming from room_channel
    # RoomChannel is transmitting the subscription confirmation
    # RoomChannel is streaming from room_channel_user_2
  end

  def unsubscribed
  end
end
```
```ruby
# app/controllers/messages_controller.rb
class MessagesController < ApplicationController
  
  def create
    message = current_user.messages.build(message_params)
    if message.save
      #PS: 1、广播失败自动忽略(比如：没有频道),返回nil
      #    2、rails c 中不可广播（都没有log)

      # broadcast 方式一
      a = ActionCable.server.broadcast 'rom_channel',
                                    message: render_message(message)
      # broadcast 方式二（strem_for)
      RoomChannel.broadcast_to(User.last, object_message: true)

      message.mentions.each do |user|
        ActionCable.server.broadcast "room_channel_user_#{user.id}",
                                      mention: true
      end

    end
  end

end
```
```ruby
# app/channels/application_cable/connection.rb
module ApplicationCable
  class Connection < ActionCable::Connection::Base
    # 不能在 订阅中直接使用 current_user
    include SessionsHelper

    # identified_by action_cable 内置方法（属性访问器）
    identified_by :message_user

    def connect
      self.message_user = find_verified_user
      # 订阅中 可直接用 message_user
    end

    private

      def find_verified_user
        if logged_in?
          current_user
        else
          reject_unauthorized_connection # action cable 内置方法
        end
      end
  end
end
```

```ruby
#app/assets/javascripts/channel/room.coffe

# 客户端,处理收到广播数据
# PS: 1、需要格式对齐
#     2、语法错误，浏览器中可看到
App.room = App.cable.subscriptions.create "RoomChannel",
  # 这里方法都是回调
  connected: ->
    # Called when the subscription is ready for use on the server

  disconnected: ->
    # Called when the subscription has been terminated by the server

  received: (data) ->
    # 两种写法 data.xx / data['xx']

    alert("You have a new mention") if data['mention']
    alert("object message") if data.object_message
    if (data.message && !data.message.blank?)
      $('#messages-table').append data.message
      scroll_bottom()


# 可以放 普通js 代码
submit_message = () ->
  $('#message_content').on 'keydown', (event) ->
    if event.keyCode is 13 && !event.shiftKey    # 按下enter 但 没有按shift
      # event.target.value 层叠结构哈
      console.log(event)
      $('input').click()
      event.target.value = ""           # 都不用分号结束
      event.preventDefault()

$(document).on 'turbolinks:load', ->
  submit_message()

scroll_bottom = () ->
  scroll_height = $("#messages")[0].scrollHeight
  $("#messages").scrollTop(scroll_height)
```

##### 逻辑流程
> broadcast(action中) -> redis -> 频道 -> xx.coffee(app/assets/javascripts/channels/xx.coffee) 



