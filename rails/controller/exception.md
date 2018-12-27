##### rescue_from
> 在controller中处理异常
```ruby
class xxController < ApplicationController
  rescue_from GameSublevel::MultiSaveError, with: :show_error_flash

  private
    def show_error_flash(exception)          # 默认异常参数
      flash[:warning] = exception.messages
      redirect_to xx_path                    # 必须有render/redirect_to,捕获异常后 action将不再执行
    end
end

class GameSublevel < ActiveRecord::Base
  class MutilSaveError < StandardError; end

  # 错误类可放到 Model中
end
```

> 在接口中，处理多种异常方式
```ruby
# app/controllers/application_controller.rb

class ApplicationController < ActionController::Base

  # 定义出所有 错误类
  # 命名：XXApp::YYError
  class ChatApp::TestError < StandardError; end

  # 直接用find 找不到就会被捕获
  rescue_from ActiveRecord::RecordNotFound do |exception|
    render_error :NotFind, message: exception.message, full_message: exception.full_message
  end

  rescue_from ChatApp::TestError do |exception|
    render_error :error_type, message: exception.message, full_message: exception.full_message
  end

  private
    def render_error(error_type, options={})
      render json: {
        error_type: error_type,
        error_message: options[:message],
        error_full_message: options[:full_message]
      }
    end
end

# 使用：model/action 中都可
# raise ChatApp::TestError, 'xxyy' 
```

