<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="utf-8">
<title>{{config "String" "globaltitle" ""}}</title>
{{template "inc/meta.tpl" .}}
<link href="/static/js/bootstrap-datepicker/css/datepicker-custom.css" rel="stylesheet" />
<style>
.form-group .fa{font-size:66px;}
.js-selectuserbox a {border-radius: 50px;  width: 60px;  height: 70px;  text-align: center;vertical-align: middle;   display: inline-block;}
.js-selectuserbox img{width:60px;height:60px;    border-radius: 50%;}
.js-oagoodBox {margin-bottom:10px}
</style>
</head><body class="sticky-header">
<section> {{template "inc/left.tpl" .}}
  <!-- main content start-->
  <div class="main-content" >
    <!-- header section start-->
    <div class="header-section">
      <!--toggle button start-->
      <a class="toggle-btn"><i class="fa fa-bars"></i></a> {{template "inc/user-info.tpl" .}} </div>
    <!-- header section end-->
    <!-- page heading start-->
    <div class="page-heading">
      <h3> 审批管理 </h3>
      <ul class="breadcrumb pull-left">
        <li> <a href="/user/show/{{.LoginUserid}}">OPMS</a> </li>
        <li> <a href="/oagood/manage">审批管理</a> </li>
        <li class="active"> 领用 </li>
      </ul>
    </div>
    <!-- page heading end-->
    <!--body wrapper start-->
    <div class="wrapper">
      <div class="row">
        <div class="col-lg-12">
          <section class="panel">
            <header class="panel-heading"> {{.title}} </header>
            <div class="panel-body">
              <div class="alert alert-block alert-danger fade in">
                <button type="button" class="close close-sm" data-dismiss="alert"> <i class="fa fa-times"></i> </button>
                <strong>注意!</strong> 领用单状态为正常后(可在列表操作中设置为“正常”)，就不能再编辑！后续流程等待审批人操作。. </div>
              <form class="form-horizontal adminex-form" id="oagood-form">
			  <div class="form-group">
                  <label class="col-sm-2 col-sm-2 control-label">物品用途</label>
                  <div class="col-sm-10">
                    <input type="text" name="purpose" value="{{.oagood.Purpose}}" class="form-control" placeholder="如办公用品 必填">
                  </div>
                </div>
                {{if le .oagood.Id 0}}
                <div class="js-oagoodBox">
                  <div class="alert alert-info fade in"> 领用明细(1) </div>
                  <div class="form-group">
                    <label class="col-sm-2 col-sm-2 control-label">物品名称</label>
                    <div class="col-sm-10">
                      <input type="text" name="names[]" class="form-control" placeholder="请输入物品名称">
                    </div>
                  </div>
                  <div class="form-group">
                    <label class="col-sm-2 col-sm-2 control-label">数量</label>
                    <div class="col-sm-10">
                      <input type="number" name="quantitys[]" class="form-control" placeholder="请输入物品数量">
                    </div>
                  </div>
                  
                </div>
                {{end}}
                <div class="form-group">
                  <label class="col-sm-2 col-sm-2 control-label"></label>
                  <div class="col-sm-10 text-center"> <a href="javascript:;" class="js-oagoodBoxAdd"><i class="fa fa-plus-circle" style="font-size:20px;"></i> 添加明细</a> </div>
                </div>
				<div class="form-group">
                    <label class="col-sm-2 col-sm-2 control-label">领用详情</label>
                    <div class="col-sm-10">
                      <textarea name="content" placeholder="领用详情" style="height:94px;" class="form-control"></textarea>
                    </div>
                  </div>
                <div class="form-group">
                  <label class="col-sm-2 col-sm-2 control-label">图片</label>
                  <div class="col-sm-10">
                    <input type="file" name="picture">
                    {{if ne .oagood.Picture ""}}<br/>
                    <a href="{{.oagood.Picture}}" target="_blank">预览下载</a> {{end}} </div>
                </div>
                {{if le .oagood.Id 0}}
                <div class="form-group">
                  <label class="col-sm-2 col-sm-2 control-label">审批人(点击头像可删除)</label>
                  <div class="col-sm-10 js-selectuserbox"> <a class="addAvatar" href="#acceptModal" data-toggle="modal"><i class="fa fa-plus-circle"></i></a> </div>
                </div>
                {{end}}
                <div class="form-group">
                  <label class="col-lg-2 col-sm-2 control-label"></label>
                  <div class="col-lg-10">
                    <input type="hidden" name="approverid" id="approverid" value="{{.oagood.Approverids}}">
                    <input type="hidden" name="id" id="oagoodid" value="{{.oagood.Id}}">
                    <button type="submit" class="btn btn-primary">提交保存</button>
                  </div>
                </div>
              </form>
            </div>
          </section>
        </div>
      </div>
    </div>
    <!--body wrapper end-->
    <!--footer section start-->
    {{template "inc/user-dialog.tpl" .}}
    {{template "inc/foot-info.tpl" .}}
    <!--footer section end-->
  </div>
  <!-- main content end-->
