# rspec 项目下(所有测试)
# rspec 路径(单个测试)
# ps：
# 1、本地运行rspec命令,是不需要requrie 'rspec'；
# 2、这里require 目的是让ruby xx/rspec.rb 可用

# describle 类
# context   内容快
# it        测试细节
# before let subject 测试数据


#=================== 测试类 ===================#
require 'active_model'
class Person
  include ActiveModel::Model
  attr_accessor :name,:age,:address
  validates     :name,:age, presence: true

  def show_age_info
    "#{name}的年龄是: #{age}岁"
  end

  def birth_year
    Time.now.year - age
  end

end


#==================== 测试 =====================#
require 'rspec/autorun' # 自动运行 ruby xx.rb方式
#require 'rspec'        # rspec xx.rb 方式

# 类
describe Person do

  # each 每个 例子运行前 执行
  before(:all) do
    # 实例变量
    @person = Person.new(name: 'hubar',age: 6, address: 'china')
  end

  # let 
  # 惰性 可用 let! 切换
  # 可多个
  let(:person1) { Person.new(name: 'lisi',address: 'china') }
  let(:person2) { Person.new(age: 6, address: 'china') }

  # subject 
  # 是默认存在(类的实例.new)
  # subject(:person) { Person.new(name: 'hubar',age: 6, address: 'china')}

  # 内容块
  context "保存person" do
    # 细节
    it "没有年龄不能保存" do
      expect(person1.valid?).to eq(false)
    end

    it "没有名字不能保存" do
      expect(person2.valid?).to eq(false)
    end
  end

  context "person 相关方法" do
    it "年龄展示方法" do
      expect(@person.show_age_info).to eq('hubar的年龄是: 6岁')
    end

    # xit 临时跳过
    it "出生年份方法" do
      expect(@person.birth_year).to eq(2012)
    end
  end

  context "xx匹配器" do
    it '匹配器测试' do
      expect(nil).to            be_nil
      expect(['a','b','c']).to  be_include('a')
      expect('dmysaf').to       be_start_with('dm')
      expect('sdesd').to        be_end_with('sd')
      expect('adaddf').to       match(/^a.*/)
      expect(true).to           be true
      expect { raise 'sda' }.to raise_error(RuntimeError)
    end
  end

end