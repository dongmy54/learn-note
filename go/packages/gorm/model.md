### model

```go
// scope最近十天的数据
func RecentTenDays(db *gorm.DB) *gorm.DB {
  return db.Where("CreatedAt > ?", time.Now().AddDate(0, 0, -10))
}


// 基本构建
func (m *defaultTDfCaseModel) BaseBuilder(ctx context.Context) *gorm.DB {
  return m.conn.WithContext(ctx).Model(&TDfCase{})
}

// 批量操作
func (m *defaultTDfCaseModel) BatchDeal(dataSource *gorm.DB, batchSize int, operFun func(obj *TDfCase)) error {
  var results []TDfCase
  result := dataSource.FindInBatches(&results, batchSize, func(tx *gorm.DB, batch int) error {
    for _, obj := range results {
      operFun(&obj)
    }
    return tx.Commit().Error
  })
  return result.Error
}


// 按页取数据
func (m *defaultTDfCaseModel) FindListByPage(gormBuilder *gorm.DB, pageNo int32, pageSize int32, orderBy string, isAsc bool) ([]*TDfCase, error) {
  var ascOrDesc string
  var caseData []*TDfCase

  if pageNo < 1 {
    pageNo = 1
  }

  if pageSize < 1 {
    pageSize = 10
  }

  if orderBy == "" {
    orderBy = "id"
  }

  if isAsc {
    ascOrDesc = "ASC"
  } else {
    ascOrDesc = "DESC"
  }

  offset := (pageNo - 1) * pageSize
  err := gormBuilder.Offset(int(offset)).
    Limit(int(pageSize)).
    Order(fmt.Sprintf("%s %s", orderBy, ascOrDesc)).Find(&caseData).Error

  switch err {
  case nil:
    return caseData, nil
  default:
    return nil, err
  }
}


// 用法
model := t_df_case.NewTDfCaseModel(gormInstance)
  dataSource := model.BaseBuilder(context.TODO()).Where("CreatedAt <?", time.Now())
  model.BatchDeal(dataSource, 100, func(ca *t_df_case.TDfCase) {
    fmt.Printf("=============%#v\n", ca)
  })

// scopes使用
var cases []t_df_case.TDfCase
  model.BaseBuilder(context.TODO()).Scopes(t_df_case.RecentTenDays).Find(&cases)

  for _, v := range cases {
    fmt.Println(v)
  }
```
