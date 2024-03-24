## gorm quick start
虽然 gorm 官方文档写的很好，但是对于新手来说，缺少一个从项目搭建到实际运行的完整流程，所以这里准备了一个从零开始的 gorm 快速入门教程，希望对大家有所帮助。

### 1. 项目环境搭建
1. `mkdir gorm_practice` 创建项目目录
2. `cd gorm_practice` 切换到项目下
3. `go mod init gorm_practice` 初始化模块
4. `touch main.go` 并添加内容

```go
package main

import "fmt"

func main() {
	fmt.Println("Hello, World!")
}
```
终端运行`go run .`能看到 hello, world输出, ok代码项目搭建成功，开始正式学习gorm吧！

### 2. 准备数据库
这里使用pg数据库，创建一个数据库名为`gorm_practice`,用户名我这里是dongmingyan,无密码
> PS: 默认情况下，pg的用户名是`postgres`

### 3. gorm 连接数据库
改`main.go`文件为
```go
package main

import (
	"log"

	"gorm.io/driver/postgres"
	"gorm.io/gorm"
)

func main() {
	// 由于这里没有密码所以省略password=号后面没有值
	dsn := "host=localhost user=dongmingyan dbname=gorm_practice port=5432 password= sslmode=disable"

	// 打开数据库连接
	db, err := gorm.Open(postgres.Open(dsn), &gorm.Config{})
	if err != nil {
		log.Fatalf("failed to connect database: %v", err)
	}

	// 检查数据库连接是否成功
	if err := db.Exec("SELECT 1").Error; err != nil {
		log.Fatalf("failed to connect database: %v", err)
	}

	log.Println("Successfully connected to the database!")
}
```

执行命令`go mod tidy`它会自动下载包以及包的依赖；执行下`go run .`，看到`Successfully connected to the database!`说明连接成功。


### 4. 创建表
先创建一个users表，试试看，为了更方便的组织代码结构，我们创建一个`models`文件夹，然后创建一个`user.go`文件
1. `mkdir models` 创建models文件夹
2. `touch models/user.go` 创建user.go文件

`user.go`文件内容如下
```go
package models

import (
	"gorm.io/gorm"
)

// User 模型定义
type User struct {
	gorm.Model
	Name     string `gorm:"type:varchar(100);not null"`
	Email    string `gorm:"type:varchar(100);not null"`
	Password string `gorm:"type:varchar(100);not null"`
}

// 注意默认情况下gorm会同时帮我们创建id、created_at、updated_at、deleted_at
// 这三个字段
```

在`main.go`引入models package
```go
package main

import (
	"log"

	"gorm_practice/models" // 这里引入models包
  // ...省略
)

func main() {
	// ...省略

	// 检查数据库连接是否成功
	if err := db.Exec("SELECT 1").Error; err != nil {
		log.Fatalf("failed to connect database: %v", err)
	}

	log.Println("Successfully connected to the database!")

	// 自动迁移数据库模式，创建 User 表
	if err := db.AutoMigrate(&models.User{}); err != nil { // 导入 models 包中的 User 模型
		log.Fatalf("failed to auto migrate: %v", err)
	}

	log.Println("User table has been created successfully!")
}
```

执行`go run .`，看到`User table has been created successfully!`说明创建表成功。

### 5. 创建数据
现在我们来创建一些数据，在`main.go`中添加以下代码
```go
// ...省略
func main() {
	// ...省略
	log.Println("User table has been created successfully!")

	// 创建一个user实例
	user := models.User{
		Name:     "Dongmingyan",
		Email:    "dongmingyan@gmail.com",
		Password: "123456",
	}

	result := db.Create(&user)
	if result.Error != nil {
		log.Fatalf("failed to create user: %v", result.Error)
	}

	log.Printf("User has been created successfully. ID: %d", user.ID)
}
```
执行`go run .`，看到`User has been created successfully. ID: 1`说明创建数据成功。


### 6. 查询、更新、删除
#### 6.1 查询数据
```go
func main() {
	// ...省略
	log.Println("User table has been created successfully!")

	// 查询数据 先查询单条数据
	var user models.User
	// 查第一条件记录  主键盘升序
	db.First(&user)
	log.Printf("First user: %#v\n", user)

	// 根据email查询
	db.Find(&user, "email = ?", "dongmingyan@gmail.com")
	log.Printf("Find user: %#v\n", user)

  // 获取全部记录
	var users []models.User
	db.Find(&users)
	// 循环取出所有的users遍历打印ID
	for _, u := range users {
		log.Printf("User ID: %d\n", u.ID)
	}
}
```
`go run .`，看到输出First user信息说明查询数据成功。

