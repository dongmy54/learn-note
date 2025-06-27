### jwt

#### 解析不验证 方式一
```go
// 包："github.com/golang-jwt/jwt/v5"
// 自定义结构体（因为默认的map转换会有浮点数问题）
type MyCustomClaims struct {
	UserId               string `json:"userid"` // 假设JWT中的key是 "userId"
	UserType             string `json:"usertype"`
	Role                 string `json:"role"`
	CommonId             string `json:"commonid"`
	GroupId              int64  `json:"gid"` // 明确指定为 int64
	GroupType            int64  `json:"bg"`
	jwt.RegisteredClaims        // 嵌入标准claims, 如 exp, iat 等
}

// ParseToken 解析JWT token并返回claims
func ParseToken(tokenString string) (*MyCustomClaims, error) {
	claims := &MyCustomClaims{}
	parser := jwt.NewParser()
	token, _, err := parser.ParseUnverified(tokenString, claims)

	if err != nil {
		logx.Errorf("ParseToken parse token error: %#v", err)
		return nil, errors.Annotatef(err, "parse token error")
	}

	log.Printf("token: %#v", token)

	if token != nil {
		if claims, ok := token.Claims.(*MyCustomClaims); ok {
			return claims, nil
		} else {
			logx.Errorf("ParseToken token claims is not MyCustomClaims")
			return nil, errors.Annotatef(err, "token claims is not MyCustomClaims")
		}
	} else {
		logx.Errorf("ParseToken token is nil")
	}
	return nil, errors.Annotate(errors.New("ParseToken failed"), "token is nil")
}
```

#### 自己写解析,不验证
```go
// parseTokenUnverified 只解析 Claims，不进行任何验证
func parseTokenUnverified(tokenString string, claims jwt.Claims) error {
  // 1. 将 Token 字符串按 "." 分割
  parts := strings.Split(tokenString, ".")
  if len(parts) != 3 {
    return fmt.Errorf("token 格式无效，期望有 3 个部分，实际有 %d 个", len(parts))
  }

  // 2. 获取 Payload 部分 (第二部分)
  payloadPart := parts[1]

  // 3. Base64Url 解码
  payloadBytes, err := base64.RawURLEncoding.DecodeString(payloadPart)
  if err != nil {
    return fmt.Errorf("解码 payload 失败: %w", err)
  }

  err = json.Unmarshal(payloadBytes, claims)
  if err != nil {
    return fmt.Errorf("unmarshal claims JSON 失败: %w", err)
  }

  return nil
}
```

#### 解析并验证
```go
type MyCustomClaims struct {
  UserId               string `json:"userid"` // 假设JWT中的key是 "userId"
  UserType             string `json:"usertype"`
  Role                 string `json:"role"`
  CommonId             string `json:"commonid"`
  GroupId              int64  `json:"gid"` // 明确指定为 int64
  GroupType            int64  `json:"bg"`
  jwt.RegisteredClaims        // 嵌入标准claims, 如 exp, iat 等
}

// ParseToken 解析JWT token并返回claims
func ParseToken(tokenString string) *UserRoleInfo {
  claims := &MyCustomClaims{}
  // 使用自定义的 MyCustomClaims 解析
  token, err := jwt.ParseWithClaims(tokenString, claims, func(token *jwt.Token) (interface{}, error) {
    return []byte("secrect key "), nil // 签名
  })

  if err != nil {
    log.Printf("parse token error: %#v", err)
    return nil
  }

  if token != nil && token.Valid {
    // 解析成功，claims 变量已经被正确填充
    return &UserRoleInfo{
      UserId:    claims.UserId,
      UserType:  claims.UserType,
      Role:      claims.Role,
      CommonId:  claims.CommonId,
      GroupId:   claims.GroupId, // 直接从强类型字段获取，不会有精度问题
      GroupType: claims.GroupType,
      IsPri:     claims.GroupType == t_df_group.GroupTypePrivate,
      IsGroup:   claims.GroupType == t_df_group.GroupTypePublic,
      IsFac:     claims.GroupType == t_df_group.GroupTypeFactory,
    }
  }
  return nil
}
```