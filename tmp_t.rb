# 业务逻辑说明：
# 文中: 如果交租日期在“合同开始/结束日期”之外，则取合同开始日或结束月的第一天作为默认天
# 下面为解读，标准时间（每月15日）存在三种情况
# 1. 小于开始时间
# 2. 位于开始时间 和 结束时间之间
# 3. 大于 结束时间
# 代码中采用下面计算逻辑,特此说明（PS：邮件示例子中开始时间为2020-11-16 给出的首次交租日为 2020-11-15，考虑到现实中，签约情况，不可能在未签合同前就交租，所以做了调整，为开始日期当天）
#  标准时间位于时间段位置   开始时间   结束时间         缴租日期
#      中间             2020-1-1 - 2020-1-18 => 2020-1-15
#      大于             2020-1-1 - 2020-1-14 => 2020-1-1
#      小于             2020-1-18- 2020-1-25 => 2020-1-18


require 'active_support'
require 'active_support/core_ext'

# 合同
class Contract
  attr_accessor :start_time   # 开始日期
  attr_accessor :end_time     # 结束日期
  attr_accessor :total_amount # 总金额
  attr_accessor :rent         # 月租
  attr_accessor :period       # 交租周期
  attr_accessor :bills        # 多条账单
  attr_accessor :phase_infos  # 多个阶段信息

  def initialize(start_time, end_time, rent, period)
    @start_time  = DateTime.parse(start_time)          # 一天的开始
    @end_time    = DateTime.parse(end_time).end_of_day # 一天的结束
    @rent        = rent
    @period      = period
    @bills       = []
    @phase_infos = []

    self.generate_bill
    self.generate_phase_info

    @total_amount = cal_total_amount
  end

  # 日租金
  def day_rent
    (self.rent * 12) / 365.0
  end

  # 生成账单
  def generate_bill
    Bill.generate_bill(self)
  end

  # 生成阶段信息
  def generate_phase_info
    PhaseInfo.generate_phase_info(self)
  end

  # 计算合同总金额
  def cal_total_amount
    self.bills.map(&:amount).sum
  end

  # 划分月份
  def divde_months
    month_arr    = [] # 月份数组
    current_time = self.start_time
    
    while (current_time.end_of_month < self.end_time)
      tmp_start_time = current_time == self.start_time ? current_time : current_time.beginning_of_month
      tmp_end_time   = current_time.end_of_month

      month_arr << [tmp_start_time, tmp_end_time]
      current_time += 1.month
    end

    # 末月
    tmp_start_time = current_time == self.start_time ? current_time : current_time.beginning_of_month
    month_arr << [tmp_start_time, self.end_time]
  end

  # 通过周期对账单分组
  def bill_group_by_period
    self.bills.in_groups_of(period)
  end

  def print_contract_info
    puts  <<-EOF
      合同信息：
      开始日期   结束日期  合同总金额  月租金  交租周期 
      ------------------------------------------------
      #{self.start_time.strftime("%F")} #{self.end_time.strftime("%F")} #{self.total_amount} #{self.rent} #{self.period}
    EOF
  end

  def print_phase_info
    puts <<-EOF
      交租阶段信息：
      交租阶段开始结束时间       交租日   月交租阶段总租金
      ----------------------------------------------------
    EOF
    self.phase_infos.each{ |phase_info| phase_info.print_info }
  end

  def print_bill_info
    puts <<-EOF
      交租阶段按月分割账单：
      开始日期     结束日期     月份     总金额
      ----------------------------------------------------
    EOF
    self.bills.each{ |bill| bill.print_info }
  end

  # 打印信息
  def print_info
    self.print_contract_info
    puts "=============================== 分割线 =========================="
    self.print_phase_info
    puts "=============================== 分割线 =========================="
    self.print_bill_info
  end
end

