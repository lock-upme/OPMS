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
      <form class="searchform" action="/leave/manage" method="get">
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
        <select name="type" class="form-control">
          <option value="">类型</option>
          <option value="1" {{if eq "1" .condArr.type}}selected{{end}}>事假</option>
          <option value="2" {{if eq "2" .condArr.type}}selected{{end}}>病假</option>
          <option value="3" {{if eq "3" .condArr.type}}selected{{end}}>年假</option>
          <option value="4" {{if eq "4" .condArr.type}}selected{{end}}>调休</option>
          <option value="5" {{if eq "5" .condArr.type}}selected{{end}}>婚假</option>
          <option value="6" {{if eq "6" .condArr.type}}selected{{end}}>产假</option>
          <option value="7" {{if eq "7" .condArr.type}}selected{{end}}>陪产假</option>
          <option value="8" {{if eq "8" .condArr.type}}selected{{end}}>路途假</option>
          <option value="9" {{if eq "9" .condArr.type}}selected{{end}}>其他</option>
        </select>
        <button type="submit" class="btn btn-primary">搜索</button>
      </form>
      <!--search end-->
      {{template "inc/user-info.tpl" .}} </div>
    <!-- header section end-->
    <!-- page heading start-->
    <div class="page-heading">
      <h3> 审批管理 {{template "inc/checkwork-nav.tpl" .}}</h3>
      <ul class="breadcrumb pull-left">
        <li> <a href="/user/show/{{.LoginUserid}}">OPMS</a> </li>
        <li> <a href="/leave/manage">审批管理</a> </li>
        <li class="active"> 请假 </li>
      </ul>
      <div class="pull-right"> <a href="/leave/manage" class="btn btn-default hidden-xs">全部</a> <a href="/leave/approval" class="btn btn-warning" style="padding:4px;">待审批</a> <a href="/leave/add" class="btn btn-success">+我要请假</a> </div>
    </div>
    <!-- page heading end-->
    <!--body wrapper start-->
    <div class="wrapper">
      <div class="row">
        <div class="col-sm-12">
          <section class="panel">
            <header class="panel-heading"> 请假 / 总数：{{.countLeave}}<span class="tools pull-right"><a href="javascript:;" class="fa fa-chevron-down"></a> </span> </header>
            <div class="panel-body">
              <table class="table table-hover general-table">
                <thead>
                  <tr>
                    <th> 类型</th>
                    <th class="hidden-phone hidden-xs">请假日期</th>
                    <th>天数</th>
                    <th>状态</th>
                    <th>结果</th>
                    <th>进度</th>
                    <th>操作</th>
                  </tr>
                </thead>
                <tbody>
                
                {{range $k,$v := .leaves}}
                <tr>
                  <td> {{getLeaveType $v.Type}} </td>
                  <td class="hidden-phone hidden-xs">{{getDate $v.Started}}至{{getDate $v.Ended}}</td>
                  <td>{{$v.Days}}天 </td>
                  <td> {{if eq $v.Status 1}} <span class="label label-warning label-mini">草稿</span> {{else if eq $v.Status 2}} <span class="label label-success label-mini">正常</span> {{end}} </td>
                  <td> {{if eq $v.Result 1}} <span class="label label-success label-mini">同意</span> {{else if eq $v.Result 2}} <span class="label label-danger label-mini">拒绝</span>{{else}}<span class="label label-warning label-mini">等待中</span> {{end}} </td>
                  <td><div class="js-selectuserbox"> {{str2html (getLeaveProcess $v.Id)}} </div></td>
                  <td> {{if eq $v.Status 1}}
                    <div class="btn-group">
                      <button type="button" class="btn btn-primary dropdown-toggle" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false"> 操作<span class="caret"></span> </button>
                      <ul class="dropdown-menu">
                        <li><a href="/leave/edit/{{$v.Id}}">编辑</a></li>
                        <li role="separator" class="divider"></li>
                        <li><a href="javascript:;" class="js-leave-delete" data-op="delete" data-id="{{$v.Id}}">删除</a></li>
                        {{if eq $v.Status 1}}
                        <li role="separator" class="divider"></li>
                        <li><a href="javascript:;" class="js-leave-status" data-op="status" data-id="{{$v.Id}}">正常</a></li>
                        {{end}}
                      </ul>
                    </div>
                    {{else}} <a href="/leave/approval/{{$v.Id}}"> 查看 </a> {{end}} </td>
                </tr>
                {{else}}
                <tr>
                  <td colspan="7">你还没有申请过请假单</td>
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
