<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="utf-8">
<title>{{config "String" "globaltitle" ""}}</title>
{{template "inc/meta.tpl" .}}
<link href="/static/css/jquery-ui-1.10.3.css"  rel="stylesheet" />
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
      <h3> 版本管理 </h3>
      <ul class="breadcrumb pull-left">
        <li> <a href="/user/show/{{.LoginUserid}}">OPMS</a> </li>
        <li> <a href="/project/version/{{.project.Id}}">{{.project.Name}}</a> </li>
        <li class="active"> 版本 </li>
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
              <form class="form-horizontal adminex-form" id="version-form">
                <div class="form-group">
                  <label class="col-sm-2 col-sm-2 control-label"><span>*</span>版本名称</label>
                  <div class="col-sm-10">
                    <input type="text" name="title" value="{{.versions.Title}}" class="form-control" placeholder="请输入版本名称">
                  </div>
                </div>
				<div class="form-group">
                  <label class="col-sm-2 col-sm-2 control-label"><span>*</span>打包日期</label>
                  <div class="col-sm-10">
                   
                      <input type="text" class="form-control dpd1" data-date="2016-07-07" data-date-format="yyyy-mm-dd" name="versioned" placeholder="打包日期" value="{{getDate .versions.Versioned}}">
                                      
                  </div>
                </div>
				<div class="form-group">
                  <label class="col-sm-2 col-sm-2 control-label">源代码地址</label>
                  <div class="col-sm-10">
                    <input type="text" name="sourceurl" value="{{.versions.Sourceurl}}" class="form-control" placeholder="http://">
                  </div>
                </div>
				<div class="form-group">
                  <label class="col-sm-2 col-sm-2 control-label">下载地址</label>
                  <div class="col-sm-10">
                    <input type="text" name="downurl" value="{{.versions.Downurl}}" class="form-control" placeholder="http://">
                  </div>
                </div>
				 <div class="form-group">
                  <label class="col-sm-2 col-sm-2 control-label">上传发行包</label>
                  <div class="col-sm-10">
                    <input type="file" name="attachment">
                    {{if ne .versions.Attachment ""}}<br/>
                    <a href="{{.versions.Attachment}}" target="_blank">预览下载</a> {{end}} </div>
                </div>
                <div class="form-group">
                  <label class="col-sm-2 col-sm-2 control-label">描述</label>
                  <div class="col-sm-10">
                    <textarea name="content" placeholder="请填写正文" style="height:300px;" class="form-control">{{.versions.Content}}</textarea>
                  </div>
                </div>                
                
                <div class="form-group">
                  <label class="col-lg-2 col-sm-2 control-label"></label>
                  <div class="col-lg-10">
                    <input type="hidden" name="projectid" id="projectid" value="{{.project.Id}}">
                    <input type="hidden" name="id" value="{{.versions.Id}}">
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
    {{template "inc/foot-info.tpl" .}}
    <!--footer section end-->
  </div>
  <!-- main content end-->
</section>
{{template "inc/foot.tpl" .}}
<script type="text/javascript" src="/static/js/bootstrap-datepicker/js/bootstrap-datepicker.js"></script>
<script src="/static/js/jquery-ui-1.10.3.min.js"></script>
<script src="/static/keditor/kindeditor-min.js"></script>
<script>
$(function(){
	var editor = KindEditor.create('textarea[name="content"]', {
	    uploadJson: "/kindeditor/upload",
	    allowFileManager: true,
	    filterMode : false,
	    afterBlur: function(){this.sync();}
	});
	$('.dpd1').datepicker('option', $.datepicker.regional['zh-CN']); 	
	 $('.dpd1').datepicker({
        dateFormat: 'yy-mm-dd',
		changeMonth: true,
		changeYear: true,
		yearRange:'-60:+0'
    });
});	
</script>	
</body>
</html>
