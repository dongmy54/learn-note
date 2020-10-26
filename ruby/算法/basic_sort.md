#### basic_sort 基本排序

> 1. 冒泡排序（每次把一个最大/最小值挤到某一边）
> 2. 插入排序（左右分已排序、未排序；取未排序中值插入已排序中）
> 3. 选择排序（左右分已排序、未排序；取未排序中最小值放入已排序右边）
>
> 总结：
>
> 用的最多未插入排序，原因？
>
> a. 相比冒泡排序更快，因为冒泡中间赋值步骤要多些
>
> b. 相比插入排序，插入排序不是稳定排序

##### 分析一个排序角度

> - 原地排序（排序时是否会占用额外空间）
> - 稳定排序（相同的两个值之间，在排序后顺序是否改变）
> - 时间复杂度（上面三个都是 O(n^2)

##### 冒泡排序实现
```ruby
def bubble_sort(arr)
  len = arr.length
  return arr if len == 0
  
  i = 0
  # 外层冒泡次数
  while(i < len - 1) do
    j = 0
    flag = false # 是否有移动
    while(j < len - i - 1) do
      if arr[j] > arr[j+1]
        tmp = arr[j+1]
        arr[j+1] = arr[j]
        arr[j] = tmp
        flag = true
      end
      j += 1
    end
    i +=1

    break unless flag # 没有移动（全部有序）提前结束
  end
  arr
end
```

##### 插入排序
```ruby
# 从小到大排序
def insertion_sort(arr)
  len = arr.length
  return arr if len == 0

  # 取多少次值
  (1..(len-1)).each do |i|
    value = arr[i] # 当前值
    j = i - 1      # 已有序索引

    # 移动数据
    while(j>=0) do
      if arr[j] > value
        arr[j+1] = arr[j]
      else
        break
      end
      j -= 1
    end
    # 插入
    arr[j+1] = value
  end
  arr
end
```

##### 选择排序
```ruby
def selection_sort(arr)
  len = arr.length
  return 0 if arr.length == 0

  i = 0
  while(i < len - 1) do
    # 内层找最小
    min_val = arr[i..(len-1)].min
    # 最小索引
    min_index = arr[i..(len-1)].index(min_val)

    j = i + min_index
    # 移动元素
    while(j > i) do
      arr[j] = arr[j-1]
      j -= 1
    end
    arr[i] = min_val
    i += 1
  end
  arr
end
```


