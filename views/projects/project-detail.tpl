<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="utf-8">
<title>{{config "String" "globaltitle" ""}}</title>
{{template "inc/meta.tpl" .}}
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
      <h3> 项目管理 </h3>
      <ul class="breadcrumb pull-left">
        <li> <a href="/user/show/{{.LoginUserid}}">OPMS</a> </li>
        <li> <a href="{{.url}}">项目管理</a> </li>
        <li class="active"> 项目 </li>
      </ul>
      <div class="pull-right"><a href="/project/team/{{.project.Id}}" class="btn btn-success">团队</a> <a href="/project/need/{{.project.Id}}" class="btn btn-success">需求</a> <a href="/project/task/{{.project.Id}}" class="btn btn-success">任务</a> <a href="/project/test/{{.project.Id}}" class="btn btn-success">Bug</a> <a href="/project/chart/{{.project.Id}}" class="btn btn-warning">报表</a></div>
    </div>
    <div class="clearfix"></div>
    <!-- page heading end-->
    <!--body wrapper start-->
    <div class="wrapper">
      <div class="row">
        <div class="col-md-8">
          <div class="row">
            <div class="col-md-12">
              <div class="panel">
                <div class="panel-body">
                  <div class="profile-desk">
                    <h1>项目介绍</h1>
                    <span class="designation">{{.project.Aliasname}}</span>
                    <div class="content"> {{str2html .project.Desc}} </div>
					{{if eq .LoginUserid .project.Userid}}
                    <a class="btn p-follow-btn" href="/project/edit/{{.project.Id}}"> <i class="fa fa-check"></i> 编辑</a>&nbsp; <a href="javascript:;" class="btn p-follow-btn js-project-single {{if eq .project.Status 1}}active{{end}}" data-id="{{.project.Id}}" data-status="1">挂起</a> <a href="javascript:;" class="btn p-follow-btn js-project-single {{if eq .project.Status 2}}active{{end}}" data-id="{{.project.Id}}" data-status="2">延期</a> <a href="javascript:;" class="btn p-follow-btn js-project-single {{if eq .project.Status 3}}active{{end}}" data-id="{{.project.Id}}" data-status="3">进行</a> <a href="javascript:;" class="btn p-follow-btn js-project-single {{if eq .project.Status 4}}active{{end}}" data-id="{{.project.Id}}" data-status="4">结束</a> 
                	{{end}}
					</div>
				</div>
              </div>
            </div>
          </div>
        </div>
        <div class="col-md-4">
          <div class="panel">
            <div class="panel-body">
              <ul class="p-info">
                <li>
                  <div class="title">项目名称</div>
                  <div class="desk">{{.project.Name}}</div>
                </li>
                <li>
                  <div class="title">代号</div>
                  <div class="desk">{{.project.Aliasname}}</div>
                </li>
                <li>
                  <div class="title">起止时间</div>
                  <div class="desk">{{getDate .project.Started}}至{{getDate .project.Ended}}</div>
                </li>
                <li>
                  <div class="title">可用工作日</div>
                  <div class="desk js-workday">{{.project.Name}}</div>
                </li>
                <li>
                  <div class="title">项目负责人</div>
                  <div class="desk">{{getRealname .project.Projuserid}}</div>
                </li>
                <li>
                  <div class="title">产品负责人</div>
                  <div class="desk">{{getRealname .project.Produserid}}</div>
                </li>
                <li>
                  <div class="title">测试负责人</div>
                  <div class="desk">{{getRealname .project.Testuserid}}</div>
                </li>
                <li>
                  <div class="title">发布负责人</div>
                  <div class="desk">{{getRealname .project.Publuserid}}</div>
                </li>
                <li>
                  <div class="title">项目状态</div>
                  <div class="desk">{{if eq 1 .project.Status}}挂起{{else if eq 2 .project.Status}}延期{{else if eq 3 .project.Status}}进行{{else if eq 4 .project.Status}}结束{{end}}</div>
                </li>
              </ul>
            </div>
          </div>
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
	var workday = workDay({{getDate .project.Started}},{{getDate .project.Ended}});
	$('.js-workday').text(workday+'天');
});
</script>
</body>
</html>
