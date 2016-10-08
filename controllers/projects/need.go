package projects

import (
	"fmt"
	"opms/controllers"
	. "opms/models/projects"
	"opms/utils"
	"os"
	"strconv"
	"strings"
	"time"

	"github.com/astaxie/beego"
	"github.com/astaxie/beego/utils/pagination"
)

type MyNeedProjectController struct {
	controllers.BaseController
}

func (this *MyNeedProjectController) Get() {
	userid := this.BaseController.UserUserId

	page, err := this.GetInt("p")
	if err != nil {
		page = 1
	}

	offset, err1 := beego.AppConfig.Int("pageoffset")
	if err1 != nil {
		offset = 15
	}

	condArr := make(map[string]string)

	filter := this.GetString("filter")
	if filter == "create" {
		condArr["userid"] = fmt.Sprintf("%d", userid)
	} else {
		condArr["acceptid"] = fmt.Sprintf("%d", userid)
		filter = "accept"
	}
	condArr["filter"] = filter

	countNeeds := CountNeeds(condArr)
	paginator := pagination.SetPaginator(this.Ctx, offset, countNeeds)
	_, _, needs := ListProjectNeeds(condArr, page, offset)

	this.Data["needs"] = needs
	this.Data["paginator"] = paginator

	this.Data["condArr"] = condArr
	this.Data["countNeeds"] = countNeeds

	_, _, teams := ListProjectTeam(0, 1, 100)
	this.Data["teams"] = teams

	this.TplName = "projects/myneeds.tpl"
}

type NeedsProjectController struct {
	controllers.BaseController
}

func (this *NeedsProjectController) Get() {
	//权限检测
	if !strings.Contains(this.GetSession("userPermission").(string), "project-need") {
		this.Abort("401")
	}
	idstr := this.Ctx.Input.Param(":id")
	id, err := strconv.Atoi(idstr)
	idlong := int64(id)
	project, err := GetProject(idlong)
	if err != nil {
		this.Abort("404")
	}
	this.Data["project"] = project

	status := this.GetString("status")
	stage := this.GetString("stage")
	keywords := this.GetString("keywords")
	acceptid := this.GetString("acceptid")
	page, err := this.GetInt("p")
	if err != nil {
		page = 1
	}

	offset, err1 := beego.AppConfig.Int("pageoffset")
	if err1 != nil {
		offset = 15
	}

	condArr := make(map[string]string)
	condArr["projectid"] = idstr
	condArr["status"] = status
	condArr["stage"] = stage
	condArr["keywords"] = keywords
	condArr["acceptid"] = acceptid

	var acceptids int64
	acceptidtmp, _ := strconv.Atoi(acceptid)
	acceptids = int64(acceptidtmp)
	this.Data["acceptid"] = acceptids

	countNeeds := CountNeeds(condArr)

	paginator := pagination.SetPaginator(this.Ctx, offset, countNeeds)
	_, _, needs := ListProjectNeeds(condArr, page, offset)

	this.Data["paginator"] = paginator
	this.Data["condArr"] = condArr
	this.Data["needs"] = needs
	this.Data["countNeeds"] = countNeeds

	_, _, teams := ListProjectTeam(idlong, 1, 100)
	this.Data["teams"] = teams

	this.TplName = "projects/needs.tpl"
}

type ShowNeedsProjectController struct {
	controllers.BaseController
}

func (this *ShowNeedsProjectController) Get() {
	idstr := this.Ctx.Input.Param(":id")
	id, _ := strconv.Atoi(idstr)
	needs, _ := GetProjectNeeds(int64(id))

	project, err := GetProject(needs.Projectid)
	if err != nil {
		this.Abort("404")
	}
	this.Data["project"] = project
	this.Data["needs"] = needs
	this.TplName = "projects/needs-detail.tpl"
}

type AjaxStatusNeedProjectController struct {
	controllers.BaseController
}

func (this *AjaxStatusNeedProjectController) Post() {
	//权限检测
	if !strings.Contains(this.GetSession("userPermission").(string), "need-edit") {
		this.Data["json"] = map[string]interface{}{"code": 0, "message": "无权设置"}
		this.ServeJSON()
		return
	}
	id, _ := this.GetInt64("id")
	if id <= 0 {
		this.Data["json"] = map[string]interface{}{"code": 0, "message": "请选择需求"}
		this.ServeJSON()
		return
	}
	status, _ := this.GetInt("status")
	if status < 0 || status >= 6 {
		this.Data["json"] = map[string]interface{}{"code": 0, "message": "请选择操作状态"}
		this.ServeJSON()
		return
	}

	err := ChangeProjectNeedsStatus(id, status)

	if err == nil {
		this.Data["json"] = map[string]interface{}{"code": 1, "message": "状态更改成功"}
	} else {
		this.Data["json"] = map[string]interface{}{"code": 0, "message": "状态更改失败"}
	}
	this.ServeJSON()
}

type AddNeedsProjectController struct {
	controllers.BaseController
}

func (this *AddNeedsProjectController) Get() {
	//权限检测
	if !strings.Contains(this.GetSession("userPermission").(string), "need-add") {
		this.Abort("401")
	}
	idstr := this.Ctx.Input.Param(":id")
	id, err := strconv.Atoi(idstr)
	project, err := GetProject(int64(id))
	if err != nil {
		this.Abort("404")
	}
	this.Data["project"] = project

	var needs ProjectsNeeds
	needs.Source = 0
	needs.Level = 0
	this.Data["needs"] = needs

	_, _, teams := ListProjectTeam(project.Id, 1, 100)
	this.Data["teams"] = teams

	this.TplName = "projects/needs-form.tpl"
}

