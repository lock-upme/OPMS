<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<title>{{config "String" "globaltitle" ""}}</title>
{{template "inc/meta.tpl" .}}
<link href="/static/css/table-responsive.css" rel="stylesheet">
<link href="/static/js/lightbox/css/lightbox.min.css" media="all" rel="stylesheet" type="text/css" />
</head><body class="sticky-header">
{{template "inc/left.tpl" .}}
<!-- main content start-->
<div class="main-content" >
  <!-- header section start-->
  <div class="header-section">
    <!--toggle button start-->
    <a class="toggle-btn"><i class="fa fa-bars"></i></a> {{template "inc/user-info.tpl" .}} </div>
  <!-- header section end-->
  <!-- page heading start-->
  <!-- page heading end-->
  <!--body wrapper start-->
  <div class="wrapper">
    <div class="row">
      <div class="col-lg-12">
        <section class="panel">
          <header class="panel-heading"> 精彩相片
            <div class="pull-right"><a href="/album/manage?filter=me" class="btn btn-warning">我的相片</a>&nbsp;<a href="/album/manage" class="btn btn-success">全部相片</a>&nbsp;<a href="/album/upload" class="btn btn-success">+上传相片</a></div>
          </header>
          <div class="panel-body"> 
		<div id="gallery" class="media-gal">
		{{range $k,$v := .albums}}
		
		
		
                                <div class="images item " >
                                    <a href="{{$v.Picture}}" data-lightbox="example-set" data-title="{{$v.Summary}}">
                                        <img src="{{$v.Picture}}" alt="{{$v.Title}}" />
                                    </a>
                                    <p><a href="/album/{{$v.Id}}">{{substr $v.Title 0 10}}</a> </p>
									<p>{{substr $v.Summary 0 16}}</p>
									<p>{{getRealname $v.Userid}}{{getDate $v.Created}}上传</p>
									{{if eq $.LoginUserid $v.Userid}}
				{{if eq $.condArr.filter "me"}}
                  <p>
				<a href="javascript:;"title="编辑" class="js-album-edit" data-id="{{$v.Id}}" data-title="{{$v.Title}}" data-summary="{{$v.Summary}}" data-status="{{$v.Status}}"><i class="fa fa-edit"></i></a> 
				
				<a href="javascript:;" class="js-album-delete" data-id="{{$v.Id}}" title="删除"><i class="fa fa-trash-o"></i></a>
				<!--a href="javascript:;" class="btn btn-default">{{if $v.Status}}正常{{else}}屏蔽{{end}}</a--></p>
              {{end}}
			  {{end}}
                                </div>

		
            
			
			
			
			{{else}}
			<h2 class="text-center">我的还有上传过相片,现在就<a href="/album/upload">上传相片</a></h2>
            {{end}}
			</div>
			<div class="clearfix"></div>
			{{template "inc/page.tpl" .}}		
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
{{template "inc/foot.tpl" .}}
<script src="/static/js/lightbox/js/lightbox.min.js" type="text/javascript"></script>
</body>
</html>
