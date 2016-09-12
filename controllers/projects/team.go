package projects

import (
	"fmt"
	"opms/controllers"
	. "opms/models/projects"
	. "opms/models/users"
	"opms/utils"
	"strconv"
	"strings"
)

//项目成员
type TeamProjectController struct {
	controllers.BaseController
}

func (this *TeamProjectController) Get() {
	//权限检测
	if !strings.Contains(this.GetSession("userPermission").(string), "project-team") {
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

	page, err := this.GetInt("p")
	if err != nil {
		page = 1
	}
	offset := 500
	_, _, teams := ListProjectTeam(idlong, page, offset)
	this.Data["teams"] = teams
	this.Data["countTeam"] = len(teams)
	this.TplName = "projects/team.tpl"
}

type AjaxDeleteTeamProjectController struct {
	controllers.BaseController
}

func (this *AjaxDeleteTeamProjectController) Post() {
	//权限检测
	if !strings.Contains(this.GetSession("userPermission").(string), "team-delete") {
		this.Data["json"] = map[string]interface{}{"code": 0, "message": "无权设置"}
		this.ServeJSON()
		return
	}
	id, _ := this.GetInt64("id")
	if id <= 0 {
		this.Data["json"] = map[string]interface{}{"code": 0, "message": "请选择用户"}
		this.ServeJSON()
		return
	}

	err := DeleteProjectTeam(id)

	if err == nil {
		this.Data["json"] = map[string]interface{}{"code": 1, "message": "成员删除成功"}
	} else {
		this.Data["json"] = map[string]interface{}{"code": 0, "message": "成员删除失败"}
	}
	this.ServeJSON()
}

type AddTeamProjectController struct {
	controllers.BaseController
}

func (this *AddTeamProjectController) Get() {
	//权限检测
	if !strings.Contains(this.GetSession("userPermission").(string), "team-add") {
		this.Abort("401")
	}
	idstr := this.Ctx.Input.Param(":id")
	id, err := strconv.Atoi(idstr)
	project, err := GetProject(int64(id))
	if err != nil {
		this.Abort("404")
	}
	this.Data["project"] = project
	this.TplName = "projects/team-form.tpl"
}

func (this *AddTeamProjectController) Post() {
	//权限检测
	if !strings.Contains(this.GetSession("userPermission").(string), "team-add") {
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
	userid, _ := this.GetInt64("userid")
	if userid <= 0 {
		this.Data["json"] = map[string]interface{}{"code": 0, "message": "请填写成员"}
		this.ServeJSON()
		return
	}
	realname := GetRealname(userid)
	if "" == realname {
		this.Data["json"] = map[string]interface{}{"code": 0, "message": "成员不存在"}
		this.ServeJSON()
		return
	}

	checkteam, _ := GetProjectTeam(userid, projectid)
	if checkteam.Userid > 0 {
		this.Data["json"] = map[string]interface{}{"code": 0, "message": "成员已经存在"}
		this.ServeJSON()
		return
	}

	var err error
	//雪花算法ID生成
	id := utils.SnowFlakeId()

	var team ProjectsTeam
	team.Id = id
	team.Userid = userid
	team.Projectid = projectid

	err = AddTeam(team)

	if err == nil {
		this.Data["json"] = map[string]interface{}{"code": 1, "message": "项目成员添加成功", "id": fmt.Sprintf("%d", id)}
	} else {
		this.Data["json"] = map[string]interface{}{"code": 0, "message": "项目成员添加失败"}
	}
	this.ServeJSON()
}
