#### 经典布局
> 页头 本体 页尾

```html
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title></title>
  <style type="text/css">
    body{
      margin: 0px;
      padding: 0px;
    }

    .nav{
      width: 100%;
      height: 100px;
      background: rgb(56, 61, 66);
      overflow: hidden; /* 清楚浮动 */
      zoom: 1;
    }

    .left-logo{
      float: left;
    }

    .right-nav-link{
      float: right;
      margin-right: 80px;
    }

    .nav-link{
      float: right;
      line-height: 100px;
      margin-left: 40px;
      color: #fff;
      font-size: 20px;
      cursor: pointer;
    }

    .container{
      width: 100%;
      height: 1000px;
      background: #97f6fc;
    }

    .side-content{
      width: 80%;
      margin: 0 auto;
      overflow: hidden; /* 清除浮动 */
      zoom: 1;
    }

    .left-side{
      width: 50%;
      float: left;
    }

    .rigth-side{
      width: 50%;
      float: left;
    }

    .intro{
      list-style: none;
      padding-left: 0;
    }

    .intro li{
      margin-bottom: 15px;
    }

    .career-path{
      background: #e0b73d;
      margin-right: 10px;
    }

    .course-line{
      margin-bottom: 15px;
    }

    .course{
      margin-right: 10px;
    }

    .footer{
      width: 100%;
      height: 150px;
      background: #333;
      position: fixed;
      bottom: 0;
    }

    .footer-link{
      width: 80%;
      margin: 0 auto;
    }

    .footer-link-item {
      display: inline-block;
      margin-right: 100px;
      color: #fff;
      cursor: pointer;
      line-height: 150px;
    }
  </style>
</head>
<body>
  <div class="nav">
    <div class="left-logo">
      <img src="http://climg.mukewang.com/58c0d2d900016ce303000100.png">
    </div>

    <div class="right-nav-link">
      <div class="nav-link">课程</div>
      <div class="nav-link">职业路径</div>
      <div class="nav-link">实战</div>
      <div class="nav-link">猿问</div>
      <div class="nav-link">手记</div>
    </div>
  </div>

  <div class="container">
    <div class="side-content">
      <div class="left-side">
        <h2>课程推荐</h2>
        <div>
          <ul class="intro">
            <li>
              <span class="career-path">职业路径</span> HTML5与CSS3实现动态网页
            </li>
            <li>
              <span class="career-path">职业路径</span> 零基础入门Android语法与界面
            </li>
            <li>
              <span class="career-path">职业路径</span> iOS零基础语法与常用控件
            </li>
            <li>
              <span class="career-path">职业路径</span> PHP入门开发
            </li>
            <li>
              <span class="career-path">职业路径</span> JAVA入门开发
            </li>
          </ul>
        </div>
      </div>

      <div class="right-side">
        <h2>相关课程</h2>
        <div class="course-line">
          <span class="course">HTML</span>
          <span class="course">CSS</span>
          <span class="course">JavaScript</span>
        </div>
        <div class="course-line">
          <span class="course">HTML</span>
          <span class="course">CSS</span>
          <span class="course">JavaScript</span>
        </div>
        <div class="course-line">
          <span class="course">HTML5</span>
          <span class="course">CSS3</span>
          <span class="course">Jquery</span>
        </div>
        <div class="course-line">
          <span class="course">移动端基础</span>
          <span class="course">移动端APP开发</span>
        </div>
      </div>
    </div>
  </div>

  <div class="footer">
    <div class="footer-link">
      <div class="footer-link-item">网站首页</div>
      <div class="footer-link-item">创业合作</div>
      <div class="footer-link-item">人才招聘</div>
      <div class="footer-link-item">联系我们</div>
      <div class="footer-link-item">常见问题</div>
      <div class="footer-link-item">友情链接</div>
    </div>
  </div>
</body>
</html>
``` 