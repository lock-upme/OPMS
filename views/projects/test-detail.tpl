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
      <h3> 测试管理 </h3>
      <ul class="breadcrumb pull-left">
        <li> <a href="/user/show/{{.LoginUserid}}">OPMS</a> </li>
        <li> <a href="/project/test/{{.project.Id}}">{{.project.Name}}</a> </li>
        <li class="active"> Bug </li>
      </ul>
      <div class="pull-right">{{template "projects/nav.tpl" .}}</div>
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
                    <h1>测试描述</h1>
                    <div class="content"> {{str2html .test.Desc}} </div>
                    <h1>关联需求</h1>
                    <div class="content">  {{str2html .need.Desc}} </div>
                    <h1>关联项目</h1>
                    <div class="content">  {{str2html .project.Desc}} </div>
                    <a class="btn p-follow-btn" href="/test/edit/{{.test.Id}}"> <i class="fa fa-check"></i> 编辑</a>&nbsp; 
					<a  href="javascript:;" class="btn p-follow-btn js-test-delete" data-id="{{.test.Id}}"> <i class="fa fa-times"></i> 删除</a>&nbsp;
					<a href="javascript:;" class="btn p-follow-btn js-test-status {{if eq .test.Status 1}}active{{end}}" data-id="{{.test.Id}}" data-status="1">设计如此</a>&nbsp; 
					<a href="javascript:;" class="btn p-follow-btn js-test-status {{if eq .test.Status 2}}active{{end}}" data-id="{{.test.Id}}" data-status="2">重复Bug</a>&nbsp; 
					<a href="javascript:;" class="btn p-follow-btn js-test-status {{if eq .test.Status 3}}active{{end}}" data-id="{{.test.Id}}" data-status="3">外部原因</a>&nbsp; 
					<a href="javascript:;" class="btn p-follow-btn js-test-status {{if eq .test.Status 4}}active{{end}}" data-id="{{.test.Id}}" data-status="4">已解决</a>&nbsp; 
					<a href="javascript:;" class="btn p-follow-btn js-test-status {{if eq .test.Status 5}}active{{end}}" data-id="{{.test.Id}}" data-status="5">无法重现</a>&nbsp; 
					<a href="javascript:;" class="btn p-follow-btn js-test-status {{if eq .test.Status 6}}active{{end}}" data-id="{{.test.Id}}" data-status="6">延期处理</a>&nbsp; 
					<a href="javascript:;" class="btn p-follow-btn js-test-status {{if eq .test.Status 7}}active{{end}}" data-id="{{.test.Id}}" data-status="7">不予解决</a>&nbsp; 
					
					</div>
                </div>
              </div>
            </div>
            <div class="col-md-12">
              <div class="panel">
                <div class="panel-body">
                  <div class="profile-desk">
				{{if ne .test.Attachment ""}}
                    <h1>附件下载</h1>
                    <p><a href="{{.test.Attachment}}" target="_blank">预览下载</a></p>
				{{end}}
                    <h1>历史记录</h1>
                    {{range .log}}
                    <ul>
                      <li>{{getDateMH .Created}} {{str2html .Note}}</li>
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
                  <div class="title">Bug标题</div>
                  <div class="desk">{{.test.Name}}</div>
                </li>
                <li>
                  <div class="title">优先级</div>
                  <div class="desk">{{.test.Level}}级</div>
                </li>                
                <li>
                  <div class="title">状态</div>
                  <div class="desk">{{getTestStatus .test.Status}}</div>
                </li>
                <li>
                  <div class="title">创建人</div>
                  <div class="desk">{{getRealname .test.Userid}}</div>
                </li>
                <li>
                  <div class="title">指派人</div>
                  <div class="desk">{{getRealname .test.Acceptid}}</div>
                </li>
                <li>
                  <div class="title">完成者</div>
                  <div class="desk">{{getRealname .test.Completeid}}</div>
                </li>
				<li>
                  <div class="title">操作系统</div>
                  <div class="desk">{{getOs .test.Os}}</div>
                </li>
                <li>
                  <div class="title">浏览器</div>
                  <div class="desk">{{getBrowser .test.Browser}}</div>
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
