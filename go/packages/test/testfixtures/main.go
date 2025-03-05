package main

import (
	"database/sql"
	"fmt"
	"time"

	_ "gorm.io/driver/mysql"

	"github.com/go-testfixtures/testfixtures/v3"
)

// 数据库连接信息 (请根据你的实际情况修改)
func main() {
	var err error

	// Open connection to the test database.
	// Do NOT import fixtures in a production database!
	// Existing data would be deleted.
	mysqlDsn := "root:123@tcp(192.168.yy.xx:3306)/dxptest?charset=utf8mb4&parseTime=True&loc=Local"
	db, err := sql.Open("mysql", mysqlDsn)
	if err != nil {
		panic(err)
	}

	fixtures, err := testfixtures.New(
		testfixtures.Database(db),          // You database connection
		testfixtures.Dialect("mysql"),      // Available: "postgresql", "timescaledb", "mysql", "mariadb", "sqlite" and "sqlserver"
		testfixtures.Directory("testdata"), // The directory containing the YAML files
		testfixtures.Location(time.Local),
	)
	if err != nil {
		panic(err)
	}

	if err := fixtures.Load(); err != nil {
		fmt.Println("加载测试数据库失败:", err)
	}

	fmt.Println("加载测试数据库成功!")
}
