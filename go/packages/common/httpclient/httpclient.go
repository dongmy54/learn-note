package httpclient

import (
	"bytes"
	"context"
	"encoding/json"
	"errors"
	"fmt"
	"io"
	"net/http"
	"net/url"
	"strings"
	"sync"
	"time"
)

// *****************************
//          类型定义
// *****************************

// Logger 日志接口，用于依赖注入
type Logger interface {
	Debugf(format string, args ...interface{})
	Infof(format string, args ...interface{})
	Errorf(format string, args ...interface{})
}

// Middleware 中间件函数类型
type Middleware func(*http.Request, func(*http.Request) (*Response, error)) (*Response, error)

// RetryCondition 自定义重试条件函数类型
type RetryCondition func(*http.Request, *Response, error) bool

// BackoffStrategy 退避策略接口
type BackoffStrategy interface {
	Next(attempt int) time.Duration // 计算下次重试间隔
}

// HTTPError 增强的HTTP错误类型
type HTTPError struct {
	StatusCode int
	Body       []byte
	Method     string
	URL        string
}

func (e *HTTPError) Error() string {
	return fmt.Sprintf("%s %s failed with %d: %s", e.Method, e.URL, e.StatusCode, string(e.Body))
}

// Response 统一响应结构
type Response struct {
	StatusCode int         // HTTP状态码
	Headers    http.Header // 响应头
	Body       []byte      // 响应体
	RequestURL string      // 实际请求URL
}

// RequestConfig 请求配置参数
type RequestConfig struct {
	Headers     http.Header       // 请求头
	Query       url.Values        // 查询参数
	PathParams  map[string]string // 路径参数
	Body        interface{}       // 请求体
	ContentType string            // 内容类型
	Timeout     time.Duration     // 请求超时时间
}

// Base HTTP客户端基类
type Base struct {
	client      *http.Client    // 底层HTTP客户端
	maxRetries  int             // 最大重试次数
	logger      Logger          // 日志记录器
	baseURL     string          // 基础URL
	baseHeader  http.Header     // 公共请求头
	middlewares []Middleware    // 中间件链
	retryIf     RetryCondition  // 重试条件判断函数
	mu          sync.RWMutex    // 保护公共请求头的读写锁
	backoff     BackoffStrategy // 退避策略实现
}

// RequestBuilder 链式请求构建器
type RequestBuilder struct {
	base    *Base           // 基础客户端实例
	method  string          // HTTP方法
	path    string          // 请求路径
	config  *RequestConfig  // 请求配置
	context context.Context // 请求上下文
}

// *****************************
//        默认实现与常量
// *****************************

// DefaultBackoff 默认指数退避策略
type DefaultBackoff struct {
	baseDelay time.Duration // 基础延迟时间
	maxDelay  time.Duration // 最大延迟时间
}

func (b *DefaultBackoff) Next(attempt int) time.Duration {
	delay := b.baseDelay * time.Duration(1<<(attempt-1))
	if delay > b.maxDelay {
		return b.maxDelay
	}
	return delay
}

// nopLogger 空日志实现
type nopLogger struct{}

func (l *nopLogger) Debugf(format string, args ...interface{}) {}
func (l *nopLogger) Infof(format string, args ...interface{})  {}
func (l *nopLogger) Errorf(format string, args ...interface{}) {}

// *****************************
//        客户端初始化
// *****************************

// NewBase 创建新的HTTP客户端实例
// opts: 配置选项函数，用于自定义客户端行为
func NewBase(opts ...Option) *Base {
	b := &Base{
		client: &http.Client{
			Timeout: 30 * time.Second,
		},
		maxRetries: 2,
		logger:     &nopLogger{},
		baseHeader: make(http.Header),
		backoff: &DefaultBackoff{
			baseDelay: 500 * time.Millisecond,
			maxDelay:  10 * time.Second,
		},
	}

	// 应用所有配置选项
	for _, opt := range opts {
		opt(b)
	}
	return b
}

// *****************************
//        配置选项函数
// *****************************

type Option func(*Base)

// WithBaseURL 设置基础URL
func WithBaseURL(url string) Option {
	return func(b *Base) { b.baseURL = url }
}

// WithMaxRetries 设置最大重试次数
func WithMaxRetries(n int) Option {
	return func(b *Base) { b.maxRetries = n }
}

// WithRetryCondition 设置自定义重试条件
func WithRetryCondition(fn RetryCondition) Option {
	return func(b *Base) {
		b.retryIf = fn
	}
}

// WithLogger 设置日志记录器
func WithLogger(l Logger) Option {
	return func(b *Base) { b.logger = l }
}

