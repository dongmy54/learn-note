# 链接：https://www.rubydoc.info/gems/workflow/2.0.0
# 概述：在不同状态间切换, 去回调做不同操作

require 'workflow'

class Article
  attr_accessor :name, :is_publish
  
  def initialize(name, is_publish=false)
    @name       = name
    @is_publish = is_publish
  end

  include Workflow

  workflow do
    state :new do
      event :submit, :transitions_to => :awaiting_review
    end

    state :awaiting_review do
      event :review, :transitions_to => :being_reviewed
    end

    state :being_reviewed, meta: {importance: 8} do  # 元数据针对状态
      on_exit do
        puts '正在离开being_reviewed'
      end

      event :accept, :transitions_to => :accepted, if: lambda{|article| article.is_publish}
      event :reject, :transitions_to => :rejected    # 1.2版本仅支持块 不支持方法名
    end

    state :accepted do
      on_entry do     # 与状态绑定
        puts 'hello everyone here is accepted!'
      end
    end

    state :rejected

    # 记录每个切换点 信息
    on_transition do |from, to, triggering_event, *event_args|
      puts "触发事件：#{triggering_event};状态改变：#{from} -> #{to}"
    end
  end

  # 事件触发时 唤醒同名方法
  # 称为 action 与 事件绑定
  def submit(name)
    puts "#{name}提交了文章"
  end

  def accept
    puts '此文已被接受'
  end
  
end

article = Article.new('似水流年')

puts article.current_state       
# new
puts article.awaiting_review?
# false


article.submit!('dmy')                 # 调动事件 都带!号
# dmy提交了文章
# 触发事件：submit;状态改变：new -> awaiting_review
puts article.current_state     
# awaiting_review

puts article.current_state >= :accepted  # 当前状态 所处阶段
# false

article.review!
# 触发事件：review;状态改变：awaiting_review -> being_reviewed
puts article.can_accept?                 # 是否(条件)可切换
# false
article.is_publish = true

puts article.can_accept?
# true
article.accept!                          # 发现当条件不能满足时 会报错
# 此文已被接受
# 触发事件：accept;状态改变：being_reviewed -> accepted
# 正在离开being_reviewed
# hello everyone here is accepted!

puts Article.workflow_spec.states.keys.inspect   # 列出所有状态
# [:new, :awaiting_review, :being_reviewed, :accepted, :rejected] 

puts Article.workflow_spec.states[:being_reviewed].meta[:importance]  # 取每个状态元数据
# 8