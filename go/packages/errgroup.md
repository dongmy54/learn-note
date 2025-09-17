```go
func ErrGroupTest() error {
	urls := []string{"sucess1", "sucess2", "failed", "sucess4", "sucess5", "sucess6", "sucess7", "sucess8", "sucess9", "sucess10", "sucess11", "sucess12", "sucess13", "sucess14", "sucess15", "sucess16", "sucess17", "sucess18", "sucess19", "sucess20", "sucess21", "sucess22", "sucess23", "sucess24", "sucess25", "sucess26", "sucess27", "sucess28", "sucess29", "sucess30"}

	// 并发处理 10个协程
	g, ctx := errgroup.WithContext(context.Background())
	// 限制协程数量
	g.SetLimit(4)
	for _, url := range urls {
		url2 := url
		g.Go(func() error {
			select {
			case <-ctx.Done(): // 必须这里使用才能达到其它协程失败后取消，其它也同步取消
				fmt.Printf("%s 收到取消信号，退出\n", url2)
				return ctx.Err()
			default:
				// 模拟耗时
				time.Sleep(time.Second)
				if url2 == "failed" {
					return errors.New("failed")
				} else {
					logx.Infof("ErrGroupTest success url: %s", url2)
				}
			}
			return nil
		})
	}
	logx.Infof("ErrGroupTest NumGoroutine: %d", runtime.NumGoroutine())
	if err := g.Wait(); err != nil {
		return errors.Annotatef(err, "ErrGroupTest error")
	}
	return nil
}
```