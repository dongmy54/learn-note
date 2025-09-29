## traceId
```go 
// "github.com/zeromicro/go-zero/core/trace"
trace.TraceIDFromContext(r.Context())
```

```go
// "go.opentelemetry.io/otel/trace"

// 生成
func CreateTraceCtx(traceId string) context.Context {
	// 1. 创建一个基础的 context
	ctx := context.Background()

	// 2. 解析并创建 SpanContext
	tid, err := trace.TraceIDFromHex(traceId)
	if err != nil {
		logx.Errorf("Invalid traceId format: %s", traceId)
		// 处理错误，可能直接返回或使用一个新的 traceId
		return nil
	}

	// 3. 生成 SpanID
	var sid trace.SpanID
	sid, _ = trace.SpanIDFromHex(traceId[:16])

	spanCtx := trace.NewSpanContext(trace.SpanContextConfig{
		TraceID:    tid,
		SpanID:     sid,
		TraceFlags: trace.TraceFlags(01), // 采样
		Remote:     true,
	})

	// 4. 将 SpanContext 注入到 ctx
	ctx = trace.ContextWithRemoteSpanContext(ctx, spanCtx)
	return ctx
}
```