################################### 思路分析 ##################################
# 要想检查十张牌可能的胡牌
# 理论上 有效的牌有 A..H a..h 共16张
# 我们只需依次判断每张牌插入到当前的十张中能否胡牌，将能胡牌的牌记录下来，就能找到所有可能胡牌
# 所以问题的关键就变成了，如何判定当前牌（原来10张+1张插入的）= 11张能否胡牌问题
# 依据胡牌规则 1*对子 + m * 顺子 + n * 3相同重复
# 可以考虑将当前11张牌先拿出一个对子(2张)，则剩余9张；如果一个对子都没有，直接判定当前不能胡牌
# 如果剩余这9张,能否全部由顺子、3相同重复组合，就可以判定当前能否胡牌
# 那么如何判定这9张全部由顺子、3相同重复组合呢？
# 1. 约定先检查能否取出顺子，再检查能否取出3重复相同
# 2. 如果能取出顺子，则剩下 9 - 3 = 6 张，进行下一轮判定
# 3. 如果不能取出顺子张，则检查能否取出3重复相同，如果能取出则进行下一轮判定
# 4. 如果当前既不能取出顺子，也不能取出3重复，则回退
# 4. 每进入下轮时，记录上一轮的是顺子还是3重复，以及剩下牌是哪些
# 5. 回退时，依据进去时的的记录，找到当前最后一次顺子进去的记录
# 6. 如果最后一次顺子记录存在，则改切该顺子为3重复，开始新一轮
# 7. 如果找完所有记录都没有顺子记录，证明已经验证了所有可能性，都未能成功
# 8. 如果走到最后，能划分到剩下的牌一张不剩，则证明胡牌成功

# 总结1：上面的过程就是一个不断往下分（分出顺子/3重复）进入下一轮，如果某一步不能再往下分（则先回退一步），切换上一步形式继续分的过程；

# 关于牌中的X
# 可以认为是上面的变体，我们能计算一个不包含X的十张牌，可能的胡牌
# 那么如果十张牌中包含一张X，那么X可能有（A-H、a-h)总共16种
# 那么当前十张牌可以变出 16种，依次计算这16种组合可能的胡牌，求和、去重就能找到所有胡牌
# 如果十张种包含两张X,那么X可能有（A-H、a-h)两两组合（注意：Aa、aA算一种）144种
# 然后计算 144种组合所有胡牌
# 3个X 依次类推

# 总结2: 如果包含X先穷举出X的所有情况，然后当其为不包含X做求胡牌计算

################################### 代码展示 ###############################
# 约定
# 对子 (区分大小写) AA aa CC 代码中用 double 表示
# 顺子（区分大小写）ABC BCD  代码中用 staright 表示
# 3重复（不区分大小写）AAa Bbb 代码中 triple 表示

# 本代码尾部已经写出执行代码，直接运行本此文件即可看到输出


# 顺子hash
StraightHash = {
  'A' => 'ABC',
  'B' => 'BCD',
  'C' => 'CDE',
  'D' => 'DEF',
  'E' => 'EFG',
  'F' => 'FGH',
  'a' => 'abc',
  'b' => 'bcd',
  'c' => 'cde',
  'd' => 'def',
  'e' => 'efg',
  'f' => 'fgh'
}

# 所有有效字符
ALLChars = (('A'..'H').to_a + ('a'..'h').to_a)

# 计算匹配顺子
# ABCCDE => ABC
# adedfd => false
def cal_match_straight(str)
  return false unless straight_str = StraightHash[str[0]]
  straight_str.chars.all?{|i| str.include?(i)} ? straight_str : false
end

# 计算匹配3重复
# AAabbd => AAa
# aaabbd => aaa
# adefbb => false
def cal_match_triple(str)
  str = string_order(str)
  triple_str_arr = str.chars.first(3)
  triple_str_arr.map{|i| i.upcase}.uniq.length == 1 ? triple_str_arr.join : false
end


# 计算匹配对子
# AAABBcDdeef => ['AA','BB','ee']
# AaBbCcDefFg => []
def cal_match_double(str)
  str = string_order(str)
  double_arr = []

  str.chars.uniq.each do |char|
    char_index = str.index(char)
    next_char  = str[char_index+1]
    double_arr << char*2 if char == next_char
  end
  double_arr
end

# 排序字符串(按AaBbCc)
# AABBCaa => AAaaBBC
def string_order(str)
  str.chars.sort(&:casecmp).join
end

# 字符串相减
# str1 - str2 
# AABBBCccefh - ABC => ABBccefh
def string_reduce(str1,str2)
  arr = str1.chars
  str2.chars.each do |char|
    arr.delete_at(arr.index(char))
  end
  arr.join
end

# 计算字符串中X字母数量
def string_x_num(str)
  str.chars.reject{|i| i != 'X'}.length
end

# 对字符计数
# ABcA => {'A' => 2, 'B' => 1, c => 1}
def string_count_hash(str)
  str_count_hash = {}
  str.chars.each do |char|
    str_count_hash[char] = str_count_hash[char].to_i + 1
  end
  str_count_hash
end

# 检验字符是否有效
def string_is_valid?(str)
  return false unless str.length == 11
  return false if str.chars.any?{|i| !ALLChars.include?(i)}   # 只能是A-H、a-h的字母
  return false if string_count_hash(str).values.max > 5 # 相同字母不能超过5个
  return true
end

