<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="utf-8">
<title>{{config "String" "globaltitle" ""}}</title>
<link href="/static/css/clndr.css" rel="stylesheet">
<link href="/static/css/table-responsive.css" rel="stylesheet">
{{template "inc/meta.tpl" .}}
</head>
</head>
<body class="sticky-header">
<section> {{template "inc/left.tpl" .}}
  <!-- main content start-->
  <div class="main-content" >
    <!-- header section start-->
    <div class="header-section"> <a class="toggle-btn"><i class="fa fa-bars"></i></a> {{template "inc/user-info.tpl" .}} </div>
    <!-- header section end-->
    <!-- page heading start-->
    <!--<div class="page-heading">-->
    <!--Page Tittle goes here-->
    <!--</div>-->
    <!-- page heading end-->
    <!--body wrapper start-->
    <div class="wrapper">
      <div class="row">
        <div class="col-md-4">
          <div class="row">
            <div class="col-md-12">
              <div class="panel">
                <div class="panel-body">
                  <div class="profile-pic text-center"> <img alt="{{getRealname .user.Id}}" src="{{getAvatarUserid .user.Id}}"> </div>
                </div>
              </div>
            </div>
            <div class="col-md-12">
              <div class="panel">
                <div class="panel-body">
                  <ul class="p-info">
                    <li>
                      <div class="title">姓名</div>
                      <div class="desk">{{.pro.Realname}}</div>
                    </li>
                    <li>
                      <div class="title">性别</div>
                      <div class="desk">{{if eq .pro.Sex 1}}男{{else}}女{{end}}</div>
                    </li>
                    <li>
                      <div class="title">生日</div>
                      <div class="desk">{{.pro.Birth}}</div>
                    </li>
                    <li>
                      <div class="title">电话</div>
                      <div class="desk">{{.pro.Phone}}</div>
                    </li>
                    <li>
                      <div class="title">部门</div>
                      <div class="desk">{{.departName}}</div>
                    </li>
                    <li>
                      <div class="title">职称</div>
                      <div class="desk">{{.positionName}}</div>
                    </li>
                  </ul>
                </div>
              </div>
            </div>
            <div class="col-md-12">
              <div class="panel">
                <div class="panel-body p-states">
                  <h4 class="title">公告</h4>
                  <ul class="dropdown-list normal-list">
                    {{range $k,$v := .notices}}
                    <li class="new"> <a href="#noticeModal" data-toggle="modal" data-content="{{$v.Content}}"> <span class="label label-danger"><i class="fa fa-bolt"></i></span> <span class="name">{{$v.Title}} </span> <em class="small">{{getDateMH $v.Created}}</em> </a> </li>
                    {{end}}
                    <!--li class="new"><a href="">See All Notifications</a></li-->
                  </ul>
                </div>
              </div>
            </div>
			  <!--div class="col-md-12">
              <div class="panel">
                <div class="panel-body p-states">
                  <div class="summary pull-left">
                    <h4>Total <span>Earning</span></h4>
                    <span>Monthly Summary</span>
                    <h3>$ 51,2600</h3>
                  </div>
                  <div id="expense2" class="chart-bar"></div>
                </div>
              </div>
            </div-->
            <div class="col-md-12">
              <div class="panel">
                <div class="panel-body">
                  <div class="calendar-block ">
                    <div class="cal1"> </div>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>
        <div class="col-md-8">
          <div class="row">
            <div class="col-md-12">
              <div class="panel">
                <div class="panel-body">
                  <div class="profile-desk">
                    <h1>项目<a class="pull-right" style="font-size:16px;" href="/my/project">更多</a></h1>
                    <table class="table table-bordered table-striped table-condensed cf">
                      <thead class="cf">
                        <tr>
                          <th>项目名称</th>
                          <th>结束日期</th>
                          <th class="numeric">状态</th>
                          <th class="numeric">项目负责人</th>
                        </tr>
                      </thead>
                      <tbody>
                      
                      {{range $k,$v := .projects}}
                      <tr>
                        <td><a href="/project/{{$v.Id}}">{{$v.Name}}</a></td>
                        <td>{{getDate $v.Ended}}</td>
                        <td>{{if eq 1 $v.Status}}挂起{{else if eq 2 $v.Status}}延期{{else if eq 3 $v.Status}}进行{{else if eq 4 $v.Status}}结束{{end}}</td>
                        <td><a href="/user/show/{{$v.Projuserid}}">{{getRealname $v.Projuserid}}</a></td>
                      </tr>
                      {{end}}
                      </tbody>
                      
                    </table>
                  </div>
                </div>
              </div>
            </div>
          </div>
          <div class="row">
            <div class="col-md-12">
              <div class="panel">
                <div class="panel-body">
                  <div class="profile-desk">
                    <h1>任务<a class="pull-right" style="font-size:16px;" href="/my/task">更多</a></h1>
                    <table class="table table-bordered table-striped table-condensed cf">
                      <thead class="cf">
                        <tr>
                          <th>任务名称</th>
                          <th>结束日期</th>
                          <th class="numeric">状态</th>
                          <th class="numeric">预计工时</th>
                        </tr>
                      </thead>
                      <tbody>
                      
                      {{range $k,$v := .tasks}}
                      <tr>
                        <td><a href="/task/show/{{$v.Id}}">{{$v.Name}}</a></td>
                        <td>{{getDate $v.Ended}}</td>
                        <td>{{getTaskStatus $v.Status}}</td>
                        <td>{{$v.Tasktime}}</td>
                      </tr>
                      {{end}}
                      </tbody>
                      
                    </table>
                  </div>
                </div>
              </div>
            </div>
          </div>
          <div class="row">
            <div class="col-md-12">
              <div class="panel">
                <div class="panel-body">
                  <div class="profile-desk">
                    <h1>Bug<a class="pull-right" style="font-size:16px;" href="/my/test">更多</a></h1>
                    <table class="table table-bordered table-striped table-condensed cf">
                      <thead class="cf">
                        <tr>
                          <th>Bug标题</th>
                          <th>创建日期</th>
                          <th class="numeric">状态</th>
                          <th>创建人</th>
                        </tr>
                      </thead>
                      <tbody>
                        <tr> {{range $k,$v := .tests}}
                          <td><a href="/test/show/{{$v.Id}}">{{$v.Name}}</a></td>
                          <td>{{getDate $v.Created}}</td>
                          <td>{{getTestStatus $v.Status}}</td>
                          <td><a href="/user/show/{{$v.Userid}}">{{getRealname $v.Userid}}</a></td>
                        </tr>
                      {{end}}
                      </tbody>
                      
                    </table>
                  </div>
                </div>
              </div>
            </div>
          </div>
          <!--div class="row">
            <div class="col-md-12">
              <div class="panel">
                <form>
                  <textarea class="form-control input-lg p-text-area" rows="2" placeholder="Whats in your mind today?"></textarea>
                </form>
                <footer class="panel-footer">
                  <button class="btn btn-post pull-right">Post</button>
                  <ul class="nav nav-pills p-option">
                    <li> <a href="#"><i class="fa fa-user"></i></a> </li>
                    <li> <a href="#"><i class="fa fa-camera"></i></a> </li>
                    <li> <a href="#"><i class="fa fa-location-arrow"></i></a> </li>
                    <li> <a href="#"><i class="fa fa-meh-o"></i></a> </li>
                  </ul>
                </footer>
              </div>
            </div>
          </div-->
          <div class="row">
            <div class="col-md-12">
              <div class="panel">
                <header class="panel-heading"> 知识 <span class="pull-right"> <a href="/knowledge/list?filter=me">更多</a></span> </header>
                <div class="panel-body">
                  <ul class="activity-list">
                    {{range $k,$v := .knowledges}}
                    <li>
                      <div class="avatar"> <img src="{{getAvatarUserid $v.Userid}}" alt="{{getRealname $v.Userid}}"> </div>
                      <div class="activity-desk">
                        <h5><a href="/user/show/{{$v.Userid}}">{{getRealname $v.Userid}}</a> <span><a href="/knowledge/{{$v.Id}}" style="color:#2a323f">{{$v.Title}}</a></span></h5>
                        <p class="text-muted">{{$v.Summary}}</p>
                        <p class="pull-right text-muted"><i class="fa fa-eye"></i> {{$v.Viewnum}}&nbsp;&nbsp;&nbsp;<i class="fa fa-heart"></i> {{$v.Laudnum}}&nbsp;&nbsp;&nbsp;<i class="fa fa-envelope-o"></i> {{$v.Comtnum}}&nbsp;&nbsp;&nbsp;{{getDateMH $v.Created}}</p>
                      </div>
                    </li>
                    {{end}}
                  </ul>
                </div>
              </div>
            </div>
          </div>
          <div class="row">
            <div class="col-md-12">
              <div class="panel">
                <header class="panel-heading"> 相册 <span class="pull-right"> <a href="/album/list?filter=me">更多</a></span> </header>
                <div class="panel-body"> {{range $k,$v := .albums}}
                  <div class="col-sm-6 col-md-4">
                    <div class="thumbnail"> <a href="/album/{{$v.Id}}"><img alt="{{$v.Title}}" class="img-responsive" src="{{$v.Picture}}" style="width:100%;height:200px;"></a>
                      <div class="caption">
                        <h3><a href="/album/{{$v.Id}}">{{$v.Title}}</a></h3>
                        <p>{{substr $v.Summary 0 20}}</p>
                      </div>
                    </div>
                  </div>
                  {{end}} </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
    <!--body wrapper end-->
    <!--footer section start-->
	{{template "inc/notice-dialog.tpl" .}}
    {{template "inc/foot-info.tpl" .}}	
    <!--footer section end-->
  </div>
  <!-- main content end-->
</section>
{{template "inc/foot.tpl" .}}
<script src="/static/js/calendar/clndr.js"></script>
<script src="/static/js/calendar/evnt.calendar.init.js"></script>
<script src="/static/js/calendar/moment-2.2.1.js"></script>
<script src="/static/js/underscore-min.js"></script>
<script>
$(function(){
	$('#noticeModal').on('show.bs.modal', function (e) {
		$('#notice-box').html($(e.relatedTarget).attr('data-content'))
	});	
})
</script>
</body>
</html>
