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
            <header class="panel-heading"> 项目 / 总数：{{.countProject}}<span class="tools pull-right"><a href="javascript:;" class="fa fa-chevron-down"></a>
              <!--a href="javascript:;" class="fa fa-times"></a-->
              </span> </header>
            <div class="panel-body">
              <section id="unseen">
                <form id="project-form-list">
                  <table class="table table-bordered table-striped table-condensed">
                    <thead>
                      <tr>
                        <th>名称</th>
                        <th>别名</th>
                        <th>负责人</th>
                        <th>结束时间</th>
                        <th>状态</th>
                      </tr>
                    </thead>
                    <tbody>
                    
                    {{range $k,$v := .projects}}
                    <tr>
                      <td><a href="/project/{{$v.Id}}">{{$v.Name}}</a></td>
                      <td>{{$v.Aliasname}}</td>
                      <td>{{getRealname $v.Projuserid}}</td>
                      <td>{{getDate $v.Ended}}</td>
                      <td>{{if eq 1 $v.Status}}挂起{{else if eq 2 $v.Status}}延期{{else if eq 3 $v.Status}}进行{{else if eq 4 $v.Status}}结束{{end}}</td>                     
                    </tr>
                    {{end}}
                    </tbody>
                    
                  </table>
                </form>
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
</body>
</html>
