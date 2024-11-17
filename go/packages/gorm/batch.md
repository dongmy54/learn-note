### 批处理

#### 1. 批量插入
```go
// 批量插入
// 其中某一个发生错误将导致本次整个插入失败
func BatchCreate(db *gorm.DB, users []*User, batch_size int) error {
	return db.CreateInBatches(users, batch_size).Error
}

// 这种方式批量插入是可以的，当发生冲突自动忽略
func BatchCreate1(db *gorm.DB, users []*User) error {
	if len(users) == 0 {
		return nil
	}

	return db.Clauses(clause.OnConflict{DoNothing: true}).Create(&users).Error
}
```

#### 2. 批量查询
```go
// 对数据批量操作
func BatchOperation(db *gorm.DB) error {
	results := make([]*User, 0)
	res := db.Model(User{}).Unscoped().FindInBatches(&results, 2, func(tx *gorm.DB, batch int) error {
		npUsers := make([]*User, 0)
		// 循环遍历数据
		for _, user := range results {
			log.Printf("user: %#v=====\n", user)
			if user.PhoneNum == "" {
				num := fmt.Sprintf("phoneNum_%d", user.ID)
				npUsers = append(npUsers, &User{Name: "空手机号用户", PhoneNum: num})
			}
		}

		// 找出来后 批量插入
		BatchCreate1(db, npUsers)
		return nil
	})

	return res.Error
}
```