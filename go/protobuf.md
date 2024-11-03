## protobuf
1. 它和我们的其它的格式化协议（json/xml类似），是一种**数据格式化协议**。
2. 只不过它是序列化成二进制的; 它会自动生成任意语言的序列化和反序列化代码
3. 序列化和反序列化通过`protoc`命令生成

### 最简单的生成

`simple.proto`文件
```go
syntax = "proto3";

option go_package = "./pb"; // 这里代表 生成的路径 + 包名（省略后为文件名）
// option go_package = "./pb;search";

message SearchRequest {
  string query = 1;
  int32 page_number = 2;
  int32 result_per_page = 3;
}
```

执行`protoc  --go_out=. simple.proto`，在当前目录下的pb目录下生成`simple.pb.go`文件

### 快速认识
```go
// message消息体

// 字段格式： 
// [repeated] fieldType fieldName = filedNum [fieldptions]

// fieldNum 字段编号
// 1. 同一个消息体内必须唯一
// 2. 另外最好控制在1-15范围，只占用一个字节；超过后2个字节
// 3. 不一定按顺序写也是可以的，建议从1开始，按顺序来
message SearchRequest {
  string query = 1;
  int32 page_number = 2;
  int32 result_per_page = 3;
}
```

### 字段类型映射
```go
message SearchRequest {
	bool is_true = 1;
  string query = 2;
  int32 page_number = 3;
  int64 result_per_page = 4;
	double price = 5; // float64
	float vip_price = 6; // float32
	repeated string list = 7; // []string
	bytes myData = 8; // []byte

	uint32 total1 = 9;
	uint64 total2 = 10;

	sint32 total3 = 11; // int32 可边长编码，负值时，效率比int32高
	sint64 total4 = 12; // int64 可边长编码 比int64高
}


// 生成如下结构
type SearchRequest struct {
	state         protoimpl.MessageState
	sizeCache     protoimpl.SizeCache
	unknownFields protoimpl.UnknownFields

	IsTrue        bool     `protobuf:"varint,1,opt,name=is_true,json=isTrue,proto3" json:"is_true,omitempty"`
	Query         string   `protobuf:"bytes,2,opt,name=query,proto3" json:"query,omitempty"`
	PageNumber    int32    `protobuf:"varint,3,opt,name=page_number,json=pageNumber,proto3" json:"page_number,omitempty"`
	ResultPerPage int64    `protobuf:"varint,4,opt,name=result_per_page,json=resultPerPage,proto3" json:"result_per_page,omitempty"`
	Price         float64  `protobuf:"fixed64,5,opt,name=price,proto3" json:"price,omitempty"`                       // float64
	VipPrice      float32  `protobuf:"fixed32,6,opt,name=vip_price,json=vipPrice,proto3" json:"vip_price,omitempty"` // float32
	List          []string `protobuf:"bytes,7,rep,name=list,proto3" json:"list,omitempty"`                           // []string
	MyData        []byte   `protobuf:"bytes,8,opt,name=myData,proto3" json:"myData,omitempty"`                       // []byte
	Total1        uint32   `protobuf:"varint,9,opt,name=total1,proto3" json:"total1,omitempty"`
	Total2        uint64   `protobuf:"varint,10,opt,name=total2,proto3" json:"total2,omitempty"`
	Total3        int32    `protobuf:"zigzag32,11,opt,name=total3,proto3" json:"total3,omitempty"` // int32 可边长编码，负值时，效率比int32高
	Total4        int64    `protobuf:"zigzag64,12,opt,name=total4,proto3" json:"total4,omitempty"` // int64 可边长编码 比int64高
}
```

### 枚举Enum
它生成后对应为**常量**
```go
message SearchRequest {
	Color color = 1;
}

// 定义一个颜色枚举
enum Color {
	COLOR_UNSPECIFIED = 0; // 默认值
	RED = 1;
	GREEN = 2;
	BLUE = 3;
}

// 定义一个颜色枚举
type Color int32

const (
	Color_COLOR_UNSPECIFIED Color = 0 // 默认值
	Color_RED               Color = 1
	Color_GREEN             Color = 2
	Color_BLUE              Color = 3
)

type SearchRequest struct {
	state         protoimpl.MessageState
	sizeCache     protoimpl.SizeCache
	unknownFields protoimpl.UnknownFields

	Color Color `protobuf:"varint,1,opt,name=color,proto3,enum=Color" json:"color,omitempty"`
}
```