#### 6.2 更新数据
```go
func main() {
	// ...省略
	log.Println("User table has been created successfully!")

  // 先查询出来 再更新字段保存
	var user models.User
	db.First(&user, 2)    // 根据ID查找用户
	user.Password = "123" // 更新用户邮箱
	user.Name = "王武"
	db.Save(&user) // 保存更新后的用户信息

	// 更新ID为1的用户邮箱
	result := db.Model(&models.User{}).Where("id = ?", 1).Update("email", "ID1@gmail.com")
	if result.Error != nil {
		log.Fatalf("failed to update user email: %v", result.Error)
	}
	log.Println("User email has been updated successfully!")

	// 查询email为dongmingyan@gmail.com的用户更新password为234567
	// 必须要有where条件 否则会更新失败
	db.Model(&models.User{}).Where("email =?", "dongmingyan@gmail.com").Update("password", "234567")

	// 更新多个字段
	result = db.Model(&models.User{}).Where("id =?", 1).Updates(models.User{
		Email: "ID1@gmail.com",
		Name:  "张三",
	})
	if result.Error != nil {
		log.Fatalf("failed to updates user: %v", result.Error)
	}
}
```

#### 6.3 删除数据
```go
	// 先查询出来 再删除
	var user models.User
	db.First(&user, 2) // 根据ID查找用户
	db.Delete(&user)   // 删除用户

	// 批量删除（注意这里删除是软删除 ）
	// 注意 这种链式调用是有区别的下面是先删除，然后where指定条件 不对哦
	// db.Delete(&models.User{}).Where("id >= ?", 1)
	db.Where("id >= ?", 1).Delete(&models.User{})

	// 永久删除
	// result := db.Unscoped().Delete(&models.User{})
	// if result.Error != nil {
	// 	// 会报错 WHERE conditions required
	// 	log.Fatalf("users delete error: %s", result.Error.Error())
	// }

	// 需要添加一个条件 永久删除
	db.Unscoped().Where("1=1").Delete(&models.User{})

	var count int64
	db.Unscoped().Model(&models.User{}).Count(&count)
	log.Printf("current users count: %v", count)
```

### 7. 关联关系
#### 7.1 1对1
##### 7.1.1 关联建立
一个用户有一张信用卡 
1. `user` has_one `credit_card`
2. `credit_card` belongs_to `user`

改`models/user.go`文件
```go
// User 模型定义
type User struct {
	gorm.Model
	Name     string `gorm:"type:varchar(100);not null"`
	Email    string `gorm:"type:varchar(100);not null"`
	Password string `gorm:"type:varchar(100);not null"`

	CreditCard CreditCard // user has_one credit_card
}
```

添加`models/credit_card.go`文件
```go
package models

import "gorm.io/gorm"

type CreditCard struct {
	gorm.Model
	Number string // 不指定具体长度会退化为text
	UserId uint   // 默认情况下使用UserID作为User的外键

	// 注意：这里用*User主要作用是避免循环引用（User中已经有CreditCard了）
	User *User // 使其可以通过credit_card.User
}
```

改`main.go`文件中的自动迁移
```go
func main() {
  // 自动迁移数据库模式 注意，需要显示的写出来 否则不会迁移
	if err := db.AutoMigrate(models.User{}, models.CreditCard{}); err != nil { // 导入 models 包中的 User 模型
		log.Fatalf("failed to auto migrate: %v", err)
	}
}
```
执行`go run .`将会把新的`credit_cards`表在数据库中成功创建。

##### 7.1.2 关联数据创建
主要有两种方式：
1. 分别创建user 和 credit_card
```go
	// 创建模型关联数据
	user := models.User{
		Name:     "张三",
		Email:    "123@qqcom",
		Password: "123456",
	}
	db.Create(&user)

	// 创建信用卡
	credit_card := models.CreditCard{
		Number: "1234567890123456",
		UserId: user.ID,
	}
	db.Create(&credit_card)
```

2. 创建user时，同时创建credit_card
这种更简单实用
```go
db.Create(&models.User{
  Name:       "李四",
  Email:      "456@qq.com",
  Password:   "345@qq.com",
  CreditCard: models.CreditCard{Number: "677889"},
})
```
把上面的代码放到`main.go`中，执行`go run .`,将可以看到user和 credit_card 都成功创建了。

