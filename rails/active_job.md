#### ActiveJob 相关
1. 类似于controller 和 model 也是一个类 XXXJob
2. 根类继承自 ActiveJob::Base
3. 
   > `BotUserSpinJob.perform_later(参数)` 后台执行; `BotUserSpinJob.perform_now(参数)`立即执行; 都可在rails c 中运行
4. 后台的执行从 `bundle exec sidekiq -q default`中查看
5. 默认情况下,队列保存在内存中,重新启动,之前未执行的队列会消失