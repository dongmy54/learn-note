#### senior sort 高级排序

> 1. 归并排序（将分成两段、如果对分开的排好序，将两段合起来就可以了）
> 2. 快速排序（随机取分割点，将小于分割点的 和 大于分割点的各放一边，只要对分成小的再排序，组合起来就好了）
>
> 结论：
>
> 1. 用的多的是快速排序，因为归并排序不是原地排序（需要占用额外的空间）
> 2. 两个时间复杂度都是 nlogn,但是在最坏情况下，快速排序时间复杂度是 n^2


##### 归并排序
分析
```
### 归并排序
6 3 5 8 ｜1 4 0 2 6
6 3 ｜ 5 8   1 4 ｜ 0 2 6
6｜3   5｜8  1｜4   0 2 ｜ 6
3 6 | 5 8  |  1 4 |  0|2  6
                    0 2  | 6
3 5 6 8    |  0 1 2 4 | 6
3 5 6 8    |  0 1 2 4 6
0 1 2 3 4 5 6 6 8

递推公式
f(n) = merge(f(0..(n/2-1)), f(n/2..n))

终止条件
n = 1 返回 原数组
```
代码
```ruby
def merge_arr(arr1, arr2)
  arr = []
  while (arr1.length>0 && arr2.length>0)
    if arr1[0] < arr2[0]
      arr << arr1.shift
    else
      arr << arr2.shift
    end
  end

  return arr + arr1 if arr1.length >0
  return arr + arr2 if arr2.length >0
  arr
end

def cal(arr)
  return arr if arr.length == 1
  len = arr.length

  arr1 = arr[0..(len/2 -1)]
  arr2 = arr[(len/2)..(len-1)]

  merge_arr(cal(arr1), cal(arr2))
end
```


##### 快速排序
分析
```
#### 快速排序
任意 pivot 中心点
5 7 4 2 8 9 0

pivot 4
2 0           4     5 7 8 9 
pivot 2              pivot 8 
 0  2              5 7     8  9 
                  pivot 5
                    5 7

# 对象: 数组
# 分割点(默认n/2)

# 递推
f(n) = f(arr[0..(n/2 -1)]) + [arr[n/2]] + f(arr[(n/2 + 1)..(n-1)])

# 终止
n = 0 返回 arr
n = 1 返回 arr
```
```ruby
def cal(arr)
  return arr if arr.length == 1 || arr.length == 0
  
  left_arr,pivot,right_arr = pivot_arr(arr)
  cal(left_arr) + [pivot] + cal(right_arr)
end


arr = [3, 2, 4, 1, 6]
def pivot_arr(arr)
  pivot_index = arr.length / 2   # 分区索引
  pivot       = arr[pivot_index] # 分区点值
  arr[pivot_index] = arr[0]      # 交换首和分区元素位置
  arr.shift                      # 弹出多余的首

  left_arr  = []
  right_arr = []
  while(arr.length > 0)
    val = arr.shift
    if val > pivot
      right_arr << val
    else
      left_arr << val
    end
  end

  [left_arr, pivot, right_arr]
end
```



