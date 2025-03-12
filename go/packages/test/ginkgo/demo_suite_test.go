// 这个文件正常使用即可
package grouplogic

import (
	"errors"
	"fmt"
	"time"

	. "github.com/onsi/ginkgo/v2"
	. "github.com/onsi/gomega"
)

// 使用Focus标签 代表只运行此示例 其它全部跳过 执行完后 记的改回去
// Pending 让它暂时不执行
// 这里改成 Label("library")
var _ = Describe("Checking books out of the library", Label("library"), func() {
	var library string
	BeforeEach(func() {
		library = "libray"
		fmt.Println("其下每个It执行一次")
	})

	When("the library has the book in question", func() {
		BeforeEach(func(ctx SpecContext) {
			fmt.Println("其下每个It执行一次")
		})

		Context("and the book is available", func() {
			It("lends it to the reader", func(ctx SpecContext) {
				fmt.Println("lend book1 to reader1", library)
				Expect("book1").To(Equal("book1"))
			}, SpecTimeout(time.Second*5))
		})

		Context("and the book is not available", func() {
			It("does not lend it to the reader", func(ctx SpecContext) {
				Expect("book1").To(Equal("book1"))
			}, SpecTimeout(time.Second*5))

			It("does not lend it to the reader", func(ctx SpecContext) {
				Expect("book1").To(Equal("book1"))
			})
		})
	})

	When("the library does not have the book in question", func() {
		It("tells the reader the book is unavailable", func(ctx SpecContext) {
			Expect(errors.New("Les Miserables is not in the library catalog")).To(MatchError("Les Miserables is not in the library catalog"))
		}, SpecTimeout(time.Second*5))
	})
})
