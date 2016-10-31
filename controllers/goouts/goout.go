package goouts

import (
	"fmt"
	"opms/controllers"
	. "opms/models/goouts"
	. "opms/models/messages"
	. "opms/models/users"
	"opms/utils"
	"os"
	"strconv"
	"strings"
	"time"

	"github.com/astaxie/beego"
	"github.com/astaxie/beego/utils/pagination"
)

//我的
type ManageGooutController struct {
	controllers.BaseController
}

func (this *ManageGooutController) Get() {
	//权限检测
	if !strings.Contains(this.GetSession("userPermission").(string), "goout-manage") {
		this.Abort("401")
	}
	page, err := this.GetInt("p")
	status := this.GetString("status")
	result := this.GetString("result")

	if err != nil {
		page = 1
	}

	offset, err1 := beego.AppConfig.Int("pageoffset")
	if err1 != nil {
		offset = 15
	}

	condArr := make(map[string]string)
	condArr["status"] = status
	condArr["result"] = result
	condArr["userid"] = fmt.Sprintf("%d", this.BaseController.UserUserId)

	countGoout := CountGoout(condArr)

	paginator := pagination.SetPaginator(this.Ctx, offset, countGoout)
	_, _, goouts := ListGoout(condArr, page, offset)

	this.Data["paginator"] = paginator
	this.Data["condArr"] = condArr
	this.Data["goouts"] = goouts
	this.Data["countGoout"] = countGoout

	this.TplName = "goouts/index.tpl"
}

//审批
type ApprovalGooutController struct {
	controllers.BaseController
}

func (this *ApprovalGooutController) Get() {
	//权限检测
	if !strings.Contains(this.GetSession("userPermission").(string), "goout-approval") {
		this.Abort("401")
	}
	page, err := this.GetInt("p")
	filter := this.GetString("filter")

	if err != nil {
		page = 1
	}

	offset, err1 := beego.AppConfig.Int("pageoffset")
	if err1 != nil {
		offset = 15
	}

	condArr := make(map[string]string)
	condArr["filter"] = filter
	if filter == "over" {
		condArr["status"] = "1"
	} else {
		condArr["filter"] = "wait"
		condArr["status"] = "0"
	}
	condArr["userid"] = fmt.Sprintf("%d", this.BaseController.UserUserId)

	countGoout := CountGooutApproval(condArr)

	paginator := pagination.SetPaginator(this.Ctx, offset, countGoout)
	_, _, goouts := ListGooutApproval(condArr, page, offset)

	this.Data["paginator"] = paginator
	this.Data["condArr"] = condArr
	this.Data["goouts"] = goouts
	this.Data["countGoout"] = countGoout

	this.TplName = "goouts/approval.tpl"
}

type ShowGooutController struct {
	controllers.BaseController
}

func (this *ShowGooutController) Get() {
	//权限检测
	if !strings.Contains(this.GetSession("userPermission").(string), "goout-view") {
		this.Abort("401")
	}
	idstr := this.Ctx.Input.Param(":id")
	id, err := strconv.Atoi(idstr)
	goout, err := GetGoout(int64(id))
	if err != nil {
		this.Abort("404")

	}
	this.Data["goout"] = goout
	_, _, approvers := ListGooutApproverProcess(goout.Id)
	this.Data["approvers"] = approvers

	if this.BaseController.UserUserId != goout.Userid {

		//检测是否可以审批和是否已审批过
		checkApproverid, checkStatus := CheckGooutApprover(goout.Id, this.BaseController.UserUserId)
		if 0 == checkApproverid {
			this.Abort("401")
		}
		this.Data["checkStatus"] = checkStatus
		this.Data["checkApproverid"] = checkApproverid

		//检测审批顺序
		var checkApproverCan = 1
		for i, v := range approvers {
			if v.Status == 2 {
				checkApproverCan = 0
				break
			}
			if v.Userid == this.BaseController.UserUserId {
				if i != 0 {
					if approvers[i-1].Status == 0 {
						checkApproverCan = 0
						break
					}
				}
			}
		}
		this.Data["checkApproverCan"] = checkApproverCan

	} else {
		this.Data["checkStatus"] = 0
		this.Data["checkApproverCan"] = 0
	}
	this.TplName = "goouts/detail.tpl"
}

