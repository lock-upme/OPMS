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
.js-expenseBox {margin-bottom:10px}
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
        <li> <a href="/expense/manage">审批管理</a> </li>
        <li class="active"> 报销 </li>
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
                <strong>注意!</strong> 报销单状态为正常后(可在列表操作中设置为“正常”)，就不能再编辑！后续流程等待审批人操作。. </div>
              <form class="form-horizontal adminex-form" id="expense-form">
                {{if le .expense.Id 0}}
                <div class="js-expenseBox">
                  <div class="alert alert-info fade in"> 报销明细(1) </div>
                  <div class="form-group">
                    <label class="col-sm-2 col-sm-2 control-label">报销金额</label>
                    <div class="col-sm-10">
                      <input type="number" name="amounts[]" class="form-control" placeholder="请输入金额">
                    </div>
                  </div>
                  <div class="form-group">
                    <label class="col-sm-2 col-sm-2 control-label">报销类型</label>
                    <div class="col-sm-10">
                      <input type="text" name="types[]" class="form-control" placeholder="请输入报销类型，如采购经费、活动经费">
                    </div>
                  </div>
                  <div class="form-group">
                    <label class="col-sm-2 col-sm-2 control-label">报销明细</label>
                    <div class="col-sm-10">
                      <textarea name="contents[]" placeholder="报销明细" style="height:94px;" class="form-control"></textarea>
                    </div>
                  </div>
                </div>
                {{end}}
                <div class="form-group">
                  <label class="col-sm-2 col-sm-2 control-label"></label>
                  <div class="col-sm-10 text-center"> <a href="javascript:;" class="js-expenseBoxAdd"><i class="fa fa-plus-circle" style="font-size:20px;"></i> 添加明细</a> </div>
                </div>
                <div class="form-group">
                  <label class="col-sm-2 col-sm-2 control-label">图片</label>
                  <div class="col-sm-10">
                    <input type="file" name="picture">
                    {{if ne .expense.Picture ""}}<br/>
                    <a href="{{.expense.Picture}}" target="_blank">预览下载</a> {{end}} </div>
                </div>
                {{if le .expense.Id 0}}
                <div class="form-group">
                  <label class="col-sm-2 col-sm-2 control-label">审批人(点击头像可删除)</label>
                  <div class="col-sm-10 js-selectuserbox"> <a class="addAvatar" href="#acceptModal" data-toggle="modal"><i class="fa fa-plus-circle"></i></a> </div>
                </div>
                {{end}}
                <div class="form-group">
                  <label class="col-lg-2 col-sm-2 control-label"></label>
                  <div class="col-lg-10">
                    <input type="hidden" name="approverid" id="approverid" value="{{.expense.Approverids}}">
                    <input type="hidden" name="total" id="total" value="{{.expense.Total}}">
                    <input type="hidden" name="id" id="expenseid" value="{{.expense.Id}}">
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
 {{if gt .expense.Id 0}}
	var amounts = '{{.expense.Amounts}}';
	var types = '{{.expense.Types}}';
	var contents = '{{.expense.Contents}}';
	
	amountsArr = amounts.split('||');
	typesArr = types.split('||');
	contentsArr = contents.split('||');
	
	var html = '';
	for(var i=0;i<amountsArr.length;i++) {	
		html += '<div class="js-expenseBox">';
        html += '         <div class="alert alert-info fade in">';
		if (i==1) {
        html += '            <a href="#" class="closeBox close-sm pull-right"> <i class="fa fa-times"></i>删除 </a>';
		}
        html += '           报销明细('+(i+1)+') </div>';
        html += '          <div class="form-group">';
        html += '           <label class="col-sm-2 col-sm-2 control-label">报销金额</label>';
        html += '            <div class="col-sm-10">';
        html += '              <input type="number" name="amounts[]" value="'+amountsArr[i]+'" class="form-control" placeholder="请输入金额">';
        html += '            </div>';
        html += '          </div>';
        html += '         <div class="form-group">';
        html += '           <label class="col-sm-2 col-sm-2 control-label">报销类型</label>';
        html += '           <div class="col-sm-10">';
        html += '           <input type="text" name="types[]" value="'+typesArr[i]+'" class="form-control" placeholder="请输入报销类型，如采购经费、活动经费">';
        html += '           </div>';
        html += '        </div>';
        html += '        <div class="form-group">';
        html += '          <label class="col-sm-2 col-sm-2 control-label">报销明细</label>';
        html += '         <div class="col-sm-10">';
        html += '            <textarea name="contents[]" placeholder="报销明细" style="height:94px;" class="form-control">'+contentsArr[i]+'</textarea>';
        html += '         </div>';
        html += '        </div>';
        html += '      </div>';
	}
	
	$('#expense-form').prepend(html);
{{end}}	

	$('.js-expenseBoxAdd').on('click', function(){
		var index = $('.js-expenseBox').size();
		var html = '';
		html += '<div class="js-expenseBox">';
        html += '         <div class="alert alert-info fade in">';
        html += '            <a href="#" class="closeBox close-sm pull-right"> <i class="fa fa-times"></i>删除 </a>';
        html += '           报销明细('+(index+1)+') </div>';
        html += '          <div class="form-group">';
        html += '           <label class="col-sm-2 col-sm-2 control-label">报销金额</label>';
        html += '            <div class="col-sm-10">';
        html += '              <input type="number" name="amounts[]" class="form-control" placeholder="请输入金额">';
        html += '            </div>';
        html += '          </div>';
        html += '         <div class="form-group">';
        html += '           <label class="col-sm-2 col-sm-2 control-label">报销类型</label>';
        html += '           <div class="col-sm-10">';
        html += '           <input type="text" name="types[]" class="form-control" placeholder="请输入报销类型，如采购经费、活动经费">';
        html += '           </div>';
        html += '        </div>';
        html += '        <div class="form-group">';
        html += '          <label class="col-sm-2 col-sm-2 control-label">报销明细</label>';
        html += '         <div class="col-sm-10">';
        html += '            <textarea name="contents[]" placeholder="报销明细" style="height:94px;" class="form-control"></textarea>';
        html += '         </div>';
        html += '        </div>';
        html += '      </div>';
		$('.js-expenseBox:eq('+(index-1)+')').after(html);
	});
	
	$('body').delegate('.closeBox', 'click',function(){
		var that = $(this);
		that.parents('.js-expenseBox').remove();
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
