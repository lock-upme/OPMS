<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="utf-8">
<title>{{config "String" "globaltitle" ""}}</title>
{{template "inc/meta.tpl" .}}
<link href="/static/css/table-responsive.css" rel="stylesheet">
<link href="/static/js/advanced-datatable/css/demo_table.css" rel="stylesheet" />
<link href="/static/js/data-tables/DT_bootstrap.css" rel="stylesheet" />
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
      <form class="searchform" action="/project/test/{{.project.Id}}" method="get">
        <select name="status" class="form-control">
          <option value="">状态</option>
          <option value="1" {{if eq "1" .condArr.status}}selected{{end}}>设计如此</option>
          <option value="2" {{if eq "2" .condArr.status}}selected{{end}}>重复Bug</option>
          <option value="3" {{if eq "3" .condArr.status}}selected{{end}}>外部原因</option>
          <option value="4" {{if eq "4" .condArr.status}}selected{{end}}>已解决</option>
          <option value="5" {{if eq "5" .condArr.status}}selected{{end}}>无法重现</option>
          <option value="6" {{if eq "6" .condArr.status}}selected{{end}}>延期处理</option>
          <option value="7" {{if eq "7" .condArr.status}}selected{{end}}>不予解决</option>
        </select>
        <select name="acceptid" class="form-control">
          <option value="">指派给</option>          
		  {{range .teams}}		  
          <option value="{{.Userid}}" {{if eq .Userid $.acceptid}}selected{{end}}>{{getRealname .Userid}}</option>          
		  {{end}}
        </select>
        <input type="text" class="form-control" name="keywords" placeholder="请输入名称" value="{{.condArr.keywords}}"/>
        <button type="submit" class="btn btn-primary">搜索</button>
      </form>
      <!--search end-->
      {{template "inc/user-info.tpl" .}} </div>
    <!-- header section end-->
    <!-- page heading start-->
    <div class="page-heading">
      <h3> 项目管理 </h3>
      <ul class="breadcrumb pull-left">
        <li> <a href="/user/show/{{.LoginUserid}}">OPMS</a> </li>
        <li> <a href="/project/{{.project.Id}}">{{substr .project.Name 0 8}}</a> </li>
        <li class="active"> Bug </li>
      </ul>
      <div class="pull-right"> <a href="/project/test/{{.project.Id}}" class="btn btn-default {{if eq .condArr.filter ""}}active{{end}}">全部</a> <a href="/project/test/{{.project.Id}}?filter=accept" class="hidden-xs btn btn-default {{if eq .condArr.filter "accept"}}active{{end}}">指派给我</a> <a href="/project/test/{{.project.Id}}?filter=create" class="hidden-xs btn btn-default {{if eq .condArr.filter "create"}}active{{end}}">由我创建</a> <a href="/project/test/{{.project.Id}}?filter=complete" class="hidden-xs btn btn-default {{if eq .condArr.filter "complete"}}active{{end}}">由我解决</a> <a href="/test/add/{{.project.Id}}" class="btn btn-success">+提Bug</a></div>
    </div>
    <!-- page heading end-->
    <!--body wrapper start-->
    <div class="wrapper">
      <div class="row">
        <div class="col-sm-12">
          <section class="panel">
            <header class="panel-heading"> 测试 / 总数：{{.countTest}}<span class="tools pull-right"><a href="javascript:;" class="fa fa-chevron-down"></a>
              <!--a href="javascript:;" class="fa fa-times"></a-->
              </span> </header>
            <div class="panel-body">
              <section id="unseen">
                <form id="project-form-list">
                  <table class="table table-bordered table-striped table-condensed" id="dynamic-table">
                    <thead>
                      <tr>
                        <th>级别</th>
                        <th>Bug标题</th>
                        <th>状态</th>
                        <th>创建人</th>
                        <th class="hidden-xs">创建日期</th>
                        <th>指派人</th>
                        <th>解决人</th>
                        <th>解决日期</th>
                        <th>操作</th>
                      </tr>
                    </thead>
                    <tbody>
                    
                    {{range $k,$v := .tests}}
                    <tr>
                      <td><span class="label {{if eq 1 $v.Level}}label-danger{{else if eq 2 $v.Level}}label-warning{{else if eq 3 $v.Level}}label-primary{{else if eq 4 $v.Level}}label-default{{end}}">{{$v.Level}}级</span></td>
                      <td><a href="/test/show/{{$v.Id}}">{{$v.Name}}</a></td>
                      <td>{{getTestStatus $v.Status}}</td>
                      <td><a href="/user/show/{{$v.Userid}}">{{getRealname $v.Userid}}</a></td>
                      <td class="hidden-xs">{{getDate $v.Created}}</td>
                      <td><a href="/user/show/{{$v.Acceptid}}">{{getRealname $v.Acceptid}}</a></td>
                      <td><a href="/user/show/{{$v.Completeid}}">{{getRealname $v.Completeid}}</a></td>
                      <td>{{getDate $v.Completed}}</td>
                      <td><a href="#acceptModal" data-toggle="modal" data-id="{{$v.Id}}" title="指派" class="btn btn-warning btn-xs"><i class="fa fa-hand-o-right"></i></a> <a href="#completeModal" data-toggle="modal" data-id="{{$v.Id}}" title="完成" class="btn btn-info btn-xs"><i class="fa fa-check-square"></i></a> <a href="/test/edit/{{$v.Id}}" title="编辑" class="btn btn-danger btn-xs"><i class="fa fa-pencil-square-o"></i></a> </td>
                    </tr>
                    {{end}}
                    </tbody>
                    
                  </table>
                </form>
                {{template "inc/page.tpl" .}} </section>
            </div>
          </section>
        </div>
      </div>
    </div>
    <!--body wrapper end-->
    {{template "inc/test-dialog.tpl" .}}
    <!--footer section start-->
    {{template "inc/foot-info.tpl" .}}
    <!--footer section end-->
  </div>
  <!-- main content end-->
</section>
{{template "inc/foot.tpl" .}}
<script type="text/javascript" src="/static/js/advanced-datatable/js/jquery.dataTables.js"></script>
<script type="text/javascript" src="/static/js/data-tables/DT_bootstrap.js"></script>
<script src="/static/js/dynamic_table_init.js"></script>
<script>
$(function(){
	$('#acceptModal').on('show.bs.modal', function (e) {
		$('#testid').val($(e.relatedTarget).attr('data-id'))
	});
	$('#completeModal').on('show.bs.modal', function (e) {
		$('#ctestid').val($(e.relatedTarget).attr('data-id'))
	});		
})
</script>
</body>
</html>