func (this *ShowGooutController) Post() {
	//权限检测
	if !strings.Contains(this.GetSession("userPermission").(string), "goout-approval") {
		this.Data["json"] = map[string]interface{}{"code": 0, "message": "无权设置"}
		this.ServeJSON()
		return
	}

	approverid, _ := this.GetInt64("id")
	if approverid <= 0 {
		this.Data["json"] = map[string]interface{}{"code": 0, "message": "参数出错"}
		this.ServeJSON()
		return
	}

	gooutid, _ := this.GetInt64("gooutid")
	if gooutid <= 0 {
		this.Data["json"] = map[string]interface{}{"code": 0, "message": "参数出错"}
		this.ServeJSON()
		return
	}

	status, _ := this.GetInt("status")
	if status <= 0 {
		this.Data["json"] = map[string]interface{}{"code": 0, "message": "请选择状态"}
		this.ServeJSON()
		return
	}
	summary := this.GetString("summary")

	var goout GooutsApprover
	goout.Status = status
	goout.Summary = summary
	goout.Gooutid = gooutid
	err := UpdateGooutsApprover(approverid, goout)

	if err == nil {
		//消息通知
		goout, _ := GetGoout(gooutid)
		var msg Messages
		msg.Id = utils.SnowFlakeId()
		msg.Userid = this.BaseController.UserUserId
		msg.Touserid = goout.Userid
		msg.Type = 3
		msg.Subtype = 35
		if status == 1 {
			msg.Title = "同意"
		} else if status == 2 {
			msg.Title = "拒绝"
		}
		msg.Url = "/goout/approval/" + fmt.Sprintf("%d", gooutid)
		AddMessages(msg)
		this.Data["json"] = map[string]interface{}{"code": 1, "message": "审批成功"}
	} else {
		this.Data["json"] = map[string]interface{}{"code": 0, "message": "审批失败"}
	}
	this.ServeJSON()
}

type AddGooutController struct {
	controllers.BaseController
}

func (this *AddGooutController) Get() {
	//权限检测
	if !strings.Contains(this.GetSession("userPermission").(string), "goout-add") {
		this.Abort("401")
	}
	var goout Goouts
	this.Data["goout"] = goout

	_, _, users := ListUserFind()
	this.Data["users"] = users

	this.TplName = "goouts/form.tpl"
}
func (this *AddGooutController) Post() {
	//权限检测
	if !strings.Contains(this.GetSession("userPermission").(string), "goout-add") {
		this.Data["json"] = map[string]interface{}{"code": 0, "message": "无权设置"}
		this.ServeJSON()
		return
	}
	startedstr := this.GetString("started")
	startedtime := utils.GetTimeParse(startedstr)

	endedstr := this.GetString("ended")
	endedtime := utils.GetTimeParse(endedstr)

	hours, _ := this.GetFloat("hours")
	if hours <= 0 {
		this.Data["json"] = map[string]interface{}{"code": 0, "message": "请填写外出小时数"}
		this.ServeJSON()
		return
	}
	reason := this.GetString("reason")
	if "" == reason {
		this.Data["json"] = map[string]interface{}{"code": 0, "message": "请填写外出原因"}
		this.ServeJSON()
		return
	}
	approverids := strings.Trim(this.GetString("approverid"), ",")
	if "" == approverids {
		this.Data["json"] = map[string]interface{}{"code": 0, "message": "请选择审核批人"}
		this.ServeJSON()
		return
	}

	var filepath string
	f, h, err := this.GetFile("picture")

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
			this.SaveToFile("picture", dir+"/"+filename)
			filepath = strings.Replace(dir, ".", "", 1) + "/" + filename
		}
	}

	var goout Goouts
	gooutid := utils.SnowFlakeId()
	goout.Id = gooutid
	goout.Userid = this.BaseController.UserUserId
	goout.Started = startedtime
	goout.Ended = endedtime
	goout.Hours = hours
	goout.Reason = reason
	goout.Picture = filepath
	goout.Approverids = approverids

	err = AddGoout(goout)

	if err == nil {
		//审批人入库
		var gooutApp GooutsApprover
		userids := strings.Split(approverids, ",")
		for _, v := range userids {
			userid, _ := strconv.Atoi(v)
			id := utils.SnowFlakeId()
			gooutApp.Id = id
			gooutApp.Userid = int64(userid)
			gooutApp.Gooutid = gooutid
			AddGooutsApprover(gooutApp)
		}

		this.Data["json"] = map[string]interface{}{"code": 1, "message": "添加成功。请‘我的外出单’中设置为正常，审批人才可以看到", "id": fmt.Sprintf("%d", gooutid)}
	} else {
		this.Data["json"] = map[string]interface{}{"code": 0, "message": "外出添加失败"}
	}
	this.ServeJSON()
}

type EditGooutController struct {
	controllers.BaseController
}

