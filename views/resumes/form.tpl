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
    <div class="page-heading">
      <h3> 简历管理 </h3>
      <ul class="breadcrumb pull-left">
        <li> <a href="/user/show/{{.LoginUserid}}">OPMS</a> </li>
        <li> <a href="/resume/list">简历管理</a> </li>
        <li class="active"> 简历 </li>
      </ul>
    </div>
    <!-- page heading end-->
    <!--body wrapper start-->
    <div class="wrapper">
      <div class="row">
        <div class="col-lg-12">
          <section class="panel">
            <header class="panel-heading"> {{.title}} </header>
            <div class="panel-body">
              <form class="form-horizontal adminex-form" id="resume-form">
                <div class="form-group">
                  <label class="col-sm-2 col-sm-2 control-label">姓名</label>
                  <div class="col-sm-10">
                    <input type="text" name="realname" value="{{.resume.Realname}}" class="form-control" placeholder="请输入姓名">
                  </div>
                </div>
                <div class="form-group">
                  <label class="col-sm-2 col-sm-2 control-label">手机</label>
                  <div class="col-sm-10">
                    <input type="text" name="phone" value="{{.resume.Phone}}" class="form-control" placeholder="请输入手机号">
                  </div>
                </div>
                <div class="form-group">
                  <label class="col-sm-2 col-sm-2 control-label">性别</label>
                  <div class="col-sm-10">
                    <label class="radio-inline">
                    <input type="radio" name="sex" value="1" {{if eq 1 .resume.Sex}}checked{{end}}>
                    男 </label>
                    <label class="radio-inline">
                    <input type="radio" name="sex" value="2" {{if eq 2 .resume.Sex}}checked{{end}}>
                    女 </label>
                  </div>
                </div>
                <div class="form-group">
                  <label class="col-sm-2 col-sm-2 control-label">生日</label>
                  <div class="col-sm-10">
                    <input type="text" name="birth" id="default-date-picker"  value="{{getDate .resume.Birth}}" class="form-control" placeholder="出生日期">
                  </div>
                </div>
                <div class="form-group">
                  <label class="col-sm-2 col-sm-2 control-label">学历</label>
                  <div class="col-sm-10">
                    <select name="edu" class="form-control">
                      <option value="">请选择学历</option>
                      <option value="1" {{if eq 1 .resume.Edu}}selected{{end}}>小学</option>
                      <option value="2" {{if eq 2 .resume.Edu}}selected{{end}}>中专</option>
                      <option value="3" {{if eq 3 .resume.Edu}}selected{{end}}>初中</option>
                      <option value="4" {{if eq 4 .resume.Edu}}selected{{end}}>高中</option>
                      <option value="5" {{if eq 5 .resume.Edu}}selected{{end}}>技校</option>
                      <option value="6" {{if eq 6 .resume.Edu}}selected{{end}}>大专</option>
                      <option value="7" {{if eq 7 .resume.Edu}}selected{{end}}>本科</option>
                      <option value="8" {{if eq 8 .resume.Edu}}selected{{end}}>硕士</option>
                      <option value="9" {{if eq 9 .resume.Edu}}selected{{end}}>博士</option>
                      <option value="10" {{if eq 10 .resume.Edu}}selected{{end}}>博士后</option>
                    </select>
                  </div>
                </div>
                <div class="form-group">
                  <label class="col-sm-2 col-sm-2 control-label">工作年限</label>
                  <div class="col-sm-10">
                    <select name="work" class="form-control">
                      <option value="">请选择工作年限</option>
                      <option value="1" {{if eq 1 .resume.Work}}selected{{end}}>应届毕业生</option>
                      <option value="2" {{if eq 2 .resume.Work}}selected{{end}}>1年以下</option>
                      <option value="3" {{if eq 3 .resume.Work}}selected{{end}}>1-2年</option>
                      <option value="4" {{if eq 4 .resume.Work}}selected{{end}}>3-5年</option>
                      <option value="5" {{if eq 5 .resume.Work}}selected{{end}}>6-7年</option>
                      <option value="6" {{if eq 6 .resume.Work}}selected{{end}}>8-10年</option>
                      <option value="7" {{if eq 7 .resume.Work}}selected{{end}}>10年以上</option>
                    </select>
                  </div>
                </div>
                <div class="form-group">
                  <label class="col-sm-2 col-sm-2 control-label">备注</label>
                  <div class="col-sm-10">
                    <textarea name="note" placeholder="备注说明" style="height:300px;" class="form-control">{{.resume.Note}}</textarea>
                  </div>
                </div>
                <div class="form-group">
                  <label class="col-sm-2 col-sm-2 control-label">简历附件</label>
                  <div class="col-sm-10">
                    <input type="file" name="attachment">
                    {{if ne .resume.Attachment ""}}<br/>
                    <a href="{{.resume.Attachment}}" target="_blank">预览下载</a> {{end}} </div>
                </div>
                <div class="form-group">
                  <label class="col-sm-2 col-sm-2 control-label">状态</label>
                  <div class="col-sm-10">
                    <label class="radio-inline">
                    <input type="radio" name="status" value="1" {{if eq 1 .resume.Status}}checked{{end}}>
                    入档 </label>
                    <label class="radio-inline">
                    <input type="radio" name="status" value="2" {{if eq 2 .resume.Status}}checked{{end}}>
                    通知面试 </label>
                    <label class="radio-inline">
                    <input type="radio" name="status" value="3" {{if eq 3 .resume.Status}}checked{{end}}>
                    违约 </label>
                    <label class="radio-inline">
                    <input type="radio" name="status" value="4" {{if eq 4 .resume.Status}}checked{{end}}>
                    录用 </label>
                    <label class="radio-inline">
                    <input type="radio" name="status" value="5" {{if eq 5 .resume.Status}}checked{{end}}>
                    不录用 </label>
                  </div>
                </div>
                <div class="form-group">
                  <label class="col-lg-2 col-sm-2 control-label"></label>
                  <div class="col-lg-10">
                    <input type="hidden" name="id" id="resumeid" value="{{.resume.Id}}">
                    <button type="submit" class="btn btn-primary">提交保存</button>
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
<script src="/static/keditor/kindeditor-min.js"></script>
<script>
$(function(){
	var editor = KindEditor.create('textarea[name="note"]', {
	    uploadJson: "/kindeditor/upload",
	    allowFileManager: true,
	    filterMode : false,
	    afterBlur: function(){this.sync();}
	});

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
