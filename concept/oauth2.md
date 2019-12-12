#### oauth2
> 定义：解决 用户 授权 第三方应用 获取 数据 的标准


##### 主要对象
> * 用户（数据拥有者）
> * 第三方应用
> * 认证服务器
> * 资源服务器（PS：通常与资源服务器属于同一台服务器）


##### 授权方式
> 无论哪种方式,最终都是以获取访问token(access_token)为目的

> 1. 授权码（authorization code）
> * 是最标准、安全的
> * 授权后仅返回授权码，需拿着授权码向认证服务器请求，才能获得access_token
> * 适用于后端获取 access_token

> 2. 简化模式（implicit）
> * 直接返回access_token在跳转链接中（以锚点形式： `http://example.com/cb#access_token=2YotnFZFEjr1zCsicMWpAA&state=xyz&token_type=example&expires_in=3600`）
> * 适合前端获取 access_token

> 3. 密码模式
> 用户直接把密码交予第三方，不够安全

> 4. 凭证模式
> * 第三方直接向认证服务器获取访问token
> * 常用语命令行


##### 第三方平台注册
> 第三方要从平台获取数据，需先向平台注册申请(以便平台后续知道是谁来获取资源)
> 申请后得到 app_id app_secret


##### github授权流程示例
> 1. 用户进入第三方应用登录界面
> 2. 点击github登录,跳转到github授权页面
> 3. 用户同意授权后，重新跳回第三方应用（跳转链接中含授权码 code）
> 4. 后端从跳转链接中获取授权码后，请求认证服务器获取access_token
> 5. 得到access_token后，调用github api接口获取用户数据



