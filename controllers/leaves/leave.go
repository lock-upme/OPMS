package leaves

import (
	"fmt"
	"opms/controllers"
	. "opms/models/leaves"
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
type ManageLeaveController struct {
	controllers.BaseController
}

func (this *ManageLeaveController) Get() {
	//权限检测
	if !strings.Contains(this.GetSession("userPermission").(string), "leave-manage") {
		this.Abort("401")
	}
	page, err := this.GetInt("p")
	status := this.GetString("status")
	ltype := this.GetString("type")
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
	condArr["type"] = ltype
	condArr["result"] = result
	condArr["userid"] = fmt.Sprintf("%d", this.BaseController.UserUserId)

	countLeave := CountLeave(condArr)

	paginator := pagination.SetPaginator(this.Ctx, offset, countLeave)
	_, _, leaves := ListLeave(condArr, page, offset)

	this.Data["paginator"] = paginator
	this.Data["condArr"] = condArr
	this.Data["leaves"] = leaves
	this.Data["countLeave"] = countLeave

	this.TplName = "leaves/index.tpl"
}

//审批
type ApprovalLeaveController struct {
	controllers.BaseController
}

func (this *ApprovalLeaveController) Get() {
	//权限检测
	if !strings.Contains(this.GetSession("userPermission").(string), "leave-approval") {
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

	countLeave := CountLeaveApproval(condArr)

	paginator := pagination.SetPaginator(this.Ctx, offset, countLeave)
	_, _, leaves := ListLeaveApproval(condArr, page, offset)

	this.Data["paginator"] = paginator
	this.Data["condArr"] = condArr
	this.Data["leaves"] = leaves
	this.Data["countLeave"] = countLeave

	this.TplName = "leaves/approval.tpl"
}

type ShowLeaveController struct {
	controllers.BaseController
}

func (this *ShowLeaveController) Get() {
	//权限检测
	if !strings.Contains(this.GetSession("userPermission").(string), "leave-view") {
		this.Abort("401")
	}
	idstr := this.Ctx.Input.Param(":id")
	id, err := strconv.Atoi(idstr)
	leave, err := GetLeave(int64(id))
	if err != nil {
		this.Abort("404")

	}
	this.Data["leave"] = leave
	_, _, approvers := ListLeaveApproverProcess(leave.Id)
	this.Data["approvers"] = approvers

	if this.BaseController.UserUserId != leave.Userid {

		//检测是否可以审批和是否已审批过
		checkApproverid, checkStatus := CheckLeaveApprover(leave.Id, this.BaseController.UserUserId)
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

	this.TplName = "leaves/detail.tpl"
}

func (this *ShowLeaveController) Post() {
	//权限检测
	if !strings.Contains(this.GetSession("userPermission").(string), "leave-approval") {
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

	leaveid, _ := this.GetInt64("leaveid")
	if leaveid <= 0 {
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

	var leave LeavesApprover
	leave.Status = status
	leave.Summary = summary
	leave.Leaveid = leaveid
	err := UpdateLeavesApprover(approverid, leave)

	if err == nil {
		this.Data["json"] = map[string]interface{}{"code": 1, "message": "审批成功"}
	} else {
		this.Data["json"] = map[string]interface{}{"code": 0, "message": "审批失败"}
	}
	this.ServeJSON()
}

type AddLeaveController struct {
	controllers.BaseController
}

func (this *AddLeaveController) Get() {
	//权限检测
	if !strings.Contains(this.GetSession("userPermission").(string), "leave-add") {
		this.Abort("401")
	}
	var leave Leaves
	this.Data["leave"] = leave

	_, _, users := ListUserFind()
	this.Data["users"] = users

	this.TplName = "leaves/form.tpl"
}
func (this *AddLeaveController) Post() {
	//权限检测
	if !strings.Contains(this.GetSession("userPermission").(string), "leave-add") {
		this.Data["json"] = map[string]interface{}{"code": 0, "message": "无权设置"}
		this.ServeJSON()
		return
	}
	ltype, _ := this.GetInt("type")
	if ltype <= 0 {
		this.Data["json"] = map[string]interface{}{"code": 0, "message": "请选择类型"}
		this.ServeJSON()
		return
	}
	startedstr := this.GetString("started")
	startedtime := utils.GetDateParse(startedstr)

	endedstr := this.GetString("ended")
	endedtime := utils.GetDateParse(endedstr)

	days, _ := this.GetInt("days")
	if days <= 0 {
		this.Data["json"] = map[string]interface{}{"code": 0, "message": "请填写请假天数"}
		this.ServeJSON()
		return
	}
	reason := this.GetString("reason")
	if "" == reason {
		this.Data["json"] = map[string]interface{}{"code": 0, "message": "请填写请假原因"}
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

	var leave Leaves
	leaveid := utils.SnowFlakeId()
	leave.Id = leaveid
	leave.Userid = this.BaseController.UserUserId
	leave.Type = ltype
	leave.Started = startedtime
	leave.Ended = endedtime
	leave.Days = days
	leave.Reason = reason
	leave.Picture = filepath
	leave.Approverids = approverids

	err = AddLeave(leave)

	if err == nil {
		//审批人入库
		var leaveApp LeavesApprover
		userids := strings.Split(approverids, ",")
		for _, v := range userids {
			userid, _ := strconv.Atoi(v)
			id := utils.SnowFlakeId()
			leaveApp.Id = id
			leaveApp.Userid = int64(userid)
			leaveApp.Leaveid = leaveid
			AddLeavesApprover(leaveApp)
		}

		this.Data["json"] = map[string]interface{}{"code": 1, "message": "添加成功。请‘请假列表’中设置为正常，审批人才可以看到", "id": fmt.Sprintf("%d", leaveid)}
	} else {
		this.Data["json"] = map[string]interface{}{"code": 0, "message": "请假添加失败"}
	}
	this.ServeJSON()
}

type EditLeaveController struct {
	controllers.BaseController
}

func (this *EditLeaveController) Get() {
	//权限检测
	if !strings.Contains(this.GetSession("userPermission").(string), "leave-edit") {
		this.Abort("401")
	}
	idstr := this.Ctx.Input.Param(":id")
	id, _ := strconv.Atoi(idstr)
	leave, _ := GetLeave(int64(id))

	if leave.Userid != this.BaseController.UserUserId {
		this.Abort("401")
	}
	if leave.Status != 1 {
		this.Abort("401")
	}

	this.Data["leave"] = leave
	this.TplName = "leaves/form.tpl"
}
func (this *EditLeaveController) Post() {
	//权限检测
	if !strings.Contains(this.GetSession("userPermission").(string), "leave-edit") {
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

	ltype, _ := this.GetInt("type")
	if ltype <= 0 {
		this.Data["json"] = map[string]interface{}{"code": 0, "message": "请选择类型"}
		this.ServeJSON()
		return
	}
	startedstr := this.GetString("started")
	startedtime := utils.GetDateParse(startedstr)

	endedstr := this.GetString("ended")
	endedtime := utils.GetDateParse(endedstr)

	days, _ := this.GetInt("days")
	if days <= 0 {
		this.Data["json"] = map[string]interface{}{"code": 0, "message": "请填写请假天数"}
		this.ServeJSON()
		return
	}
	reason := this.GetString("reason")
	if "" == reason {
		this.Data["json"] = map[string]interface{}{"code": 0, "message": "请填写请假原因"}
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

	var leave Leaves
	leave.Type = ltype
	leave.Started = startedtime
	leave.Ended = endedtime
	leave.Days = days
	leave.Reason = reason
	leave.Picture = filepath

	err = UpdateLeave(id, leave)

	if err == nil {
		this.Data["json"] = map[string]interface{}{"code": 1, "message": "请假修改成功", "id": fmt.Sprintf("%d", id)}
	} else {
		this.Data["json"] = map[string]interface{}{"code": 0, "message": "请假修改失败"}
	}
	this.ServeJSON()
}

type AjaxLeaveDeleteController struct {
	controllers.BaseController
}

func (this *AjaxLeaveDeleteController) Post() {
	//权限检测
	if !strings.Contains(this.GetSession("userPermission").(string), "leave-edit") {
		this.Abort("401")
	}
	id, _ := this.GetInt64("id")
	if id <= 0 {
		this.Data["json"] = map[string]interface{}{"code": 0, "message": "参数出错"}
		this.ServeJSON()
		return
	}
	leave, _ := GetLeave(int64(id))

	if leave.Userid != this.BaseController.UserUserId {
		this.Data["json"] = map[string]interface{}{"code": 0, "message": "无权操作"}
		this.ServeJSON()
		return
	}
	if leave.Status != 1 {
		this.Data["json"] = map[string]interface{}{"code": 0, "message": "请假状态修改成正常，不能再删除"}
		this.ServeJSON()
		return
	}
	err := DeleteLeave(id)

	if err == nil {
		this.Data["json"] = map[string]interface{}{"code": 1, "message": "删除成功"}
	} else {
		this.Data["json"] = map[string]interface{}{"code": 0, "message": "删除失败"}
	}
	this.ServeJSON()
}

type AjaxLeaveStatusController struct {
	controllers.BaseController
}

func (this *AjaxLeaveStatusController) Post() {
	//权限检测
	if !strings.Contains(this.GetSession("userPermission").(string), "leave-edit") {
		this.Abort("401")
	}
	id, _ := this.GetInt64("id")
	if id <= 0 {
		this.Data["json"] = map[string]interface{}{"code": 0, "message": "参数出错"}
		this.ServeJSON()
		return
	}
	leave, _ := GetLeave(int64(id))

	if leave.Userid != this.BaseController.UserUserId {
		this.Data["json"] = map[string]interface{}{"code": 0, "message": "无权操作"}
		this.ServeJSON()
		return
	}
	if leave.Status != 1 {
		this.Data["json"] = map[string]interface{}{"code": 0, "message": "请假状态修改成正常，不能再删除"}
		this.ServeJSON()
		return
	}
	err := ChangeLeaveStatus(id, 2)

	if err == nil {
		this.Data["json"] = map[string]interface{}{"code": 1, "message": "状态修改成功"}
	} else {
		this.Data["json"] = map[string]interface{}{"code": 0, "message": "状态修改失败"}
	}
	this.ServeJSON()
}
