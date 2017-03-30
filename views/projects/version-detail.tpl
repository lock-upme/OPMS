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
      <h3> 版本管理 </h3>
      <ul class="breadcrumb pull-left">
        <li> <a href="/user/show/{{.LoginUserid}}">OPMS</a> </li>
        <li> <a href="/project/version/{{.project.Id}}">{{.project.Name}}</a> </li>
        <li class="active"> 版本 </li>
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
                    <h1>版本描述</h1>
                    <div class="content"> {{str2html .versions.Content}} </div>
					{{if ne .versions.Sourceurl ""}}
                    <h1>源代码地址</h1>
                    <div class="content"> <a href="{{.versions.Sourceurl}}" target="_blank">查看链接</a> </div>
                    {{end}}
					{{if ne .versions.Downurl ""}}
                    <h1>下载地址</h1>
                    <div class="content"> <a href="{{.versions.Downurl}}" target="_blank">查看链接</a> </div>
                    {{end}}
                    <a class="btn p-follow-btn" href="/version/edit/{{.versions.Id}}"> <i class="fa fa-check"></i> 编辑</a>&nbsp; <a  href="javascript:;" class="btn p-follow-btn js-version-delete" data-id="{{.versions.Id}}"> <i class="fa fa-times"></i> 删除</a></div>
                </div>
              </div>
            </div>
            <div class="col-md-12">
              <div class="panel">
                <div class="panel-body">
                  <div class="profile-desk">
					{{if ne .versions.Attachment ""}}
                    <h1>发行包下载</h1>
                    <p><a href="{{.versions.Attachment}}" target="_blank">预览下载</a></p>
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
                  <div class="title">版本名称</div>
                  <div class="desk">{{.versions.Title}}</div>
                </li>
                <li>
                  <div class="title">打包日期</div>
                  <div class="desk">{{getDate .versions.Versioned}}</div>
                </li>
                
                <li>
                  <div class="title">创建人</div>
                  <div class="desk">{{getRealname .versions.Userid}}</div>
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
