## factory_bot 
## 在rails c 中测试方式
## PS： 在rails c 中测试会。实际创建数据到数据库
require 'factory_bot'
include FactoryBot::Syntax::Methods
require './spec/factories/video_records.rb'  # 加载的测试文件


# 定义
FactoryBot.define do
  factory :video_record do
    date {3.day.ago}
    ratio {rand(120)}
    game {'ClassicMachine'}
    sequence  :guid do |i| 
      "1001#{i}" 
    end
    sequence :video_id do |i|
      i
    end
    url {VideoRecord.video_url(guid)}
    thumbnail {VideoRecord.thumbnail_url(guid)}
    association :game_sublevel
    association :user
    bet {200}
    win {10}
  end
end

# 简单创建
create(:video_record)

# 已有属性可覆盖
create(:video_record, win: 200)

# 重复利用 另一已有属性
FactoryBot.define do
  factory :video_record do
    date {3.day.ago}
    ratio {"sah#{date}"}  # 这里重复利用date 
                          # ps: 这里不能复用这里没有的属性 比如id
    #...
  end
end

# 序列化属性
FactoryBot.define do
  factory :video_record do
    sequence  :guid do |i| 
      "1001#{i}"               # 序列化
    end
  end
end

# 关联
FactoryBot.define do
  factory :video_record do
    # ...
    association :game_sublevel   # 关联
    association :user
    bet {200}
    win {10}
  end
end




