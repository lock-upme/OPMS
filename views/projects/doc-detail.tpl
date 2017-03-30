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
      <h3> 文档管理 </h3>
      <ul class="breadcrumb pull-left">
        <li> <a href="/user/show/{{.LoginUserid}}">OPMS</a> </li>
        <li> <a href="/project/doc/{{.project.Id}}">{{.project.Name}}</a> </li>
        <li class="active"> 文档 </li>
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
                    <h1>文档描述</h1>
                    <div class="content"> {{str2html .docs.Content}} </div>
					{{if ne .docs.Url ""}}
                    <h1>文档链接</h1>
                    <div class="content"> <a href="{{.docs.Url}}" target="_blank">查看链接</a> </div>
                    {{end}}
                    <a class="btn p-follow-btn" href="/doc/edit/{{.docs.Id}}"> <i class="fa fa-check"></i> 编辑</a>&nbsp; <a  href="javascript:;" class="btn p-follow-btn js-doc-delete" data-id="{{.docs.Id}}"> <i class="fa fa-times"></i> 删除</a></div>
                </div>
              </div>
            </div>
            <div class="col-md-12">
              <div class="panel">
                <div class="panel-body">
                  <div class="profile-desk">
					{{if ne .docs.Attachment ""}}
                    <h1>附件下载</h1>
                    <p><a href="{{.docs.Attachment}}" target="_blank">预览下载</a></p>
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
                  <div class="title">文档名称</div>
                  <div class="desk">{{.docs.Title}}</div>
                </li>
                <li>
                  <div class="title">文档类型</div>
                  <div class="desk">{{if eq .docs.Sort 1}}正文{{else}}链接{{end}}</div>
                </li>
                
                <li>
                  <div class="title">创建人</div>
                  <div class="desk">{{getRealname .docs.Userid}}</div>
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
