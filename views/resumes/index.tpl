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
      <form class="searchform" action="/resume/list" method="get">
        <select name="status" class="form-control">
          <option value="">状态</option>
          <option value="1" {{if eq "1" .condArr.status}}selected{{end}}>入档</option>
          <option value="2" {{if eq "2" .condArr.status}}selected{{end}}>通知面试</option>
		<option value="3" {{if eq "3" .condArr.status}}selected{{end}}>违约</option>
		<option value="4" {{if eq "4" .condArr.status}}selected{{end}}>录用</option>
		<option value="5" {{if eq "5" .condArr.status}}selected{{end}}>不录用</option>
        </select>
        <input type="text" class="form-control" name="keywords" placeholder="请输入姓名" value="{{.condArr.keywords}}"/>
        <button type="submit" class="btn btn-primary">搜索</button>
      </form>
      <!--search end-->
      {{template "inc/user-info.tpl" .}} </div>
    <!-- header section end-->
    <!-- page heading start-->
    <div class="page-heading">
      <h3> 简历管理 </h3>
      <ul class="breadcrumb pull-left">
        <li> <a href="/user/show/{{.LoginUserid}}">OPMS</a> </li>
        <li> <a href="/resume/list">简历管理</a> </li>
        <li class="active"> 简历 </li>
      </ul>
      <div class="pull-right"><a href="/resume/add" class="btn btn-success">添加新简历</a></div>
    </div>
    <!-- page heading end-->
    <!--body wrapper start-->
    <div class="wrapper">
      <div class="row">
        <div class="col-sm-12">
          <section class="panel">
            <header class="panel-heading"> 简历管理 / 总数：{{.countResume}}<span class="tools pull-right"><a href="javascript:;" class="fa fa-chevron-down"></a>
              <!--a href="javascript:;" class="fa fa-times"></a-->
              </span> </header>
            <div class="panel-body">
              <section id="unseen">
                <form id="resume-form-list">
                  <table class="table table-bordered table-striped table-condensed">
                    <thead>
                      <tr>
                        <th>姓名</th>
                        <th>性别</th>
						<th>手机</th>
						<th>生日</th>
						<th>学历</th>
						<th>经验</th>
						<th>简历</th>
                        <th>状态</th>
                        <th>操作</th>
                      </tr>
                    </thead>
                    <tbody>
                    
                    {{range $k,$v := .resumes}}
                    <tr>
                      <td>{{$v.Realname}}</td>
					  <td>{{if eq 1 $v.Sex}}男{{else}}女{{end}}</td>
                      <td>{{$v.Phone}}</td>
					<td>{{getDate $v.Birth}}</td>
					<td>{{getEdu $v.Edu}}</td>
					<td>{{getWorkYear $v.Work}}</td>
					<td><a href="{{$v.Attachment}}" target="_blank">查看预览</a></td>
                      <td>{{getResumeStatus $v.Status}}</td>
                      <td><div class="btn-group">
                          <button type="button" class="btn btn-primary dropdown-toggle" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false"> 操作<span class="caret"></span> </button>
                          <ul class="dropdown-menu">
                            <li><a href="/resume/edit/{{$v.Id}}">编辑</a></li>                           
                            {{if eq 1 $v.Status}}
							 <li role="separator" class="divider"></li>
                            <li><a href="javascript:;" class="js-resumes-single" data-id="{{$v.Id}}" data-status="2">通知面试</a></li>
                            {{else if eq 2 $v.Status}}
							 <li role="separator" class="divider"></li>
                            <li><a href="javascript:;" class="js-resumes-single" data-id="{{$v.Id}}" data-status="3">违约</a></li>
							<li><a href="javascript:;" class="js-resumes-single" data-id="{{$v.Id}}" data-status="4">录用</a></li>                           
							<li><a href="javascript:;" class="js-resumes-single" data-id="{{$v.Id}}" data-status="5">不录用</a></li>                            
                            {{end}}
                          </ul>
                        </div></td>
                    </tr>
                    {{end}}
                    </tbody>
                    
                  </table>
                </form>
                {{template "inc/page.tpl" .}}
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
