#!/bin/bash

# 构建项目
go build -o bin/go-demo

# 检查是否已运行
echo "Checking for existing go-demo processes..."
if pgrep -f "go-demo" > /dev/null; then
    echo "Killing go-demo processes..."
    kill -9 $(pgrep -f "go-demo")
else
    echo "No go-demo processes found."
fi

# 启动项目
./bin/go-demo > log/demo.log 2>&1 &

# 检查上一个命令的退出码
EXIT_CODE=$?
if [ $EXIT_CODE -eq 0 ]; then
    echo "go-demo started with PID $!"
else
    echo "go-demo started failed with PID $!"
fi
