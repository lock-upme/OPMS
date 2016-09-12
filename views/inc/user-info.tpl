<!--notification menu start -->
<div class="menu-right">
  <ul class="notification-menu">
    <li> <a href="javascript:;" class="btn btn-default dropdown-toggle" data-toggle="dropdown"> <img src="{{getAvatar .LoginAvatar}}" alt="{{.LoginUsername}}" /> {{.LoginUsername}} <span class="caret"></span> </a>
      <ul class="dropdown-menu dropdown-menu-usermenu pull-right">
        <li><a href="/user/show/{{.LoginUserid}}"><i class="fa fa-user"></i> 个人主页</a></li>
        <li><a href="/user/profile"><i class="fa fa-cog"></i> 基本资料</a></li>
		<li><a href="/user/avatar"><i class="fa fa-camera"></i> 更换头像</a></li>
		<li><a href="/user/password"><i class="fa fa-cog"></i> 更换密码</a></li>
		<li><a href="/my/task"><i class="fa fa-th-list"></i> 我的任务</a></li>		
        <li><a href="/logout"><i class="fa fa-sign-out"></i> 退出</a></li>
      </ul>
    </li>
  </ul>
</div>
<!--notification menu end -->
