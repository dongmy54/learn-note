## sdk命令行工具安装
1. 到这里`https://developer.android.com/studio?hl=en#command-tools`下砸文件
2. 解压后得到一个`cmdline-tools`目录
3. 终端执行`ANDROID_SDK_ROOT=/Users/dongmingyan/Downloads/cmdline-tools`

## ndk
1. 直接到google官网`https://developer.android.com/ndk/downloads?hl=zh-cn`下载Mac版
2. 双击`.dmg`文件，可以看到一个类似`AndroidNDK13004108`的文件，需要注意的是它不是应用，直接右键`显示包内容`,
可以看到一个Contents文件夹，里面有很多文件夹。
3. 把这个`Contents`文件夹复制到一个路径下，比如`/Users/dongmingyan/Downloads/`目录
4. 然后终端执行`export ANDROID_NDK_HOME=/Users/dongmingyan/Downloads/Contents/NDK`即可

参考：`https://blog.csdn.net/qq_40314318/article/details/128255393`

## 其它
`fyne package -os android -appID com.mycompany.myapp` 打包



