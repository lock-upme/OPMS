<div aria-hidden="true" aria-labelledby="acceptModalLabel" role="dialog" tabindex="-1" id="acceptModal" class="modal fade">
    <div class="modal-dialog">
      <div class="modal-content">
        <div class="modal-header">
          <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
          <h4 class="modal-title">审批人</h4>
        </div>
        <div class="modal-body">
		<ul class="list-unstyled">
		 {{range $k,$v := .users}}
		 {{if ne $v.Userid $.LoginUserid}}
		<li><a href="javascript:;" data-id="{{$v.Userid}}" data-name="{{$v.Realname}}" class="js-selectuser"><img src="{{getAvatar $v.Avatar}}">{{$v.Realname}}（{{$v.Position}}）</a></li>
		{{end}}
		{{end}}

		</ul>		
		
		</div>
  
      </div>
    </div>
  </div>
<style>
	.modal-body{ max-height: 470px;    overflow: auto;}
	.modal-body img{width:50px;height:50px;    border-radius: 50%;margin-right:20px;}
	.modal-body li {    margin-bottom: 6px;    border-bottom: 1px #ddd solid;    padding-bottom: 6px;}
	.modal-body a{display:block;    text-decoration: none;}
</style>
