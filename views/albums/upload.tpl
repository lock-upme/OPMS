<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<title>{{config "String" "globaltitle" ""}}</title>
{{template "inc/meta.tpl" .}}
<link href="/static/js/bootstrap-fileinput-master/css/fileinput.min.css" media="all" rel="stylesheet" type="text/css" />
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
          <header class="panel-heading"> 上传相片 <div class="pull-right"><a href="/album/manage" class="btn btn-success">欣赏相片</a></div></header>
          <div class="panel-body">
            <form method="post" action="/uploadmulti" enctype="multipart/form-data" id="uploadMulti-form">
              <div class="wrapper text-center">
                <h2>请选择图片</h2>
                <input id="albumUpload" name="uploadFiles" type="file" multiple class="file-loading" accept="image/*" data-allowed-file-extensions='["jpg", "jpeg", "png", "gif"]'>
              </div>
            </form>
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
<script src="/static/js/bootstrap-fileinput-master/js/plugins/canvas-to-blob.min.js" type="text/javascript"></script>
<script src="/static/js/bootstrap-fileinput-master/js/plugins/sortable.min.js" type="text/javascript"></script>
<script src="/static/js/bootstrap-fileinput-master/js/plugins/purify.min.js" type="text/javascript"></script>
<script src="/static/js/bootstrap-fileinput-master/js/fileinput.min.js"></script>
<script src="/static/js/bootstrap-fileinput-master/themes/fa/fa.js"></script>
<script src="/static/js/bootstrap-fileinput-master/js/locales/zh.js"></script>
<script>
$(function(){	
	$("#albumUpload").fileinput({ language: 'zh', showCaption: false});	
});
</script>
</body>
</html>
