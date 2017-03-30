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

//版本管理
type VersionProjectController struct {
	controllers.BaseController
}

func (this *VersionProjectController) Get() {
	if !strings.Contains(this.GetSession("userPermission").(string), "project-version") {
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

	keywords := this.GetString("keywords")
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
	condArr["keywords"] = keywords

	countVersions := CountVersions(condArr)

	paginator := pagination.SetPaginator(this.Ctx, offset, countVersions)
	_, _, version := ListProjectVersions(condArr, page, offset)

	this.Data["paginator"] = paginator
	this.Data["condArr"] = condArr
	this.Data["versions"] = version
	this.Data["countVersions"] = countVersions

	this.TplName = "projects/version.tpl"
}

type FormVersionProjectController struct {
	controllers.BaseController
}

func (this *FormVersionProjectController) Get() {
	uri := this.Ctx.Request.RequestURI
	uriarr := strings.Split(uri, "/")
	var projectId int64
	if uriarr[2] == "edit" {
		//权限检测
		if !strings.Contains(this.GetSession("userPermission").(string), "version-edit") {
			this.Abort("401")
		}
		idstr := this.Ctx.Input.Param(":id")
		id, _ := strconv.Atoi(idstr)
		version, _ := GetProjectVersions(int64(id))
		this.Data["versions"] = version
		projectId = version.Projectid
	} else if uriarr[2] == "add" {
		//权限检测
		if !strings.Contains(this.GetSession("userPermission").(string), "version-add") {
			//this.Abort("401")
		}
		var version ProjectsVersions
		this.Data["versions"] = version
		idstr := this.Ctx.Input.Param(":id")
		id, _ := strconv.Atoi(idstr)
		projectId = int64(id)
	}

	project, err := GetProject(projectId)
	if err != nil {
		this.Abort("404")
	}
	this.Data["project"] = project

	this.TplName = "projects/version-form.tpl"
}

func (this *FormVersionProjectController) Post() {
	//权限检测
	title := this.GetString("title")
	if "" == title {
		this.Data["json"] = map[string]interface{}{"code": 0, "message": "请填写名称"}
		this.ServeJSON()
		return
	}
	versioned := this.GetString("versioned")
	content := this.GetString("content")
	sourceurl := this.GetString("sourceurl")
	downurl := this.GetString("downurl")
	projectid, _ := this.GetInt64("projectid")
	userid := this.BaseController.UserUserId

	var version ProjectsVersions
	version.Userid = userid
	version.Projectid = projectid
	version.Title = title
	version.Versioned = utils.GetDateParse(versioned)
	version.Sourceurl = sourceurl
	version.Content = content
	version.Downurl = downurl

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
	version.Attachment = filepath

	versionid, _ := this.GetInt64("id")
	if versionid <= 0 {
		versionid = utils.SnowFlakeId()
		version.Id = versionid
		err = AddVersions(version)
	} else {
		err = UpdateVersions(versionid, version)
	}

	if err == nil {
		this.Data["json"] = map[string]interface{}{"code": 1, "message": "操作成功", "id": fmt.Sprintf("%d", versionid)}
	} else {
		this.Data["json"] = map[string]interface{}{"code": 0, "message": "添加失败"}
	}
	this.ServeJSON()
}

type ShowVersionProjectController struct {
	controllers.BaseController
}

func (this *ShowVersionProjectController) Get() {
	//权限检测
	if !strings.Contains(this.GetSession("userPermission").(string), "version-view") {
		this.Abort("401")
	}
	idstr := this.Ctx.Input.Param(":id")
	id, _ := strconv.Atoi(idstr)

	version, _ := GetProjectVersions(int64(id))

	project, err := GetProject(version.Projectid)
	if err != nil {
		this.Abort("404")
	}
	this.Data["project"] = project
	this.Data["versions"] = version
	this.TplName = "projects/version-detail.tpl"
}

type AjaxDeleteVersionPorjectController struct {
	controllers.BaseController
}

func (this *AjaxDeleteVersionPorjectController) Post() {
	//权限检测
	if !strings.Contains(this.GetSession("userPermission").(string), "version-delete") {
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

	err := DeleteVersion(ids, this.BaseController.UserUserId)

	if err == nil {
		this.Data["json"] = map[string]interface{}{"code": 1, "message": "删除成功"}
	} else {
		this.Data["json"] = map[string]interface{}{"code": 0, "message": "删除失败"}
	}
	this.ServeJSON()
}
