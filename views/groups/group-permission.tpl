<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="utf-8">
<title>{{config "String" "globaltitle" ""}}</title>
{{template "inc/meta.tpl" .}}
<link href="/static/css/table-responsive.css" rel="stylesheet">
<style>
.border { border-bottom: 1px solid #ddd;margin-bottom:20px;}
.pul{}
.pul li {display: block;float: left; width: 100%;}
.cul {display:block}
.cul li { float: left; list-unstyled: none; width: 130px;}
</style>
</head><body class="sticky-header">
<section> {{template "inc/left.tpl" .}}
  <!-- main content start-->
  <div class="main-content" >
    <!-- header section start-->
    <div class="header-section">
      <!--toggle button start-->
      <a class="toggle-btn"><i class="fa fa-bars"></i></a>
      <!--toggle button end-->
      <!--search start-->
      <!--search end-->
      {{template "inc/user-info.tpl" .}} </div>
    <!-- header section end-->
    <!-- page heading start-->
    <div class="page-heading">
      <h3> 组织管理 {{template "users/nav.tpl" .}}</h3>
      <ul class="breadcrumb pull-left">
        <li> <a href="/user/show/{{.LoginUserid}}">OPMS</a> </li>
        <li> <a href="/user/manage">用户管理</a> </li>
        <li class="active"> 权限 </li>
      </ul>
    </div>
    <!-- page heading end-->
    <!--body wrapper start-->
    <div class="wrapper">
      <div class="row">
        <div class="col-sm-12">
          <section class="panel">
            <header class="panel-heading"> 权限设置 <span class="tools pull-right"><a href="javascript:;" class="fa fa-chevron-down"></a>
              <!--a href="javascript:;" class="fa fa-times"></a-->
              </span> </header>
            <div class="panel-body">
              <section id="unseen">
                <form id="permission-form">
                  <ul class="list-unstyled pul" id="js-permission">
					<li class="text-center">
                      <input type="hidden" id="groupid" value="{{.group.Id}}">
                      <button type="button" id="permission-btn-new" class="btn btn-success">权限设置</button>
                    </li>
                  </ul>
                </form>
              </section>
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
	$('body').delegate('input[name="checkpermission"]', 'click',function(){
		var obj = $(this);
		obj.parent().next().find('input').each(function(){
			if (obj.is(':checked')) {
				$(this).prop('checked', true)
			} else {
				$(this).prop('checked', false)
			}		
		});
	});


	var pstring = "{{.pstring}}";
	var farr = pstring.substring(0,pstring.length-1).split(',');
	
	var cstring = "{{.cstring}}";
	var carr = cstring.substring(0,cstring.length-1).split(',');
	
	var html = '';
	var lefthtml = '';
	
	for(var i=0;i<farr.length;i++) {
		sarr = farr[i].split('||');		
		html +='<li data-pmodel="'+sarr[2]+'-'+sarr[3]+'" class="border">';
		html += '<h4>'+sarr[2]+' <input type="checkbox" name="checkpermission" ></h4>';
		
		html+='<ul class="cul">'
		for(var j=0;j<carr.length;j++) {
			scarr = carr[j].split('||');
			if (sarr[0] == scarr[1]) {
				html += '<li>';
                   html +='<div class="form-group" data-cmodel="'+scarr[2]+'"> ';
                   html +='<label class="checkbox-inline">';
                   html +='<input type="checkbox" name="permission[]" data-ename="'+scarr[3]+'" value="'+scarr[0]+'">';
				html += scarr[2];
                   html +='</label>';
                   html +='</div>';
                   html +='</li>';						
			}
		}			
		html += '</ul>';			
		html +='</li>';
	}

	$('#js-permission').prepend(html);
	//$('.js-left-nav').append(lefthtml);
	
	var per = '{{.groupspermissions}}';
	var val = '';
	$('input[name="permission[]"]').each(function(){
		val =  $(this).val();
		//console.log(val)
		if (per.indexOf(val) > -1) {
			$(this).attr('checked', true)
		}
	});
	
	var leftnav = '';
	var lefthtml = '';
})
</script>
</body>
</html>