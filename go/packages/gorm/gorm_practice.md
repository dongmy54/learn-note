## GORM 实践
经过前面快速入门gorm的学习,我们已经对gorm建立了整体的认知;但是距离实践还存在一定的距离,这里从实际使用的角度出发，对使用过程中的高频知识点进行了汇总，希望对您有所帮助。

### 1. 单个对象First/Last/Take
- `First` 主键升序第一个
- `Last`  主键降序第一个
- `Take` 不排序

### 2. 单列/多列提取Pluck
```go
var names []string
// 一次提取所有的name出来
db.Table("users").Pluck("name", &names)

// 可以用Scan/Find 结合Map提取出多列
var user_data []map[string]interface{}
// 多列提取，这里用Scan也行
db.Model(&models.User{}).Select("id", "name").Find(&user_data)
for _, data := range user_data {
  log.Printf("user data id: %v, name: %v\n", data["id"], data["name"])
}
```

### 2. 更新
```go
// 单列更新：都可以更新到空值 Update
gormInstance.Debug().Model(&t_df_case.TDfCase{}).Where("id =?", ca.Id).Update("StatusRemark", sql.NullString{Valid: false})
// UpdateColumn 不触发回调
gormInstance.Model(&t_df_case.TDfCase{}).Where("id =?", ca.Id).UpdateColumn("StatusRemark", sql.NullString{Valid: false})

// 多列更新：只有map可以更新空值
mp := map[string]interface{}{
  "StatusRemark": sql.NullString{Valid: false},
  "PatientId":    3,
}

gormInstance.Model(&t_df_case.TDfCase{}).Where("id =?", ca.Id).Updates(mp)

// 使用结构体自动过滤掉空值情况 
ca.StatusRemark = sql.NullString{Valid: false}
gormInstance.Debug().WithContext(context.TODO()).Updates(ca)
```

### 3. Where写法
支持字符串、结构体、Map多种方式。
```go
var users []models.User
// 1. 字符串
db.Where("name = ?", "李四").Find(&users)

// 2. 结构体
db.Where(models.User{Name: "李四"}).Find(&users)

// 3. map
db.Where(map[string]interface{}{"name": "李四"}).Find(&users)
```

### 4. 表名推断
gorm还是比较智能的，能根据我们的输入参数，推断出表名，在推断不出表名时，就会提示报错。

在具体之前先补充两个基础知识：
1. `db.Table("users")` 字符串指定表名
2. `db.Model(User{})` 通过model名指定表名

上面两个写法，我们经常可以看到，它们的作用都是指定表名；但这不是必须的，有些时候不写这两个查询也是可以的， 比如：

```go
var user User
db.First(&user, 1) // 推断出表名出

var users User
db.Find(&users)   // 推断出表名
```

### 5. 批处理
默认情况下`Find`会查所有数据,数量大量时，我们需要批处理方法，这个`FindInBatches`非常实用。

> 除了这种方式外，gorm中还有`Rows`方法更底层点。
```go
var users []models.User
// 批量查询
db.FindInBatches(&users, 2, func(tx *gorm.DB, batch int) error {
  fmt.Printf("第%d批数据: \n", batch) // batch 从1开始
  // 处理获取到的本批次数据
  for _, user := range users {
    fmt.Println(user.ID, user.Name)
  }

  return nil
})
```

### 6. Scopes重用查询
我们可以把常见的查询条件以scope的方式写好，方便复用。
```go
// scope方法
// 查询年龄大于xx的用户 带参数
func AgeGreaterThan(age int) func(db *gorm.DB) *gorm.DB {
	return func(db *gorm.DB) *gorm.DB {
		return db.Where("age > ?", age)
	}
}

// state为有效的用户
func ValidState(db *gorm.DB) *gorm.DB {
	return db.Where("state = ?", "valid")
}


// 使用
var users []models.User
db.Scopes(models.ValidState, models.AgeGreaterThan(18)).Find(&users)
```


### 7. FirstOrInit vs FirstOrCreate
查找和初始化/创建一体
```go
// FirstOrInit 初始化
var user models.User
// 如果找不到 kkkkk@gmail.com 用户则 创建一个email: kkkkk@gmail.com的用户
db.Where(models.User{Email: "kkkkk@gmail.com"}).FirstOrInit(&user)

// 根据邮箱 kkkkk@gmail.com 查用户，如果查不到则创建邮箱 kkkkk@gmail.com的用户 但是此时还需要其它字段值 可以搭配Attrs使用
db.Where(models.User{Email: "kkkkk@gmail.com"}).Attrs(models.User{Name: "kkkkk"}).FirstOrInit(&user)


// FisrtOrCreate 和 xxInit使用方法一致 区别在于它直接写入数据库中
db.Where(models.User{Email: "kkkkk@gmail.com"}).FirstOrCreate(&user)

db.Where(models.User{Email: "kkkkk@gmail.com"}).Attrs(models.User{Name: "kkkkk"}).FirstOrCreate(&user)
```

如果我们只是初始化和创建用户，那么前面的代码功能已经够用了；但是如果我们希望如果查到记录后**对已存记录中的字段进行赋予值，我们需要用`Assign()`实现。

