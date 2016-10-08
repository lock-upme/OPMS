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
      <form class="searchform" action="/businesstrip/manage" method="get">
        <select name="status" class="form-control">
          <option value="">状态</option>
          <option value="1" {{if eq "1" .condArr.status}}selected{{end}}>草稿</option>
          <option value="2" {{if eq "2" .condArr.status}}selected{{end}}>正常</option>
        </select>
        <select name="result" class="form-control">
          <option value="">结果</option>
          <option value="1" {{if eq "1" .condArr.result}}selected{{end}}>同意</option>
          <option value="2" {{if eq "2" .condArr.result}}selected{{end}}>拒绝</option>
        </select>
        <button type="submit" class="btn btn-primary">搜索</button>
      </form>
      <!--search end-->
      {{template "inc/user-info.tpl" .}} </div>
    <!-- header section end-->
    <!-- page heading start-->
    <div class="page-heading">
      <h3> 审批管理 </h3>
      <ul class="breadcrumb pull-left">
        <li> <a href="/user/show/{{.LoginUserid}}">OPMS</a> </li>
        <li> <a href="/businesstrip/manage">审批管理</a> </li>
        <li class="active"> 出差 </li>
      </ul>
      <div class="pull-right"> <a href="/businesstrip/manage" class="hidden-xs btn btn-default">全部</a> <a href="/businesstrip/approval" class="btn btn-warning" style="padding:4px;">待审批</a> <a href="/businesstrip/add" class="btn btn-success">+出差申请</a> </div>
    </div>
    <!-- page heading end-->
    <!--body wrapper start-->
    <div class="wrapper">
      <div class="row">
        <div class="col-sm-12">
          <section class="panel">
            <header class="panel-heading"> 出差 / 总数：{{.countBusinesstrip}}<span class="tools pull-right"><a href="javascript:;" class="fa fa-chevron-down"></a> </span> </header>
            <div class="panel-body">
              <table class="table table-hover general-table">
                <thead>
                  <tr>
                    <th class="hidden-phone">天数</th>
                    <th>状态</th>
                    <th>结果</th>
                    <th>进度</th>
                    <th>操作</th>
                  </tr>
                </thead>
                <tbody>
                
                {{range $k,$v := .businesstrips}}
                <tr>
                  <td class="hidden-phone">{{$v.Days}}天</td>
                  <td> {{if eq $v.Status 1}} <span class="label label-warning label-mini">草稿</span> {{else if eq $v.Status 2}} <span class="label label-success label-mini">正常</span> {{end}} </td>
                  <td> {{if eq $v.Result 1}} <span class="label label-success label-mini">同意</span> {{else if eq $v.Result 2}} <span class="label label-danger label-mini">拒绝</span>{{else}}<span class="label label-warning label-mini">等待中</span> {{end}} </td>
                  <td><div class="js-selectuserbox"> {{str2html (getBusinesstripProcess $v.Id)}} </div></td>
                  <td> {{if eq $v.Status 1}}
                    <div class="btn-group">
                      <button type="button" class="btn btn-primary dropdown-toggle" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false"> 操作<span class="caret"></span> </button>
                      <ul class="dropdown-menu">
                        <li><a href="/businesstrip/edit/{{$v.Id}}">编辑</a></li>
                        <li role="separator" class="divider"></li>
                        <li><a href="javascript:;" class="js-businesstrip-delete" data-op="delete" data-id="{{$v.Id}}">删除</a></li>
                        {{if eq $v.Status 1}}
                        <li role="separator" class="divider"></li>
                        <li><a href="javascript:;" class="js-businesstrip-status" data-op="status" data-id="{{$v.Id}}">正常</a></li>
                        {{end}}
                      </ul>
                    </div>
                    {{else}} <a href="/businesstrip/approval/{{$v.Id}}"> 查看 </a> {{end}} </td>
                </tr>
                {{else}}
                <tr>
                  <td colspan="7">你还没有申请过出差单</td>
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
