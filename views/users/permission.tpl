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
      <!--search end-->
      {{template "inc/user-info.tpl" .}} </div>
    <!-- header section end-->
    <!-- page heading start-->
    <div class="page-heading">
      <h3> 用户管理 </h3>
      <ul class="breadcrumb pull-left">
        <li> <a href="/user/show/{{.LoginUserid}}">OPMS</a> </li>
        <li> <a href="/user/manage">用户管理</a> </li>
        <li class="active"> 权限 </li>
      </ul>
    </div>
    <!-- page heading end-->
    <!--body wrapper start-->
    <div class="wrapper">
      <div class="row">
        <div class="col-sm-12">
          <section class="panel">
            <header class="panel-heading"> 权限设置 <span class="tools pull-right"><a href="javascript:;" class="fa fa-chevron-down"></a>
              <!--a href="javascript:;" class="fa fa-times"></a-->
              </span> </header>
            <div class="panel-body">
              <section id="unseen">
                <form id="permission-form">
                  <ul class="list-unstyled">
                    <li>
                      <div class="form-group"> 用户：
                        <label class="checkbox-inline">
                        <input type="checkbox" name="permission[]" value="user-manage">
                        用户列表 </label>
                        <label class="checkbox-inline">
                        <input type="checkbox" name="permission[]" value="user-add">
                        添加用户 </label>
                        <label class="checkbox-inline">
                        <input type="checkbox" name="permission[]" value="user-edit">
                        编辑用户 </label>
                      </div>
                    </li>
					<li>
                      <div class="form-group"> 权限：                       
                        <label class="checkbox-inline">
                        <input type="checkbox" name="permission[]" value="user-permission">
                        权限设置 </label>
                      </div>
                    </li>
                    <li>
                      <div class="form-group"> 部门：
                        <label class="checkbox-inline">
                        <input type="checkbox" name="permission[]" value="department-manage">
                        部门列表 </label>
                        <label class="checkbox-inline">
                        <input type="checkbox" name="permission[]" value="department-add">
                        添加部门 </label>
                        <label class="checkbox-inline">
                        <input type="checkbox" name="permission[]" value="department-edit">
                        编辑部门 </label>
                      </div>
                    </li>
                    <li>
                      <div class="form-group"> 职称：
                        <label class="checkbox-inline">
                        <input type="checkbox" name="permission[]" value="position-manage">
                        职称列表 </label>
                        <label class="checkbox-inline">
                        <input type="checkbox" name="permission[]" value="position-add">
                        添加职称 </label>
                        <label class="checkbox-inline">
                        <input type="checkbox" name="permission[]" value="position-edit">
                        编辑职称 </label>
                      </div>
                    </li>
					<li>
                      <div class="form-group"> 公告：
                        <label class="checkbox-inline">
                        <input type="checkbox" name="permission[]" value="notice-manage">
                        公告列表 </label>
                        <label class="checkbox-inline">
                        <input type="checkbox" name="permission[]" value="notice-add">
                        添加公告 </label>
                        <label class="checkbox-inline">
                        <input type="checkbox" name="permission[]" value="notice-edit">
                        编辑公告 </label>
                      </div>
                    </li>
                    <li>
                      <div class="form-group"> 项目：
                        <label class="checkbox-inline">
                        <input type="checkbox" name="permission[]" value="project-manage">
                        项目列表 </label>
                        <label class="checkbox-inline">
                        <input type="checkbox" name="permission[]" value="project-add">
                        添加项目 </label>
                        <label class="checkbox-inline">
                        <input type="checkbox" name="permission[]" value="project-edit">
                        编辑项目 </label>
                      </div>
                    </li>
                    <li>
                      <div class="form-group"> 团队：
                        <label class="checkbox-inline">
                        <input type="checkbox" name="permission[]" value="project-team">
                        团队列表 </label>
                        <label class="checkbox-inline">
                        <input type="checkbox" name="permission[]" value="team-add">
                        添加团队 </label>
                        <label class="checkbox-inline">
                        <input type="checkbox" name="permission[]" value="team-delete">
                        删除团队 </label>
                      </div>
                    </li>
                    <li>
                      <div class="form-group"> 需求：
                        <label class="checkbox-inline">
                        <input type="checkbox" name="permission[]" value="project-need">
                        需求列表 </label>
                        <label class="checkbox-inline">
                        <input type="checkbox" name="permission[]" value="need-add">
                        添加需求 </label>
                        <label class="checkbox-inline">
                        <input type="checkbox" name="permission[]" value="need-edit">
                        编辑需求 </label>
                      </div>
                    </li>
                    <li>
                      <div class="form-group"> 任务：
                        <label class="checkbox-inline">
                        <input type="checkbox" name="permission[]" value="project-task">
                        任务列表 </label>
                        <label class="checkbox-inline">
                        <input type="checkbox" name="permission[]" value="task-add">
                        添加任务 </label>
                        <label class="checkbox-inline">
                        <input type="checkbox" name="permission[]" value="task-edit">
                        编辑任务 </label>
                      </div>
                    </li>
                    <li>
                      <div class="form-group"> Bug：
                        <label class="checkbox-inline">
                        <input type="checkbox" name="permission[]" value="project-test">
                        Bug列表 </label>
                        <label class="checkbox-inline">
                        <input type="checkbox" name="permission[]" value="test-add">
                        提Bug </label>
                        <label class="checkbox-inline">
                        <input type="checkbox" name="permission[]" value="test-edit">
                        编辑Bug </label>
                      </div>
                    </li>
                    <li>
                      <div class="form-group"> 知识：
                        <label class="checkbox-inline">
                        <input type="checkbox" name="permission[]" value="knowledge-manage">
                        知识列表 </label>
                        <label class="checkbox-inline">
                        <input type="checkbox" name="permission[]" value="knowledge-add">
                        分享知识 </label>
                        <label class="checkbox-inline">
                        <input type="checkbox" name="permission[]" value="knowledge-edit">
                        编辑知识 </label>
                      </div>
                    </li>
                    <li>
                      <div class="form-group"> 相册：
                        <label class="checkbox-inline">
                        <input type="checkbox" name="permission[]" value="album-manage">
                        相册列表 </label>
                        <label class="checkbox-inline">
                        <input type="checkbox" name="permission[]" value="album-upload">
                        上传相片 </label>
                        <label class="checkbox-inline">
                        <input type="checkbox" name="permission[]" value="album-edit">
                        编辑相片 </label>
                      </div>
                    </li>
                    <li>
                      <div class="form-group"> 简历：
                        <label class="checkbox-inline">
                        <input type="checkbox" name="permission[]" value="resume-manage">
                        简历列表 </label>
                        <label class="checkbox-inline">
                        <input type="checkbox" name="permission[]" value="resume-add">
                        添加简历 </label>
                        <label class="checkbox-inline">
                        <input type="checkbox" name="permission[]" value="resume-edit">
                        编辑简历 </label>
                      </div>
                    </li>
					<li>
                      <div class="form-group"> 公告：
                        <label class="checkbox-inline">
                        <input type="checkbox" name="permission[]" value="notice-manage">
                        公告列表 </label>
                        <label class="checkbox-inline">
                        <input type="checkbox" name="permission[]" value="notice-add">
                        添加公告 </label>
                        <label class="checkbox-inline">
                        <input type="checkbox" name="permission[]" value="notice-edit">
                        编辑公告 </label>
                      </div>
                    </li>
                    <li>
                      <input type="hidden" id="userid" value="{{.userid}}">
                      <input type="hidden" id="permission" value="{{.permission}}">
                      <button type="button" id="permission-btn" class="btn btn-success">权限设置</button>
                    </li>
                  </ul>
                </form>
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
<script>
$(function(){
	var per = $('#permission').val();
	var val = '';
	$('input[name="permission[]"]').each(function(){
		val =  $(this).val();
		console.log(val)
		if (per.indexOf(val) > -1) {
			$(this).attr('checked', true)
		}
	});
})
</script>
</body>
</html>
