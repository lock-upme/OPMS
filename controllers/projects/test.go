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

type MyTestProjectController struct {
	controllers.BaseController
}

func (this *MyTestProjectController) Get() {
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
	} else {
		condArr["acceptid"] = fmt.Sprintf("%d", userid)
		filter = "accept"
	}
	condArr["filter"] = filter

	countTest := CountTest(condArr)
	paginator := pagination.SetPaginator(this.Ctx, offset, countTest)
	_, _, tests := ListProjectTest(condArr, page, offset)

	this.Data["tests"] = tests
	this.Data["paginator"] = paginator

	this.Data["condArr"] = condArr
	this.Data["countTest"] = countTest

	_, _, teams := ListProjectTeam(0, 1, 100)
	this.Data["teams"] = teams

	this.TplName = "projects/mytest.tpl"
}

type TestProjectController struct {
	controllers.BaseController
}

func (this *TestProjectController) Get() {
	//权限检测
	if !strings.Contains(this.GetSession("userPermission").(string), "project-test") {
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
	} else if filter == "accept" {
		condArr["acceptid"] = fmt.Sprintf("%d", userid)
		filter = "accept"
	}
	condArr["filter"] = filter

	countTest := CountTest(condArr)
	paginator := pagination.SetPaginator(this.Ctx, offset, countTest)
	_, _, tests := ListProjectTest(condArr, page, offset)

	this.Data["tests"] = tests
	this.Data["paginator"] = paginator

	this.Data["condArr"] = condArr
	this.Data["countTest"] = countTest
	this.Data["title"] = "项目测试"

	_, _, teams := ListProjectTeam(idlong, 1, 100)
	this.Data["teams"] = teams

	this.TplName = "projects/test.tpl"
}

type ShowTestProjectController struct {
	controllers.BaseController
}

func (this *ShowTestProjectController) Get() {
	idstr := this.Ctx.Input.Param(":id")
	id, _ := strconv.Atoi(idstr)
	test, _ := GetProjectTest(int64(id))
	this.Data["test"] = test

	project, _ := GetProject(test.Projectid)
	this.Data["project"] = project

	need, _ := GetProjectNeeds(test.Needsid)
	this.Data["need"] = need

	log := ListProjectTestLog(test.Id)
	this.Data["log"] = log
	this.TplName = "projects/test-detail.tpl"
}

type AjaxStatusTestController struct {
	controllers.BaseController
}

func (this *AjaxStatusTestController) Post() {
	//权限检测
	if !strings.Contains(this.GetSession("userPermission").(string), "test-edit") {
		this.Data["json"] = map[string]interface{}{"code": 0, "message": "无权设置"}
		this.ServeJSON()
		return
	}
	id, _ := this.GetInt64("testid")
	if id <= 0 {
		this.Data["json"] = map[string]interface{}{"code": 0, "message": "请选择测试"}
		this.ServeJSON()
		return
	}
	status, _ := this.GetInt("status")
	if status <= 0 || status >= 7 {
		this.Data["json"] = map[string]interface{}{"code": 0, "message": "请选择操作状态"}
		this.ServeJSON()
		return
	}

	note := this.GetString("note")
	err := ChangeProjectTestStatus(id, this.BaseController.UserUserId, status, note)

	if err == nil {
		this.Data["json"] = map[string]interface{}{"code": 1, "message": "解决方案更改成功"}
	} else {
		this.Data["json"] = map[string]interface{}{"code": 0, "message": "状态更改失败"}
	}
	this.ServeJSON()
}

type AjaxAcceptTestController struct {
	controllers.BaseController
}

func (this *AjaxAcceptTestController) Post() {
	//权限检测
	if !strings.Contains(this.GetSession("userPermission").(string), "test-edit") {
		this.Data["json"] = map[string]interface{}{"code": 0, "message": "无权设置"}
		this.ServeJSON()
		return
	}
	id, _ := this.GetInt64("testid")
	if id <= 0 {
		this.Data["json"] = map[string]interface{}{"code": 0, "message": "请选择测试"}
		this.ServeJSON()
		return
	}
	acceptid, _ := this.GetInt64("acceptid")
	note := this.GetString("note")

	err := ChangeProjectTestAccept(id, acceptid, this.BaseController.UserUserId, note)

	if err == nil {
		this.Data["json"] = map[string]interface{}{"code": 1, "message": "指派成功"}
	} else {
		this.Data["json"] = map[string]interface{}{"code": 0, "message": "指派失败"}
	}
	this.ServeJSON()
}

type AddTestProjectController struct {
	controllers.BaseController
}

