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

      {{template "inc/user-info.tpl" .}} </div>
    <!-- header section end-->
    <!-- page heading start-->
    <div class="page-heading">
      <h3> 项目管理 </h3>
      <ul class="breadcrumb pull-left">
        <li> <a href="/user/show/{{.LoginUserid}}">OPMS</a> </li>
        <li> <a href="/project/task/{{.project.Id}}">{{substr .project.Name 0 8}}</a> </li>
        <li class="active"> 任务 </li>
      </ul>
      <div class="pull-right">
				<a href="/project/task/{{.project.Id}}" class="btn btn-default">全部</a>

	<a href="/project/task/{{.project.Id}}?filter=accept" class="hidden-xs btn btn-default" style="padding:6px;">指派给我</a>
			<a href="/project/task/{{.project.Id}}?filter=create" class="hidden-xs btn btn-default" style="padding:6px;">由我创建</a>
			<a href="/project/task/{{.project.Id}}?filter=complete" class="hidden-xs btn btn-default" style="padding:6px;">由我解决</a>	
			<a href="/project/task/{{.project.Id}}?filter=close" class="hidden-xs btn btn-default" style="padding:6px;">由我关闭</a>	
			<a href="/project/task/{{.project.Id}}?filter=cancel" class="hidden-xs btn btn-default" style="padding:6px;">由我取消</a>			

	
	<a href="/task/add/{{.project.Id}}" class="btn btn-success">+新任务</a>
	<a href="/project/taskbatch/{{.project.Id}}" class="btn btn-warning">+批量新任务</a>
	
	</div>
    </div>
    <!-- page heading end-->
    <!--body wrapper start-->
    <div class="wrapper">
      <div class="row">
        <div class="col-sm-12">
          <section class="panel">
            <header class="panel-heading"> 批量添加任务<span class="tools pull-right"><a href="javascript:;" class="fa fa-chevron-down"></a>
              <!--a href="javascript:;" class="fa fa-times"></a-->
              </span> </header>
            <div class="panel-body">
              <section id="unseen">
                <form id="taskbatch-form" method="Post">
                  <table class="table table-bordered table-striped table-condensed">
                    <thead>
                      <tr>
						<th style="width:14%;">相关需求</th>
                        <th>任务名称</th>
                        <th style="width:100px;">类型</th>
                        <th style="width:100px;">指派给</th>
                        <th style="width:70px;">预工时</th>
                        <th style="width:25%;">描述</th>
                        <th style="width:66px;">级别</th>
                      </tr>
                    </thead>
                    <tbody>
                    
                   
                    <tr class="js-clone">
					  <td><select name="needsid[]" class="form-control">
                      <option value="">相关需求</option>
					{{range .needs}}
					<option value="{{.Id}}">{{.Name}}</option>
                    {{end}}					
					</select>
					</td>
                      <td><input name="name[]" type="text" class="form-control"></td>
                      <td><select name="type[]" class="form-control">
                      <option value="">任务类型</option>
                      <option value="1">设计</option>
                      <option value="2">开发</option>
                      <option value="3">测试</option>
                      <option value="4">研究</option>
                      <option value="5">讨论</option>
                      <option value="6">界面</option>
                      <option value="7">事务</option>
                      <option value="8">其他</option>
                    </select></td>
                      <td><select name="acceptid[]" class="form-control">
              <option value="">指派给</option>
              
				{{range .teams}}
					
              <option value="{{.Userid}}">{{getRealname .Userid}}</option>
              
					{{end}}
				
            </select></td>
                      <td><input name="tasktime[]" type="number" class="form-control"></td>
                      <td><input name="desc[]" type="text" class="form-control"></td>
                      <td><select name="level[]" class="form-control">
                      <option value="">级别</option>
                      <option value="1">1级</option>
                      <option value="2">2级</option>
                      <option value="3" selected>3级</option>
                      <option value="4">4级</option>
                    </select></td>
                    </tr>
                   
                    </tbody>
                    
                  </table>
				<div class="form-group">
                  <div class="text-center">
                    <input type="hidden" name="projectid" id="projectid" value="{{.project.Id}}">
                    <button type="submit" class="btn btn-success">提交保存</button>
                  </div>
                </div>
                </form>
				 </section>
            </div>
          </section>
        </div>
      </div>
    </div>    
    <!--footer section start-->
    {{template "inc/foot-info.tpl" .}}
    <!--footer section end-->
  </div>
  <!-- main content end-->
</section>
{{template "inc/foot.tpl" .}}
<script>
$(function(){
	var that = $('.js-clone')
	for(var i=0;i<9;i++) {
		$('.js-clone:eq(0)').clone().insertAfter(that)
	}
	
		
})
</script>
</body>
</html>
