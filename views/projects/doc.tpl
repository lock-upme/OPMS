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
      <form class="searchform" action="/project/doc/{{.project.Id}}" method="get">
        <select name="type" class="form-control">
          <option value="">类型</option>
          <option value="1" {{if eq "1" .condArr.sort}}selected{{end}}>正文</option>
          <option value="2" {{if eq "2" .condArr.sort}}selected{{end}}>链接</option>
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
        <li> <a href="/project/{{.project.Id}}">{{.project.Name}}</a> </li>
        <li class="active"> 文档 </li>
      </ul>
      <div class="pull-right"><a href="/doc/add/{{.project.Id}}" class="btn btn-success">+新文档</a></div>
    </div>
    <!-- page heading end-->
    <!--body wrapper start-->
    <div class="wrapper">
      <div class="row">
        <div class="col-sm-12">
          <section class="panel">
            <header class="panel-heading"> 文档 / 总数：{{.countDocs}}<span class="tools pull-right"><a href="javascript:;" class="fa fa-chevron-down"></a>
              <!--a href="javascript:;" class="fa fa-times"></a-->
              </span> </header>
            <div class="panel-body">
              <section id="unseen">
                <form id="project-form-list">
                  <table class="table table-bordered table-striped table-condensed">
                    <thead>
                      <tr>
                        <th>名称</th>
						<th>类型</th>
                        <th>创建人</th>
                        <th>创建日期</th>                        
                        <th>操作</th>
                      </tr>
                    </thead>
                    <tbody>
                    
                    {{range $k,$v := .docs}}
                    <tr>
                      <td><a href="/doc/show/{{$v.Id}}">{{$v.Title}}</a></td>
					  <td>{{if eq $v.Sort 1}}正文{{else}}链接{{end}}</td>
                      <td><a href="/user/show/{{$v.Userid}}">{{getRealname $v.Userid}}</a></td>                    
                      <td>{{getDate $v.Created}}</td>                     
                      <td><a href="/doc/edit/{{$v.Id}}" title="编辑" class="btn btn-danger btn-xs"><i class="fa fa-pencil-square-o"></i></a> <a href="/doc/show/{{$v.Id}}" title="查看" class="btn btn-success btn-xs"><i class="fa fa-eye"></i></a> </td>
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
    <!--footer section start-->
    {{template "inc/foot-info.tpl" .}}
    <!--footer section end-->
  </div>
  <!-- main content end-->
</section>
{{template "inc/foot.tpl" .}}
</body>
</html>
