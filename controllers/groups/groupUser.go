package groups

import (
	"fmt"
	"opms/controllers"
	. "opms/models/groups"
	"opms/utils"
	"strconv"
	"strings"
	//"time"

	//"github.com/astaxie/beego"
	//"github.com/astaxie/beego/utils/pagination"
)

//组成员管理
type ManageGroupUserController struct {
	controllers.BaseController
}

func (this *ManageGroupUserController) Get() {
	//权限检测
	if !strings.Contains(this.GetSession("userPermission").(string), "group-user") {
		this.Abort("401")
	}
	idstr := this.Ctx.Input.Param(":id")

	groupid, _ := strconv.Atoi(idstr)

	group, _ := GetGroup(int64(groupid))
	this.Data["group"] = group

	_, _, users := ListGroupsUserAndName(int64(groupid))
	fmt.Println(users)
	this.Data["users"] = users

	this.TplName = "groups/user.tpl"
}

type FormGroupUserController struct {
	controllers.BaseController
}

func (this *FormGroupUserController) Get() {
	//权限检测
	if !strings.Contains(this.GetSession("userPermission").(string), "group-user-add") {
		this.Abort("401")
	}
	idstr := this.Ctx.Input.Param(":id")
	//fmt.Println("hello" + idstr)

	if "" != idstr {
		id, _ := strconv.Atoi(idstr)
		group, _ := GetGroup(int64(id))
		this.Data["group"] = group
	}
	this.TplName = "groups/user-form.tpl"
}

func (this *FormGroupUserController) Post() {
	//权限检测
	if !strings.Contains(this.GetSession("userPermission").(string), "group-user-add") {
		this.Data["json"] = map[string]interface{}{"code": 0, "message": "无权设置"}
		this.ServeJSON()
		return
	}
	groupid, _ := this.GetInt64("groupid")
	if groupid <= 0 {
		this.Data["json"] = map[string]interface{}{"code": 0, "message": "请选择组"}
		this.ServeJSON()
		return
	}
	userid, _ := this.GetInt64("userid")
	if userid <= 0 {
		this.Data["json"] = map[string]interface{}{"code": 0, "message": "请填写成员"}
		this.ServeJSON()
		return
	}

	var groupUser GroupsUser
	var err error
	groupUser.Id = utils.SnowFlakeId()
	groupUser.Groupid = groupid
	groupUser.Userid = userid
	err = AddGroupsUser(groupUser)

	if err == nil {
		this.Data["json"] = map[string]interface{}{"code": 1, "message": "操作成功", "id": fmt.Sprintf("%d", groupid)}
	} else {
		this.Data["json"] = map[string]interface{}{"code": 0, "message": "添加失败"}
	}
	this.ServeJSON()
}

type AjaxDeleteGroupUserController struct {
	controllers.BaseController
}

func (this *AjaxDeleteGroupUserController) Post() {
	//权限检测
	if !strings.Contains(this.GetSession("userPermission").(string), "group-user-delete") {
		this.Data["json"] = map[string]interface{}{"code": 0, "message": "无权设置"}
		this.ServeJSON()
		return
	}
	id, _ := this.GetInt64("id")
	if id <= 0 {
		this.Data["json"] = map[string]interface{}{"code": 0, "message": "请选择要删除的选项"}
		this.ServeJSON()
		return
	}

	err := DeleteGroupsUser(id)

	if err == nil {
		this.Data["json"] = map[string]interface{}{"code": 1, "message": "删除成功"}
	} else {
		this.Data["json"] = map[string]interface{}{"code": 0, "message": "删除失败"}
	}
	this.ServeJSON()
}
