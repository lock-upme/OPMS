package users

import (
	"fmt"
	"image"
	"image/jpeg"

	"opms/controllers"
	. "opms/models/albums"
	. "opms/models/knowledges"
	. "opms/models/projects"
	. "opms/models/users"
	"opms/utils"
	"os"
	"strconv"
	"strings"
	"time"

	"github.com/astaxie/beego"
	"github.com/astaxie/beego/utils/pagination"
	"github.com/oliamb/cutter"
)

//主页
type MainController struct {
	controllers.BaseController
}

func (this *MainController) Get() {
	this.TplName = "index.tpl"
}

//登录
type LoginUserController struct {
	controllers.BaseController
}

func (this *LoginUserController) Get() {
	check := this.BaseController.IsLogin
	if check {
		this.Abort("401")
	} else {
		this.TplName = "users/login.tpl"
	}
}

func (this *LoginUserController) Post() {
	username := this.GetString("username")
	password := this.GetString("password")

	if "" == username {
		this.Data["json"] = map[string]interface{}{"code": 0, "message": "请填写用户名"}
		this.ServeJSON()
	}

	if "" == password {
		this.Data["json"] = map[string]interface{}{"code": 0, "message": "请填写密码"}
		this.ServeJSON()
	}
	err, users := LoginUser(username, password)

	if err == nil {
		this.SetSession("userLogin", fmt.Sprintf("%d", users.Id)+"||"+users.Username+"||"+users.Avatar)
		this.SetSession("userPermission", GetPermissions(users.Id))
		this.Data["json"] = map[string]interface{}{"code": 1, "message": "贺喜你，登录成功"}
	} else {
		this.Data["json"] = map[string]interface{}{"code": 0, "message": "登录失败"}
	}
	this.ServeJSON()
}

//退出
type LogoutUserController struct {
	controllers.BaseController
}

func (this *LogoutUserController) Get() {
	this.DelSession("userLogin")
	//this.Ctx.WriteString("you have logout")
	this.Redirect("/login", 302)

}

//用户管理
type ManageUserController struct {
	controllers.BaseController
}

func (this *ManageUserController) Get() {
	//权限检测
	if !strings.Contains(this.GetSession("userPermission").(string), "user-manage") {
		this.Abort("401")
	}

	page, err := this.GetInt("p")
	status := this.GetString("status")
	keywords := this.GetString("keywords")
	if err != nil {
		page = 1
	}

	offset, err1 := beego.AppConfig.Int("pageoffset")
	if err1 != nil {
		offset = 15
	}

	condArr := make(map[string]string)
	condArr["status"] = status
	condArr["keywords"] = keywords

	countUser := CountUser(condArr)

	paginator := pagination.SetPaginator(this.Ctx, offset, countUser)
	_, _, user := ListUser(condArr, page, offset)

	this.Data["paginator"] = paginator
	this.Data["condArr"] = condArr
	this.Data["user"] = user
	this.Data["countUser"] = countUser

	this.TplName = "users/user-index.tpl"
}

//用户主页
type ShowUserController struct {
	controllers.BaseController
}

func (this *ShowUserController) Get() {
	idstr := this.Ctx.Input.Param(":id")
	id, _ := strconv.Atoi(idstr)
	userId := int64(id)
	pro, _ := GetProfile(userId)
	if pro.Realname == "" {
		this.Abort("404")
	}
	this.Data["pro"] = pro
	user, _ := GetUser(userId)
	this.Data["user"] = user

	this.Data["departName"] = GetDepartsName(pro.Departid)
	this.Data["positionName"] = GetPositionsName(pro.Positionid)

	//我的项目
	_, _, projects := ListMyProject(userId, 1, 10)
	this.Data["projects"] = projects

	//我的任务
	condArr := make(map[string]string)
	condArr["acceptid"] = idstr
	_, _, tasks := ListProjectTask(condArr, 1, 10)
	this.Data["tasks"] = tasks

	//我的bug
	_, _, tests := ListProjectTest(condArr, 1, 10)
	this.Data["tests"] = tests

	//知识分享
	if this.BaseController.UserUserId != userId {
		condArr["userid"] = idstr
	}
	_, _, knowledges := ListKnowledge(condArr, 1, 10)
	this.Data["knowledges"] = knowledges

	//相片
	if this.BaseController.UserUserId != userId {
		condArr["userid"] = idstr
	}
	_, _, albums := ListAlbum(condArr, 1, 6)
	this.Data["albums"] = albums

	//公告
	//知识分享
	condArr["status"] = "1"
	_, _, notices := ListNotices(condArr, 1, 10)
	this.Data["notices"] = notices

	this.TplName = "users/profile.tpl"
}

