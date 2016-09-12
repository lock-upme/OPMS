package users

import (
	"fmt"
	"opms/controllers"
	. "opms/models/users"
	"opms/utils"
	"strconv"
	"strings"

	"github.com/astaxie/beego"
	"github.com/astaxie/beego/utils/pagination"
)

//公告管理
type ManageNoticeController struct {
	controllers.BaseController
}

func (this *ManageNoticeController) Get() {
	//权限检测
	if !strings.Contains(this.GetSession("userPermission").(string), "notice-manage") {
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

	countNotice := CountNotices(condArr)

	paginator := pagination.SetPaginator(this.Ctx, offset, countNotice)
	_, _, notice := ListNotices(condArr, page, offset)

	this.Data["paginator"] = paginator
	this.Data["condArr"] = condArr
	this.Data["notice"] = notice
	this.Data["countNotice"] = countNotice

	this.TplName = "users/notice.tpl"
}

//公告状态
type AjaxStatusNoticeController struct {
	controllers.BaseController
}

func (this *AjaxStatusNoticeController) Post() {
	//权限检测
	if !strings.Contains(this.GetSession("userPermission").(string), "notice-edit") {
		this.Data["json"] = map[string]interface{}{"code": 0, "message": "无权设置"}
		this.ServeJSON()
		return
	}
	id, _ := this.GetInt64("id")
	if id <= 0 {
		this.Data["json"] = map[string]interface{}{"code": 0, "message": "请选择公告"}
		this.ServeJSON()
		return
	}
	status, _ := this.GetInt("status")
	if status <= 0 || status >= 3 {
		this.Data["json"] = map[string]interface{}{"code": 0, "message": "请选择操作状态"}
		this.ServeJSON()
		return
	}

	err := ChangeNoticeStatus(id, status)

	if err == nil {
		this.Data["json"] = map[string]interface{}{"code": 1, "message": "公告状态更改成功"}
	} else {
		this.Data["json"] = map[string]interface{}{"code": 0, "message": "公告状态更改失败"}
	}
	this.ServeJSON()
}

//公告添加
type AddNoticeController struct {
	controllers.BaseController
}

func (this *AddNoticeController) Get() {
	//权限检测
	if !strings.Contains(this.GetSession("userPermission").(string), "notice-add") {
		this.Abort("401")
	}
	this.TplName = "users/notice-form.tpl"
}

func (this *AddNoticeController) Post() {
	//权限检测
	if !strings.Contains(this.GetSession("userPermission").(string), "notice-add") {
		this.Data["json"] = map[string]interface{}{"code": 0, "message": "无权设置"}
		this.ServeJSON()
		return
	}
	title := this.GetString("title")
	if "" == title {
		this.Data["json"] = map[string]interface{}{"code": 0, "message": "请填写标题"}
		this.ServeJSON()
		return
	}
	content := this.GetString("content")

	var not Notices
	not.Id = utils.SnowFlakeId()
	not.Title = title
	not.Content = content
	err := AddNotices(not)

	if err == nil {
		this.Data["json"] = map[string]interface{}{"code": 1, "message": "公告添加成功"}
	} else {
		this.Data["json"] = map[string]interface{}{"code": 0, "message": "公告添加失败"}
	}
	this.ServeJSON()
}

//公告编辑
type EditNoticeController struct {
	controllers.BaseController
}

func (this *EditNoticeController) Get() {
	//权限检测
	if !strings.Contains(this.GetSession("userPermission").(string), "notice-edit") {
		this.Abort("401")
	}
	idstr := this.Ctx.Input.Param(":id")
	id, err := strconv.Atoi(idstr)
	notice, err := GetNotices(int64(id))
	if err != nil {
		this.Abort("404")
	}
	this.Data["notice"] = notice
	this.TplName = "users/notice-form.tpl"
}

func (this *EditNoticeController) Post() {
	//权限检测
	if !strings.Contains(this.GetSession("userPermission").(string), "notice-edit") {
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
	_, err := GetNotices(id)
	if err != nil {
		this.Data["json"] = map[string]interface{}{"code": 0, "message": "公告不存在"}
		this.ServeJSON()
		return
	}

	title := this.GetString("title")
	if "" == title {
		this.Data["json"] = map[string]interface{}{"code": 0, "message": "请填写标题"}
		this.ServeJSON()
		return
	}
	content := this.GetString("content")

	var not Notices
	not.Title = title
	not.Content = content

	err = UpdateNotices(id, not)

	if err == nil {
		this.Data["json"] = map[string]interface{}{"code": 1, "message": "信息修改成功", "id": fmt.Sprintf("%d", id)}
	} else {
		this.Data["json"] = map[string]interface{}{"code": 0, "message": "信息修改失败"}
	}
	this.ServeJSON()
}
