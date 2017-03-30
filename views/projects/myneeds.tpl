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
      <!--search end-->
      {{template "inc/user-info.tpl" .}} </div>
    <!-- header section end-->
    <!-- page heading start-->
    {{template "inc/my-nav.tpl" .}}
    <!-- page heading end-->
    <!--body wrapper start-->
    <div class="wrapper">
      <div class="row">
        <div class="col-sm-12">
          <section class="panel">
            <header class="panel-heading"> 需求 / 总数：{{.countNeeds}}<span class="tools pull-right">
			<a href="/my/need?filter=accept" class="btn btn-default {{if eq .condArr.filter "accept"}}active{{end}}" style="padding:6px;">指派给我</a>
			<a href="/my/need?filter=create" class="btn btn-default {{if eq .condArr.filter "create"}}active{{end}}" style="padding:6px;">由我创建</a>
			<a href="javascript:;" class="fa fa-chevron-down"></a>
            </span> </header>
            <div class="panel-body">
              <section id="unseen">
                <form id="project-form-list">
                  <table class="table table-bordered table-striped table-condensed" id="dynamic-table">
                    <thead>
                      <tr>
					    <th>级别</th>
                        <th>名称</th>
                        <th>创建人</th>
                        <th>指派人</th>
                        <th>工时</th>
                        <th class="hidden-xs">日期</th>
                        <th>状态</th>
                        <th>阶段</th>
                        <th>操作</th>
                      </tr>
                    </thead>
                    <tbody>
                    
                    {{range $k,$v := .needs}}
                    <tr>
					  <td><span class="label {{if eq 1 $v.Level}}label-danger{{else if eq 2 $v.Level}}label-warning{{else if eq 3 $v.Level}}label-primary{{else if eq 4 $v.Level}}label-default{{end}}">{{$v.Level}}级</span></td>
                      <td><a href="/need/show/{{$v.Id}}">{{getProjectname $v.Projectid}}&nbsp;{{$v.Name}}</a></td>
                      <td><a href="/user/show/{{$v.Userid}}">{{getRealname $v.Userid}}</a></td>
                      <td><a href="/user/show/{{$v.Acceptid}}">{{getRealname $v.Acceptid}}</a></td>
                      <td>{{$v.Tasktime}}</td>
                      <td class="hidden-xs">{{getDate $v.Created}}</td>
                      <td>{{getNeedsStatus $v.Status}}</td>
                      <td>{{getNeedsStage $v.Stage}}</td>
                      <td><a href="/task/add/{{$v.Projectid}}?needsid={{$v.Id}}" title="任务" class="btn btn-success btn-xs"><i class="fa fa-tasks"></i></a> <a href="/need/edit/{{$v.Id}}" title="编辑" class="btn btn-danger btn-xs"><i class="fa fa-pencil-square-o"></i></a> </td>
                    </tr>
                    {{end}}
                    </tbody>
                    
                  </table>
                </form>
				{{template "inc/page.tpl" .}}
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
<script type="text/javascript" src="/static/js/advanced-datatable/js/jquery.dataTables.js"></script>
<script type="text/javascript" src="/static/js/data-tables/DT_bootstrap.js"></script>
<script src="/static/js/dynamic_table_init.js"></script>
</body>
</html>
