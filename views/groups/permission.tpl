<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="utf-8">
<title>{{config "String" "globaltitle" ""}}</title>
{{template "inc/meta.tpl" .}}
</head>
<body class="sticky-header">
<section> {{template "inc/left.tpl" .}}
  <!-- main content start-->
  <div class="main-content" >
    <!-- header section start-->
    <div class="header-section">
      <!--toggle button start-->
      <a class="toggle-btn"><i class="fa fa-bars"></i></a>
      <!--toggle button end-->
      <!--search start-->
      <form class="searchform" action="/permission/manage" method="get">
        <input type="text" class="form-control" name="keywords" placeholder="请输入名称" value="{{.condArr.keywords}}"/>
		<select name="parentid" class="form-control">
                      <option value="">请选择栏目</option>
					{{range .parentpermissions}}
                      <option value="{{.Id}}" {{if eq .Id $.parentids}}selected{{end}}>{{.Name}}</option>
					{{end}}
                    </select>
        <button type="submit" class="btn btn-primary">搜索</button>
      </form>
      <!--search end-->
      {{template "inc/user-info.tpl" .}} </div>
    <!-- header section end-->
    <!-- page heading start-->
    <div class="page-heading">
      <h3> 组织管理 {{template "users/nav.tpl" .}}</h3>
      <ul class="breadcrumb pull-left">
        <li> <a href="/user/show/{{.LoginUserid}}">OPMS</a> </li>
        <li> <a href="/permission/manage">权限管理</a> </li>
        <li class="active"> 权限 </li>
      </ul>
      <div class="pull-right"> <a href="/permission/add" class="btn btn-success">+新增</a> </div>
    </div>
    <!-- page heading end-->
    <!--body wrapper start-->
    <div class="wrapper">
      <div class="row">
        <div class="col-sm-12">
          <section class="panel">
            <header class="panel-heading"> 权限管理 / 总数：{{.countPermission}}<span class="tools pull-right"><a href="javascript:;" class="fa fa-chevron-down"></a> </span> </header>
            <div class="panel-body">
              <table class="table table-bordered table-striped table-condensed">
                <thead>
                  <tr>
					<th>栏目</th>
                    <th>名称</th>
                    <th class="hidden-phone hidden-xs">英文</th>
                    <th>操作</th>
                  </tr>
                </thead>
                <tbody>
                
                {{range $k,$v := .permissions}}
                <tr>
				  <td>{{getPermissionname $v.Parentid}}</td>
                  <td> {{$v.Name}} </td>
                  <td class="hidden-phone hidden-xs">{{$v.Ename}}</td>
                  <td><div class="btn-group">
                      <button type="button" class="btn btn-primary dropdown-toggle" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false"> 操作<span class="caret"></span> </button>
                      <ul class="dropdown-menu">                       
                        <li><a href="/permission/edit/{{$v.Id}}">编辑</a></li>
                        <li role="separator" class="divider"></li>
                        <li><a href="javascript:;" class="js-permission-delete" data-op="delete" data-id="{{$v.Id}}">删除</a></li>
                      </ul>
                    </div></td>
                </tr>
                {{else}}
                <tr>
                  <td colspan="7">你还没有添加权限</td>
                </tr>
                {{end}}
                </tbody>
                
              </table>
              {{template "inc/page.tpl" .}} </div>
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