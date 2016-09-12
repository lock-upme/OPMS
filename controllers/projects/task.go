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

//我的任务
type MyTaskProjectController struct {
	controllers.BaseController
}

func (this *MyTaskProjectController) Get() {
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
	} else if filter == "complete" {
		condArr["completeid"] = fmt.Sprintf("%d", userid)
	} else if filter == "close" {
		condArr["closeid"] = fmt.Sprintf("%d", userid)
	} else if filter == "cancel" {
		condArr["cancelid"] = fmt.Sprintf("%d", userid)
	} else {
		condArr["acceptid"] = fmt.Sprintf("%d", userid)
		filter = "accept"
	}
	condArr["filter"] = filter
	countTask := CountTask(condArr)
	paginator := pagination.SetPaginator(this.Ctx, offset, countTask)
	_, _, tasks := ListProjectTask(condArr, page, offset)

	this.Data["tasks"] = tasks
	this.Data["paginator"] = paginator

	this.Data["condArr"] = condArr
	this.Data["countTask"] = countTask

	_, _, teams := ListProjectTeam(0, 1, 100)
	this.Data["teams"] = teams

	this.TplName = "projects/mytask.tpl"
}

//任务管理
type TaskProjectController struct {
	controllers.BaseController
}

func (this *TaskProjectController) Get() {
	//权限检测
	if !strings.Contains(this.GetSession("userPermission").(string), "project-task") {
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

	userid := this.BaseController.UserUserId

	status := this.GetString("status")
	stype := this.GetString("type")
	keywords := this.GetString("keywords")
	acceptid := this.GetString("acceptid")
	completeid := this.GetString("completeid")
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
	condArr["type"] = stype
	condArr["keywords"] = keywords
	condArr["acceptid"] = acceptid
	condArr["completeid"] = completeid
	var acceptids int64
	acceptidtmp, _ := strconv.Atoi(acceptid)
	acceptids = int64(acceptidtmp)
	this.Data["acceptid"] = acceptids

	filter := this.GetString("filter")
	if filter == "create" {
		condArr["userid"] = fmt.Sprintf("%d", userid)
	} else if filter == "complete" {
		condArr["completeid"] = fmt.Sprintf("%d", userid)
	} else if filter == "close" {
		condArr["closeid"] = fmt.Sprintf("%d", userid)
	} else if filter == "cancel" {
		condArr["cancelid"] = fmt.Sprintf("%d", userid)
	} else if filter == "accept" {
		condArr["acceptid"] = fmt.Sprintf("%d", userid)
		filter = "accept"
	}
	condArr["filter"] = filter

	countTask := CountTask(condArr)
	paginator := pagination.SetPaginator(this.Ctx, offset, countTask)
	_, _, tasks := ListProjectTask(condArr, page, offset)

	this.Data["tasks"] = tasks
	this.Data["paginator"] = paginator

	this.Data["condArr"] = condArr
	this.Data["countTask"] = countTask

	_, _, teams := ListProjectTeam(idlong, 1, 100)
	this.Data["teams"] = teams

	this.TplName = "projects/task.tpl"
}

type ShowTaskProjectController struct {
	controllers.BaseController
}

func (this *ShowTaskProjectController) Get() {
	idstr := this.Ctx.Input.Param(":id")
	id, _ := strconv.Atoi(idstr)
	task, _ := GetProjectTask(int64(id))
	this.Data["task"] = task

	project, _ := GetProject(task.Projectid)
	this.Data["project"] = project

	need, _ := GetProjectNeeds(task.Needsid)
	this.Data["need"] = need

	log := ListProjectTaskLog(task.Id)
	this.Data["log"] = log
	this.TplName = "projects/task-detail.tpl"
}

type AjaxStatusTaskController struct {
	controllers.BaseController
}

func (this *AjaxStatusTaskController) Post() {
	//权限检测
	if !strings.Contains(this.GetSession("userPermission").(string), "task-edit") {
		this.Data["json"] = map[string]interface{}{"code": 0, "message": "无权设置"}
		this.ServeJSON()
		return
	}
	id, _ := this.GetInt64("taskid")
	if id <= 0 {
		this.Data["json"] = map[string]interface{}{"code": 0, "message": "请选择任务"}
		this.ServeJSON()
		return
	}
	status, _ := this.GetInt("status")
	if status <= 0 || status >= 7 {
		this.Data["json"] = map[string]interface{}{"code": 0, "message": "请选择操作状态"}
		this.ServeJSON()
		return
	}
	err := ChangeProjectTaskStatus(id, this.BaseController.UserUserId, status)

	if err == nil {
		this.Data["json"] = map[string]interface{}{"code": 1, "message": "状态更改成功"}
	} else {
		this.Data["json"] = map[string]interface{}{"code": 0, "message": "状态更改失败"}
	}
	this.ServeJSON()
}

type AjaxAcceptTaskController struct {
	controllers.BaseController
}

func (this *AjaxAcceptTaskController) Post() {
	//权限检测
	if !strings.Contains(this.GetSession("userPermission").(string), "task-edit") {
		this.Data["json"] = map[string]interface{}{"code": 0, "message": "无权设置"}
		this.ServeJSON()
		return
	}
	id, _ := this.GetInt64("taskid")
	if id <= 0 {
		this.Data["json"] = map[string]interface{}{"code": 0, "message": "请选择任务"}
		this.ServeJSON()
		return
	}
	acceptid, _ := this.GetInt64("acceptid")
	note := this.GetString("note")

	err := ChangeProjectTaskAccept(id, acceptid, this.BaseController.UserUserId, note)

	if err == nil {
		this.Data["json"] = map[string]interface{}{"code": 1, "message": "指派成功"}
	} else {
		this.Data["json"] = map[string]interface{}{"code": 0, "message": "指派失败"}
	}
	this.ServeJSON()
}

type AddTaskProjectController struct {
	controllers.BaseController
}

func (this *AddTaskProjectController) Get() {
	//权限检测
	if !strings.Contains(this.GetSession("userPermission").(string), "task-add") {
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

	var task ProjectsTask
	task.Level = 0
	task.Started = time.Now().Unix()
	task.Ended = time.Now().Unix()
	task.Needsid, _ = this.GetInt64("needsid")
	this.Data["task"] = task

	needs := ListNeedsForForm(idlong, 1, 100)
	this.Data["needs"] = needs

	_, _, teams := ListProjectTeam(idlong, 1, 100)
	this.Data["teams"] = teams

	this.TplName = "projects/task-form.tpl"
}

func (this *AddTaskProjectController) Post() {
	//权限检测
	if !strings.Contains(this.GetSession("userPermission").(string), "task-add") {
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

	ccid := this.GetString("ccid")
	tasktype, _ := this.GetInt("type")

	needsid, _ := this.GetInt64("needsid")
	acceptid, _ := this.GetInt64("acceptid")
	level, _ := this.GetInt("level")
	tasktime, _ := this.GetInt("tasktime")

	startedstr := this.GetString("started")
	started, _ := time.Parse("2006-01-02", startedstr)
	startedtime := started.Unix()

	endedstr := this.GetString("ended")
	ended, _ := time.Parse("2006-01-02", endedstr)
	endedtime := ended.Unix()

	desc := this.GetString("desc")
	note := this.GetString("note")

	var filepath string
	f, h, err := this.GetFile("attachment")

	if err == nil {
		defer f.Close()

		//生成上传路径
		now := time.Now()
		dir := "./static/uploadfile/" + strconv.Itoa(now.Year()) + "-" + strconv.Itoa(int(now.Month())) + "/" + strconv.Itoa(now.Day())
		err1 := os.MkdirAll(dir, 0755)
		if err1 != nil {
			this.Data["json"] = map[string]interface{}{"code": 1, "message": "目录权限不够"}
			this.ServeJSON()
			return
		}
		filename := h.Filename
		if err != nil {
			this.Data["json"] = map[string]interface{}{"code": 0, "message": err}
			this.ServeJSON()
			return
		} else {
			this.SaveToFile("attachment", dir+"/"+filename)
			filepath = strings.Replace(dir, ".", "", 1) + "/" + filename
		}
	}

	//var err error
	//雪花算法ID生成
	id := utils.SnowFlakeId()

	var task ProjectsTask
	task.Id = id
	task.Needsid = needsid
	task.Projectid = projectid
	task.Userid = userid
	task.Acceptid = acceptid
	task.Ccid = ccid
	task.Name = name
	task.Desc = desc
	task.Note = note
	task.Type = tasktype
	task.Level = level
	task.Tasktime = tasktime
	task.Started = startedtime
	task.Ended = endedtime
	task.Attachment = filepath

	err = AddTask(task)

	if err == nil {
		this.Data["json"] = map[string]interface{}{"code": 1, "message": "任务添加成功", "id": fmt.Sprintf("%d", id)}
	} else {
		this.Data["json"] = map[string]interface{}{"code": 0, "message": "任务添加失败"}
	}
	this.ServeJSON()
}

type EditTaskProjectController struct {
	controllers.BaseController
}

func (this *EditTaskProjectController) Get() {
	//权限检测
	if !strings.Contains(this.GetSession("userPermission").(string), "task-edit") {
		this.Abort("401")
	}
	idstr := this.Ctx.Input.Param(":id")
	id, _ := strconv.Atoi(idstr)
	task, _ := GetProjectTask(int64(id))

	project, err := GetProject(task.Projectid)
	if err != nil {
		this.Abort("404")
	}
	this.Data["project"] = project
	this.Data["task"] = task

	ccids := strings.Split(task.Ccid, ",")
	var ccidsmap = make(map[int]int64)
	for i, v := range ccids {
		ccid, _ := strconv.Atoi(v)
		ccidsmap[i] = int64(ccid)
	}
	this.Data["ccids"] = ccidsmap

	needs := ListNeedsForForm(task.Projectid, 1, 100)
	this.Data["needs"] = needs

	_, _, teams := ListProjectTeam(task.Projectid, 1, 100)
	this.Data["teams"] = teams

	this.TplName = "projects/task-form.tpl"
}

func (this *EditTaskProjectController) Post() {
	//权限检测
	if !strings.Contains(this.GetSession("userPermission").(string), "task-edit") {
		this.Data["json"] = map[string]interface{}{"code": 0, "message": "无权设置"}
		this.ServeJSON()
		return
	}
	taskid, _ := this.GetInt64("id")
	if taskid <= 0 {
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

	ccid := this.GetString("ccid")
	tasktype, _ := this.GetInt("type")

	needsid, _ := this.GetInt64("needsid")
	acceptid, _ := this.GetInt64("acceptid")
	level, _ := this.GetInt("level")
	tasktime, _ := this.GetInt("tasktime")

	startedstr := this.GetString("started")
	started, _ := time.Parse("2006-01-02", startedstr)
	startedtime := started.Unix()

	endedstr := this.GetString("ended")
	ended, _ := time.Parse("2006-01-02", endedstr)
	endedtime := ended.Unix()

	desc := this.GetString("desc")
	note := this.GetString("note")

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
		filename := h.Filename
		if err != nil {
			this.Data["json"] = map[string]interface{}{"code": 0, "message": err}
			this.ServeJSON()
			return
		} else {
			this.SaveToFile("attachment", dir+"/"+filename)
			filepath = strings.Replace(dir, ".", "", 1) + "/" + filename
		}
	}

	var task ProjectsTask
	task.Needsid = needsid
	task.Acceptid = acceptid
	task.Ccid = ccid
	task.Name = name
	task.Desc = desc
	task.Note = note
	task.Type = tasktype
	task.Level = level
	task.Tasktime = tasktime
	task.Started = startedtime
	task.Ended = endedtime
	task.Attachment = filepath
	task.Userid = this.BaseController.UserUserId

	err = UpdateTask(taskid, task)

	if err == nil {
		this.Data["json"] = map[string]interface{}{"code": 1, "message": "任务编辑成功"}
	} else {
		this.Data["json"] = map[string]interface{}{"code": 0, "message": "任务编辑失败"}
	}
	this.ServeJSON()
}

type DeleteTaskProjectController struct {
	controllers.BaseController
}

func (this *DeleteTaskProjectController) Post() {
	//权限检测
	if !strings.Contains(this.GetSession("userPermission").(string), "task-edit") {
		this.Data["json"] = map[string]interface{}{"code": 0, "message": "无权设置"}
		this.ServeJSON()
		return
	}
	taskid, _ := this.GetInt64("id")
	if taskid <= 0 {
		this.Data["json"] = map[string]interface{}{"code": 0, "message": "参数出错"}
		this.ServeJSON()
		return
	}

	err := DeleteProjectTask(taskid)
	if err == nil {
		this.Data["json"] = map[string]interface{}{"code": 1, "message": "删除任务成功"}
	} else {
		this.Data["json"] = map[string]interface{}{"code": 0, "message": "删除任务失败"}
	}
	this.ServeJSON()
}