func (this *AddNeedsProjectController) Post() {
	//权限检测
	if !strings.Contains(this.GetSession("userPermission").(string), "need-add") {
		this.Data["json"] = map[string]interface{}{"code": 0, "message": "无权设置"}
		this.ServeJSON()
		return
	}
	projectid, _ := this.GetInt64("projectid")
	if projectid <= 0 {
		this.Data["json"] = map[string]interface{}{"code": 0, "message": "请选择项目"}
		this.ServeJSON()
		return
	}
	userid := this.BaseController.UserUserId
	name := this.GetString("name")
	if "" == name {
		this.Data["json"] = map[string]interface{}{"code": 0, "message": "请填写名称"}
		this.ServeJSON()
		return
	}
	source, _ := this.GetInt("source")

	level, _ := this.GetInt("level")
	tasktime, _ := this.GetInt("tasktime")
	desc := this.GetString("desc")
	acceptid, _ := this.GetInt64("acceptid")
	stage, _ := this.GetInt("stage")
	acceptance := this.GetString("acceptance")

	var filepath string
	f, h, err := this.GetFile("attachment")

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
		//ext := utils.SubString(filename, strings.LastIndex(filename, "."), 5)
		//filename = utils.GetGuid() + ext

		if err != nil {
			this.Data["json"] = map[string]interface{}{"code": 0, "message": err}
			this.ServeJSON()
			return
		} else {
			//this.SaveToFile("imgFile", "./static/uploadfile/"+h.Filename)
			this.SaveToFile("attachment", dir+"/"+filename)
			filepath = strings.Replace(dir, ".", "", 1) + "/" + filename
		}
	}

	//var err error
	//雪花算法ID生成
	id := utils.SnowFlakeId()

	var needs ProjectsNeeds
	needs.Id = id
	needs.Userid = userid
	needs.Projectid = projectid
	needs.Name = name
	needs.Source = source
	needs.Level = level
	needs.Tasktime = tasktime
	needs.Desc = desc
	needs.Acceptid = acceptid
	needs.Acceptance = acceptance
	needs.Attachment = filepath
	needs.Stage = stage
	needs.Status = 2

	err = AddNeeds(needs)

	if err == nil {
		this.Data["json"] = map[string]interface{}{"code": 1, "message": "需求添加成功", "id": fmt.Sprintf("%d", id)}
	} else {
		this.Data["json"] = map[string]interface{}{"code": 0, "message": "需求添加失败"}
	}
	this.ServeJSON()
}

type EditNeedsProjectController struct {
	controllers.BaseController
}

func (this *EditNeedsProjectController) Get() {
	//权限检测
	if !strings.Contains(this.GetSession("userPermission").(string), "need-edit") {
		this.Abort("401")
	}
	idstr := this.Ctx.Input.Param(":id")
	id, _ := strconv.Atoi(idstr)
	needs, _ := GetProjectNeeds(int64(id))

	project, err := GetProject(needs.Projectid)
	if err != nil {
		this.Abort("404")
	}
	this.Data["project"] = project
	this.Data["needs"] = needs

	_, _, teams := ListProjectTeam(project.Id, 1, 100)
	this.Data["teams"] = teams

	this.TplName = "projects/needs-form.tpl"
}

func (this *EditNeedsProjectController) Post() {
	//权限检测
	if !strings.Contains(this.GetSession("userPermission").(string), "need-edit") {
		this.Data["json"] = map[string]interface{}{"code": 0, "message": "无权设置"}
		this.ServeJSON()
		return
	}
	needsid, _ := this.GetInt64("id")
	if needsid <= 0 {
		this.Data["json"] = map[string]interface{}{"code": 0, "message": "参数出错"}
		this.ServeJSON()
		return
	}

	name := this.GetString("name")
	if "" == name {
		this.Data["json"] = map[string]interface{}{"code": 0, "message": "请填写名称"}
		this.ServeJSON()
		return
	}
	source, _ := this.GetInt("source")

	level, _ := this.GetInt("level")
	tasktime, _ := this.GetInt("tasktime")
	desc := this.GetString("desc")
	acceptid, _ := this.GetInt64("acceptid")
	stage, _ := this.GetInt("stage")
	acceptance := this.GetString("acceptance")

	var filepath string
	f, h, err := this.GetFile("attachment")

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
		//ext := utils.SubString(filename, strings.LastIndex(filename, "."), 5)
		//filename = utils.GetGuid() + ext

		if err != nil {
			this.Data["json"] = map[string]interface{}{"code": 0, "message": err}
			this.ServeJSON()
			return
		} else {
			//this.SaveToFile("imgFile", "./static/uploadfile/"+h.Filename)
			this.SaveToFile("attachment", dir+"/"+filename)
			filepath = strings.Replace(dir, ".", "", 1) + "/" + filename
		}
	}

	var needs ProjectsNeeds
	needs.Name = name
	needs.Source = source
	needs.Level = level
	needs.Tasktime = tasktime
	needs.Desc = desc
	needs.Acceptid = acceptid
	needs.Acceptance = acceptance
	needs.Attachment = filepath
	needs.Stage = stage
	err = UpdateNeeds(needsid, needs)

	if err == nil {
		this.Data["json"] = map[string]interface{}{"code": 1, "message": "需求编辑成功"}
	} else {
		this.Data["json"] = map[string]interface{}{"code": 0, "message": "需求编辑失败"}
	}
	this.ServeJSON()
}