//头像更换
type AvatarUserController struct {
	controllers.BaseController
}

func (this *AvatarUserController) Get() {
	this.TplName = "users/avatar.tpl"
}

func (this *AvatarUserController) Post() {
	dataX, _ := this.GetInt("dataX")
	dataY, _ := this.GetInt("dataY")
	dataWidth, _ := this.GetInt("dataWidth")
	dataHeight, _ := this.GetInt("dataHeight")

	var filepath string
	f, h, err := this.GetFile("file")
	if err == nil {
		defer f.Close()
		now := time.Now()
		dir := "./static/uploadfile/" + strconv.Itoa(now.Year()) + "-" + strconv.Itoa(int(now.Month())) + "/" + strconv.Itoa(now.Day())
		err1 := os.MkdirAll(dir, 0755)
		if err1 != nil {
			this.Data["json"] = map[string]interface{}{"code": 1, "message": "目录权限不够"}
			this.ServeJSON()
			return
		}
		//生成新的文件名
		filename := h.Filename
		ext := utils.SubString(filename, strings.LastIndex(filename, "."), 5)
		filename = utils.GetGuid() + ext

		if err != nil {
			this.Data["json"] = map[string]interface{}{"code": 0, "message": err}
			this.ServeJSON()
			return
		} else {
			this.SaveToFile("file", dir+"/"+filename)
			filepath = strings.Replace(dir, ".", "", 1) + "/" + filename
		}

		//utils.DoImageHandler(filepath, 200)
	} else {
		filepath = this.GetString("avatar")
	}

	dst, _ := utils.LoadImage("." + filepath)
	croppedImg, err := cutter.Crop(dst, cutter.Config{
		Width:  dataWidth,
		Height: dataHeight,
		Anchor: image.Point{dataX, dataY},
		Mode:   cutter.TopLeft, // optional, default value
	})
	filen := strings.Replace(filepath, ".", "-cropper.", -1)
	file, err := os.Create("." + filen)
	defer file.Close()

	err = jpeg.Encode(file, croppedImg, &jpeg.Options{100})
	if err == nil {
		ChangeUserAvatar(this.BaseController.UserUserId, filen)
		this.SetSession("userLogin", fmt.Sprintf("%d", int64(this.BaseController.UserUserId))+"||"+this.BaseController.UserUsername+"||"+filen)
	}
	this.Data["json"] = map[string]interface{}{"code": 1, "message": "个性头像设置成功"}
	this.ServeJSON()
}

//用户状态更改异步操作
type AjaxStatusUserController struct {
	controllers.BaseController
}

func (this *AjaxStatusUserController) Post() {
	//权限检测
	if !strings.Contains(this.GetSession("userPermission").(string), "user-edit") {
		this.Data["json"] = map[string]interface{}{"code": 0, "message": "无权设置"}
		this.ServeJSON()
		return
	}
	id, _ := this.GetInt64("id")
	if id <= 0 {
		this.Data["json"] = map[string]interface{}{"code": 0, "message": "请选择用户"}
		this.ServeJSON()
		return
	}
	status, _ := this.GetInt("status")
	if status <= 0 || status >= 3 {
		this.Data["json"] = map[string]interface{}{"code": 0, "message": "请选择操作状态"}
		this.ServeJSON()
		return
	}

	err := ChangeUserStatus(id, status)

	if err == nil {
		this.Data["json"] = map[string]interface{}{"code": 1, "message": "用户状态更改成功"}
	} else {
		this.Data["json"] = map[string]interface{}{"code": 0, "message": "用户状态更改失败"}
	}
	this.ServeJSON()
}

