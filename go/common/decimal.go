package main

import (
	"fmt"

	"github.com/shopspring/decimal"
)

func main() {
	baseDecimal := decimal.NewFromInt(3)

	// 等效于 234.678 * 3 = 704.034 然后保留2位小数
	mvlResult, _ := decimal.NewFromFloat(234.678).Mul(baseDecimal).Truncate(2).Float64()
	fmt.Println(mvlResult)
	// 704.03

	// 等效于 234.678 * 3 = 78.226 然后保留2位小数
	divResult, _ := decimal.NewFromFloat(234.678).Div(baseDecimal).Truncate(2).Float64()
	fmt.Println(divResult)
	// 78.22

	// 四舍五入保留小数点后2位
	mvRes, _ := decimal.NewFromFloat(234.678).Round(2).Float64()
	fmt.Println(mvRes)
	// 234.68
}
