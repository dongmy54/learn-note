## GORM 实践
前面我们快速入门的gorm，这里针对一些常见场景进行一些实践。

### 1. 表名推断
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

### 2. 批量处理
默认情况下Find会查所有数据,数量大量时，我们需要批处理方法，这个`FindInBatches`非常实用。
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

### 3. Scopes重用查询条件
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

### 3. 事务
#### 1.1 手动事务
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

#### 1.2 自动事务（简明）
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

### 4. 排它锁
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

### 5. FirstOrInit vs FirstOrCreate
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


### 6. 自定义数据类型
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

### 7. 常见迁移的写法

### 8. 复杂查询
- preload
- joins
计数等