type AjaxSearchUserController struct {
	controllers.BaseController
}

func (this *AjaxSearchUserController) Get() {
	username := this.GetString("term")
	if "" == username {
		this.Data["json"] = map[string]interface{}{"code": 0, "message": "请填写用户名"}
		this.ServeJSON()
		return
	}
	condArr := make(map[string]string)
	condArr["keywords"] = username
	_, _, users := ListUser(condArr, 1, 20)
	/*
		a := make([]map[string]string, 2)
		for i := 0; i < 2; i++ {
			a[i] = map[string]string{"id": "1", "investor": "2"}
		}
	*/
	newArr := make([]map[string]string, len(users))
	for b, _ := range users {
		newArr[b] = map[string]string{"value": fmt.Sprintf("%d", users[b].Id), "label": users[b].Profile.Realname}
	}
	this.Data["json"] = newArr
	this.ServeJSON()
}

//添加用户信息
type AddUserController struct {
	controllers.BaseController
}

func (this *AddUserController) Get() {
	//权限检测
	if !strings.Contains(this.GetSession("userPermission").(string), "user-add") {
		this.Abort("401")
	}
	condArr := make(map[string]string)
	condArr["status"] = "1"

	_, _, departs := ListDeparts(condArr, 1, 9)
	this.Data["departs"] = departs

	_, _, positions := ListPositions(condArr, 1, 9)
	this.Data["positions"] = positions

	var pro UsersProfile
	pro.Sex = 1
	this.Data["pro"] = pro
	this.TplName = "users/user-form.tpl"
}

func (this *AddUserController) Post() {
	//权限检测
	if !strings.Contains(this.GetSession("userPermission").(string), "user-add") {
		this.Data["json"] = map[string]interface{}{"code": 0, "message": "无权设置"}
		this.ServeJSON()
		return
	}

	username := this.GetString("username")
	if "" == username {
		this.Data["json"] = map[string]interface{}{"code": 0, "message": "请填写用户名"}
		this.ServeJSON()
		return
	}

	departid, _ := this.GetInt64("depart")
	if departid <= 0 {
		this.Data["json"] = map[string]interface{}{"code": 0, "message": "请选择部门"}
		this.ServeJSON()
		return
	}
	positionid, _ := this.GetInt64("position")
	if positionid <= 0 {
		this.Data["json"] = map[string]interface{}{"code": 0, "message": "请选择职位"}
		this.ServeJSON()
		return
	}
	password := this.GetString("password")

	realname := this.GetString("realname")
	if "" == realname {
		this.Data["json"] = map[string]interface{}{"code": 0, "message": "请填写姓名"}
		this.ServeJSON()
		return
	}
	sex, _ := this.GetInt("sex")
	if sex <= 0 {
		this.Data["json"] = map[string]interface{}{"code": 0, "message": "请选择性别"}
		this.ServeJSON()
		return
	}
	birth := this.GetString("birth")
	if "" == birth {
		this.Data["json"] = map[string]interface{}{"code": 0, "message": "请选择出生日期"}
		this.ServeJSON()
		return
	}
	email := this.GetString("email")
	if "" == email {
		this.Data["json"] = map[string]interface{}{"code": 0, "message": "请填写邮箱"}
		this.ServeJSON()
		return
	}
	webchat := this.GetString("webchat")
	qq := this.GetString("qq")
	phone := this.GetString("phone")
	if "" == phone {
		this.Data["json"] = map[string]interface{}{"code": 0, "message": "请填写手机号"}
		this.ServeJSON()
		return
	}
	tel := this.GetString("tel")
	address := this.GetString("address")
	emercontact := this.GetString("emercontact")
	if "" == emercontact {
		this.Data["json"] = map[string]interface{}{"code": 0, "message": "请填写紧急联系人"}
		this.ServeJSON()
		return
	}
	emerphone := this.GetString("emerphone")
	if "" == emerphone {
		this.Data["json"] = map[string]interface{}{"code": 0, "message": "请填写紧急联系人电话"}
		this.ServeJSON()
		return
	}
	var err error
	//雪花算法ID生成
	id := utils.SnowFlakeId()

	var pro UsersProfile
	pro.Id = id
	pro.Realname = realname
	pro.Sex = sex
	pro.Birth = birth
	pro.Email = email
	pro.Webchat = webchat
	pro.Qq = qq
	pro.Phone = phone
	pro.Tel = tel
	pro.Address = address
	pro.Emercontact = emercontact
	pro.Emerphone = emerphone
	pro.Departid = departid
	pro.Positionid = positionid
	pro.Ip = this.Ctx.Input.IP()

	var user Users
	user.Id = id
	user.Username = username
	user.Password = password

	err = AddUserProfile(user, pro)

	if err == nil {
		var per Permissions
		per.Id = id
		per.Permission = "project-team,team-add,team-delete,project-need,need-add,need-edit,project-task,task-add,task-edit,project-test,test-add,test-edit,knowledge-manage,knowledge-add,knowledge-edit,album-manage,album-upload,album-edit"
		AddPermissions(per)
		this.Data["json"] = map[string]interface{}{"code": 1, "message": "员工信息添加成功", "id": fmt.Sprintf("%d", id)}
	} else {
		this.Data["json"] = map[string]interface{}{"code": 0, "message": "员工信息添加失败"}
	}
	this.ServeJSON()
}