func (this *EditGooutController) Get() {
	//权限检测
	if !strings.Contains(this.GetSession("userPermission").(string), "goout-edit") {
		this.Abort("401")
	}
	idstr := this.Ctx.Input.Param(":id")
	id, _ := strconv.Atoi(idstr)
	goout, _ := GetGoout(int64(id))

	if goout.Userid != this.BaseController.UserUserId {
		this.Abort("401")
	}
	if goout.Status != 1 {
		this.Abort("401")
	}

	this.Data["goout"] = goout
	this.TplName = "goouts/form.tpl"
}
func (this *EditGooutController) Post() {
	//权限检测
	if !strings.Contains(this.GetSession("userPermission").(string), "goout-edit") {
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
	startedstr := this.GetString("started")
	startedtime := utils.GetTimeParse(startedstr)

	endedstr := this.GetString("ended")
	endedtime := utils.GetTimeParse(endedstr)

	hours, _ := this.GetFloat("hours")
	if hours <= 0 {
		this.Data["json"] = map[string]interface{}{"code": 0, "message": "请填写外出小时"}
		this.ServeJSON()
		return
	}
	reason := this.GetString("reason")
	if "" == reason {
		this.Data["json"] = map[string]interface{}{"code": 0, "message": "请填写外出原因"}
		this.ServeJSON()
		return
	}

	var filepath string
	f, h, err := this.GetFile("picture")

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
			this.SaveToFile("picture", dir+"/"+filename)
			filepath = strings.Replace(dir, ".", "", 1) + "/" + filename
		}
	}

	var goout Goouts
	goout.Started = startedtime
	goout.Ended = endedtime
	goout.Hours = hours
	goout.Reason = reason
	goout.Picture = filepath

	err = UpdateGoout(id, goout)

	if err == nil {
		this.Data["json"] = map[string]interface{}{"code": 1, "message": "外出修改成功", "id": fmt.Sprintf("%d", id)}
	} else {
		this.Data["json"] = map[string]interface{}{"code": 0, "message": "外出修改失败"}
	}
	this.ServeJSON()
}

type AjaxGooutDeleteController struct {
	controllers.BaseController
}

func (this *AjaxGooutDeleteController) Post() {
	//权限检测
	if !strings.Contains(this.GetSession("userPermission").(string), "goout-edit") {
		this.Abort("401")
	}
	id, _ := this.GetInt64("id")
	if id <= 0 {
		this.Data["json"] = map[string]interface{}{"code": 0, "message": "参数出错"}
		this.ServeJSON()
		return
	}
	goout, _ := GetGoout(int64(id))

	if goout.Userid != this.BaseController.UserUserId {
		this.Data["json"] = map[string]interface{}{"code": 0, "message": "无权操作"}
		this.ServeJSON()
		return
	}
	if goout.Status != 1 {
		this.Data["json"] = map[string]interface{}{"code": 0, "message": "外出状态修改成正常，不能再删除"}
		this.ServeJSON()
		return
	}
	err := DeleteGoout(id)

	if err == nil {
		this.Data["json"] = map[string]interface{}{"code": 1, "message": "删除成功"}
	} else {
		this.Data["json"] = map[string]interface{}{"code": 0, "message": "删除失败"}
	}
	this.ServeJSON()
}

type AjaxGooutStatusController struct {
	controllers.BaseController
}

func (this *AjaxGooutStatusController) Post() {
	//权限检测
	if !strings.Contains(this.GetSession("userPermission").(string), "goout-edit") {
		this.Abort("401")
	}
	id, _ := this.GetInt64("id")
	if id <= 0 {
		this.Data["json"] = map[string]interface{}{"code": 0, "message": "参数出错"}
		this.ServeJSON()
		return
	}
	goout, _ := GetGoout(int64(id))

	if goout.Userid != this.BaseController.UserUserId {
		this.Data["json"] = map[string]interface{}{"code": 0, "message": "无权操作"}
		this.ServeJSON()
		return
	}
	if goout.Status != 1 {
		this.Data["json"] = map[string]interface{}{"code": 0, "message": "外出状态修改成正常，不能再删除"}
		this.ServeJSON()
		return
	}
	err := ChangeGooutStatus(id, 2)

	if err == nil {
		userids := strings.Split(goout.Approverids, ",")
		for _, v := range userids {
			//消息通知
			userid, _ := strconv.Atoi(v)
			var msg Messages
			msg.Id = utils.SnowFlakeId()
			msg.Userid = this.BaseController.UserUserId
			msg.Touserid = int64(userid)
			msg.Type = 4
			msg.Subtype = 35
			msg.Title = "去审批处理"
			msg.Url = "/goout/approval/" + fmt.Sprintf("%d", goout.Id)
			AddMessages(msg)
		}
		this.Data["json"] = map[string]interface{}{"code": 1, "message": "状态修改成功"}
	} else {
		this.Data["json"] = map[string]interface{}{"code": 0, "message": "状态修改失败"}
	}
	this.ServeJSON()
}
