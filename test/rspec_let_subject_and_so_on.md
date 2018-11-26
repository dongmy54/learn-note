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