# 依据x数量生成 所有可能字符组合
def cal_all_x_prossible(x_num,result_arr=[])
  # 注意这里需去重 Aac、acA、aAc 都属于同一个
  return result_arr.map{|i| string_order(i)}.uniq if x_num == 0

  if result_arr.empty? # 为空则 刚进来
    cal_all_x_prossible(x_num-1, ALLChars)
  else # 已经存在
    next_result_arr = []
    result_arr.each do |char1|
      ALLChars.each do |char2|
        next_result_arr << char1 + char2
      end
    end
    cal_all_x_prossible(x_num-1,next_result_arr)
  end
end

# 回退
def back_source_history(source_history)
  loop do
    break if source_history.empty?
    last_source = source_history.last
    if last_source.first == 'straight' # 此处可退
      last_source[0] = 'triple' # 切triple
      break
    end
    source_history.pop
  end

  if source_history.empty?
    return false # 无路可走
  else
    str = source_history.last.last
    cal_is_pass(str, source_history) # 再次计算
  end
end

# 计算是否可行
def cal_is_pass(str, source_history=[])
  if str.empty?
    return source_history.empty? ? false : true
  end

  # 刚进/下一层开始
  if source_history.empty? || str != source_history.last.last
    if straight_str = cal_match_straight(str) # 顺子存在
      source_history << ['straight', str]
      next_str = string_reduce(str, straight_str)
      cal_is_pass(next_str, source_history)
    elsif triple_str = cal_match_triple(str) # 3重复存在
      source_history << ['triple', str]
      next_str = string_reduce(str, triple_str)
      cal_is_pass(next_str, source_history)
    else # 两个都不存在 则回退
      return back_source_history(source_history)
    end
  else # 退回的 只可能为 triple
    if triple_str = cal_match_triple(str)
      next_str = string_reduce(str, triple_str)
      cal_is_pass(next_str, source_history)
    else # 回退后 triple还是不行
      return back_source_history(source_history)
    end
  end
end

# 计算可能的字符(不包含x)
# str 计算字符
# has_chars 已经筛处字符
def cal_simple_kattble(str, has_chars=[])
  result_arr = []
  all_chars  = ALLChars - has_chars # 减去已筛选出的
  
  # 循环可能的字符
  all_chars.each do |char|
    comb_str = str + char
    comb_str = string_order(comb_str)

    # 检验组合字符串有效性
    next unless string_is_valid?(comb_str) 
    # 对子
    double_arr = cal_match_double(comb_str)
    next if double_arr.empty?
    
    # 循环对子 str
    double_arr.each do |d_str|
      current_str = string_reduce(comb_str, d_str) # 减去对子后剩余字符串

      if cal_is_pass(current_str) # pass 则终止
        result_arr << char
        break
      end
    end
  end
  result_arr
end

# 计算单个可能的字符串（所有）
def cal_single_kattble(str)
  if str.include?('X') # 包含X
    # x字符数量
    x_num = string_x_num(str)
    raise '字符x超过约定数量3' if x_num > 3
    # x字符可能列表 3层 最多960
    x_prossible_arr = cal_all_x_prossible(x_num)
    # 不含x基础字符
    basic_str = string_reduce(str,'X'*x_num)
    # 结果字符
    result_arr = []

    # 循环x所有可能
    x_prossible_arr.each do |x_str|
      current_str = basic_str + x_str
      result_arr += cal_simple_kattble(current_str,result_arr)
    end
  else # 普通
    result_arr = cal_simple_kattble(str)
  end
  result_arr.sort_by{|i| i.ord}.join
end


# 功能代码
File.open("test_data.txt").each_with_index do |line, index|
  next unless str = line.strip.split(".").last
  result_str = cal_single_kattble(str)
  puts "#{index+1}: #{result_str}" unless result_str.empty?
end



############################### 测试部分 ###############################
require 'test/unit'

class TestKattble < Test::Unit::TestCase

  # 测试字符串为空的情况 ""
  def test_string_is_empty
    assert_equal(cal_single_kattble(''), '')
  end

  # 测试字符串包含非法字符 AAAOOPPPDDD
  def test_string_not_illegal
    assert_equal(cal_single_kattble('AAAOOPPPDDD'), '')
  end

  # 测试字符串 长度超过10
  def test_string_length
    assert_equal(cal_single_kattble('AAABBBCCCDDD'), '')
  end

  # 测试X字母太多情况
  def test_string_x_to_many
    assert_raise_message("字符x超过约定数量3") {cal_single_kattble('AAABBBXXXX')}
  end

  # 测试简单有效字符串（不含X)
  def test_simple_string
    assert_equal(cal_single_kattble('AABBBCCCdd'), 'ADad')
    assert_equal(cal_single_kattble('AABBBCCCde'), 'cf')
    assert_equal(cal_single_kattble('AgBBBCCCde'), '')
    assert_equal(cal_single_kattble('BGGbcdeefg'), 'Bb')
  end
  
  # 测试包含X情况
  def test_x_string
    # 一个X
    assert_equal(cal_single_kattble('AXBBBCCCde'), 'ABCbcf')
    # 二个X
    assert_equal(cal_single_kattble('BEEFFHXXch'), '')
    assert_equal(cal_single_kattble('CDEFHXXdeg'), 'Gcdfg')
    # 三个X
    assert_equal(cal_single_kattble('HHXXXccdeh'), 'ABCDEFGHabcdefgh')
    assert_equal(cal_single_kattble('BEEGXXXegh'), 'ABCDEFGHbefgh')
  end

end