//修改用户信息
type EditUserController struct {
	controllers.BaseController
}

func (this *EditUserController) Get() {
	//权限检测
	if !strings.Contains(this.GetSession("userPermission").(string), "user-edit") {
		this.Abort("401")
	}
	idstr := this.Ctx.Input.Param(":id")
	id, _ := strconv.Atoi(idstr)
	pro, err := GetProfile(int64(id))
	if err != nil {
		this.Abort("404")
	}
	this.Data["pro"] = pro

	user, _ := GetUser(int64(id))
	this.Data["user"] = user

	condArr := make(map[string]string)
	condArr["status"] = "1"
	_, _, departs := ListDeparts(condArr, 1, 9)
	this.Data["departs"] = departs

	_, _, positions := ListPositions(condArr, 1, 9)
	this.Data["positions"] = positions
	this.TplName = "users/user-form.tpl"
}

func (this *EditUserController) Post() {
	//权限检测
	if !strings.Contains(this.GetSession("userPermission").(string), "user-edit") {
		this.Data["json"] = map[string]interface{}{"code": 0, "message": "无权设置"}
		this.ServeJSON()
		return
	}
	id, _ := this.GetInt64("id")
	if id <= 0 {
		this.Data["json"] = map[string]interface{}{"code": 0, "message": "员工参数出错"}
		this.ServeJSON()
		return
	}
	username := this.GetString("username")
	if "" == username {
		this.Data["json"] = map[string]interface{}{"code": 0, "message": "请填写用户名"}
		this.ServeJSON()
		return
	}

	departid, _ := this.GetInt64("depart")
	if departid <= 0 {
		this.Data["json"] = map[string]interface{}{"code": 0, "message": "请选择部门"}
		this.ServeJSON()
		return
	}
	positionid, _ := this.GetInt64("position")
	if positionid <= 0 {
		this.Data["json"] = map[string]interface{}{"code": 0, "message": "请选择职位"}
		this.ServeJSON()
		return
	}
	password := this.GetString("password")

	realname := this.GetString("realname")
	if "" == realname {
		this.Data["json"] = map[string]interface{}{"code": 0, "message": "请填写姓名"}
		this.ServeJSON()
		return
	}
	sex, _ := this.GetInt("sex")
	if sex <= 0 {
		this.Data["json"] = map[string]interface{}{"code": 0, "message": "请选择性别"}
		this.ServeJSON()
		return
	}
	birth := this.GetString("birth")
	if "" == birth {
		this.Data["json"] = map[string]interface{}{"code": 0, "message": "请选择出生日期"}
		this.ServeJSON()
		return
	}
	email := this.GetString("email")
	if "" == email {
		this.Data["json"] = map[string]interface{}{"code": 0, "message": "请填写邮箱"}
		this.ServeJSON()
		return
	}
	webchat := this.GetString("webchat")
	qq := this.GetString("qq")
	phone := this.GetString("phone")
	if "" == phone {
		this.Data["json"] = map[string]interface{}{"code": 0, "message": "请填写手机号"}
		this.ServeJSON()
		return
	}
	tel := this.GetString("tel")
	address := this.GetString("address")
	emercontact := this.GetString("emercontact")
	if "" == emercontact {
		this.Data["json"] = map[string]interface{}{"code": 0, "message": "请填写紧急联系人"}
		this.ServeJSON()
		return
	}
	emerphone := this.GetString("emerphone")
	if "" == emerphone {
		this.Data["json"] = map[string]interface{}{"code": 0, "message": "请填写紧急联系人电话"}
		this.ServeJSON()
		return
	}

	_, err := GetUser(id)
	if err != nil {
		this.Data["json"] = map[string]interface{}{"code": 0, "message": "员工不存在"}
		this.ServeJSON()
		return
	}

	var pro UsersProfile
	pro.Realname = realname
	pro.Sex = sex
	pro.Birth = birth
	pro.Email = email
	pro.Webchat = webchat
	pro.Qq = qq
	pro.Phone = phone
	pro.Tel = tel
	pro.Address = address
	pro.Emercontact = emercontact
	pro.Emerphone = emerphone
	pro.Departid = departid
	pro.Positionid = positionid

	err = UpdateProfile(id, pro)

	var user Users
	user.Username = username
	if password != "" {
		user.Password = password
	}
	err = UpdateUser(id, user)

	if err == nil {
		this.Data["json"] = map[string]interface{}{"code": 1, "message": "信息修改成功", "id": fmt.Sprintf("%d", id)}
	} else {
		this.Data["json"] = map[string]interface{}{"code": 0, "message": "信息修改失败"}
	}
	this.ServeJSON()
}