// WithMiddleware 添加中间件
func WithMiddleware(mw Middleware) Option {
	return func(b *Base) { b.middlewares = append(b.middlewares, mw) }
}

// *****************************
//        公共方法
// *****************************

// AddHeader 添加公共请求头（线程安全）
func (b *Base) AddHeader(key, value string) {
	b.mu.Lock()
	defer b.mu.Unlock()
	b.baseHeader.Add(key, value)
}

// NewRequest 创建新的请求构建器
// method: HTTP方法，path: 请求路径
func (b *Base) NewRequest(method, path string) *RequestBuilder {
	return &RequestBuilder{
		base:    b,
		method:  method,
		path:    path,
		config:  &RequestConfig{},
		context: context.Background(),
	}
}

// *****************************
//      请求构建器方法
// *****************************

// Header 设置请求头
func (rb *RequestBuilder) Header(key, value string) *RequestBuilder {
	if rb.config.Headers == nil {
		rb.config.Headers = make(http.Header)
	}
	rb.config.Headers.Set(key, value)
	return rb
}

// QueryParam 添加查询参数
func (rb *RequestBuilder) QueryParam(key, value string) *RequestBuilder {
	if rb.config.Query == nil {
		rb.config.Query = make(url.Values)
	}
	rb.config.Query.Add(key, value)
	return rb
}

// PathParam 设置路径参数（替换路径中的{key}）
func (rb *RequestBuilder) PathParam(key, value string) *RequestBuilder {
	if rb.config.PathParams == nil {
		rb.config.PathParams = make(map[string]string)
	}
	rb.config.PathParams[key] = value
	return rb
}

// Body 设置请求体，支持多种类型：
// - []byte: 直接发送
// - io.Reader: 读取内容
// - url.Values: 表单编码
// - 其他类型: JSON编码
func (rb *RequestBuilder) Body(body interface{}) *RequestBuilder {
	rb.config.Body = body
	return rb
}

// Timeout 设置单次请求超时时间
func (rb *RequestBuilder) Timeout(d time.Duration) *RequestBuilder {
	rb.config.Timeout = d
	return rb
}

// Do 执行请求
func (rb *RequestBuilder) Do() (*Response, error) {
	return rb.base.doRequest(rb.context, rb.method, rb.path, rb.config)
}

// *****************************
//        核心请求逻辑
// *****************************

// doRequest 执行请求的核心方法
func (b *Base) doRequest(ctx context.Context, method, path string, config *RequestConfig) (*Response, error) {
	// 处理路径参数
	processedPath := replacePathParams(path, config.PathParams)

	// 构建完整URL
	fullURL, err := buildFullURL(b.baseURL, processedPath, config.Query)
	if err != nil {
		return nil, fmt.Errorf("build URL failed: %w", err)
	}

	// 准备请求体
	bodyReader, contentType, err := prepareRequestBody(config)
	if err != nil {
		return nil, fmt.Errorf("prepare body failed: %w", err)
	}

	// 创建基础请求
	req, err := http.NewRequestWithContext(ctx, method, fullURL, bodyReader)
	if err != nil {
		return nil, fmt.Errorf("create request failed: %w", err)
	}

	// 设置请求头
	setRequestHeaders(req, b.baseHeader, config.Headers, contentType)

	// 构建中间件调用链
	handler := func(r *http.Request) (*Response, error) {
		return b.sendRequest(r, config)
	}
	for i := len(b.middlewares) - 1; i >= 0; i-- {
		handler = wrapMiddleware(b.middlewares[i], handler)
	}

	return handler(req)
}

// sendRequest 实际发送请求并处理重试逻辑
func (b *Base) sendRequest(req *http.Request, config *RequestConfig) (*Response, error) {
	var (
		resp      *Response
		err       error
		bodyCache []byte
	)

	// 缓存请求体用于重试（兼容非nil Body）
	if req.Body != nil {
		if bodyCache, err = io.ReadAll(req.Body); err != nil {
			return nil, fmt.Errorf("cache body failed: %w", err)
		}
		// 恢复原始请求的Body
		req.Body = io.NopCloser(bytes.NewReader(bodyCache))
	}

	// 重试循环
	for attempt := 1; attempt <= b.maxRetries+1; attempt++ {
		// 创建带超时的上下文（如果配置了超时）
		ctx := req.Context()
		if config.Timeout > 0 {
			var cancel context.CancelFunc
			ctx, cancel = context.WithTimeout(req.Context(), config.Timeout)
			defer cancel()
		}

		// 创建可重试的请求副本（携带新的上下文）
		retryReq := cloneRequest(req, bodyCache).WithContext(ctx)

		b.logger.Debugf("Attempt %d/%d: %s %s",
			attempt, b.maxRetries+1, retryReq.Method, retryReq.URL)

		// 实际发送请求
		httpResp, httpErr := b.client.Do(retryReq)
		resp = processHttpResponse(httpResp, httpErr)

		// 判断是否需要重试
		if !b.shouldRetry(retryReq, resp, httpErr) || attempt > b.maxRetries {
			return resp, httpErr
		}

		// 执行退避等待
		delay := b.backoff.Next(attempt)
		b.logger.Debugf("Retrying in %v (%d/%d)", delay, attempt, b.maxRetries)
		time.Sleep(delay)
	}

	return nil, errors.New("max retries exceeded")
}

