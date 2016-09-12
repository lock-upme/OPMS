package resumes

import (
	"fmt"
	"opms/controllers"
	. "opms/models/resumes"
	"opms/utils"
	"os"
	"strconv"
	"strings"
	"time"

	"github.com/astaxie/beego"
	"github.com/astaxie/beego/utils/pagination"
)

//用户管理
type ManageResumeController struct {
	controllers.BaseController
}

func (this *ManageResumeController) Get() {
	//权限检测
	if !strings.Contains(this.GetSession("userPermission").(string), "resume-manage") {
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

	countResume := CountResumes(condArr)

	paginator := pagination.SetPaginator(this.Ctx, offset, countResume)
	_, _, resumes := ListResumes(condArr, page, offset)

	this.Data["paginator"] = paginator
	this.Data["condArr"] = condArr
	this.Data["resumes"] = resumes
	this.Data["countResume"] = countResume

	this.TplName = "resumes/index.tpl"
}

type AjaxStatusResumeController struct {
	controllers.BaseController
}

func (this *AjaxStatusResumeController) Post() {
	//权限检测
	if !strings.Contains(this.GetSession("userPermission").(string), "resume-edit") {
		this.Data["json"] = map[string]interface{}{"code": 0, "message": "无权设置"}
		this.ServeJSON()
		return
	}
	id, _ := this.GetInt64("id")
	if id <= 0 {
		this.Data["json"] = map[string]interface{}{"code": 0, "message": "请选择面试者"}
		this.ServeJSON()
		return
	}
	status, _ := this.GetInt("status")
	if status <= 0 || status > 5 {
		this.Data["json"] = map[string]interface{}{"code": 0, "message": "请选择操作状态"}
		this.ServeJSON()
		return
	}

	err := ChangeResumeStatus(id, status)

	if err == nil {
		this.Data["json"] = map[string]interface{}{"code": 1, "message": "状态更改成功"}
	} else {
		this.Data["json"] = map[string]interface{}{"code": 0, "message": "状态更改失败"}
	}
	this.ServeJSON()
}

//部门添加
type AddResumeController struct {
	controllers.BaseController
}

func (this *AddResumeController) Get() {
	//权限检测
	if !strings.Contains(this.GetSession("userPermission").(string), "resume-add") {
		this.Abort("401")
	}
	var resume Resumes
	resume.Sex = 1
	resume.Status = 1
	this.Data["resume"] = resume
	this.TplName = "resumes/form.tpl"
}

func (this *AddResumeController) Post() {
	//权限检测
	if !strings.Contains(this.GetSession("userPermission").(string), "resume-add") {
		this.Data["json"] = map[string]interface{}{"code": 0, "message": "无权设置"}
		this.ServeJSON()
		return
	}
	realname := this.GetString("realname")
	if "" == realname {
		this.Data["json"] = map[string]interface{}{"code": 0, "message": "请填写姓名"}
		this.ServeJSON()
		return
	}
	sex, _ := this.GetInt("sex")

	birthstr := this.GetString("birth")
	birthtmp, _ := time.Parse("2006-01-02", birthstr)
	birth := birthtmp.Unix()

	edu, _ := this.GetInt("edu")
	work, _ := this.GetInt("work")
	phone := this.GetString("phone")
	note := this.GetString("note")
	status, _ := this.GetInt("status")

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

	var res Resumes
	res.Id = utils.SnowFlakeId()
	res.Realname = realname
	res.Sex = sex
	res.Birth = birth
	res.Edu = edu
	res.Work = work
	res.Phone = phone
	res.Note = note
	res.Status = status
	res.Attachment = filepath
	err = AddResumes(res)

	if err == nil {
		this.Data["json"] = map[string]interface{}{"code": 1, "message": "添加成功"}
	} else {
		this.Data["json"] = map[string]interface{}{"code": 0, "message": "添加失败"}
	}
	this.ServeJSON()
}

//部门编辑
type EditResumeController struct {
	controllers.BaseController
}

func (this *EditResumeController) Get() {
	//权限检测
	if !strings.Contains(this.GetSession("userPermission").(string), "resume-edit") {
		this.Abort("401")
	}
	idstr := this.Ctx.Input.Param(":id")
	id, err := strconv.Atoi(idstr)
	resume, err := GetResumes(int64(id))
	if err != nil {
		this.Abort("404")
	}
	this.Data["resume"] = resume
	this.TplName = "resumes/form.tpl"
}

func (this *EditResumeController) Post() {
	//权限检测
	if !strings.Contains(this.GetSession("userPermission").(string), "resume-edit") {
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
	_, err := GetResumes(id)
	if err != nil {
		this.Data["json"] = map[string]interface{}{"code": 0, "message": "面试者不存在"}
		this.ServeJSON()
		return
	}
	realname := this.GetString("realname")
	sex, _ := this.GetInt("sex")
	birthstr := this.GetString("birth")
	birthtmp, _ := time.Parse("2006-01-02", birthstr)
	birth := birthtmp.Unix()
	edu, _ := this.GetInt("edu")
	work, _ := this.GetInt("work")
	phone := this.GetString("phone")
	note := this.GetString("note")
	status, _ := this.GetInt("status")

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

	var res Resumes
	res.Realname = realname
	res.Sex = sex
	res.Birth = birth
	res.Edu = edu
	res.Work = work
	res.Phone = phone
	res.Note = note
	res.Status = status
	res.Attachment = filepath
	err = UpdateResumes(id, res)

	if err == nil {
		this.Data["json"] = map[string]interface{}{"code": 1, "message": "信息修改成功", "id": fmt.Sprintf("%d", id)}
	} else {
		this.Data["json"] = map[string]interface{}{"code": 0, "message": "信息修改失败"}
	}
	this.ServeJSON()
}
