#### paranoia
> 软删除

#### 常用方法
> 1. `user.destroy` 软删除
> 2. `user.deleted?` 删除了么
> 3. `user.really_destroy!` 真删除
> 4. `user.restore` 恢复不删除状态
> 5. `User.unscoped` /`User.with_deleted`所有记录
> 6. `Department.only_deleted` 仅删除记录

