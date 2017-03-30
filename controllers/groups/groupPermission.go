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
type ManageGroupPermissionController struct {
	controllers.BaseController
}

func (this *ManageGroupPermissionController) Get() {
	//权限检测
	if !strings.Contains(this.GetSession("userPermission").(string), "group-permission") {
		this.Abort("401")
	}
	idstr := this.Ctx.Input.Param(":id")

	groupid, _ := strconv.Atoi(idstr)

	group, _ := GetGroup(int64(groupid))
	this.Data["group"] = group

	condArr := make(map[string]string)
	_, _, permissions := ListPermission(condArr, 1, 1000)

	var pstring = ""
	var cstring = ""
	for _, value := range permissions {
		if value.Parentid == 0 {
			pstring += fmt.Sprintf("%d", value.Id) + "||" + fmt.Sprintf("%d", value.Parentid) + "||" + value.Name + "||" + value.Ename + ","
		} else {
			cstring += fmt.Sprintf("%d", value.Id) + "||" + fmt.Sprintf("%d", value.Parentid) + "||" + value.Name + "||" + value.Ename + ","
		}
	}
	this.Data["pstring"] = pstring
	this.Data["cstring"] = cstring

	groupspermissions := ListGroupsPermission(int64(groupid))
	var groupstring = ""
	for _, v := range groupspermissions {
		groupstring += fmt.Sprintf("%d", v.Permissionid) + ","
	}

	this.Data["groupspermissions"] = groupstring
	//fmt.Println(groupstring)

	this.TplName = "groups/group-permission.tpl"
}

func (this *ManageGroupPermissionController) Post() {
	//权限检测
	if !strings.Contains(this.GetSession("userPermission").(string), "group-permission") {
		this.Data["json"] = map[string]interface{}{"code": 0, "message": "无权设置"}
		this.ServeJSON()
	}
	groupid, _ := this.GetInt64("groupid")
	if groupid <= 0 {
		this.Data["json"] = map[string]interface{}{"code": 0, "message": "请选择组"}
		this.ServeJSON()
		return
	}

	//permission := make([]string, 0, 2)
	//this.Ctx.Input.Bind(&permission, "permission") //ul ==[str array]

	permission := this.GetString("permission")

	//fmt.Println("hello")
	//fmt.Println(permission)

	var groupPermission GroupsPermission
	var err error

	groupPermission.Groupid = groupid

	//先删除,再添加
	DeleteGroupsPermissionForGroupid(groupid)

	names := strings.Split(permission, ",")
	for _, v := range names {
		pid, _ := strconv.Atoi(v)
		groupPermission.Id = utils.SnowFlakeId()
		groupPermission.Permissionid = int64(pid)
		err = AddGroupsPermission(groupPermission)
	}

	if err == nil {
		this.Data["json"] = map[string]interface{}{"code": 1, "message": "操作成功", "id": fmt.Sprintf("%d", groupid)}
	} else {
		this.Data["json"] = map[string]interface{}{"code": 0, "message": "添加失败"}
	}
	this.ServeJSON()
}

type AjaxDeleteGroupPermissionController struct {
	controllers.BaseController
}

func (this *AjaxDeleteGroupPermissionController) Post() {
	//权限检测
	if !strings.Contains(this.GetSession("userPermission").(string), "group-permission") {
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

	err := DeleteGroupsPermission(id)

	if err == nil {
		this.Data["json"] = map[string]interface{}{"code": 1, "message": "删除成功"}
	} else {
		this.Data["json"] = map[string]interface{}{"code": 0, "message": "删除失败"}
	}
	this.ServeJSON()
}
