# 邮箱 短信 微信 站内信(account_notifies) 弹窗(yee_notices) 五种类型
# email sms weixin isl(in-station-letter) popup
# 收纳成一个通知

data = {:to_email => '12@qq.com',
        :sort_by => 'test',
        :html => html,
        :from_email => from_email,
        :from_name => from_name}
Notify.new('email', data)

data = {:mobile => '18200375876', :content => content}
Notify.new('sms', data)
# 封装
class Notify
  attr_accessor :type, :data
  # email
  # sms 
  # weixin 
  # isl(in-station-letter)
  # popup

  # 初始化
  def initialize(type, data={})
    @type = type
    @data = data
  end

  # 发送通知
  def delivery
    case type
    when 'email'
      ShopCommon::SendCloudApi::send(data[:to_email], data[:subject], data[:html], data[:from_email], data[:from_name])
    when 'sms'
      ShopCommon::YunPianApi::single_send(data[:mobile], data[:content])
    when 'weixin'
      $weixin_client.send_template_message(data[:post_params])
    when 'isl'
      AccountNotify.add_notify(data[:account_id], data[:siteid], data[:title], data[:content], data[:notify_from], data[:notify_at])
    when 'popup'
      # 就是写入数据 yee_notices(官网) website_notice_settings(网站)
    end
      
   end

end

class Email
  attr_accessor :to_email, :subject, :html, :from_email, :from_name

  def initialize(to_email, subject, html, from_email, from_name)
    @to_email   = to_email
    @subject    = subject
    @html       = html
    @from_email = from_email
    @from_name  = from_name
  end

  def delivery
    ShopCommon::SendCloudApi::send(to_email, subject, html, from_email], from_name)
  end
end

class Sms
  attr_accessor :mobile, :content

  def initialize(mobile, content)
    @mobile   = mobile
    @content  = content
  end

  def delivery
    ShopCommon::YunPianApi::single_send(mobile, content)
  end
end

class wp
  attr_accessor :post_params

  def initialize(post_params)
    @post_params = post_params
  end

  def delivery
    # post_params = ShopCommon.oj_json_parse(template_params).merge('touser'=> open_id)
    $weixin_client.send_template_message(post_params)
  end
end






