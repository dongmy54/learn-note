// 这是目录下的ginkgo 框架的启动文件(执行这个函数默认执行此目录下所有ginkgo编写的测试) 必不可少
// 可以通过ginkgo bootstrap 在目录下自动生成
package grouplogic_test

import (
	"fmt"
	"testing"

	. "github.com/onsi/ginkgo/v2"
	. "github.com/onsi/gomega"
)

func TestGroup(t *testing.T) {
	RegisterFailHandler(Fail)
	fmt.Println("lend book1 to reader2--22")
	RunSpecs(t, "Group Suite")
}