// *****************************
//        辅助函数
// *****************************

// replacePathParams 替换路径中的{key}为实际值
func replacePathParams(path string, params map[string]string) string {
	for k, v := range params {
		path = strings.ReplaceAll(path, "{"+k+"}", url.PathEscape(v))
	}
	return path
}

// buildFullURL 构建完整请求URL
func buildFullURL(base, path string, query url.Values) (string, error) {
	fullURL, err := url.JoinPath(base, path)
	if err != nil {
		return "", err
	}

	if query != nil {
		parsed, _ := url.Parse(fullURL)
		parsed.RawQuery = query.Encode()
		fullURL = parsed.String()
	}
	return fullURL, nil
}

// prepareRequestBody 准备请求体并确定Content-Type
func prepareRequestBody(config *RequestConfig) (io.Reader, string, error) {
	if config.Body == nil {
		return nil, "", nil
	}

	switch v := config.Body.(type) {
	case []byte:
		return bytes.NewReader(v), config.ContentType, nil
	case io.Reader:
		return v, config.ContentType, nil
	case url.Values:
		return strings.NewReader(v.Encode()), "application/x-www-form-urlencoded", nil
	default:
		if config.ContentType == "" {
			config.ContentType = "application/json"
		}
		buf := new(bytes.Buffer)
		if err := json.NewEncoder(buf).Encode(v); err != nil {
			return nil, "", fmt.Errorf("json encode error: %w", err)
		}
		return buf, config.ContentType, nil
	}
}

// setRequestHeaders 合并设置请求头
func setRequestHeaders(req *http.Request, base, additional http.Header, contentType string) {
	// 合并基础头与请求特定头
	req.Header = mergeHeaders(base, additional)

	// 设置内容类型
	if contentType != "" {
		req.Header.Set("Content-Type", contentType)
	}
}

// mergeHeaders 合并两个Header
func mergeHeaders(a, b http.Header) http.Header {
	merged := a.Clone()
	for k, vs := range b {
		for _, v := range vs {
			merged.Add(k, v)
		}
	}
	return merged
}

// cloneRequest 克隆可重试的请求（包含缓存的Body）
func cloneRequest(orig *http.Request, body []byte) *http.Request {
	clone := orig.Clone(orig.Context())
	if body != nil {
		clone.Body = io.NopCloser(bytes.NewReader(body))
	}
	return clone
}

// processHttpResponse 处理HTTP响应
func processHttpResponse(resp *http.Response, err error) *Response {
	if resp == nil {
		return nil
	}
	defer resp.Body.Close()

	body, _ := io.ReadAll(resp.Body)
	return &Response{
		StatusCode: resp.StatusCode,
		Headers:    resp.Header.Clone(),
		Body:       body,
		RequestURL: resp.Request.URL.String(),
	}
}

// shouldRetry 判断是否需要重试的方法
func (b *Base) shouldRetry(req *http.Request, resp *Response, err error) bool {
	if b.retryIf != nil {
		return b.retryIf(req, resp, err)
	}

	// 默认重试条件
	if err != nil {
		return true
	}
	if resp.StatusCode >= 500 || resp.StatusCode == 429 {
		return true
	}
	return false
}

// wrapMiddleware 中间件包装函数
func wrapMiddleware(mw Middleware, next func(*http.Request) (*Response, error)) func(*http.Request) (*Response, error) {
	return func(req *http.Request) (*Response, error) {
		return mw(req, next)
	}
}

// *****************************
//        响应处理方法
// *****************************

// DecodeJSON 将响应体解码到指定结构
func (r *Response) DecodeJSON(v interface{}) error {
	return json.Unmarshal(r.Body, v)
}

// Text 获取响应文本内容
func (r *Response) Text() string {
	return string(r.Body)
}
