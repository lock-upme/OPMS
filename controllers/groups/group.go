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
type ManageGroupController struct {
	controllers.BaseController
}

func (this *ManageGroupController) Get() {
	//权限检测
	if !strings.Contains(this.GetSession("userPermission").(string), "group-manage") {
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

	countGroup := CountGroup(condArr)

	paginator := pagination.SetPaginator(this.Ctx, offset, countGroup)
	_, _, groups := ListGroup(condArr, page, offset)

	this.Data["paginator"] = paginator
	this.Data["condArr"] = condArr
	this.Data["groups"] = groups
	this.Data["countGroup"] = countGroup

	this.TplName = "groups/index.tpl"
}

type FormGroupController struct {
	controllers.BaseController
}

func (this *FormGroupController) Get() {

	idstr := this.Ctx.Input.Param(":id")
	if "" != idstr {
		//权限检测
		if !strings.Contains(this.GetSession("userPermission").(string), "group-edit") {
			this.Abort("401")
		}
		id, _ := strconv.Atoi(idstr)
		group, _ := GetGroup(int64(id))
		this.Data["group"] = group
	} else {
		//权限检测
		if !strings.Contains(this.GetSession("userPermission").(string), "group-add") {
			this.Abort("401")
		}
	}

	this.TplName = "groups/form.tpl"
}

func (this *FormGroupController) Post() {
	//权限检测
	name := this.GetString("name")
	if "" == name {
		this.Data["json"] = map[string]interface{}{"code": 0, "message": "请填写组名称"}
		this.ServeJSON()
		return
	}
	summary := this.GetString("summary")

	var group Groups
	group.Name = name
	group.Summary = summary

	groupid, _ := this.GetInt64("id")
	var err error
	if groupid <= 0 {
		groupid = utils.SnowFlakeId()
		group.Id = groupid
		err = AddGroup(group)
	} else {
		err = UpdateGroup(groupid, group)
	}

	if err == nil {
		this.Data["json"] = map[string]interface{}{"code": 1, "message": "操作成功", "id": fmt.Sprintf("%d", groupid)}
	} else {
		this.Data["json"] = map[string]interface{}{"code": 0, "message": "添加失败"}
	}
	this.ServeJSON()
}

type AjaxDeleteGroupController struct {
	controllers.BaseController
}

func (this *AjaxDeleteGroupController) Post() {
	//权限检测
	if !strings.Contains(this.GetSession("userPermission").(string), "group-delete") {
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

	err := DeleteGroup(ids)

	if err == nil {
		this.Data["json"] = map[string]interface{}{"code": 1, "message": "删除成功"}
	} else {
		this.Data["json"] = map[string]interface{}{"code": 0, "message": "删除失败"}
	}
	this.ServeJSON()
}
