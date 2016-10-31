<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="utf-8">
<title>{{config "String" "globaltitle" ""}}</title>
{{template "inc/meta.tpl" .}}
<link href="/static/css/table-responsive.css" rel="stylesheet">
<style>
.border { border-bottom: 1px solid #ddd;margin-bottom:20px;}
</style>
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
                    <li data-pmodel="项目管理-project-book||project-manage" class="border">
                      <h4>项目管理</h4>
                      <ul class="list-unstyled">
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
                      </ul>
                    </li>
					<li data-pmodel="考勤管理-checkwork-tasks||checkwork-list" class="border">
                      <h4>考勤管理</h4>
                      <ul class="list-unstyled">
                        <li>
                          <div class="form-group">
                            <label class="checkbox-inline">
                            <input type="checkbox" name="permission[]" value="checkwork-manage">
                             我的考勤</label>
                            <label class="checkbox-inline">
                            <input type="checkbox" name="permission[]" value="checkwork-all">
                            全部员工考勤 </label>						
                          </div>
                        </li>
						
						<li>
                          <div class="form-group">
                            <label class="checkbox-inline">
                            <input type="checkbox" name="permission[]" value="message-manage">
                            消息列表 </label>
							<label class="checkbox-inline">
                            <input type="checkbox" name="permission[]" value="message-delete">
                            删除消息 </label>
                          </div>
							
                        </li>
                      </ul>
                    </li>
                    <li data-pmodel="审批管理-approval-suitcase||#" class="border">
                      <h4>审批管理</h4>
                      <ul class="list-unstyled">
                        <li>
                          <div class="form-group" data-cmodel="请假-approval||leave-manage"> 请假：
                            <label class="checkbox-inline">
                            <input type="checkbox" name="permission[]" value="leave-manage">
                            请假列表 </label>
                            <label class="checkbox-inline">
                            <input type="checkbox" name="permission[]" value="leave-add">
                            申请请假 </label>
                            <label class="checkbox-inline">
                            <input type="checkbox" name="permission[]" value="leave-edit">
                            编辑请假 </label>
                            <label class="checkbox-inline">
                            <input type="checkbox" name="permission[]" value="leave-view">
                            请假查看 </label>
                            <label class="checkbox-inline">
                            <input type="checkbox" name="permission[]" value="leave-approval">
                            审批 </label>
                          </div>
                        </li>
						<li>
                          <div class="form-group" data-cmodel="加班-approval||overtime-manage"> 加班：
                            <label class="checkbox-inline">
                            <input type="checkbox" name="permission[]" value="overtime-manage">
                            加班列表 </label>
                            <label class="checkbox-inline">
                            <input type="checkbox" name="permission[]" value="overtime-add">
                            申请加班 </label>
                            <label class="checkbox-inline">
                            <input type="checkbox" name="permission[]" value="overtime-edit">
                            编辑加班申请 </label>
                            <label class="checkbox-inline">
                            <input type="checkbox" name="permission[]" value="overtime-view">
                            加班申请查看 </label>
                            <label class="checkbox-inline">
                            <input type="checkbox" name="permission[]" value="overtime-approval">
                            审批 </label>
                          </div>
                        </li>
                        <li>
                          <div class="form-group" data-cmodel="报销-approval||expense-manage"> 报销：
                            <label class="checkbox-inline">
                            <input type="checkbox" name="permission[]" value="expense-manage">
                            报销列表 </label>
                            <label class="checkbox-inline">
                            <input type="checkbox" name="permission[]" value="expense-add">
                            申请报销 </label>
                            <label class="checkbox-inline">
                            <input type="checkbox" name="permission[]" value="expense-edit">
                            编辑报销 </label>
                            <label class="checkbox-inline">
                            <input type="checkbox" name="permission[]" value="expense-view">
                            报销查看 </label>
                            <label class="checkbox-inline">
                            <input type="checkbox" name="permission[]" value="expense-approval">
                            审批 </label>
                          </div>
                        </li>
                        <li>
                          <div class="form-group" data-cmodel="出差-approval||businesstrip-manage"> 出差：
                            <label class="checkbox-inline">
                            <input type="checkbox" name="permission[]" value="businesstrip-manage">
                            出差列表 </label>
                            <label class="checkbox-inline">
                            <input type="checkbox" name="permission[]" value="businesstrip-add">
                            申请出差 </label>
                            <label class="checkbox-inline">
                            <input type="checkbox" name="permission[]" value="businesstrip-edit">
                            编辑出差 </label>
                            <label class="checkbox-inline">
                            <input type="checkbox" name="permission[]" value="businesstrip-view">
                            出差查看 </label>
                            <label class="checkbox-inline">
                            <input type="checkbox" name="permission[]" value="businesstrip-approval">
                            审批 </label>
                          </div>
                        </li>
                        <li>
                          <div class="form-group" data-cmodel="外出-approval||goout-manage"> 外出：
                            <label class="checkbox-inline">
                            <input type="checkbox" name="permission[]" value="goout-manage">
                            外出列表 </label>
                            <label class="checkbox-inline">
                            <input type="checkbox" name="permission[]" value="goout-add">
                            申请外出 </label>
                            <label class="checkbox-inline">
                            <input type="checkbox" name="permission[]" value="goout-edit">
                            编辑外出 </label>
                            <label class="checkbox-inline">
                            <input type="checkbox" name="permission[]" value="goout-view">
                            外出查看 </label>
                            <label class="checkbox-inline">
                            <input type="checkbox" name="permission[]" value="goout-approval">
                            审批 </label>
                          </div>
                        </li>
						<li>
                          <div class="form-group" data-cmodel="物品-approval||oagood-manage"> 物品：
                            <label class="checkbox-inline">
                            <input type="checkbox" name="permission[]" value="oagood-manage">
                            物品领用列表 </label>
                            <label class="checkbox-inline">
                            <input type="checkbox" name="permission[]" value="oagood-add">
                            申请物品领用 </label>
                            <label class="checkbox-inline">
                            <input type="checkbox" name="permission[]" value="oagood-edit">
                            编辑物品领用 </label>
                            <label class="checkbox-inline">
                            <input type="checkbox" name="permission[]" value="oagood-view">
                            物品领用查看 </label>
                            <label class="checkbox-inline">
                            <input type="checkbox" name="permission[]" value="oagood-approval">
                            审批 </label>
                          </div>
                        </li>						
                      </ul>
                    </li>
                    <li data-pmodel="知识分享-knowledge-tasks||knowledge-list" class="border">
                      <h4>知识分享</h4>
                      <ul class="list-unstyled">
                        <li>
                          <div class="form-group">
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
                      </ul>
                    </li>
                    <li data-pmodel="员工相册-album-plane||album-list" class="border">
                      <h4>员工相册</h4>
                      <ul class="list-unstyled">
                        <li>
                          <div class="form-group">
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
                      </ul>
                    </li>
                    <li data-pmodel="简历管理-resume-laptop||resume-list" class="border">
                      <h4>简历管理</h4>
                      <ul class="list-unstyled">
                        <li>
                          <div class="form-group">
                            <label class="checkbox-inline">
                            <input type="checkbox" name="permission[]" value="resume-manage">
                            简历列表 </label>
                            <label class="checkbox-inline">
                            <input type="checkbox" name="permission[]" value="resume-add">
                            添加简历 </label>
                            <label class="checkbox-inline">
                            <input type="checkbox" name="permission[]" value="resume-edit">
                            编辑简历 </label>
							<label class="checkbox-inline">
                            <input type="checkbox" name="permission[]" value="resume-delete">
                            删除简历 </label>
                          </div>
                        </li>
                      </ul>
                    </li>
                    <li data-pmodel="员工管理-user-user||#" class="border">
                      <h4>员工管理</h4>
                      <ul class="list-unstyled">
                        <li>
                          <div class="form-group" data-cmodel="员工-user||user-manage"> 员工：
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
                          <div class="form-group" data-cmodel="部门-user||department-manage"> 部门：
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
                          <div class="form-group" data-cmodel="职称-user||position-manage"> 职称：
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
                          <div class="form-group" data-cmodel="公告-user||notice-manage"> 公告：
                            <label class="checkbox-inline">
                            <input type="checkbox" name="permission[]" value="notice-manage">
                            公告列表 </label>
                            <label class="checkbox-inline">
                            <input type="checkbox" name="permission[]" value="notice-add">
                            添加公告 </label>
                            <label class="checkbox-inline">
                            <input type="checkbox" name="permission[]" value="notice-edit">
                            编辑公告 </label>
							<label class="checkbox-inline">
                            <input type="checkbox" name="permission[]" value="notice-delete">
                            删除公告 </label>
                          </div>
                        </li>
                      </ul>
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
		//console.log(val)
		if (per.indexOf(val) > -1) {
			$(this).attr('checked', true)
		}
	});
})
</script>
</body>
</html>