# 账单
class Bill
  attr_accessor :start_time # 开始时间
  attr_accessor :end_time   # 结束时间
  attr_accessor :month      # 月份
  attr_accessor :amount     # 总金额
  attr_accessor :contract   # 合同

  def initialize(contract, start_time, end_time)
    @start_time = start_time
    @end_time   = end_time
    @month      = start_time.strftime("%Y%m%d")
    @contract   = contract
    @amount     = cal_amount
  end

  def self.generate_bill(contract)
    contract.divde_months.each do |month_arr|
      contract.bills << Bill.new(contract, month_arr[0], month_arr[1])
    end
  end

  # 是完整的月？
  def full_month?
    start_time == start_time.beginning_of_month && end_time == end_time.end_of_month
  end

  # 计算总金额
  def cal_amount
    full_month? ? contract.rent : ((end_time - start_time) * contract.day_rent).round(2)
  end

  def print_info
    puts <<-EOF
      #{self.start_time.strftime("%F")} #{self.end_time.strftime("%F")} #{self.month} #{self.amount}
    EOF
  end

end

# 阶段信息
class PhaseInfo
  attr_accessor :start_time      # 阶段开始时间
  attr_accessor :end_time        # 阶段结束时间
  attr_accessor :rent_day        # 交租日
  attr_accessor :total_amount    # 交租阶段总租金
  attr_accessor :contract        # 合同

  def initialize(contract, start_time, end_time)
    @start_time = start_time
    @end_time   = end_time
    @contract   = contract
    @rent_day   = cal_rent_day
    @total_amount = cal_total_amount
  end

  # 生成阶段信息
  def self.generate_phase_info(contract)
    # [[b1,b2,b3],[b4,b5,b6],[b7,b8,nil]]
    contract.bill_group_by_period.each do |bill_group_arr|
      head_bill = bill_group_arr.compact.first  # 头账单
      end_bill  = bill_group_arr.compact.last   # 尾账单
      contract.phase_infos << PhaseInfo.new(contract, head_bill.start_time, end_bill.end_time)
    end
  end

  # 计算交租日
  def cal_rent_day
    if self.start_time <= standard_day && standard_day <= self.end_time # 中间
      standard_day
    else
      self.start_time
    end
  end

  # 计算阶段总租金
  def cal_total_amount
    corresponding_bills.map(&:amount).sum
  end

  # 标准日（当月15日）
  def standard_day
    standard_day = DateTime.parse("#{start_time.strftime("%Y-%m")}-15")
  end

  # 对应的账单列表
  def corresponding_bills
    bills       = contract.bills
    start_index = bills.index{ |bill| bill.start_time == self.start_time }
    end_index   = bills.index{ |bill| bill.end_time == self.end_time }
    bills[start_index..end_index]
  end

  def print_info
    puts <<-EOF
      #{self.start_time.strftime("%F")} ~ #{self.end_time.strftime("%F")} #{self.rent_day.strftime("%F")} #{self.total_amount}
    EOF
  end
end

contract = Contract.new('2020-11-16', '2021-3-16', 5000, 2)
contract.print_info
#       合同信息：
#       开始日期   结束日期  合同总金额  月租金  交租周期
#       ------------------------------------------------
#       2020-11-16 2021-03-16 20095.89 5000 2
# =============================== 分割线 ==========================
#       交租阶段信息：
#       交租阶段开始结束时间       交租日   月交租阶段总租金
#       ----------------------------------------------------
#       2020-11-16 ~ 2020-12-31 2020-11-16 7465.75
#       2021-01-01 ~ 2021-02-28 2021-01-15 10000
#       2021-03-01 ~ 2021-03-16 2021-03-15 2630.14
# =============================== 分割线 ==========================
#       交租阶段按月分割账单：
#       开始日期     结束日期     月份     总金额
#       ----------------------------------------------------
#       2020-11-16 2020-11-30 20201116 2465.75
#       2020-12-01 2020-12-31 20201201 5000
#       2021-01-01 2021-01-31 20210101 5000
#       2021-02-01 2021-02-28 20210201 5000
#       2021-03-01 2021-03-16 20210301 2630.14