type EditUserProfileController struct {
	controllers.BaseController
}

func (this *EditUserProfileController) Get() {
	userid := this.BaseController.UserUserId

	pro, err := GetProfile(userid)
	if err != nil {
		this.Abort("404")
	}
	this.Data["pro"] = pro
	this.TplName = "users/profile-form.tpl"
}
func (this *EditUserProfileController) Post() {
	userid := this.BaseController.UserUserId

	realname := this.GetString("realname")
	if "" == realname {
		this.Data["json"] = map[string]interface{}{"code": 0, "message": "请填写姓名"}
		this.ServeJSON()
		return
	}
	sex, _ := this.GetInt("sex")
	if sex <= 0 {
		this.Data["json"] = map[string]interface{}{"code": 0, "message": "请选择性别"}
		this.ServeJSON()
		return
	}
	birth := this.GetString("birth")
	if "" == birth {
		this.Data["json"] = map[string]interface{}{"code": 0, "message": "请选择出生日期"}
		this.ServeJSON()
		return
	}
	email := this.GetString("email")
	if "" == email {
		this.Data["json"] = map[string]interface{}{"code": 0, "message": "请填写邮箱"}
		this.ServeJSON()
		return
	}
	webchat := this.GetString("webchat")
	qq := this.GetString("qq")
	phone := this.GetString("phone")
	if "" == phone {
		this.Data["json"] = map[string]interface{}{"code": 0, "message": "请填写手机号"}
		this.ServeJSON()
		return
	}
	tel := this.GetString("tel")
	address := this.GetString("address")
	emercontact := this.GetString("emercontact")
	if "" == emercontact {
		this.Data["json"] = map[string]interface{}{"code": 0, "message": "请填写紧急联系人"}
		this.ServeJSON()
		return
	}
	emerphone := this.GetString("emerphone")
	if "" == emerphone {
		this.Data["json"] = map[string]interface{}{"code": 0, "message": "请填写紧急联系人电话"}
		this.ServeJSON()
		return
	}

	_, err := GetUser(userid)
	if err != nil {
		this.Data["json"] = map[string]interface{}{"code": 0, "message": "员工不存在"}
		this.ServeJSON()
		return
	}

	var pro UsersProfile
	pro.Realname = realname
	pro.Sex = sex
	pro.Birth = birth
	pro.Email = email
	pro.Webchat = webchat
	pro.Qq = qq
	pro.Phone = phone
	pro.Tel = tel
	pro.Address = address
	pro.Emercontact = emercontact
	pro.Emerphone = emerphone

	err = UpdateProfile(userid, pro)

	if err == nil {
		this.Data["json"] = map[string]interface{}{"code": 1, "message": "个人资料修改成功", "type": "profile", "id": fmt.Sprintf("%d", userid)}
	} else {
		this.Data["json"] = map[string]interface{}{"code": 0, "message": "修改失败"}
	}
	this.ServeJSON()
}

