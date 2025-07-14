{{/* 定义模版名为layout */}}
{{define "layout"}}
  {{/* 变量 */}}
  you {{.Smile}} 
  and {{.Heart}} me!
  
  {{/* 循环 */}}
  {{ range $i, $v :=.List }}
    索引{{ $i }}值: {{ $v }}
  {{ end }}

 
  {{/* 条件判断 */}}
  {{ if ge .Age 18 }}
    {{.Name }} is old enough to vote.
  {{ else }}
    {{.Name }} is not old enough to vote.
  {{ end }}

  {{/* 自定义函数hello */}}
  {{ hello .Name .Age }}

  {{/* 包含其他模版，这个模版叫inner */}}
  {{ template "inner" . }}
{{end}}