</section>
{{template "inc/foot.tpl" .}}
<script>
$(function(){
 {{if gt .oagood.Id 0}}
	var names = '{{.oagood.Names}}';
	var quantitys = '{{.oagood.Quantitys}}';
	
	namesArr = names.split('||');
	quantitysArr = quantitys.split('||');
	
	var html = '';
	for(var i=0;i<namesArr.length;i++) {	
		html += '<div class="js-oagoodBox">';
        html += '         <div class="alert alert-info fade in">';
		if (i==1) {
        html += '            <a href="#" class="closeBox close-sm pull-right"> <i class="fa fa-times"></i>删除 </a>';
		}
        html += '           领用明细('+(i+1)+') </div>';
        html += '          <div class="form-group">';
        html += '           <label class="col-sm-2 col-sm-2 control-label">物品名称</label>';
        html += '            <div class="col-sm-10">';
        html += '              <input type="text" name="names[]" value="'+namesArr[i]+'" class="form-control" placeholder="请输入物品名称">';
        html += '            </div>';
        html += '          </div>';
        html += '         <div class="form-group">';
        html += '           <label class="col-sm-2 col-sm-2 control-label">数量</label>';
        html += '           <div class="col-sm-10">';
        html += '           <input type="number" name="quantitys[]" value="'+quantitysArr[i]+'" class="form-control" placeholder="请输入物品数量">';
        html += '           </div>';
        html += '        </div>';
        html += '      </div>';
	}
	
	$('#oagood-form').prepend(html);
{{end}}	

	$('.js-oagoodBoxAdd').on('click', function(){
		var index = $('.js-oagoodBox').size();
		var html = '';
		html += '<div class="js-oagoodBox">';
        html += '         <div class="alert alert-info fade in">';
        html += '            <a href="#" class="closeBox close-sm pull-right"> <i class="fa fa-times"></i>删除 </a>';
        html += '           领用明细('+(index+1)+') </div>';
        html += '          <div class="form-group">';
        html += '           <label class="col-sm-2 col-sm-2 control-label">物品名称</label>';
        html += '            <div class="col-sm-10">';
        html += '              <input type="text" name="names[]" class="form-control" placeholder="请输入物品名称">';
        html += '            </div>';
        html += '          </div>';
        html += '         <div class="form-group">';
        html += '           <label class="col-sm-2 col-sm-2 control-label">数量</label>';
        html += '           <div class="col-sm-10">';
        html += '           <input type="number" name="quantitys[]" class="form-control" placeholder="请输入物品数量">';
        html += '           </div>';
        html += '        </div>';
        html += '      </div>';
		$('.js-oagoodBox:eq('+(index-1)+')').after(html);
	});
	
	$('body').delegate('.closeBox', 'click',function(){
		var that = $(this);
		that.parents('.js-oagoodBox').remove();
	});

	$('.js-selectuser').on('click', function(){
		var that = $(this);
		var userid = that.attr('data-id');
		var realname = that.attr('data-name');
		var avatar = that.find('img').attr('src');
		
		var approverid = $('#approverid').val();
		if(approverid.indexOf(userid) > 0 ){
			$('#acceptModal').modal('hide')
			dialogInfo('审批人已经添加过');			
			return false;
		}
		
		var html = '';
		html += '<a href="javascript:;" data-id="'+userid+'"><img src="'+avatar+'"><span>'+realname+'</span></a><span>..........</span>';
		if ($('.js-selectuserbox').find('a img').size()) {
			$('.addAvatar').before(html);
		} else {
			$('.js-selectuserbox').prepend(html);
		}
		$('#approverid').val(approverid+','+userid);		
		$('#acceptModal').modal('hide')
	});
	
	$('.js-selectuserbox').delegate('a img', 'click',function(){
		var that = $(this);
		
		var approverid = $('#approverid').val();
		var userid = that.parent().attr('data-id');
		result = approverid.replace(eval("/,?"+userid+",?/"),' ').trim(' ').replace(' ',',');
		$('#approverid').val(result);
		
		that.parent().next('span').remove();
		that.parent().remove();
	});	

	$('.addAvatar').on('show.bs.modal', function (e) {
		//$('#taskid').val($(e.relatedTarget).attr('data-id'))
	});
})
</script>
</body>
</html>
