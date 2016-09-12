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
      <form class="searchform" action="/project/need/{{.project.Id}}" method="get">
        <select name="status" class="form-control">
          <option value="">状态</option>
          <option value="1" {{if eq "1" .condArr.status}}selected{{end}}>草稿</option>
          <option value="2" {{if eq "2" .condArr.status}}selected{{end}}>激活</option>
          <option value="3" {{if eq "3" .condArr.status}}selected{{end}}>已变更</option>
          <option value="4" {{if eq "4" .condArr.status}}selected{{end}}>待关闭</option>
          <option value="5" {{if eq "5" .condArr.status}}selected{{end}}>已关闭</option>
        </select>
        <select name="stage" class="form-control">
          <option value="">阶段</option>
          <option value="1" {{if eq "1" .condArr.stage}}selected{{end}}>未开始</option>
          <option value="2" {{if eq "2" .condArr.stage}}selected{{end}}>已计划</option>
          <option value="3" {{if eq "3" .condArr.stage}}selected{{end}}>已立项</option>
          <option value="4" {{if eq "4" .condArr.stage}}selected{{end}}>研发中</option>
          <option value="5" {{if eq "5" .condArr.stage}}selected{{end}}>研发完毕</option>
          <option value="6" {{if eq "6" .condArr.stage}}selected{{end}}>测试中</option>
          <option value="7" {{if eq "7" .condArr.stage}}selected{{end}}>测试完毕</option>
          <option value="8" {{if eq "8" .condArr.stage}}selected{{end}}>已验收</option>
          <option value="9" {{if eq "9" .condArr.stage}}selected{{end}}>已发布</option>
        </select>
        <select name="acceptid" class="form-control">
          <option value="">指派给</option>
		  {{range .teams}}
		  <option value="{{.Userid}}" {{if eq .Userid $.acceptid}}selected{{end}}>{{getRealname .Userid}}</option>
		  {{end}}                    
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
        <li class="active"> 需求 </li>
      </ul>
      <div class="pull-right"><a href="/need/add/{{.project.Id}}" class="btn btn-success">+新需求</a></div>
    </div>
    <!-- page heading end-->
    <!--body wrapper start-->
    <div class="wrapper">
      <div class="row">
        <div class="col-sm-12">
          <section class="panel">
            <header class="panel-heading"> 需求 / 总数：{{.countNeeds}}<span class="tools pull-right"><a href="javascript:;" class="fa fa-chevron-down"></a>
              <!--a href="javascript:;" class="fa fa-times"></a-->
              </span> </header>
            <div class="panel-body">
              <section id="unseen">
                <form id="project-form-list">
                  <table class="table table-bordered table-striped table-condensed">
                    <thead>
                      <tr>
                        <th>名称</th>
                        <th>创建人</th>
                        <th>指派人</th>
                        <th>等级</th>
                        <th>预工时</th>
                        <th>创建日期</th>
                        <th>状态</th>
                        <th>阶段</th>
                        <th>操作</th>
                      </tr>
                    </thead>
                    <tbody>
                    
                    {{range $k,$v := .needs}}
                    <tr>
                      <td><a href="/need/show/{{$v.Id}}">{{$v.Name}}</a></td>
                      <td><a href="/user/show/{{$v.Userid}}">{{getRealname $v.Userid}}</a></td>
                      <td><a href="/user/show/{{$v.Acceptid}}">{{getRealname $v.Acceptid}}</a></td>
                      <td>{{$v.Level}}级</td>
                      <td>{{$v.Tasktime}}</td>
                      <td>{{getDate $v.Created}}</td>
                      <td>{{getNeedsStatus $v.Status}}</td>
                      <td>{{getNeedsStage $v.Stage}}</td>
                      <td><a href="/task/add/{{$v.Projectid}}?needsid={{$v.Id}}">任务</a> <a href="/need/edit/{{$v.Id}}">编辑</a> </td>
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
