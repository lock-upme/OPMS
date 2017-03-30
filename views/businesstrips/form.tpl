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
.js-businesstripBox {margin-bottom:10px}
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
      <h3> 审批管理 {{template "inc/checkwork-nav.tpl" .}}</h3>
      <ul class="breadcrumb pull-left">
        <li> <a href="/user/show/{{.LoginUserid}}">OPMS</a> </li>
        <li> <a href="/businesstrip/manage">审批管理</a> </li>
        <li class="active"> 出差 </li>
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
                <strong>注意!</strong> 出差单状态为正常后(可在列表操作中设置为“正常”)，就不能再编辑！后续流程等待审批人操作。. </div>
              <form class="form-horizontal adminex-form" id="businesstrip-form">
                {{if le .businesstrip.Id 0}}
                <div class="js-businesstripBox">
                  <div class="alert alert-info fade in"> 行程明细(1) </div>
                  <div class="form-group">
                    <label class="col-sm-2 col-sm-2 control-label"><span>*</span>目的地</label>
                    <div class="col-sm-10">
                      <input type="text" name="destinations[]" class="form-control" placeholder="请输入目的地">
                    </div>
                  </div>
                  <div class="form-group">
                    <label class="col-sm-2 col-sm-2 control-label"><span>*</span>行程日期</label>
                    <div class="col-sm-10">
                      <div class="input-group input-large custom-date-range" data-date="2016-07-07" data-date-format="yyyy-mm-dd">
                        <input type="text" class="form-control dpd1" name="starteds[]" placeholder="开始日期">
                        <span class="input-group-addon">To</span>
                        <input type="text" class="form-control dpd2" name="endeds[]"  placeholder="结束日期">
                      </div>
                    </div>
                  </div>
                </div>
                {{end}}
                <div class="form-group">
                  <label class="col-sm-2 col-sm-2 control-label"></label>
                  <div class="col-sm-10 text-center"> <a href="javascript:;" class="js-businesstripBoxAdd"><i class="fa fa-plus-circle" style="font-size:20px;"></i> 添加行程明细</a> </div>
                </div>
                <div class="form-group">
                  <label class="col-sm-2 col-sm-2 control-label">出差天数</label>
                  <div class="col-sm-10">
                    <input type="number" name="days" value="{{.businesstrip.Days}}" class="form-control" placeholder="请输入数字">
                  </div>
                </div>
                <div class="form-group">
                  <label class="col-sm-2 col-sm-2 control-label"><span>*</span>出差事由</label>
                  <div class="col-sm-10">
                    <textarea name="reason" placeholder="请输入出差事由" style="height:200px;" class="form-control">{{.businesstrip.Reason}}</textarea>
                  </div>
                </div>
                <div class="form-group">
                  <label class="col-sm-2 col-sm-2 control-label">图片</label>
                  <div class="col-sm-10">
                    <input type="file" name="picture">
                    {{if ne .businesstrip.Picture ""}}<br/>
                    <a href="{{.businesstrip.Picture}}" target="_blank">预览下载</a> {{end}} </div>
                </div>
                {{if le .businesstrip.Id 0}}
                <div class="form-group">
                  <label class="col-sm-2 col-sm-2 control-label">审批人(点击头像可删除)</label>
                  <div class="col-sm-10 js-selectuserbox"> <a class="addAvatar" href="#acceptModal" data-toggle="modal"><i class="fa fa-plus-circle"></i></a> </div>
                </div>
                {{end}}
                <div class="form-group">
                  <label class="col-lg-2 col-sm-2 control-label"></label>
                  <div class="col-lg-10">
                    <input type="hidden" name="approverid" id="approverid" value="{{.businesstrip.Approverids}}">
                    <input type="hidden" name="id" id="businesstripid" value="{{.businesstrip.Id}}">
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
<script type="text/javascript" src="/static/js/bootstrap-datepicker/js/bootstrap-datepicker.js"></script>
<script>
$(function(){
 {{if gt .businesstrip.Id 0}}
	var destinations = '{{.businesstrip.Destinations}}';
	var starteds = '{{.businesstrip.Starteds}}';
	var endeds = '{{.businesstrip.Endeds}}';
	
	destinationsArr = destinations.split('||');
	startedsArr = starteds.split('||');
	endedsArr = endeds.split('||');
	
	var html = '';
	for(var i=0;i<destinationsArr.length;i++) {		
		html += '<div class="js-businesstripBox">';
        html += '<div class="alert alert-info fade in">';
		if (i==1) {
        html += '<a href="#" class="closeBox close-sm pull-right"> <i class="fa fa-times"></i>删除 </a>';
		}
        html += '行程明细('+(i+1)+') </div>';
		html += '<div class="form-group">';
        html += '<label class="col-sm-2 col-sm-2 control-label">目的地</label>';
        html += '<div class="col-sm-10">';
        html += ' <input type="text" name="destinations[]" value="'+destinationsArr[i]+'" class="form-control" placeholder="请输入目的地">';
        html += '</div>';
        html += '</div>';
        html += '<div class="form-group">';
        html += '<label class="col-sm-2 col-sm-2 control-label">行程日期</label>';
        html += '<div class="col-sm-10">';
        html += '<div class="input-group input-large custom-date-range" data-date="2016-07-07" data-date-format="yyyy-mm-dd">';
        html += '<input type="text" class="form-control dpd1" name="starteds[]" value="'+startedsArr[i]+'" placeholder="开始日期">';
        html += '<span class="input-group-addon">To</span>';
        html += ' <input type="text" class="form-control dpd2" name="endeds[]" value="'+endedsArr[i]+'" placeholder="结束日期">';
        html += '</div>';
        html += ' </div>';
        html += '</div>';		
	}	
	$('#businesstrip-form').prepend(html);
{{end}}	

	$('.js-businesstripBoxAdd').on('click', function(){
		var index = $('.js-businesstripBox').size();
		var html = '';
		html += '<div class="js-businesstripBox">';
        html += '<div class="alert alert-info fade in">';
        html += '<a href="#" class="closeBox close-sm pull-right"> <i class="fa fa-times"></i>删除 </a>';
        html += '行程明细('+(index+1)+') </div>';
		html += '<div class="form-group">';
        html += '<label class="col-sm-2 col-sm-2 control-label">目的地</label>';
        html += '<div class="col-sm-10">';
        html += ' <input type="text" name="destinations[]" class="form-control" placeholder="请输入目的地">';
        html += '</div>';
        html += '</div>';
        html += '<div class="form-group">';
        html += '<label class="col-sm-2 col-sm-2 control-label">行程日期</label>';
        html += '<div class="col-sm-10">';
        html += '<div class="input-group input-large custom-date-range" data-date="2016-07-07" data-date-format="yyyy-mm-dd">';
        html += '<input type="text" class="form-control dpd1" name="starteds[]" placeholder="开始日期">';
        html += '<span class="input-group-addon">To</span>';
        html += ' <input type="text" class="form-control dpd2" name="endeds[]"  placeholder="结束日期">';
        html += '</div>';
        html += ' </div>';
        html += '</div>';
		$('.js-businesstripBox:eq('+(index-1)+')').after(html);
	});
	
	$('body').delegate('.closeBox', 'click',function(){
		var that = $(this);
		that.parents('.js-businesstripBox').remove();
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
	
	
	
	var nowTemp = new Date();
    var now = new Date(nowTemp.getFullYear(), nowTemp.getMonth(), nowTemp.getDate(), 0, 0, 0, 0);
		
	$('body').delegate('.dpd1', 'focus',function(){
		var checkout = $(this).nextAll('input').datepicker({format: 'yyyy-mm-dd'}).data('datepicker');;	
		var checkin = $(this).datepicker({
			format: 'yyyy-mm-dd',
			onRender: function(date) {
				return date.valueOf() < now.valueOf() ? 'disabled' : '';
			}
		}).on('changeDate', function(ev) {
			if (ev.date.valueOf() > checkout.date.valueOf()) {
				var newDate = new Date(ev.date)
				newDate.setDate(newDate.getDate() + 1);
				checkout.setValue(newDate);
			}
			checkin.hide();
			$(this).nextAll('input').focus();
		}).data('datepicker');
	});	
	
	$('body').delegate('.dpd2', 'focus',function(){
		var checkout = $(this).datepicker({
			format: 'yyyy-mm-dd',
			onRender: function(date) {
				return date.valueOf() <= checkin.date.valueOf() ? 'disabled' : '';
			}
		}).on('changeDate', function(ev) {
			checkout.hide();
		}).data('datepicker');
	});
})
</script>
</body>
</html>
