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
      <h3> 需求管理 </h3>
      <ul class="breadcrumb pull-left">
        <li> <a href="/user/show/{{.LoginUserid}}">OPMS</a> </li>
        <li> <a href="/project/need/{{.project.Id}}">{{.project.Name}}</a> </li>
        <li class="active"> 需求 </li>
      </ul>
      <div class="pull-right"><a href="/project/team/{{.project.Id}}" class="btn btn-success">团队</a> <a href="/project/need/{{.project.Id}}" class="btn btn-success">需求</a> <a href="/project/task/{{.project.Id}}" class="btn btn-success">任务</a> <a href="/project/test/{{.project.Id}}" class="btn btn-success">测试</a> <a href="/project/chart/{{.project.Id}}" class="btn btn-success">报表</a></div>
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
                    <h1>需求介绍</h1>
                    <div class="content"> {{str2html .needs.Desc}} </div>
                    <h1>验收标准</h1>
                    <div class="content"> {{str2html .needs.Acceptance}} </div>
                    <h1>关联项目</h1>
                    <div class="content"> {{str2html .project.Desc}} </div>
                    <a class="btn p-follow-btn" href="/need/edit/{{.needs.Id}}"> <i class="fa fa-check"></i> 编辑</a>&nbsp; <a href="javascript:;" class="btn p-follow-btn js-needs-single {{if eq .needs.Status 1}}active{{end}}" data-id="{{.needs.Id}}" data-status="1">草稿</a> <a href="javascript:;" class="btn p-follow-btn js-needs-single {{if eq .needs.Status 2}}active{{end}}" data-id="{{.needs.Id}}" data-status="2">激活</a> <a href="javascript:;" class="btn p-follow-btn js-needs-single {{if eq .needs.Status 3}}active{{end}}" data-id="{{.needs.Id}}" data-status="3">已变更</a> <a href="javascript:;" class="btn p-follow-btn js-needs-single {{if eq .needs.Status 4}}active{{end}}" data-id="{{.needs.Id}}" data-status="4">待关闭</a> <a href="javascript:;" class="btn p-follow-btn js-needs-single {{if eq .needs.Status 5}}active{{end}}" data-id="{{.needs.Id}}" data-status="5">已关闭</a> </div>
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
                  <div class="title">需求名称</div>
                  <div class="desk">{{.needs.Name}}</div>
                </li>
                <li>
                  <div class="title">来源</div>
                  <div class="desk">{{getNeedsSource .needs.Source}}</div>
                </li>
                <li>
                  <div class="title">优先级</div>
                  <div class="desk">{{.needs.Level}}级</div>
                </li>
                <li>
                  <div class="title">阶段</div>
                  <div class="desk">{{getNeedsStage .needs.Stage}}</div>
                </li>
                <li>
                  <div class="title">状态</div>
                  <div class="desk">{{getNeedsStatus .needs.Status}}</div>
                </li>
                <li>
                  <div class="title">创建人</div>
                  <div class="desk">{{getRealname .needs.Userid}}</div>
                </li>
                <li>
                  <div class="title">指派人</div>
                  <div class="desk">{{getRealname .needs.Acceptid}}</div>
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
