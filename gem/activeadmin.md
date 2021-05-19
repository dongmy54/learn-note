#### activeadmin
> 1. 用途：一个用于快速搭建后台管理页面的gem
> 2. 参考： `https://activeadmin.info/`

使用
```ruby
ActiveAdmin.register City do
  # 定义需要用到哪些action
  actions :all, :except => [:new]

  # 作用域 需要在model中有对应scope
  scope :all
  scope :front

  # dashboard 菜单名称
  menu label: '城市', priority: 14

  # 过滤参数名称
  filter :name

  # 表单输入permit参数
  permit_params :name
  index do
    selectable_column
    column :id            
    column :name          
    column :created_at    
    column :updated_at    
    column :longitude     
    column :latitude      
    column :province_id   
    column "位置", :position      
    column "省会城市", :province_name
    # 自定义展示
    column "Price", sortable: :price do |city|
      city.locations.first.try(:name)
    end
    # 默认actions
    actions
  end

  # 表单设置（新增 / 编辑）
  form do |f|
    f.inputs do
      f.input :name, label: "名称" # 没有label用翻译的
    end
    f.actions
  end

  # 在edit页面 添加按钮（用于定制一些操作）
  action_item :reset_updated_at, only: :edit do
    link_to '重置更新时间', reset_updated_at_admin_city_path(resource), method: :put
  end

  # 对应上方操作（单数）
  member_action :reset_updated_at, method: :put do
    resource.lock!
    redirect_to resource_path, notice: "重置更新时间成功!"
  end

  # 批量处理数据（添加删除操作-添加后批处理中增加destroy)
  batch_action :destroy do |ids|
    redirect_to collection_path, alert: "我只是测试批处理数据而已"
  end

  # 在index页面添加 upload 按钮
  # PS: 
  # 1. 这里路由在下方collection_action中定义
  # 2. 这里需要新增 app/admin/cities/hu.html.erb 页面
  action_item :upload, only: :index do
    link_to 'Upload', hu_admin_cities_path
  end

  # 这里是定义的两个路由 get 和 post
  collection_action :hu, method: [:get,:post] do
    if request.post?
      puts "post请求"
    else
      puts "get请求"
    end
  end
end
```
