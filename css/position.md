#### position
> 各种定位

##### sticky
> 1. 实现滚动吸附效果
2. 定位依据（最近祖先定位元素，否则以视口）
ps: ie不支持

```html
<style type="text/css">
  .nav{
    height: 100px;
    background: yellow;
  }

  .pos-sticky{
    height: 100px;
    background: pink;
    position: sticky;
    top: 0;  /* 滚动到上边距0时出现吸附 */
  }

  p{height: 200px;}
</style>

<div class="nav">
  我是导航部分  
</div>

<div class="pos-sticky">
  我是导航下部，滚动会粘贴哦
</div>

<div>
  下面是段落内容
  <p>文字描述。。。。</p>
  <p>文字描述。。。。</p>
  <p>文字描述。。。。</p>
  <p>文字描述。。。。</p>
  <p>文字描述。。。。</p>
  <p>文字描述。。。。</p>
  <p>文字描述。。。。</p>
  <p>文字描述。。。。</p>
  <p>文字描述。。。。</p>
</div>
```