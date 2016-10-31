<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="utf-8">
<title>{{config "String" "globaltitle" ""}}</title>
{{template "inc/meta.tpl" .}}
</head>
<body class="sticky-header">
<section> {{template "inc/left.tpl" .}}
  <!-- main content start-->
  <div class="main-content" >
    <!-- header section start-->
    <div class="header-section">
      <!--toggle button start-->
      <a class="toggle-btn"><i class="fa fa-bars"></i></a>
      <!--toggle button end-->
      <!--search start-->
      <form class="searchform" action="/message/list" method="get">
        <select name="status" class="form-control">
          <option value="">状态</option>
          <option value="1" {{if eq "1" .condArr.view}}selected{{end}}>未看</option>
          <option value="2" {{if eq "2" .condArr.view}}selected{{end}}>已看</option>
        </select>
		<select name="type" class="form-control">
          <option value="">类型</option>
          <option value="1" {{if eq "1" .condArr.type}}selected{{end}}>评论</option>
          <option value="2" {{if eq "2" .condArr.type}}selected{{end}}>赞</option>
		  <option value="3" {{if eq "3" .condArr.type}}selected{{end}}>审批</option>
        </select>
        <button type="submit" class="btn btn-primary">搜索</button>
      </form>
      <!--search end-->
      {{template "inc/user-info.tpl" .}} </div>
    <!-- header section end-->
    <!-- page heading start-->
    <div class="page-heading">
      <h3> 消息管理 </h3>
      <ul class="breadcrumb pull-left">
        <li> <a href="/user/show/{{.LoginUserid}}">OPMS</a> </li>
        <li> <a href="/message/list">消息管理</a> </li>
        <li class="active"> 消息 </li>
      </ul>
    </div>
    <!-- page heading end-->
    <!--body wrapper start-->
    <div class="wrapper">
      <div class="row">
        <div class="col-sm-12">
          <section class="panel mail-box">
            <header class="panel-heading"> 消息管理 / 总数：{{.countMessage}}<span class="tools pull-right"><a href="javascript:;" class="fa fa-chevron-down"></a>
              <!--a href="javascript:;" class="fa fa-times"></a-->
              </span> </header>
            <div class="panel-body mail-box-info">
			<input type="checkbox" class="checkboxbtn">&nbsp;&nbsp;<a href="javascript:;" id="deleteMsg" class="btn btn-sm btn-primary">删除</a>
              <section class="mail-list" style="margin-top:6px;">
			  
                <ul class="list-group ">
                  {{range $k,$v := .messages}}
                  <li class="list-group-item"> <span class="pull-left chk">
                    <input type="checkbox" class="checked" value="{{$v.Id}}">
                    </span> <a class="thumb pull-left" href="/user/show/{{$v.Userid}}"> <img src="{{getAvatarUserid $v.Userid}}" style="width:22px;"> </a> <a href="{{$v.Url}}"> <small class="pull-right text-muted">{{getDateMH $v.Created}}</small> <strong>{{getRealname $v.Userid}}</strong> <span>{{getMessageType $v.Type}}了{{getMessageSubtype $v.Subtype}}&nbsp;&nbsp;{{$v.Title}}</span> </a> </li>
                  {{else}}
                  <li class="list-group-item text-center">目前还没有任何消息</li>
                  {{end}}
                </ul>
                {{template "inc/page.tpl" .}} </section>
            </div>
          </section>
        </div>
      </div>
    </div>
    <!--body wrapper end-->
    <!--footer section start-->
    {{template "inc/foot-info.tpl" .}}
    <!--footer section end-->
  </div>
  <!-- main content end-->
</section>
{{template "inc/foot.tpl" .}}
<script>
$(function(){
	//全选　
	$('.checkboxbtn').click(function(){
		$(this).parent().find("input[type='checkbox']").prop('checked', $(this).is(':checked'));   							 
	});
	
	$('#deleteMsg').on('click', function(){
	
		var ck = $('.checked:checked');
		if(ck.length <= 0) { dialogInfo('至少选择一个复选框'); return false; }
		
		var str = '';
		$.each(ck, function(i, n){
			str += n['value']+',';
		});
		str = str.substring(0, str.length - 1)
		$.post('/message/ajax/delete', {ids:str},function(data){
			dialogInfo(data.message)
			if (data.code) {
				setTimeout(function(){ window.location.reload(); }, 2000);
			} else {
				setTimeout(function(){ $('#dialogInfo').modal('hide'); }, 1000);
			}			
		},'json');
	});
})
</script>
</body>
</html>