##### 7.1.3 关联数据查询
关于关联的查询需要特别注意的一点是，GORM 默认只会查询主表的数据，不会查询关联表的数据，所以如果想要查询关联表的数据，需要使用`Preload`方法。

```go
// 查询出user
var user models.User
// 为了能拿到信用卡信息 这里必须使用preload
db.Preload("CreditCard").First(&user)
fmt.Printf("user name is %s, credit card number is %s", user.Name, user.CreditCard.Number)

// 查询出卡
var credit_card models.CreditCard
db.Preload("User").First(&credit_card)
fmt.Printf("credit card number is %s, user name is %s", credit_card.Number, credit_card.User.Name)
```

#### 7.2 一对多
一个用户可以有多个地址，一个地址只能属于一个用户。
##### 7.2.1 创建表
修改`models/user.go`
```go
// User 模型定义
type User struct {
	gorm.Model
	Name     string `gorm:"type:varchar(100);not null"`
	Email    string `gorm:"type:varchar(100);not null"`
	Password string `gorm:"type:varchar(100);not null"`

	CreditCard CreditCard // user has_one credit_card
	Addresses  []Address  // user has_many addresses
}
```

添加`models/address.go`
```go
package models

import "gorm.io/gorm"

type Address struct {
	gorm.Model
	// 省份
	Province string `gorm:"type:varchar(20);not null"`
	// 城市
	City string `gorm:"type:varchar(20);not null"`
	// 区
	District string `gorm:"type:varchar(20);not null"`
	// 详细地址
	Detail string `gorm:"type:varchar(100);not null"`
	UserId uint
	User   *User // 属于user 避免循环引用
}
```
自动迁移时加上`Address`
`db.AutoMigrate(models.User{}, models.CreditCard{}, models.Address{})`

执行`go run .`则会看到创建了addresses表

##### 7.2.2 创建数据
关联创建，当作切片传入就行。
```go
db.Create(&models.User{
	Name:     "John Doe",
	Email:    "234@qq.com",
	Password: "87654",
	Addresses: []models.Address{
		{Province: "四川", City: "成都", District: "温江区", Detail: "凤凰大街182号"},
		{Province: "四川", City: "成都", District: "武侯区", Detail: "天府大道中段1299号"},
	},
})
```

##### 7.2.3 关联查询
```go
var user models.User
db.Preload("Addresses").Last(&user)
// 遍历用户的地址信息
for _, address := range user.Addresses {
  log.Printf("Address: %v, %v, %v, %v\n", address.Province, address.City, address.District, address.Detail)
}
```
我们来看一个容易犯的错误！！
```go
var user models.User
db.Preload("Addresses").Last(&user)
// 遍历用户的地址信息
for _, address := range user.Addresses {
	log.Printf("Address: %v, %v, %v, %v\n", address.Province, address.City, address.District, address.Detail)

	// 根据address打印User信息呢 会发现这里输出的user是空的
	log.Printf("address User %#v", address.User)
}
```
address是根据user取的，但是address的User字段并没有被填充，所这里打印`address.User`是空的，如果你需要查询`Addresses`的`User`信息，需要使用`Preload`方法。
```go
// 这样你就可以 user.Addresses[0].User 获取到User信息了
db.Preload("Addresses").Preload("Addresses.User").Last(&user)
```

#### 7.3 多对多
一个学生可以有多门课程，一门课程可以有多个学生。它们之间是多对多的关系，下面我们开始建立关联：

##### 7.3.1 创建表
新建`models/student.go`文件
```go
package models

import "gorm.io/gorm"

type Student struct {
	gorm.Model
	Name    string `gorm:"type:varchar(100);not null"`
	Age     int8
	Courses []Course `gorm:"many2many:student_courses;"` // 定义多对多关系 一个学生有门课程

	// PS：不需要显示的定义student_coures结构体 它会自动创建表student_courses
}
```

新建`models/course.go`文件
```go
package models

import "gorm.io/gorm"

type Course struct {
	gorm.Model
	Name     string    `gorm:"type:varchar(100);not null"`
	Students []Student `gorm:"many2many:student_courses;"` // 学生与课程多对多关系
}
```

自动迁移中加上`course`和`student`
```go
db.AutoMigrate(models.User{}, models.CreditCard{}, models.Address{}, models.Student{}, models.Course{})
```

执行`go run main.go`，自动创建了`student_courses`表，当然也有`students`和`courses`表。

