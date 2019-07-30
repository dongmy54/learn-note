#### carrierwave
> 用途: 主要用作文件上传
> 配置：设置文件类（继承自`CarrierWave::Uploader::Base`)

#### 用法1（单个文件）
```ruby
# app/uploaders/attachment_uploader.rb
class AttachmentUploader < BaseUploader

  include CarrierWave::MiniMagick

  # 文件存储目录
  def store_dir
    'uploaders/images'
  end

end
```

```ruby
# model
class Attachment < ActiveRecord::Base
  mount_uploader :file, AttachmentUploader
  # mount_uploader :file, AttachmentUploader, mount_on: :file_store_column_name # mount_on 可指定文件上传的指定列
  # 单个文件
  # file是attachment字段
  # file类型 string
  # file 存的是文件名比如： java_base_supplier-e6c6a2671c908632853ec8456ea9f701-6b6a2684eb6890ffd557d42873612682.jpg
end
```

```ruby
# console中
a = Attachment.new
# 赋值的是文件
a.file = File.open('/Users/dongmingyan/Downloads/e6c6a2671c908632853ec8456ea9f701.jpg') 
a.save

a.file?     # 判断是否有文件
# => true
a.file_url  # 文件相对地址
# => "/uploads/images/attachment-e6c6a2671c908632853ec8456ea9f701-529f0043ff2f707f8ee4e370a12d7bdd.jpg"
# 可打开 http://localhost:3000/http://localhost:3000/ancient 
a.file.current_path  # 文件绝对地址
# => "/Users/dongmingyan/yg/guonengegou/public/uploads/images/attachment-e6c6a2671c908632853ec8456ea9f701-529f0043ff2f707f8ee4e370a12d7bdd.jpg"
a.a.file_identifier  # 文件路径去处路径剩下的文件名（服务器）
# attachment-e6c6a2671c908632853ec8456ea9f701-529f0043ff2f707f8ee4e370a12d7bdd.jpg
a.file.size
# => 11689 文件大小 字节
a.file.origin_name
# => "e6c6a2671c908632853ec8456ea9f701.jpg" 原文件名

f = File.open a.file.current_path  # 再次读取成文件
a.remove_file!      # 删除文件
a.file?
# => false
```

#### 用法2(多个文件)
>1. 官方的做法：字段采用json格式（mysql/postgresql）
```ruby
# model
class User < ActiveRecord::Base
  mount_uploaders :avatars, AvatarUploader # mount_uploaders 是复数注意
  # avatars 是 json格式
  # 以数组形式访问  user.avatars[0].url
end
```

>2. 利用多态关联实现
```ruby
class Attachment < ActiveRecord::Base
  belongs_to :attachable, polymorphic: true
  # 必须含有 attachable_type
  # 必须含有 attachable_id
end
```

```ruby
class User < ActiveRecord::Base
  has_many :avatars, as: :attachable
end
```






