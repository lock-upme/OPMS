package knowledges

import (
	"fmt"
	"opms/controllers"
	. "opms/models/knowledges"
	"opms/utils"
	"strconv"
	"strings"

	"github.com/astaxie/beego"
	"github.com/astaxie/beego/utils/pagination"
)

type ManageKnowledgeController struct {
	controllers.BaseController
}

func (this *ManageKnowledgeController) Get() {
	//权限检测
	if !strings.Contains(this.GetSession("userPermission").(string), "knowledge-manage") {
		this.Abort("401")
	}
	page, err := this.GetInt("p")
	status := this.GetString("status")
	keywords := this.GetString("keywords")
	sortid := this.GetString("sortid")
	filter := this.GetString("filter")
	if "" == filter {
		filter = ""
	}
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
	condArr["sortid"] = sortid
	condArr["filter"] = filter
	if filter == "me" {
		condArr["userid"] = fmt.Sprintf("%d", this.BaseController.UserUserId)
	}

	countKnowledge := CountKnowledge(condArr)

	paginator := pagination.SetPaginator(this.Ctx, offset, countKnowledge)
	_, _, knowledges := ListKnowledge(condArr, page, offset)

	this.Data["paginator"] = paginator
	this.Data["condArr"] = condArr
	this.Data["knowledges"] = knowledges
	this.Data["countKnowledge"] = countKnowledge

	_, _, sorts := ListKnowledgeSort()
	this.Data["sorts"] = sorts
	this.Data["title"] = "知识分享"
	this.TplName = "knowledges/index.tpl"
}

type ShowKnowledgeController struct {
	controllers.BaseController
}

func (this *ShowKnowledgeController) Get() {
	idstr := this.Ctx.Input.Param(":id")
	id, err := strconv.Atoi(idstr)
	knowledge, err := GetKnowledge(int64(id))
	if err != nil {
		this.Abort("404")
	}
	this.Data["knowledge"] = knowledge
	ChangeRelationNum(knowledge.Id, "view")

	comments := ListKnowledgeComment(knowledge.Id, 1, 100)
	this.Data["comments"] = comments

	this.TplName = "knowledges/detail.tpl"
}

type AjaxDeleteKnowledgeController struct {
	controllers.BaseController
}

func (this *AjaxDeleteKnowledgeController) Post() {
	//权限检测
	if !strings.Contains(this.GetSession("userPermission").(string), "knowledge-edit") {
		this.Data["json"] = map[string]interface{}{"code": 0, "message": "无权设置"}
		this.ServeJSON()
		return
	}
	id, _ := this.GetInt64("id")
	if id < 0 {
		this.Data["json"] = map[string]interface{}{"code": 0, "message": "请选择用户"}
		this.ServeJSON()
		return
	}

	err := DeleteKnowledge(id)

	if err == nil {
		this.Data["json"] = map[string]interface{}{"code": 1, "message": "成员删除成功"}
	} else {
		this.Data["json"] = map[string]interface{}{"code": 0, "message": "成员删除失败"}
	}
	this.ServeJSON()
}

type AddKnowledgeController struct {
	controllers.BaseController
}

func (this *AddKnowledgeController) Get() {
	//权限检测
	if !strings.Contains(this.GetSession("userPermission").(string), "knowledge-add") {
		this.Abort("401")
	}
	var knowledge Knowledges
	knowledge.Id = 1
	this.Data["knowledge"] = knowledge
	_, _, sorts := ListKnowledgeSort()
	this.Data["sorts"] = sorts

	this.TplName = "knowledges/form.tpl"
}
func (this *AddKnowledgeController) Post() {
	//权限检测
	if !strings.Contains(this.GetSession("userPermission").(string), "knowledge-add") {
		this.Data["json"] = map[string]interface{}{"code": 0, "message": "无权设置"}
		this.ServeJSON()
		return
	}
	sortid, _ := this.GetInt64("sortid")
	if sortid <= 0 {
		this.Data["json"] = map[string]interface{}{"code": 0, "message": "请选择类型"}
		this.ServeJSON()
		return
	}
	title := this.GetString("title")
	if "" == title {
		this.Data["json"] = map[string]interface{}{"code": 0, "message": "请填写标题"}
		this.ServeJSON()
		return
	}
	tag := this.GetString("tag")
	summary := this.GetString("summary")
	content := this.GetString("content")
	if "" == content {
		this.Data["json"] = map[string]interface{}{"code": 0, "message": "请填写正文"}
		this.ServeJSON()
		return
	}
	url := this.GetString("url")

	var err error
	var knowledge Knowledges
	id := utils.SnowFlakeId()
	knowledge.Id = id
	knowledge.Userid = this.BaseController.UserUserId
	knowledge.Sortid = sortid
	knowledge.Title = title
	knowledge.Tag = tag
	knowledge.Summary = summary
	knowledge.Content = content
	knowledge.Url = url

	err = AddKnowledge(knowledge)

	if err == nil {
		this.Data["json"] = map[string]interface{}{"code": 1, "message": "知识分享添加成功", "id": fmt.Sprintf("%d", id)}
	} else {
		this.Data["json"] = map[string]interface{}{"code": 0, "message": "知识分享添加失败"}
	}
	this.ServeJSON()
}

type EditKnowledgeController struct {
	controllers.BaseController
}

func (this *EditKnowledgeController) Get() {
	//权限检测
	if !strings.Contains(this.GetSession("userPermission").(string), "knowledge-edit") {
		this.Abort("401")
	}
	idstr := this.Ctx.Input.Param(":id")
	id, _ := strconv.Atoi(idstr)
	knowledge, _ := GetKnowledge(int64(id))

	if knowledge.Userid != this.BaseController.UserUserId {
		this.Abort("401")
	}

	this.Data["knowledge"] = knowledge

	_, _, sorts := ListKnowledgeSort()
	this.Data["sorts"] = sorts

	this.TplName = "knowledges/form.tpl"
}
func (this *EditKnowledgeController) Post() {
	//权限检测
	if !strings.Contains(this.GetSession("userPermission").(string), "knowledge-edit") {
		this.Data["json"] = map[string]interface{}{"code": 0, "message": "无权设置"}
		this.ServeJSON()
		return
	}
	id, _ := this.GetInt64("id")
	sortid, _ := this.GetInt64("sortid")
	if sortid <= 0 {
		this.Data["json"] = map[string]interface{}{"code": 0, "message": "请选择类型"}
		this.ServeJSON()
		return
	}
	title := this.GetString("title")
	if "" == title {
		this.Data["json"] = map[string]interface{}{"code": 0, "message": "请填写标题"}
		this.ServeJSON()
		return
	}
	tag := this.GetString("tag")
	summary := this.GetString("summary")
	content := this.GetString("content")
	if "" == content {
		this.Data["json"] = map[string]interface{}{"code": 0, "message": "请填写正文"}
		this.ServeJSON()
		return
	}
	url := this.GetString("url")

	var err error
	var knowledge Knowledges
	knowledge.Sortid = sortid
	knowledge.Title = title
	knowledge.Tag = tag
	knowledge.Summary = summary
	knowledge.Content = content
	knowledge.Url = url

	err = UpdateKnowledge(id, knowledge)

	if err == nil {
		this.Data["json"] = map[string]interface{}{"code": 1, "message": "知识分享修改成功", "id": fmt.Sprintf("%d", id)}
	} else {
		this.Data["json"] = map[string]interface{}{"code": 0, "message": "知识分享修改失败"}
	}
	this.ServeJSON()
}
