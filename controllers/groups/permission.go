package groups

import (
	"fmt"
	"opms/controllers"
	. "opms/models/groups"
	"opms/utils"
	"strconv"
	"strings"
	//"time"

	"github.com/astaxie/beego"
	"github.com/astaxie/beego/utils/pagination"
)

//组管理
type ManagePermissionController struct {
	controllers.BaseController
}

func (this *ManagePermissionController) Get() {
	//权限检测
	if !strings.Contains(this.GetSession("userPermission").(string), "permission-manage") {
		this.Abort("401")
	}
	page, err := this.GetInt("p")
	if err != nil {
		page = 1
	}

	offset, err1 := beego.AppConfig.Int("pageoffset")
	if err1 != nil {
		offset = 15
	}
	keywords := this.GetString("keywords")

	condArr := make(map[string]string)
	condArr["keywords"] = keywords

	parentid := this.GetString("parentid")
	condArr["parentid"] = parentid

	var parentids int64
	parentidtmp, _ := strconv.Atoi(parentid)
	parentids = int64(parentidtmp)
	this.Data["parentids"] = parentids

	countPermission := CountPermission(condArr)

	paginator := pagination.SetPaginator(this.Ctx, offset, countPermission)
	_, _, permissions := ListPermission(condArr, page, offset)

	this.Data["paginator"] = paginator
	this.Data["condArr"] = condArr
	this.Data["permissions"] = permissions
	this.Data["countPermission"] = countPermission

	//一级栏目
	condArrP := make(map[string]string)
	condArrP["parentid"] = "0"
	_, _, parentpermissions := ListPermission(condArrP, 0, 100)
	this.Data["parentpermissions"] = parentpermissions

	this.TplName = "groups/permission.tpl"
}

type FormPermissionController struct {
	controllers.BaseController
}

func (this *FormPermissionController) Get() {
	var permission Permissions
	idstr := this.Ctx.Input.Param(":id")
	if "" != idstr {
		//权限检测
		if !strings.Contains(this.GetSession("userPermission").(string), "permission-edit") {
			this.Abort("401")
		}
		id, _ := strconv.Atoi(idstr)
		permission, _ = GetPermission(int64(id))
	} else {
		//权限检测
		if !strings.Contains(this.GetSession("userPermission").(string), "permission-add") {
			this.Abort("401")
		}
		permission.Id = 0
	}
	this.Data["permission"] = permission

	//一级栏目
	condArr := make(map[string]string)
	condArr["parentid"] = "0"
	_, _, permissions := ListPermission(condArr, 0, 100)
	this.Data["permissions"] = permissions

	this.TplName = "groups/permission-form.tpl"
}

func (this *FormPermissionController) Post() {
	//权限检测
	name := this.GetString("name")
	if "" == name {
		this.Data["json"] = map[string]interface{}{"code": 0, "message": "请填写组名称"}
		this.ServeJSON()
		return
	}
	ename := this.GetString("ename")
	ptype, _ := this.GetInt("type")
	weight, _ := this.GetInt("weight")
	icon := this.GetString("icon")

	var permission Permissions
	parentid, _ := this.GetInt64("parentid")
	permission.Parentid = parentid
	permission.Name = name
	permission.Ename = ename
	permission.Type = ptype
	permission.Weight = weight
	permission.Icon = icon

	permissionid, _ := this.GetInt64("id")
	var err error
	if permissionid <= 0 {
		permissionid = utils.SnowFlakeId()
		permission.Id = permissionid
		err = AddPermission(permission)
	} else {
		err = UpdatePermission(permissionid, permission)
	}

	if err == nil {
		this.Data["json"] = map[string]interface{}{"code": 1, "message": "操作成功", "id": fmt.Sprintf("%d", permissionid)}
	} else {
		this.Data["json"] = map[string]interface{}{"code": 0, "message": "添加失败"}
	}
	this.ServeJSON()
}

type AjaxDeletePermissionController struct {
	controllers.BaseController
}

func (this *AjaxDeletePermissionController) Post() {
	//权限检测
	if !strings.Contains(this.GetSession("userPermission").(string), "permission-delete") {
		this.Data["json"] = map[string]interface{}{"code": 0, "message": "无权设置"}
		this.ServeJSON()
		return
	}
	ids := this.GetString("ids")
	if "" == ids {
		this.Data["json"] = map[string]interface{}{"code": 0, "message": "请选择要删除的选项"}
		this.ServeJSON()
		return
	}

	err := DeletePermission(ids)

	if err == nil {
		this.Data["json"] = map[string]interface{}{"code": 1, "message": "删除成功"}
	} else {
		this.Data["json"] = map[string]interface{}{"code": 0, "message": "删除失败"}
	}
	this.ServeJSON()
}
