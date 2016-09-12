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
      <a class="toggle-btn"><i class="fa fa-bars"></i></a> {{template "inc/user-info.tpl" .}} </div>
    <!-- header section end-->
    <!-- page heading start-->    
    <!-- page heading end-->
    <!--body wrapper start-->
    <div class="wrapper">
      <div class="row">
        <div class="col-lg-12">
          <section class="panel">
             <header class="panel-heading"> 基本资料 </header>
            <div class="panel-body">
              <form class="form-horizontal adminex-form" id="userprofile-form">
                <div class="form-group">
                  <label class="col-sm-2 col-sm-2 control-label">姓名</label>
                  <div class="col-sm-10">
                    <input type="text" name="realname"  value="{{.pro.Realname}}" class="form-control" placeholder="请填写姓名">
                  </div>
                </div>
                <div class="form-group">
                  <label class="col-sm-2 col-sm-2 control-label">性别</label>
                  <div class="col-sm-10">
                    <label class="radio-inline">
                    <input type="radio" name="sex" value="1" {{if eq 1 .pro.Sex}}checked{{end}}>
                    男 </label>
                    <label class="radio-inline">
                    <input type="radio" name="sex" value="2" {{if eq 2 .pro.Sex}}checked{{end}}>
                    女 </label>
                  </div>
                </div>
                <div class="form-group">
                  <label class="col-sm-2 col-sm-2 control-label">生日</label>
                  <div class="col-sm-10">
                    <input type="text" name="birth" id="default-date-picker"  value="{{.pro.Birth}}" class="form-control" placeholder="请填写昵称">
                  </div>
                </div>
                <div class="form-group">
                  <label class="col-sm-2 col-sm-2 control-label">公司邮箱</label>
                  <div class="col-sm-10">
                    <input type="email" name="email"  value="{{.pro.Email}}" class="form-control" placeholder="cto@milu365.com">
                  </div>
                </div>
                <div class="form-group">
                  <label class="col-sm-2 col-sm-2 control-label">微信号</label>
                  <div class="col-sm-10">
                    <input type="text" name="webchat"  value="{{.pro.Webchat}}" class="form-control" placeholder="微信号">
                  </div>
                </div>
                <div class="form-group">
                  <label class="col-sm-2 col-sm-2 control-label">QQ</label>
                  <div class="col-sm-10">
                    <input type="number" name="qq"  value="{{.pro.Qq}}" class="form-control" placeholder="QQ号">
                  </div>
                </div>
                <div class="form-group">
                  <label class="col-sm-2 col-sm-2 control-label">手机号</label>
                  <div class="col-sm-10">
                    <input type="number" name="phone" maxlength="11" value="{{.pro.Phone}}" class="form-control" placeholder="手机号">
                  </div>
                </div>
                <div class="form-group">
                  <label class="col-sm-2 col-sm-2 control-label">电话</label>
                  <div class="col-sm-10">
                    <input type="text" name="tel"  value="{{.pro.Tel}}" class="form-control" placeholder="联系电话">
                  </div>
                </div>
                <div class="form-group">
                  <label class="col-sm-2 col-sm-2 control-label">住址</label>
                  <div class="col-sm-10">
                    <input type="text" name="address"  value="{{.pro.Address}}" class="form-control" placeholder="详情住址">
                  </div>
                </div>
                <div class="form-group">
                  <label class="col-sm-2 col-sm-2 control-label">紧急联系人</label>
                  <div class="col-sm-10">
                    <input type="text" name="emercontact"  value="{{.pro.Emercontact}}" class="form-control" placeholder="紧急联系人">
                  </div>
                </div>
                <div class="form-group">
                  <label class="col-sm-2 col-sm-2 control-label">紧急联系人电话</label>
                  <div class="col-sm-10">
                    <input type="text" name="emerphone"  value="{{.pro.Emerphone}}" class="form-control" placeholder="紧急联系人电话">
                  </div>
                </div>
                <div class="form-group">
                  <label class="col-lg-2 col-sm-2 control-label"></label>
                  <div class="col-lg-10">
                    <input type="hidden" name="id" value="{{.pro.Id}}">
                    <button type="submit" class="btn btn-primary">提 交</button>
                  </div>
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
<script src="/static/js/jquery-ui-1.10.3.min.js"></script>
<script src="/static/js/datepicker-zh-CN.js"></script>
<script>
$(function(){
	$('#default-date-picker').datepicker('option', $.datepicker.regional['zh-CN']); 	
	$('#default-date-picker').datepicker({
        dateFormat: 'yy-mm-dd',
		changeMonth: true,
		changeYear: true,
		yearRange:'-60:+0'
    });
})
</script>
</body>
</html>
