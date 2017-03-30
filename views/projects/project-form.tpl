<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="utf-8">
<title>{{config "String" "globaltitle" ""}}</title>
{{template "inc/meta.tpl" .}}
<link href="/static/js/bootstrap-datepicker/css/datepicker-custom.css" rel="stylesheet" />
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
      <h3> 项目管理 </h3>
      <ul class="breadcrumb pull-left">
        <li> <a href="/user/show/{{.LoginUserid}}">OPMS</a> </li>
        <li> <a href="/project/manage">项目管理</a> </li>
        <li class="active"> 项目 </li>
      </ul>
      <div class="pull-right"><a href="/project/add" class="btn btn-success">添加新项目</a></div>
    </div>
    <!-- page heading end-->
    <!--body wrapper start-->
    <div class="wrapper">
      <div class="row">
        <div class="col-lg-12">
          <section class="panel">
            <header class="panel-heading"> {{.title}} </header>
            <div class="panel-body">
              <form class="form-horizontal adminex-form" id="project-form">
                <div class="form-group">
                  <label class="col-sm-2 col-sm-2 control-label"><span>*</span>项目名称</label>
                  <div class="col-sm-10">
                    <input type="text" name="name" value="{{.project.Name}}" class="form-control" placeholder="请填写名称">
                  </div>
                </div>
                <div class="form-group">
                  <label class="col-sm-2 col-sm-2 control-label"><span>*</span>项目别名</label>
                  <div class="col-sm-10">
                    <input type="text" name="aliasname" value="{{.project.Aliasname}}" class="form-control" placeholder="取个代号">
                  </div>
                </div>
                <div class="form-group">
                  <label class="col-sm-2 col-sm-2 control-label">开始和结束日期</label>
                  <div class="col-sm-10">
                    <div class="input-group input-large custom-date-range" data-date="2016-07-07" data-date-format="yyyy-mm-dd">
                      <input type="text" class="form-control dpd1" name="started" placeholder="开始日期" value="{{getDate .project.Started}}">
                      <span class="input-group-addon">To</span>
                      <input type="text" class="form-control dpd2" name="ended"  placeholder="结束日期" value="{{getDate .project.Ended}}">
                    </div>
                  </div>
                </div>
                <div class="form-group">
                  <label class="col-sm-2 col-sm-2 control-label"><span>*</span>描述</label>
                  <div class="col-sm-10">
                    <textarea name="desc" placeholder="请填写描述" style="height:300px;" class="form-control">{{.project.Desc}}</textarea>
                  </div>
                </div>
				{{if .project.Id}}
				<div class="form-group">
                  <label class="col-sm-2 col-sm-2 control-label">项目负责人</label>
                  <div class="col-sm-10">
                    <select name="projuserid" class="form-control">
                      <option>请选择项目负责人</option>
					{{range .teams}}
                      <option value="{{.Userid}}" {{if eq .Userid $.project.Projuserid}}selected{{end}}>{{getRealname .Userid}}</option>
                    {{end}}
                    </select>
                  </div>
                </div>
				<div class="form-group">
                  <label class="col-sm-2 col-sm-2 control-label">产品负责人</label>
                  <div class="col-sm-10">
                    <select name="produserid" class="form-control">
                      <option>请选择产品负责人</option>
					{{range .teams}}
                      <option value="{{.Userid}}" {{if eq .Userid $.project.Produserid}}selected{{end}}>{{getRealname .Userid}}</option>
                    {{end}}
                    </select>
                  </div>
                </div>
				<div class="form-group">
                  <label class="col-sm-2 col-sm-2 control-label">测试负责人</label>
                  <div class="col-sm-10">
                    <select name="testuserid" class="form-control">
                      <option>请选择测试负责人</option>
					{{range .teams}}
                      <option value="{{.Userid}}" {{if eq .Userid $.project.Testuserid}}selected{{end}}>{{getRealname .Userid}}</option>
                    {{end}}
                    </select>
                  </div>
                </div>
				<div class="form-group">
                  <label class="col-sm-2 col-sm-2 control-label">发布负责人</label>
                  <div class="col-sm-10">
                    <select name="publuserid" class="form-control">
                      <option>请选择产品发布人</option>
					{{range .teams}}
                      <option value="{{.Userid}}" {{if eq .Userid $.project.Publuserid}}selected{{end}}>{{getRealname .Userid}}</option>
                    {{end}}
                    </select>
                  </div>
                </div>
				{{end}}
                <div class="form-group">
                  <label class="col-lg-2 col-sm-2 control-label"></label>
                  <div class="col-lg-10">
                    <input type="hidden" name="id" value="{{.project.Id}}">
                    <button type="submit" class="btn btn-primary">提 交</button>
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
    {{template "inc/foot-info.tpl" .}}
    <!--footer section end-->
  </div>
  <!-- main content end-->
</section>
<div aria-hidden="true" aria-labelledby="projectModalLabel" role="dialog" tabindex="-1" id="projectModal" class="modal fade">
      <div class="modal-dialog">
        <div class="modal-content">
          <div class="modal-header">
            <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
            <h4 class="modal-title">新建项目成功，请先按项目流程设置</h4>
          </div>
          <div class="modal-body">
            
            
            
          </div>
          <div class="modal-footer">
            <a href="/project/manage" class="btn btn-primary">去设置管理</a>
          </div>
        </div>
      </div>
    </div>
{{template "inc/foot.tpl" .}}
<script src="/static/js/bootstrap-datepicker/js/bootstrap-datepicker.js"></script>
<script src="/static/keditor/kindeditor-min.js"></script>
<script>
$(function(){
	var editor = KindEditor.create('textarea[name="desc"]', {
	    uploadJson: "/kindeditor/upload",
	    allowFileManager: true,
	    filterMode : false,
	    afterBlur: function(){this.sync();}
	});
	
	var nowTemp = new Date();
    var now = new Date(nowTemp.getFullYear(), nowTemp.getMonth(), nowTemp.getDate(), 0, 0, 0, 0);

    var checkin = $('.dpd1').datepicker({
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
            $('.dpd2')[0].focus();
        }).data('datepicker');
    var checkout = $('.dpd2').datepicker({
		 format: 'yyyy-mm-dd',
        onRender: function(date) {
            return date.valueOf() <= checkin.date.valueOf() ? 'disabled' : '';
        }
    }).on('changeDate', function(ev) {
            checkout.hide();
        }).data('datepicker');
})
</script>
</body>
</html>