type EditUserPasswordController struct {
	controllers.BaseController
}

func (this *EditUserPasswordController) Get() {
	this.TplName = "users/profile-pwd.tpl"
}

func (this *EditUserPasswordController) Post() {
	oldpwd := this.GetString("oldpwd")
	if "" == oldpwd {
		this.Data["json"] = map[string]interface{}{"code": 0, "message": "请填写当前密码"}
		this.ServeJSON()
		return
	}
	newpwd := this.GetString("newpwd")
	if "" == newpwd {
		this.Data["json"] = map[string]interface{}{"code": 0, "message": "请填写新密码"}
		this.ServeJSON()
		return
	}
	confpwd := this.GetString("confpwd")
	if "" == confpwd {
		this.Data["json"] = map[string]interface{}{"code": 0, "message": "请填写确认密码"}
		this.ServeJSON()
		return
	}
	if confpwd != newpwd {
		this.Data["json"] = map[string]interface{}{"code": 0, "message": "两次输入密码不一致"}
		this.ServeJSON()
		return
	}
	userid := this.BaseController.UserUserId
	err := UpdatePassword(userid, oldpwd, newpwd)
	if err == nil {
		this.Data["json"] = map[string]interface{}{"code": 1, "message": "密码修改成功", "id": fmt.Sprintf("%d", userid)}
	} else {
		this.Data["json"] = map[string]interface{}{"code": 0, "message": "修改失败"}
	}
	this.ServeJSON()
}

type PermissionController struct {
	controllers.BaseController
}

func (this *PermissionController) Get() {
	//权限检测
	if !strings.Contains(this.GetSession("userPermission").(string), "user-permission") {
		this.Abort("401")
	}
	idstr := this.Ctx.Input.Param(":id")
	id, err := strconv.Atoi(idstr)
	permission := GetPermissions(int64(id))
	if err != nil {
		this.Abort("404")
	}
	this.Data["permission"] = permission
	this.Data["userid"] = idstr
	this.TplName = "users/permission.tpl"
}

func (this *PermissionController) Post() {
	//权限检测
	if !strings.Contains(this.GetSession("userPermission").(string), "user-permission") {
		this.Data["json"] = map[string]interface{}{"code": 0, "message": "无权设置"}
		this.ServeJSON()
		return
	}
	userid, _ := this.GetInt64("userid")
	permission := this.GetString("permission")

	var per Permissions
	per.Permission = permission

	err := UpdatePermissions(userid, per)
	if err == nil {
		this.Data["json"] = map[string]interface{}{"code": 1, "message": "权限设置成功"}
	} else {
		this.Data["json"] = map[string]interface{}{"code": 0, "message": "设置失败"}
	}

	this.ServeJSON()
}
