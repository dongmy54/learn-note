### 定时清理日志文件

#### 1. 清理脚本
`vim clear_large_files.sh`

```bash
#!/bin/bash

# 检查是否提供了文件路径作为参数
if [ $# -eq 0 ]; then
    echo "请提供要检查的文件路径作为参数。"
    exit 1
fi

# 循环遍历所有参数中的文件路径
for file_path in "$@"; do
    # 检查文件是否存在
    if [ -e "$file_path" ]; then
        # 获取文件大小（以字节为单位）
        file_size=$(stat -c %s "$file_path")

        # 设置1GB的字节数
        one_gb=$((1024 * 1024 * 1024))

        if [ "$file_size" -gt "$one_gb" ]; then
            # 如果文件大于1GB，则清空文件内容
            > "$file_path"
            echo "文件 $file_path 已被清空，因为它大于1GB。"
        else
            echo "文件 $file_path 不大于1GB，无需清空。"
        fi
    else
        echo "文件 $file_path 不存在。"
    fi
done
```
`chmod 777 clear_large_files.sh`

#### 2. 添加cron
`crontab -e`
写入路径
`0 0 * * * /bin/bash /home/kuban/clear_large_files.sh /home/kuban/largefile`


#### 制造大文件 用于测试
`dd if=/dev/zero of=largefile bs=1M count=1100`
`./clear_large_files.sh largefile`




