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
      <h3> 文档管理 </h3>
      <ul class="breadcrumb pull-left">
        <li> <a href="/user/show/{{.LoginUserid}}">OPMS</a> </li>
        <li> <a href="/project/doc/{{.project.Id}}">{{.project.Name}}</a> </li>
        <li class="active"> 文档 </li>
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
              <form class="form-horizontal adminex-form" id="doc-form">
                <div class="form-group">
                  <label class="col-sm-2 col-sm-2 control-label"><span>*</span>文档名称</label>
                  <div class="col-sm-10">
                    <input type="text" name="title" value="{{.docs.Title}}" class="form-control" placeholder="请输入文档名称">
                  </div>
                </div>
				<div class="form-group">
                  <label class="col-sm-2 col-sm-2 control-label">关键字</label>
                  <div class="col-sm-10">
                    <input type="text" name="keyword" value="{{.docs.Keyword}}" class="form-control" placeholder="请输入关键字">
                  </div>
                </div>                
                <div class="form-group">
                  <label class="col-sm-2 col-sm-2 control-label"><span>*</span>类型</label>
                  <div class="col-sm-10">
                    <select name="sort" class="form-control">
                      <option value="">请选择类型</option>
                      <option value="1" {{if eq .docs.Sort 1}}selected{{end}}>正文</option>
                      <option value="2" {{if eq .docs.Sort 2}}selected{{end}}>链接</option>
                    </select>
                  </div>
                </div>
				<div class="form-group">
                  <label class="col-sm-2 col-sm-2 control-label">链接</label>
                  <div class="col-sm-10">
                    <input type="text" name="url" value="{{.docs.Url}}" class="form-control" placeholder="http://">
                  </div>
                </div>   
                <div class="form-group">
                  <label class="col-sm-2 col-sm-2 control-label">正文</label>
                  <div class="col-sm-10">
                    <textarea name="content" placeholder="请填写正文" style="height:300px;" class="form-control">{{.docs.Content}}</textarea>
                  </div>
                </div>                
                <div class="form-group">
                  <label class="col-sm-2 col-sm-2 control-label">附件</label>
                  <div class="col-sm-10">
                    <input type="file" name="attachment">
                    {{if ne .docs.Attachment ""}}<br/>
                    <a href="{{.docs.Attachment}}" target="_blank">预览下载</a> {{end}} </div>
                </div>
                <div class="form-group">
                  <label class="col-lg-2 col-sm-2 control-label"></label>
                  <div class="col-lg-10">
                    <input type="hidden" name="projectid" id="projectid" value="{{.project.Id}}">
                    <input type="hidden" name="id" value="{{.docs.Id}}">
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
});	
</script>	
</body>
</html>
