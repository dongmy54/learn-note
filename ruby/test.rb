current_retry = 0 
        max_retry = 10   # 最多重试10次
        while  max_retry > current_retry
          puts current_retry
          current_retry += 1
        end
