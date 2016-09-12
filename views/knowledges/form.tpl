<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="utf-8">
<title>{{config "String" "globaltitle" ""}}</title>
{{template "inc/meta.tpl" .}}
<link href="/static/css/table-responsive.css" rel="stylesheet">
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
      <h3> 知识分享 </h3>
      <ul class="breadcrumb pull-left">
        <li> <a href="/user/show/{{.LoginUserid}}">OPMS</a> </li>
        <li> <a href="/knowledge/list">知识分享</a> </li>
        <li class="active"> 知识 </li>
      </ul>
      <div class="pull-right"><a href="/knowledge/add" class="btn btn-success">+分享知识</a></div>
    </div>
    <!-- page heading end-->
    <!--body wrapper start-->
    <div class="wrapper">
      <div class="row">
        <div class="col-lg-12">
          <section class="panel">
            <header class="panel-heading"> {{.title}} </header>
            <div class="panel-body">
              <form class="form-horizontal adminex-form" id="knowledge-form">
                <div class="form-group">
                  <label class="col-sm-2 col-sm-2 control-label">类别</label>
                  <div class="col-sm-10">
                    <select name="sortid" class="form-control">
                      <option value="">请选择分类</option>                      
					{{range .sorts}}					
                      <option value="{{.Id}}" {{if eq $.knowledge.Sortid .Id}}selected{{end}}>{{.Name}}</option> 
					{{end}}					
                    </select>
                  </div>
                </div>
                <div class="form-group">
                  <label class="col-sm-2 col-sm-2 control-label">标题</label>
                  <div class="col-sm-10">
                    <input type="text" name="title" value="{{.knowledge.Title}}" class="form-control" placeholder="请填写标题">
                  </div>
                </div>
                <div class="form-group">
                  <label class="col-sm-2 col-sm-2 control-label">标签</label>
                  <div class="col-sm-10">
                    <input type="text" name="tag" value="{{.knowledge.Tag}}" class="form-control" placeholder="填写标签">
                  </div>
                </div>
                <div class="form-group">
                  <label class="col-sm-2 col-sm-2 control-label">URL</label>
                  <div class="col-sm-10">
                    <input type="text" name="url" value="{{.knowledge.Url}}" class="form-control" placeholder="http://">
                  </div>
                </div>
                <div class="form-group">
                  <label class="col-sm-2 col-sm-2 control-label">简介</label>
                  <div class="col-sm-10">
                    <textarea name="summary" placeholder="请填写简介" style="height:90px;" class="form-control">{{.knowledge.Summary}}</textarea>
                  </div>
                </div>
                <div class="form-group">
                  <label class="col-sm-2 col-sm-2 control-label">内容</label>
                  <div class="col-sm-10">
                    <textarea name="content" placeholder="请填写简介" style="height:400px;" class="form-control">{{.knowledge.Content}}</textarea>
                  </div>
                </div>
                <div class="form-group">
                  <label class="col-lg-2 col-sm-2 control-label"></label>
                  <div class="col-lg-10">
                    <input type="hidden" name="id" value="{{.knowledge.Id}}">
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
{{template "inc/foot.tpl" .}}
<script src="/static/keditor/kindeditor-min.js"></script>
<script>
$(function(){
	var editor = KindEditor.create('textarea[name="content"]', {
	    uploadJson: "/kindeditor/upload",
	    allowFileManager: true,
	    filterMode : false,
	    afterBlur: function(){this.sync();}
	});	
})
</script>
</body>
</html>