func (this *AddTestProjectController) Get() {
	//权限检测
	if !strings.Contains(this.GetSession("userPermission").(string), "test-add") {
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

	var test ProjectsTest
	test.Level = 0
	this.Data["test"] = test

	needs := ListNeedsForForm(idlong, 1, 100)
	this.Data["needs"] = needs

	tasks := ListTaskForForm(idlong, 1, 100)
	this.Data["tasks"] = tasks

	_, _, teams := ListProjectTeam(idlong, 1, 100)
	this.Data["teams"] = teams

	this.TplName = "projects/test-form.tpl"
}

func (this *AddTestProjectController) Post() {
	//权限检测
	if !strings.Contains(this.GetSession("userPermission").(string), "test-add") {
		this.Data["json"] = map[string]interface{}{"code": 0, "message": "无权设置"}
		this.ServeJSON()
		return
	}
	projectid, _ := this.GetInt64("projectid")
	if projectid < 0 {
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
	taskid, _ := this.GetInt64("taskid")

	needsid, _ := this.GetInt64("needsid")
	acceptid, _ := this.GetInt64("acceptid")
	level, _ := this.GetInt("level")

	desc := this.GetString("desc")
	osystem := this.GetString("os")
	browser := this.GetString("browser")

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

	var test ProjectsTest
	test.Id = id
	test.Taskid = taskid
	test.Needsid = needsid
	test.Projectid = projectid
	test.Userid = userid
	test.Acceptid = acceptid
	test.Ccid = ccid
	test.Name = name
	test.Desc = desc
	test.Level = level
	test.Os = osystem
	test.Browser = browser
	test.Attachment = filepath

	err = AddTest(test)

	if err == nil {
		this.Data["json"] = map[string]interface{}{"code": 1, "message": "测试添加成功", "id": fmt.Sprintf("%d", id)}
	} else {
		this.Data["json"] = map[string]interface{}{"code": 0, "message": "测试添加失败"}
	}
	this.ServeJSON()
}

type EditTestProjectController struct {
	controllers.BaseController
}

func (this *EditTestProjectController) Get() {
	//权限检测
	if !strings.Contains(this.GetSession("userPermission").(string), "test-edit") {
		this.Abort("401")
	}
	idstr := this.Ctx.Input.Param(":id")
	id, _ := strconv.Atoi(idstr)
	test, _ := GetProjectTest(int64(id))

	project, err := GetProject(test.Projectid)
	if err != nil {
		this.Abort("404")
	}
	this.Data["project"] = project
	this.Data["test"] = test

	ccids := strings.Split(test.Ccid, ",")
	var ccidsmap = make(map[int]int64)
	for i, v := range ccids {
		ccid, _ := strconv.Atoi(v)
		ccidsmap[i] = int64(ccid)
	}
	this.Data["ccids"] = ccidsmap

	needs := ListNeedsForForm(test.Projectid, 1, 100)
	this.Data["needs"] = needs

	tasks := ListTaskForForm(test.Projectid, 1, 100)
	this.Data["tasks"] = tasks

	_, _, teams := ListProjectTeam(test.Projectid, 1, 100)
	this.Data["teams"] = teams

	this.TplName = "projects/test-form.tpl"
}

func (this *EditTestProjectController) Post() {
	//权限检测
	if !strings.Contains(this.GetSession("userPermission").(string), "test-edit") {
		this.Data["json"] = map[string]interface{}{"code": 0, "message": "无权设置"}
		this.ServeJSON()
		return
	}
	testid, _ := this.GetInt64("id")
	if testid <= 0 {
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

	taskid, _ := this.GetInt64("taskid")
	needsid, _ := this.GetInt64("needsid")
	acceptid, _ := this.GetInt64("acceptid")
	level, _ := this.GetInt("level")
	desc := this.GetString("desc")
	osystem := this.GetString("os")
	browser := this.GetString("browser")

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

	var test ProjectsTest
	test.Taskid = taskid
	test.Needsid = needsid
	test.Acceptid = acceptid
	test.Ccid = ccid
	test.Name = name
	test.Desc = desc
	test.Level = level
	test.Os = osystem
	test.Browser = browser
	test.Attachment = filepath
	test.Userid = this.BaseController.UserUserId

	err = UpdateTest(testid, test)

	if err == nil {
		this.Data["json"] = map[string]interface{}{"code": 1, "message": "测试编辑成功"}
	} else {
		this.Data["json"] = map[string]interface{}{"code": 0, "message": "测试编辑失败"}
	}
	this.ServeJSON()
}

type DeleteTestProjectController struct {
	controllers.BaseController
}

func (this *DeleteTestProjectController) Post() {
	//权限检测
	if !strings.Contains(this.GetSession("userPermission").(string), "test-edit") {
		this.Data["json"] = map[string]interface{}{"code": 0, "message": "无权设置"}
		this.ServeJSON()
		return
	}
	testid, _ := this.GetInt64("id")
	if testid <= 0 {
		this.Data["json"] = map[string]interface{}{"code": 0, "message": "参数出错"}
		this.ServeJSON()
		return
	}

	err := DeleteProjectTest(testid)
	if err == nil {
		this.Data["json"] = map[string]interface{}{"code": 1, "message": "删除Bug成功"}
	} else {
		this.Data["json"] = map[string]interface{}{"code": 0, "message": "删除Bug失败"}
	}
	this.ServeJSON()
}
