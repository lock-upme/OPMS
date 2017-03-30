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

//文档管理
type DocProjectController struct {
	controllers.BaseController
}

func (this *DocProjectController) Get() {
	if !strings.Contains(this.GetSession("userPermission").(string), "project-doc") {
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

	sort := this.GetString("sort")
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
	condArr["sort"] = sort
	condArr["keywords"] = keywords

	countDocs := CountDocs(condArr)

	paginator := pagination.SetPaginator(this.Ctx, offset, countDocs)
	_, _, doc := ListProjectDocs(condArr, page, offset)

	this.Data["paginator"] = paginator
	this.Data["condArr"] = condArr
	this.Data["docs"] = doc
	this.Data["countDocs"] = countDocs

	this.TplName = "projects/doc.tpl"
}

type FormDocProjectController struct {
	controllers.BaseController
}

func (this *FormDocProjectController) Get() {
	uri := this.Ctx.Request.RequestURI
	uriarr := strings.Split(uri, "/")
	var projectId int64
	if uriarr[2] == "edit" {
		//权限检测
		if !strings.Contains(this.GetSession("userPermission").(string), "doc-edit") {
			this.Abort("401")
		}
		idstr := this.Ctx.Input.Param(":id")
		id, _ := strconv.Atoi(idstr)
		doc, _ := GetProjectDocs(int64(id))
		this.Data["docs"] = doc
		projectId = doc.Projectid
	} else if uriarr[2] == "add" {
		//权限检测
		if !strings.Contains(this.GetSession("userPermission").(string), "doc-add") {
			this.Abort("401")
		}
		var doc ProjectsDocs
		doc.Sort = 1
		this.Data["docs"] = doc
		idstr := this.Ctx.Input.Param(":id")
		id, _ := strconv.Atoi(idstr)
		projectId = int64(id)
	}

	project, err := GetProject(projectId)
	if err != nil {
		this.Abort("404")
	}
	this.Data["project"] = project

	this.TplName = "projects/doc-form.tpl"
}

func (this *FormDocProjectController) Post() {
	//权限检测
	title := this.GetString("title")
	if "" == title {
		this.Data["json"] = map[string]interface{}{"code": 0, "message": "请填写名称"}
		this.ServeJSON()
		return
	}
	keyword := this.GetString("keyword")
	sort, _ := this.GetInt("sort")
	content := this.GetString("content")
	url := this.GetString("url")
	projectid, _ := this.GetInt64("projectid")
	userid := this.BaseController.UserUserId

	var doc ProjectsDocs
	doc.Userid = userid
	doc.Projectid = projectid
	doc.Title = title
	doc.Keyword = keyword
	doc.Sort = sort
	doc.Content = content
	doc.Url = url

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
	doc.Attachment = filepath

	docid, _ := this.GetInt64("id")
	if docid <= 0 {
		docid = utils.SnowFlakeId()
		doc.Id = docid
		err = AddDocs(doc)
	} else {
		err = UpdateDocs(docid, doc)
	}

	if err == nil {
		this.Data["json"] = map[string]interface{}{"code": 1, "message": "操作成功", "id": fmt.Sprintf("%d", docid)}
	} else {
		this.Data["json"] = map[string]interface{}{"code": 0, "message": "添加失败"}
	}
	this.ServeJSON()
}

type ShowDocProjectController struct {
	controllers.BaseController
}

func (this *ShowDocProjectController) Get() {
	//权限检测
	if !strings.Contains(this.GetSession("userPermission").(string), "doc-view") {
		this.Abort("401")
	}
	idstr := this.Ctx.Input.Param(":id")
	id, _ := strconv.Atoi(idstr)

	doc, _ := GetProjectDocs(int64(id))

	project, err := GetProject(doc.Projectid)
	if err != nil {
		this.Abort("404")
	}
	this.Data["project"] = project
	this.Data["docs"] = doc
	this.TplName = "projects/doc-detail.tpl"
}

type AjaxDeleteDocPorjectController struct {
	controllers.BaseController
}

func (this *AjaxDeleteDocPorjectController) Post() {
	//权限检测
	if !strings.Contains(this.GetSession("userPermission").(string), "doc-delete") {
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

	err := DeleteDoc(ids, this.BaseController.UserUserId)

	if err == nil {
		this.Data["json"] = map[string]interface{}{"code": 1, "message": "删除成功"}
	} else {
		this.Data["json"] = map[string]interface{}{"code": 0, "message": "删除失败"}
	}
	this.ServeJSON()
}
