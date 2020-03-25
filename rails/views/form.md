##### form 提交数组
```ruby
<%= form_tag ancient_budget_code_matches_path, method: :post, html: {:multipart => true, class: 'valid_engine'}  do %>
  <span class="ml20">
    <%= require_span %>预算码
    <%= text_field_tag :budget_code, nil,name: "budget_code_matches[][budget_code]", class: "validate[required] " %>
  </span>
  <span class="ml20">
    <%= require_span %>特征码
    <%= text_field_tag :character_code, nil,name: "budget_code_matches[][character_code]", class: "validate[required] " %>
  </span>
  <span class="ml20">描述
    <%= text_field_tag :desc, nil,name: "budget_code_matches[][desc]" %>
  </span>

  <%= submit_tag '提交' %>
<% end %>
```

##### form 提交hash
```ruby
<%= simple_form_for @plan, remote: true, html: {class: 'valid_engine', multipart: true, id: "plan_form"} do |f| %>
  <tr>
    <th class='bg'><%= require_span %>采购项目名称：</th>
    <td><%= text_field_tag "plan[#{staff_no}][name]", struct.try(:name), class: 'fiel_inpute validate[required, maxSize[200]]' %></td>
    <th class='bg'><%= require_span %>联系方式：</th>
    <td><%= text_field_tag "plan[#{staff_no}][mobile]", struct.try(:mobile), class: 'fiel_inpute validate[required, custom[phone_or_mobile]]' %></td>
  </tr>
  <tr>
    <th class='bg'><%= require_span %>经费卡号：</th>
    <td>
      <%= text_field_tag "plan[#{staff_no}][dep_code]", struct.try(:dep_code), class: 'fiel_inpute', placeholder: "部门码" %>
      <%= text_field_tag "plan[#{staff_no}][mof_code]", struct.try(:mof_code), class: 'fiel_inpute validate[required, maxSize[50]] project_code', placeholder: "项目码" %>
    </td>
   </tr>

   <div class='tc pt10'>
      <%= f.submit '保存', class: "shopbutton w100 pointer btn-success", style: 'border:0;' %>
      <%= f.submit '保存并提交审核', class: "shopbutton w180 pointer btn-success ml20", style: 'border:0;' %>
    </div>
<% end %>
```