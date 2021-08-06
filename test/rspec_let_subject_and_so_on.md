#### let
> 在不同示例中,会重复初始化，因此它们的变量会不同；但在同一示例中，只会初始化一次，因此变量相同
```ruby

require 'securerandom'

describe '测试' do
  let(:rand_string) {SecureRandom.hex}
  it '示例一' do
    puts "=========第一个随机字符串#{rand_string}"
  end

  it '示例二' do
    puts "========第二个随机字符串#{rand_string}"
  end

  it '示例三' do
    puts "=======同一示例随机字符串1#{rand_string}"
    puts "=======同一示例随机字符串1#{rand_string}"
  end

end

# 测试
# =========第一个随机字符串344100eb40644cb503b856f23d38f730
#   示例一
# ========第二个随机字符串08a5df4a60294af878c333b55f560336
#   示例二
# =======同一示例随机字符串1e8e0bc067efb645a4f4b6b9cb885ff82
# =======同一示例随机字符串1e8e0bc067efb645a4f4b6b9cb885ff82
#   示例三
```

#### each VS all
>1、all中的数据会持续存入数据库中（当运行多个文件时，会干扰）;each则不会
>2、在it 内和外是不同的，内-数据同步；外-数据会有延迟
>ps: a. 在测试时，尽量避免直接使用`User.count`这种方式（很脆弱）
>ps: b. 在同时执行多个测试文件时,it外的部分是在所有测试具体it 之前运行的,所以有延迟（异步）
>ps: c. 可用`after(:all)`清除这些干扰数据
```ruby
# 外
require 'rails_helper'

RSpec.describe BetItem, type: :model do
  # 
  before(:all) do
    @user1 = create(:user, :normal_user)
  end
  
  it 'sd' do
    @user1
  end

  puts User.count  # 外，执行在所有示例之前（更新before中内容，有延迟）
end
```
```ruby
# 内
require 'rails_helper'

RSpec.describe BetItem, type: :model do
  # 
  before(:all) do
    @user1 = create(:user, :normal_user)
  end

  it 'sd' do
    puts User.count     # 内 和before同步
  end

end
```

##### 关于上传文件的测试
```ruby
it "batch import sales products" do
  old_count = SalesProduct.count
  file = fixture_file_upload("#{Rails.root}/spec/files/batch_import_sales_products.xlsx")
  post "/managements/v2/sales_products/batch_import", {
    params: {
      shop_vendor_id: shop_vendor.id,
      product_category_id: cat1.id,
      file: file
    },
    headers: headers
  }

  res = JSON.parse(response.body)
  
  expect(response.status).to eq(200)
  new_count = SalesProduct.count
  expect(new_count - old_count).to eq(1)
end
```

##### 关于运行测试文件
> 1. `respec 目录/文件`
> 2. `respec --tag focus` 运行单个测试,需在it 后加 `focus: true`










