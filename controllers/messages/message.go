package messages

import (
	"fmt"
	"opms/controllers"
	. "opms/models/messages"
	//"opms/utils"
	//"strconv"
	"strings"
	//"time"

	"github.com/astaxie/beego"
	"github.com/astaxie/beego/utils/pagination"
)

//消息管理
type ManageMessageController struct {
	controllers.BaseController
}

func (this *ManageMessageController) Get() {
	//权限检测
	if !strings.Contains(this.GetSession("userPermission").(string), "message-manage") {
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
	status := this.GetString("status")
	mtype := this.GetString("type")

	condArr := make(map[string]string)
	condArr["touserid"] = fmt.Sprintf("%d", this.BaseController.UserUserId)
	condArr["view"] = status
	condArr["type"] = mtype

	countMessage := CountMessages(condArr)

	paginator := pagination.SetPaginator(this.Ctx, offset, countMessage)
	_, _, messages := ListMessages(condArr, page, offset)

	this.Data["paginator"] = paginator
	this.Data["condArr"] = condArr
	this.Data["messages"] = messages
	this.Data["countMessage"] = countMessage

	//查看列表即更新查看状态标为已查看
	ChangeMessagesStatusAll(this.BaseController.UserUserId)

	this.TplName = "messages/index.tpl"
}

type AjaxStatusMessageController struct {
	controllers.BaseController
}

func (this *AjaxStatusMessageController) Post() {
	//权限检测
	if !strings.Contains(this.GetSession("userPermission").(string), "message-manage") {
		this.Data["json"] = map[string]interface{}{"code": 0, "message": "无权设置"}
		this.ServeJSON()
		return
	}
	id, _ := this.GetInt64("id")
	if id <= 0 {
		this.Data["json"] = map[string]interface{}{"code": 0, "message": "请选择消息变更ID"}
		this.ServeJSON()
		return
	}

	err := ChangeMessagesStatus(id, 2)

	if err == nil {
		this.Data["json"] = map[string]interface{}{"code": 1, "message": "状态更改成功"}
	} else {
		this.Data["json"] = map[string]interface{}{"code": 0, "message": "状态更改失败"}
	}
	this.ServeJSON()
}

type AjaxDeleteMessageController struct {
	controllers.BaseController
}

func (this *AjaxDeleteMessageController) Post() {
	//权限检测
	if !strings.Contains(this.GetSession("userPermission").(string), "message-delete") {
		this.Data["json"] = map[string]interface{}{"code": 0, "message": "无权设置"}
		this.ServeJSON()
		return
	}
	ids := this.GetString("ids")
	if "" == ids {
		this.Data["json"] = map[string]interface{}{"code": 0, "message": "请选择要删除的消息"}
		this.ServeJSON()
		return
	}

	err := DeleteMessages(ids)

	if err == nil {
		this.Data["json"] = map[string]interface{}{"code": 1, "message": "删除成功"}
	} else {
		this.Data["json"] = map[string]interface{}{"code": 0, "message": "删除失败"}
	}
	this.ServeJSON()
}
