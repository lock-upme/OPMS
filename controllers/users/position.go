package users

import (
	//"fmt"
	"opms/controllers"
	. "opms/models/users"
	"opms/utils"
	"strconv"
	"strings"

	"github.com/astaxie/beego"
	"github.com/astaxie/beego/utils/pagination"
)

type ManagePositionController struct {
	controllers.BaseController
}

func (this *ManagePositionController) Get() {
	//权限检测
	if !strings.Contains(this.GetSession("userPermission").(string), "position-manage") {
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

	countPosition := CountPositions(condArr)

	paginator := pagination.SetPaginator(this.Ctx, offset, countPosition)
	_, _, position := ListPositions(condArr, page, offset)

	this.Data["paginator"] = paginator
	this.Data["condArr"] = condArr
	this.Data["position"] = position
	this.Data["countPosition"] = countPosition

	this.TplName = "users/position.tpl"
}

//职称状态
type AjaxStatusPositionController struct {
	controllers.BaseController
}

func (this *AjaxStatusPositionController) Post() {
	//权限检测
	if !strings.Contains(this.GetSession("userPermission").(string), "position-edit") {
		this.Data["json"] = map[string]interface{}{"code": 0, "message": "无权设置"}
		this.ServeJSON()
		return
	}
	id, _ := this.GetInt64("id")
	if id <= 0 {
		this.Data["json"] = map[string]interface{}{"code": 0, "message": "请选择职称"}
		this.ServeJSON()
		return
	}
	status, _ := this.GetInt("status")
	if status <= 0 || status >= 3 {
		this.Data["json"] = map[string]interface{}{"code": 0, "message": "请选择操作状态"}
		this.ServeJSON()
		return
	}

	err := ChangePositionStatus(id, status)

	if err == nil {
		this.Data["json"] = map[string]interface{}{"code": 1, "message": "职称状态更改成功"}
	} else {
		this.Data["json"] = map[string]interface{}{"code": 0, "message": "职称状态更改失败"}
	}
	this.ServeJSON()
}

//职称添加
type AddPositionController struct {
	controllers.BaseController
}

func (this *AddPositionController) Get() {
	//权限检测
	if !strings.Contains(this.GetSession("userPermission").(string), "position-add") {
		this.Abort("401")
	}
	this.TplName = "users/position-form.tpl"
}

func (this *AddPositionController) Post() {
	//权限检测
	if !strings.Contains(this.GetSession("userPermission").(string), "position-edit") {
		this.Data["json"] = map[string]interface{}{"code": 0, "message": "无权设置"}
		this.ServeJSON()
		return
	}
	name := this.GetString("name")
	if "" == name {
		this.Data["json"] = map[string]interface{}{"code": 0, "message": "请填写名称"}
		this.ServeJSON()
		return
	}
	desc := this.GetString("desc")

	var pos Positions
	pos.Id = utils.SnowFlakeId()
	pos.Name = name
	pos.Desc = desc
	err := AddPositions(pos)

	if err == nil {
		this.Data["json"] = map[string]interface{}{"code": 1, "message": "职称添加成功"}
	} else {
		this.Data["json"] = map[string]interface{}{"code": 0, "message": "职称添加失败"}
	}
	this.ServeJSON()
}

//职称编辑
type EditPositionController struct {
	controllers.BaseController
}

func (this *EditPositionController) Get() {
	//权限检测
	if !strings.Contains(this.GetSession("userPermission").(string), "position-edit") {
		this.Abort("401")
	}
	idstr := this.Ctx.Input.Param(":id")
	id, err := strconv.Atoi(idstr)
	pos, err := GetPositions(int64(id))
	if err != nil {
		this.Abort("404")
	}
	this.Data["position"] = pos
	this.TplName = "users/position-form.tpl"
}

func (this *EditPositionController) Post() {
	//权限检测
	if !strings.Contains(this.GetSession("userPermission").(string), "position-edit") {
		this.Data["json"] = map[string]interface{}{"code": 0, "message": "无权设置"}
		this.ServeJSON()
		return
	}
	id, _ := this.GetInt64("id")
	if id <= 0 {
		this.Data["json"] = map[string]interface{}{"code": 0, "message": "参数出错"}
		this.ServeJSON()
		return
	}
	_, err := GetPositions(id)
	if err != nil {
		this.Data["json"] = map[string]interface{}{"code": 0, "message": "职称不存在"}
		this.ServeJSON()
		return
	}

	name := this.GetString("name")
	if "" == name {
		this.Data["json"] = map[string]interface{}{"code": 0, "message": "请填写名称"}
		this.ServeJSON()
		return
	}
	desc := this.GetString("desc")

	var pos Positions
	pos.Name = name
	pos.Desc = desc

	err = UpdatePositions(id, pos)

	if err == nil {
		this.Data["json"] = map[string]interface{}{"code": 1, "message": "信息修改成功"}
	} else {
		this.Data["json"] = map[string]interface{}{"code": 0, "message": "信息修改失败"}
	}
	this.ServeJSON()
}
