{{if .paginator.HasPages}}
                <ul class="pagination">
                  {{if .paginator.HasPrev}}
                  <li><a href="{{.paginator.PageLinkFirst}}">首页</a></li>
                  <li><a href="{{.paginator.PageLinkPrev}}">&laquo;</a></li>
                  {{else}}
                  <li class="disabled"><a>首页</a></li>
                  <li class="disabled"><a>&laquo;</a></li>
                  {{end}}
                  {{range $index, $page := .paginator.Pages}} <li{{if $.paginator.IsActive .}} class="active"{{end}}> <a href="{{$.paginator.PageLink $page}}">{{$page}}</a>
                  </li>
                  {{end}}
                  {{if .paginator.HasNext}}
                  <li><a href="{{.paginator.PageLinkNext}}">&raquo;</a></li>
                  <li><a href="{{.paginator.PageLinkLast}}">尾页</a></li>
                  {{else}}
                  <li class="disabled"><a>&raquo;</a></li>
                  <li class="disabled"><a>尾页</a></li>
                  {{end}}
                </ul>
                {{end}}