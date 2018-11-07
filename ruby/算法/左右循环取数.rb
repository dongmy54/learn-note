# 给一个连续的整数列（从1开始）
# 取数规则：1、间隔取数；2、只取开始方向的偶数为数字
# 左右交替取数
# 1 2 3 4 5 6 7 8 9（左）
# 2 4 6 8（右）
# 2 6（左）
# 6

def is_continue?(result)
  result.length > 1
end

def from_left_deal(number_arr)
  generate_result_arr(number_arr)
end

def from_right_deal(number_arr)
  reverse_arr = number_arr.reverse
  generate_result_arr(reverse_arr).reverse
end

def generate_result_arr(number_arr)
  number_arr.select {|value| match_condition?(number_arr.index(value))}
end

def match_condition?(index)
  index % 2 != 0
end

def switch_deriction(deriction)
  deriction == 'left' ? 'right' : 'left'
end

def generate_number_series(n)
  (1..n).to_a
end

def deal_number_series(number_arr, deriction='left')
  result = from_left_deal(number_arr)  if deriction == 'left'
  result = from_right_deal(number_arr) if deriction == 'right'
  
  return deal_number_series(result, switch_deriction(deriction)) if is_continue?(result)

  result.first
end

number_arr = generate_number_series(9)
puts deal_number_series(number_arr).inspect
# 6