##### 7.3.2 创建数据
```go
// 创建关联数据
// 创建课程
c1 := &models.Course{Name: "语文"}
c2 := &models.Course{Name: "英语"}
db.Create([]*models.Course{c1, c2}) // 批量创建

// 创建学生
db.Create(&models.Student{
	Name: "张三",
	Age:  12,
	Courses: []models.Course{
		*c1,
		*c2,
	},
})
```

##### 7.3.3 查询数据
```go
// 查询学生
var s models.Student
db.Preload("Courses").First(&s)
fmt.Printf("学生：%s 课程如下：\n", s.Name)
for _, course := range s.Courses {
  fmt.Println(course.Name)
}

// 查询课程
var c models.Course
db.Preload("Students").First(&c)
fmt.Printf("课程：%s 学生如下：\n", c.Name)
for _, student := range c.Students {
	fmt.Println(student.Name)
}
```

### 8. 迁移
前面我们已经通过`db.AutoMigrate`方法自动创建了表,我在已经有表的情况下，添加字段或者索引是否可以呢？我们尝试下

我们知道学生都一个学号，并且这个学号是唯一的，我们尝试添加学号`No`字段并添加唯一索引

修改`models/student.go`
```go
type Student struct {
	gorm.Model
	
	// ...省略
	// 普通索引直接 `gorm:"index"`就行
	No string `gorm:"type:varchar(100);uniqueIndex"` // 创建唯一索引
}
```
执行迁移,会发现Student中已经多了no字段，且是唯一索引。

### 9. 钩子
GORM 允许我们在创建、查询、更新、删除对象的时候，自动执行某些操作，这些操作我们称之为钩子。

假设我们希望学生在保存的时候，如果No不存在则，自动生成一个No，我们可以在`Student`结构体中定义一个`BeforeSave`方法。

在`models/student.go`中定义`BeforeSave`方法
```go
func (s *Student) BeforeSave(tx *gorm.DB) (err error) {
	//如果学号是空字符串 或者不存在
	if s.No == "" {
		// 生成一个随机字符串做学号
		s.No = fmt.Sprintf("%d", time.Now().UnixNano())
	}

	return
}
```
我们在`main.go`中新建一个student测试下试试。

```go
s := models.Student{
  Name: "huhu",
  Age:  10,
}

db.Create(&s)
fmt.Printf("student name %s, No: %s\n", s.Name, s.No)
```
你会发现学号已经生效了。
除了`BeforeSave`钩子，GORM还提供了其他钩子，具体可以参考[官方文档](https://gorm.io/docs/hooks.html)

### 10. 链式调用
什么事链式调用，就是可以在一个方法的返回后面跟着调用另外一个方法比如：
```go
db.Where("name = ?", "dongmingyan").Where("age = ?", 20).Select("name", "age").Find(&[]models.Student{})
```
我们在`Where`后面跟着另外一个`Where`方法，后面还可以跟着`Select`方法，`Find`方法,把所有的查询条件、排序等组合成一个最终的sql去执行。

这样做有什么好处呢？
有了链式调用我们可以构建出一个非常复杂的查询，把各个部分进行拆分，代码也会比较清晰。
```go
// 对上面的例子我们可以等价改成下面这样
query := db.Where("name = ?", "dongmingyan")
query = query.Where("age = ?", 20)
query = query.Select("name", "age")
query.Find(&[]models.Student{})
```
在gorm中把方法区分成了两类
- 链式调用方法（比如：`Where`、`Select`、`Order`等）
- 最后执行方法(比如：`First`、`Find`、`Update`等)

你可能会问，这是怎么实现呢？
其实是**在每一个链式调用最后都返回一个`*gorm.DB`对象，这样就可以把所有`*gorm.DB`对象的方法串起来形成链式调用了**。

我们如何查看链式调用后生成的sql对不对呢？
可以采用`db.Debug()`实现，它会直接打印出sql语句，并且会打印出sql执行的耗时。

比如：
```go
query := db.Where("name = ?", "dongmingyan")
query = query.Where("age = ?", 20)
query = query.Select("name", "age")
// 查看生成的sql
query.Debug().Find(&[]models.Student{})
// [0.803ms] [rows:0] SELECT "name","age" FROM "students" WHERE name = 'dongmingyan' AND age = 20 AND "students"."deleted_at" IS NULL
```

### 11. 总结
总的来说gorm功能还是比较全面的，常用数据库映射库的功能它都是支持的，本文只是简单的介绍了下gorm常用的部分功能，更多功能可以参考[官方文档](https://gorm.io/docs/index.html)

