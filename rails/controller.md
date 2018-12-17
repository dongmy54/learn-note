#### Controller 相关
- `render xx and return` 终止action动作

##### rescue_from
> 在controller中捕获并处理异常
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

##### action
在有路由的情况下,可以没有action，也能正确渲染（只要页面名称能对应上）