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
      <form class="searchform" action="/knowledge/manage" method="get">
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
        <li> <a href="/knowledge/manage">知识分享</a> </li>
        <li class="active"> 知识 </li>
      </ul>
      <div class="pull-right"><a href="/knowledge/manage?filter=me" class="btn btn-warning">我的知识</a> <a href="/knowledge/manage" class="btn btn-success">全部知识</a> <a href="/knowledge/add" class="btn btn-success">+分享知识</a> </div>
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
                      <div class="avatar"> <a href="/user/show/{{$v.Userid}}"><img src="{{getAvatarUserid $v.Userid}}"></a> </div>
                      <div class="activity-desk">
                        <h5><a href="/user/show/{{$v.Userid}}">{{getRealname $v.Userid}}</a> <span><a href="/knowledge/{{$v.Id}}" style="color:#2a323f">{{$v.Title}}</a></span></h5>
                        <p class="text-muted">{{$v.Summary}}</p>
                        <p class="pull-right text-muted"> {{if eq $.LoginUserid $v.Userid}}
                          {{if eq $.condArr.filter "me"}} <a href="/knowledge/edit/{{$v.Id}}" title="修改"><i class="fa fa-edit"></i></a> <a href="javascript:;" class="js-knowledage-delete" data-id="{{$v.Id}}" title="删除"><i class="fa fa-trash-o"></i></a> {{end}}
                          {{end}} <i class="fa fa-eye"></i> {{$v.Viewnum}}&nbsp;&nbsp;&nbsp;<i class="fa fa-heart"></i> {{$v.Laudnum}}&nbsp;&nbsp;&nbsp;<i class="fa fa-envelope-o"></i> {{$v.Comtnum}}&nbsp;&nbsp;&nbsp;{{getDateMH $v.Created}}</p>
                      </div>
                    </li>
                    {{else}}
                    <h2>我要当第一个发知识分享的达人。<br/>
                      <a href="/knowledge/add">+分享知识</a></h2>
                    {{end}}
                  </ul>
                  {{template "inc/page.tpl" .}} </div>
              </div>
            </div>
          </div>
        </div>
        <div class="col-md-4">
          <div class="panel">
            <div class="panel-body">
              <div class="blog-post">
                <h3>分类</h3>
                <ul>
                  {{range .sorts}}
                  <li> <a href="/knowledge/manage?sortid={{.Id}}">{{.Name}}</a> </li>
                  {{end}}
                </ul>
              </div>
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
