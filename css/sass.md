### sass 
> 1. sass 提供了许多css所不具备的特性，比如变量、嵌套、minxin、扩展等
> 2. scss 是css的超集,所有能在css的用法 都能在scss上用
> 3. 本机安装 sass 后,用`sass test.scss test.css`转scss 为 css
> 4. sass -h 帮助

#### 变量
> 1. $ 符号开头
> 2. 用于单个值的场合
```
# scss
$font-stack:    Helvetica, sans-serif;
$primary-color: #333;

body {
  font: 100% $font-stack;
  color: $primary-color;
}

# css
body {
  font: 100% Helvetica, sans-serif;
  color: #333; }
```

#### 嵌套
> 清楚的表述了，包含关系
```
nav {
  ul {
    margin: 0;
    padding: 0;
    list-style: none;
  }

  li { display: inline-block; }

  a {
    display: block;
    padding: 6px 12px;
    text-decoration: none;
  }
}

# css
nav ul {
  margin: 0;
  padding: 0;
  list-style: none; }

nav li {
  display: inline-block; }

nav a {
  display: block;
  padding: 6px 12px;
  text-decoration: none; }
```

#### partial
> 抽取特定部分css，实现复用
```
# _reset.scss

html,
body,
ul,
ol {
  margin:  0;
  padding: 0;
}


# base.scss
@import 'reset';

body {
  font: 100% Helvetica, sans-serif;
  background-color: #efefef;
}


# css
html,
body,
ul,
ol {
  margin:  0;
  padding: 0;
}

body {
  font: 100% Helvetica, sans-serif;
  background-color: #efefef;
}
```

#### minxin
> 类似于函数,可传参数
```
@mixin transform($property) {
  -webkit-transform: $property;
  -ms-transform: $property;
  transform: $property;
}

.box { @include transform(rotate(30deg)); }


# css
.box {
  -webkit-transform: rotate(30deg);
  -ms-transform: rotate(30deg);
  transform: rotate(30deg); }
```

#### 扩展/继承
>1. %开头
>2. 定义一组css样式
>3. 与minxin比较起来，它转化的css更简洁(缺点没法传变量)
```
%message-shared {
  border: 1px solid #ccc;
  padding: 10px;
  color: #333;
}

.message {
  @extend %message-shared;
}

.success {
  @extend %message-shared;
  border-color: green;
}

.error {
  @extend %message-shared;
  border-color: red;
}

.warning {
  @extend %message-shared;
  border-color: yellow;
}


# css
.message, .success, .error, .warning {
  border: 1px solid #ccc;
  padding: 10px;
  color: #333; }

.success {
  border-color: green; }

.error {
  border-color: red; }

.warning {
  border-color: yellow; }
```

#### 运算符
```
.container {
  width: 100%;
}

article[role="main"] {
  float: left;
  width: 600px / 960px * 100%;
}

aside[role="complementary"] {
  float: right;
  width: 300px / 960px * 100%;
}


# css
.container {
  width: 100%; }

article[role="main"] {
  float: left;
  width: 62.5%; }

aside[role="complementary"] {
  float: right;
  width: 31.25%; }
```


