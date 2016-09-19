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
      <h3> 任务管理 </h3>
      <ul class="breadcrumb pull-left">
        <li> <a href="/user/show/{{.LoginUserid}}">OPMS</a> </li>
        <li> <a href="/project/task/{{.project.Id}}">{{.project.Name}}</a> </li>
        <li class="active"> 任务 </li>
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
                    <h1>任务描述</h1>
                    <div class="content"> {{str2html .task.Desc}} </div>
                    <h1>任务备注</h1>
                    <div class="content"> {{str2html .task.Note}} </div>
                    <h1>关联需求</h1>
                    <div class="content"> {{str2html .need.Desc}} </div>
                    <h1>关联项目</h1>
                    <div class="content"> {{str2html .project.Desc}} </div>
                    <a class="btn p-follow-btn" href="/task/edit/{{.task.Id}}"> <i class="fa fa-check"></i> 编辑</a>&nbsp; <a  href="javascript:;" class="btn p-follow-btn js-task-delete" data-id="{{.task.Id}}"> <i class="fa fa-times"></i> 删除</a>&nbsp; <a href="javascript:;" class="btn p-follow-btn js-task-single {{if eq .task.Status 1}}active{{end}}" data-id="{{.task.Id}}" data-status="1">未开始</a> <a href="javascript:;" class="btn p-follow-btn js-task-status {{if eq .task.Status 2}}active{{end}}" data-id="{{.task.Id}}" data-status="2">进行中</a> <a href="javascript:;" class="btn p-follow-btn js-task-status {{if eq .task.Status 3}}active{{end}}" data-id="{{.task.Id}}" data-status="3">已完成</a> <a href="javascript:;" class="btn p-follow-btn js-task-status {{if eq .task.Status 4}}active{{end}}" data-id="{{.task.Id}}" data-status="4">已暂停</a> <a href="javascript:;" class="btn p-follow-btn js-task-status {{if eq .task.Status 5}}active{{end}}" data-id="{{.task.Id}}" data-status="5">已取消</a> <a href="javascript:;" class="btn p-follow-btn js-task-status {{if eq .task.Status 6}}active{{end}}" data-id="{{.task.Id}}" data-status="6">已关闭</a> </div>
                </div>
              </div>
            </div>
            <div class="col-md-12">
              <div class="panel">
                <div class="panel-body">
                  <div class="profile-desk">
                    <h1>附件下载</h1>
                    <p>{{if ne .task.Attachment ""}}<a href="{{.task.Attachment}}" target="_blank">预览下载</a>{{end}}</p>
                    <h1>历史记录</h1>
                    {{range .log}}
                    <ul>
                      <li>{{getDateMH .Created}} {{.Note}}</li>
                    </ul>
                    {{end}} </div>
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
                  <div class="title">任务名称</div>
                  <div class="desk">{{.task.Name}}</div>
                </li>
                <li>
                  <div class="title">任务类型</div>
                  <div class="desk">{{getTaskType .task.Type}}</div>
                </li>
                <li>
                  <div class="title">优先级</div>
                  <div class="desk">{{.task.Level}}级</div>
                </li>
                <li>
                  <div class="title">预计工时</div>
                  <div class="desk">{{.task.Tasktime}}</div>
                </li>
                <li>
                  <div class="title">起止日期</div>
                  <div class="desk">{{getDate .task.Started}}至{{getDate .task.Ended}}</div>
                </li>
                <li>
                  <div class="title">状态</div>
                  <div class="desk">{{getTaskStatus .task.Status}}</div>
                </li>
                <li>
                  <div class="title">创建人</div>
                  <div class="desk">{{getRealname .task.Userid}}</div>
                </li>
                <li>
                  <div class="title">指派人</div>
                  <div class="desk">{{getRealname .task.Acceptid}}</div>
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
</body>
</html>
