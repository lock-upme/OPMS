<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="utf-8">
<title>{{config "String" "globaltitle" ""}}</title>
{{template "inc/meta.tpl" .}}
<style>
.form-signin .help-block{color:#a94442;}
</style>
</head><body class="login-body">
<div class="container">
  <form class="form-signin" id="login-form">
    <div class="form-signin-heading text-center">
      <h1 class="sign-title">登录OPMS</h1>
      <img src="/static/img/logo.png" alt="OPMS" style="width:120px;"/> </div>
    <div class="login-wrap">
      <input type="text" value="libai" class="form-control" name="username" placeholder="请填写用户名,默认:libai" autofocus>
      <input type="password" value="123456" class="form-control" name="password" placeholder="请填写密码,默认:123456">
      <p>用户名和密码：libai,123456。请勿修改</p>
      <button class="btn btn-lg btn-login btn-block" type="submit"> 登录</button>
    </div>
  </form>
</div>
{{template "inc/foot.tpl" .}}
</body>
</html>
