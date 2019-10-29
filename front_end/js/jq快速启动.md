#### jq 快速测试
```html
<!DOCTYPE html>
<html>
<head>
  <title></title>
  <script src="https://code.jquery.com/jquery-3.1.1.min.js"></script>
</head>
<body>
  <h3>引用测试</h3>
  <p>我被隐藏</p>
  <div>
    <div id="result"></div>
    <button id="start">开始测试</button>
  </div>
  
</body>
</html>

<script type="text/javascript">
  $('p').hide();

  $("#start").click(function(){
    // 返回时间戳
    var timeoutID = setTimeout(hu, 2000);

    function hu(){
      alert('我延迟2秒后，才被弹出来');
    }
  })
  
</script>
```