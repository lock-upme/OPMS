<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="utf-8">
<title>{{config "String" "globaltitle" ""}}</title>
{{template "inc/meta.tpl" .}}
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
    <div class="page-heading">
      <h3> 精彩相片 </h3>
      <ul class="breadcrumb pull-left">
        <li> <a href="/user/show/{{.LoginUserid}}">OPMS</a> </li>
        <li> <a href="/album/manage">全部相片</a> </li>
        <li class="active"> 相片 </li>
      </ul>
    </div>
    <div class="clearfix"></div>
    <!-- page heading end-->
    <!--body wrapper start-->
    <div class="wrapper">
      <div class="row">
        <div class="row">
          <div class="col-md-12">
            <div class="panel">
              <div class="panel-body">
                <div class="profile-desk">
                  <h1>{{.album.Title}}</h1>
                  <span class="designation">{{.album.Summary}}-by @<a href="/user/show/{{.album.Userid}}">{{getRealname .album.Userid}}</a></span>
                  <p> <img class="img-responsive" src="{{.album.Picture}}"> </p>
                  <a class="btn p-follow-btn js-album-laud" href="javascript:;" data-id="{{.album.Id}}"> <i class="fa fa-heart"></i> {{.album.Laudnum}}</a>&nbsp; <a class="btn p-follow-btn" href="#commenta"> <i class="fa fa-envelope-o"></i> {{.album.Comtnum}}</a>&nbsp; <a class="btn p-follow-btn" href="javascript:;"> <i class="fa fa-eye"></i> {{.album.Viewnum}}</a>
                  <ul class="p-social-link pull-right bdsharebuttonbox">
                    <li><a href="#" class="bds_qzone" data-cmd="qzone" title="分享到QQ空间"></a></li>
                    <li><a href="#" class="bds_tsina" data-cmd="tsina" title="分享到新浪微博"></a></li>
                    <li><a href="#" class="bds_weixin" data-cmd="weixin" title="分享到微信"></a></li>
                  </ul>
                </div>
              </div>
            </div>
          </div>
        </div>
        <div class="row">
          <div class="col-md-12">
            <div class="panel">
              <header class="panel-heading"> 精彩点评 <span class="tools pull-right"> <a class="fa fa-chevron-down" href="javascript:;"></a> </span> </header>
              <div class="panel-body">
                <ul class="activity-list">
                  {{range $k,$v := .comments}}
                  <li>
                    <div class="avatar"> <a href="/user/show/{{$v.Userid}}"><img src="{{getAvatarUserid $v.Userid}}"></a> </div>
                    <div class="activity-desk">
                      <h5><a href="/user/show/{{$v.Userid}}">{{getRealname $v.Userid}}</a> <span>{{$v.Content}}</span></h5>
                      <p class="text-muted">{{getDateMH $v.Created}}</p>
                    </div>
                  </li>
                  {{end}}
                </ul>
                <form class="form-horizontal" id="album-comment-form" action="/album/comment/add">
                  <a name="commenta"></a>
                  <div class="form-group">
                    <div class="col-sm-12">
                      <textarea name="comment" rows="6" class="form-control" placeholder="精彩评论不断……"></textarea>
                      <br/>
                      <input type="hidden" name="albumid" value="{{.album.Id}}">
                      <button type="submit" class="btn btn-primary pull-right">我来点评</button>
                    </div>
                  </div>
                </form>
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
<script>window._bd_share_config={"common":{"bdSnsKey":{},"bdText":"","bdMini":"2","bdMiniList":false,"bdPic":"","bdStyle":"0","bdSize":"32"},"share":{}};with(document)0[(getElementsByTagName('head')[0]||body).appendChild(createElement('script')).src='http://bdimg.share.baidu.com/static/api/js/share.js?v=89860593.js?cdnversion='+~(-new Date()/36e5)];</script>
</body>
</html>