```go
var user models.User
// 假设这里的 456@qq.com 用户存在，原用户name是 李四
// 这里使用Assign会将其Name赋值成 kkkkk
db.Where(models.User{Email: "456@qq.com"}).Assign(models.User{Name: "kkkkk"}).FirstOrInit(&user)

// PS:不建议这么写,如果用户找到，这里直接赋予值，且会存入数据库
// 相当于update 但是个人感觉使用FirstOrCreate意图非常不明显
db.Where(models.User{Email: "456@qq.com"}).Assign(models.User{Name: "kkkkk"}).FirstOrCreate(&user)
```

FirstOrInit和FirstOrCreate 使用比较广泛，他们常常与`Attrs`和`Assign`搭配使用。

### 8. 预加载Preload
```go
// 避免N+1查询
// 底层生成单独的两个sql 
db.Preload("CreditCard").Find(&models.User{}) 

// joins 则是一个sql
db.Joins("CreditCard").Find(&models.User{})
// SELECT "users"."id", xxx,"CreditCard"."id" AS "CreditCard__id",yyy,"CreditCard"."number" AS "CreditCard__number","CreditCard"."user_id" AS "CreditCard__user_id" FROM "users" LEFT JOIN "credit_cards" "CreditCard" ON "users"."id" = "CreditCard"."user_id" AND "CreditCard"."deleted_at" IS NULL WHERE "users"."deleted_at" IS NULL
```

### 9. 事务
#### 9.1 手动事务
```go
// 创建一个事务
tx := db.Begin()

user := models.User{
  Name:     "Dongmingyan",
  Email:    "dongmingyan@gmail.com",
  Password: "123456",
}

// 这里换成tx做处理
if err := tx.Create(&user).Error; err != nil {
  tx.Rollback()
  log.Fatalf("failed to create user: %v", err)
}

tx.Commit()
```

#### 9.2 自动事务（简明）
`db.Transaction`简化了很多，也不用自己写回滚还是挺方便的。
```go
user := models.User{
  Name:     "Dongmingyan",
  Email:    "dongmingyan@gmail.com",
  Password: "123456",
}

db.Transaction(func(tx *gorm.DB) error {
  // 这里user使用的是外层的 —— 闭包
  if err := tx.Create(&user).Error; err != nil {
    return err
  }

  return nil // 返回nil表示事务成功
})
```

### 10. 排它锁
```go
err := db.Transaction(func(tx *gorm.DB) error {
  // 原生sql加锁
  if err := tx.Raw("SELECT * FROM products WHERE id = ? FOR UPDATE", productID).Scan(&product).Error; err != nil {
    return err
  }

  newStockNum := product.StockNum - quantity
  if newStockNum < 0 {
    return errors.New("库存不足")
  }

  return tx.Model(&product).Update("stock_num", newStockNum).Error
})
```

原生sql加锁比较直观，还有一种方式
```go
// 使用clauses.Locking来做 看起来要专业点
tx.Clauses(clause.Locking{Strength: "UPDATE"}).Where("id =?", productID).First(&product)
```

### 11. 常见迁移的写法
```go
type Account struct {
	gorm.Model
	// 组合索引 同时命名了idx_space_location 它用于两个字段上
	SpaceId    uint `gorm:"index:idx_space_location;not null"` // 组合索引
	LocationId uint `gorm:"index:idx_space_location;not null"` // 组合索引

	Age uint `gorm:"not null"` // 整型

	Name     string `gorm:"type:varchar(255);not null"`        // 字符串
	Email    string `gorm:"type:varchar(255);not null;index"`  // 字符串(普通索引)
	PhoneNum string `gorm:"type:varchar(255);not null;unique"` // 字符串（唯一索引）
	// 描述
	Description string `gorm:"type:text;not null"` // 文本类型
	// 余额
	Balance float64 `gorm:"not null"` // 浮点类型
	// 是否有效 默认有效
	Active bool `gorm:"default:true"` // 布尔类型 默认值true
	// 有效期
	ExpiredAt *time.Time // 时间类型
}
```

### 12. 自定义数据类型
有时候我们希望存储一些自定义数据类型，比如切片、map等，这个时候我们可以自定义数据类型,我们需要做的是自己做数据的存和取的解析过程。

`user`model
```go
// User 模型定义
type User struct {
	gorm.Model
	Name     string `gorm:"type:varchar(100);not null"`
	Email    string `gorm:"type:varchar(100);not null"`
	Password string `gorm:"type:varchar(100);not null"`
	// 使用自定义的DataJSONB类型来存储json数据
	Hobbies DataJSONB `gorm:"type:jsonb;"`
}

// 在使用上它是一个字符串切片
type DataJSONB []string

// 实现底层的存
func (dj DataJSONB) Value() (driver.Value, error) {
	// 返回的是一个[]byte
  return json.Marshal(dj)
}

// 实现取
func (dj *DataJSONB) Scan(value interface{}) error {
	b, ok := value.([]byte)
	if !ok {
		return fmt.Errorf("[]byte assertion failed")
	}

  // 反解析出为 db类型
	return json.Unmarshal(b, dj)
}
```

外层使用,和正常使用一样的
```go
// 存
var user models.User
db.First(&user)

user.Hobbies = []string{"reading", "swimming"}
db.Save(&user)

// 取也一样
var user models.User
db.Find(&user, 1)

fmt.Printf("User's hobbies: %#v\n", user.Hobbies)
// User's hobbies: models.DataJSONB{"reading", "swimming"}
```
