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
      <form class="searchform" action="/knowledge/list" method="get">
        <!--select name="status" class="form-control">
          <option value="">状态</option>
          <option value="1" {{if eq "1" .condArr.status}}selected{{end}}>正常</option>
		  <option value="2" {{if eq "2" .condArr.status}}selected{{end}}>屏蔽</option>
        </select-->
        <input type="text" class="form-control" name="keywords" placeholder="请输入标题、标签" value="{{.condArr.keywords}}"/>
        <button type="submit" class="btn btn-primary">搜索</button>
      </form>
      <!--search end-->
      {{template "inc/user-info.tpl" .}} </div>
    <!-- header section end-->
    <!-- page heading start-->
    <div class="page-heading">
      <h3> 知识分享 </h3>
      <ul class="breadcrumb pull-left">
        <li> <a href="/user/show/{{.LoginUserid}}">OPMS</a> </li>
        <li> <a href="/knowledge/list">知识分享</a> </li>
        <li class="active"> 知识 </li>
      </ul>
      <div class="pull-right"><a href="/knowledge/list?filter=me" class="btn btn-default">我的知识</a> <a href="/knowledge/list" class="btn btn-success">全部知识</a> <a href="/knowledge/add" class="btn btn-success">+分享知识</a> </div>
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
                <header class="panel-heading"> 精彩分享 <span class="tools pull-right"> <a class="fa fa-chevron-down" href="javascript:;"></a> </span> </header>
                <div class="panel-body">
                  <ul class="activity-list">
                    {{range $k,$v := .knowledges}}
                    <li>
                      <div class="avatar"> <img src="{{getAvatarUserid $v.Userid}}" alt=""> </div>
                      <div class="activity-desk">
                        <h5><a href="/user/show/{{$v.Userid}}">{{getRealname $v.Userid}}</a> <span><a href="/knowledge/{{$v.Id}}" style="color:#2a323f">{{$v.Title}}</a></span></h5>
                        <p class="text-muted">{{$v.Summary}}</p>
                        <p class="pull-right text-muted">
						{{if eq $.LoginUserid $v.Userid}}
						{{if eq $.condArr.filter "me"}}
		                  <a href="/knowledge/edit/{{$v.Id}}">修改</a> 
              			{{end}}
						{{end}}						
						<i class="fa fa-eye"></i> {{$v.Viewnum}}&nbsp;&nbsp;&nbsp;<i class="fa fa-heart"></i> {{$v.Laudnum}}&nbsp;&nbsp;&nbsp;<i class="fa fa-envelope-o"></i> {{$v.Comtnum}}&nbsp;&nbsp;&nbsp;{{getDateMH $v.Created}}</p>
                      </div>
                    </li>
					{{else}}
					<h2>我要当第一个发知识分享的达人。<br/><a href="/knowledge/add">+分享知识</a></h2>
                    {{end}}
                  </ul>
				{{template "inc/page.tpl" .}}
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
                  <div class="title">分享分类</div>
                </li>
                <li>
                  <div class="title"><a href="/knowledge/list">全部</a></div>
                </li>
                {{range .sorts}}
                <li>
                  <div class="title"><a href="/knowledge/list?sortid={{.Id}}">{{.Name}}</a></div>
                </li>
                {{end}}
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
