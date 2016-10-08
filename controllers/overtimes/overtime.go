package overtimes

import (
	"fmt"
	"opms/controllers"
	. "opms/models/overtimes"
	. "opms/models/users"
	"opms/utils"
	"strconv"
	"strings"

	"github.com/astaxie/beego"
	"github.com/astaxie/beego/utils/pagination"
)

//我的
type ManageOvertimeController struct {
	controllers.BaseController
}

func (this *ManageOvertimeController) Get() {
	//权限检测
	if !strings.Contains(this.GetSession("userPermission").(string), "overtime-manage") {
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

	countOvertime := CountOvertime(condArr)

	paginator := pagination.SetPaginator(this.Ctx, offset, countOvertime)
	_, _, overtimes := ListOvertime(condArr, page, offset)

	this.Data["paginator"] = paginator
	this.Data["condArr"] = condArr
	this.Data["overtimes"] = overtimes
	this.Data["countOvertime"] = countOvertime

	this.TplName = "overtimes/index.tpl"
}

//审批
type ApprovalOvertimeController struct {
	controllers.BaseController
}

func (this *ApprovalOvertimeController) Get() {
	//权限检测
	if !strings.Contains(this.GetSession("userPermission").(string), "overtime-approval") {
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

	countOvertime := CountOvertimeApproval(condArr)

	paginator := pagination.SetPaginator(this.Ctx, offset, countOvertime)
	_, _, overtimes := ListOvertimeApproval(condArr, page, offset)

	this.Data["paginator"] = paginator
	this.Data["condArr"] = condArr
	this.Data["overtimes"] = overtimes
	this.Data["countOvertime"] = countOvertime

	this.TplName = "overtimes/approval.tpl"
}

type ShowOvertimeController struct {
	controllers.BaseController
}

func (this *ShowOvertimeController) Get() {
	//权限检测
	if !strings.Contains(this.GetSession("userPermission").(string), "overtime-view") {
		this.Abort("401")
	}
	idstr := this.Ctx.Input.Param(":id")
	id, err := strconv.Atoi(idstr)
	overtime, err := GetOvertime(int64(id))
	if err != nil {
		this.Abort("404")

	}
	this.Data["overtime"] = overtime
	_, _, approvers := ListOvertimeApproverProcess(overtime.Id)
	this.Data["approvers"] = approvers

	if this.BaseController.UserUserId != overtime.Userid {

		//检测是否可以审批和是否已审批过
		checkApproverid, checkStatus := CheckOvertimeApprover(overtime.Id, this.BaseController.UserUserId)
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

	this.TplName = "overtimes/detail.tpl"
}

func (this *ShowOvertimeController) Post() {
	//权限检测
	if !strings.Contains(this.GetSession("userPermission").(string), "overtime-approval") {
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

	overtimeid, _ := this.GetInt64("overtimeid")
	if overtimeid <= 0 {
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

	var overtime OvertimesApprover
	overtime.Status = status
	overtime.Summary = summary
	overtime.Overtimeid = overtimeid
	err := UpdateOvertimesApprover(approverid, overtime)

	if err == nil {
		this.Data["json"] = map[string]interface{}{"code": 1, "message": "审批成功"}
	} else {
		this.Data["json"] = map[string]interface{}{"code": 0, "message": "审批失败"}
	}
	this.ServeJSON()
}

type AddOvertimeController struct {
	controllers.BaseController
}

func (this *AddOvertimeController) Get() {
	//权限检测
	if !strings.Contains(this.GetSession("userPermission").(string), "overtime-add") {
		this.Abort("401")
	}
	var overtime Overtimes
	this.Data["overtime"] = overtime

	_, _, users := ListUserFind()
	this.Data["users"] = users

	this.TplName = "overtimes/form.tpl"
}
func (this *AddOvertimeController) Post() {
	//权限检测
	if !strings.Contains(this.GetSession("userPermission").(string), "overtime-add") {
		this.Data["json"] = map[string]interface{}{"code": 0, "message": "无权设置"}
		this.ServeJSON()
		return
	}
	startedstr := this.GetString("started")
	startedtime := utils.GetTimeParse(startedstr)

	endedstr := this.GetString("ended")
	endedtime := utils.GetTimeParse(endedstr)

	longtime, _ := this.GetFloat("longtime")
	if longtime <= 0 {
		this.Data["json"] = map[string]interface{}{"code": 0, "message": "请填写时长"}
		this.ServeJSON()
		return
	}

	holiday, _ := this.GetInt("holiday")
	if holiday <= 0 {
		this.Data["json"] = map[string]interface{}{"code": 0, "message": "请选择加类假日"}
		this.ServeJSON()
		return
	}
	way, _ := this.GetInt("way")
	if way <= 0 {
		this.Data["json"] = map[string]interface{}{"code": 0, "message": "请选择加类假日"}
		this.ServeJSON()
		return
	}
	reason := this.GetString("reason")
	if "" == reason {
		this.Data["json"] = map[string]interface{}{"code": 0, "message": "请填写加班原因"}
		this.ServeJSON()
		return
	}
	approverids := strings.Trim(this.GetString("approverid"), ",")
	if "" == approverids {
		this.Data["json"] = map[string]interface{}{"code": 0, "message": "请选择审核批人"}
		this.ServeJSON()
		return
	}

	var overtime Overtimes
	overtimeid := utils.SnowFlakeId()
	overtime.Id = overtimeid
	overtime.Userid = this.BaseController.UserUserId
	overtime.Started = startedtime
	overtime.Ended = endedtime
	overtime.Longtime = longtime
	overtime.Holiday = holiday
	overtime.Way = way
	overtime.Reason = reason
	overtime.Approverids = approverids

	err := AddOvertime(overtime)

	if err == nil {
		//审批人入库
		var overtimeApp OvertimesApprover
		userids := strings.Split(approverids, ",")
		for _, v := range userids {
			userid, _ := strconv.Atoi(v)
			id := utils.SnowFlakeId()
			overtimeApp.Id = id
			overtimeApp.Userid = int64(userid)
			overtimeApp.Overtimeid = overtimeid
			AddOvertimesApprover(overtimeApp)
		}

		this.Data["json"] = map[string]interface{}{"code": 1, "message": "添加成功。请‘加班列表’中设置为正常，审批人才可以看到", "id": fmt.Sprintf("%d", overtimeid)}
	} else {
		this.Data["json"] = map[string]interface{}{"code": 0, "message": "加班添加失败"}
	}
	this.ServeJSON()
}

type EditOvertimeController struct {
	controllers.BaseController
}

func (this *EditOvertimeController) Get() {
	//权限检测
	if !strings.Contains(this.GetSession("userPermission").(string), "overtime-edit") {
		this.Abort("401")
	}
	idstr := this.Ctx.Input.Param(":id")
	id, _ := strconv.Atoi(idstr)
	overtime, _ := GetOvertime(int64(id))

	if overtime.Userid != this.BaseController.UserUserId {
		this.Abort("401")
	}
	if overtime.Status != 1 {
		this.Abort("401")
	}

	this.Data["overtime"] = overtime
	this.TplName = "overtimes/form.tpl"
}
func (this *EditOvertimeController) Post() {
	//权限检测
	if !strings.Contains(this.GetSession("userPermission").(string), "overtime-edit") {
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

	longtime, _ := this.GetFloat("longtime")
	if longtime <= 0 {
		this.Data["json"] = map[string]interface{}{"code": 0, "message": "请填写时长"}
		this.ServeJSON()
		return
	}

	holiday, _ := this.GetInt("holiday")
	if holiday <= 0 {
		this.Data["json"] = map[string]interface{}{"code": 0, "message": "请选择加类假日"}
		this.ServeJSON()
		return
	}
	way, _ := this.GetInt("way")
	if way <= 0 {
		this.Data["json"] = map[string]interface{}{"code": 0, "message": "请选择加类假日"}
		this.ServeJSON()
		return
	}
	reason := this.GetString("reason")
	if "" == reason {
		this.Data["json"] = map[string]interface{}{"code": 0, "message": "请填写加班原因"}
		this.ServeJSON()
		return
	}

	var overtime Overtimes
	overtime.Started = startedtime
	overtime.Ended = endedtime
	overtime.Longtime = longtime
	overtime.Holiday = holiday
	overtime.Way = way
	overtime.Reason = reason

	err := UpdateOvertime(id, overtime)

	if err == nil {
		this.Data["json"] = map[string]interface{}{"code": 1, "message": "加班修改成功", "id": fmt.Sprintf("%d", id)}
	} else {
		this.Data["json"] = map[string]interface{}{"code": 0, "message": "加班修改失败"}
	}
	this.ServeJSON()
}

type AjaxOvertimeDeleteController struct {
	controllers.BaseController
}

func (this *AjaxOvertimeDeleteController) Post() {
	//权限检测
	if !strings.Contains(this.GetSession("userPermission").(string), "overtime-edit") {
		this.Abort("401")
	}
	id, _ := this.GetInt64("id")
	if id <= 0 {
		this.Data["json"] = map[string]interface{}{"code": 0, "message": "参数出错"}
		this.ServeJSON()
		return
	}
	overtime, _ := GetOvertime(int64(id))

	if overtime.Userid != this.BaseController.UserUserId {
		this.Data["json"] = map[string]interface{}{"code": 0, "message": "无权操作"}
		this.ServeJSON()
		return
	}
	if overtime.Status != 1 {
		this.Data["json"] = map[string]interface{}{"code": 0, "message": "加班状态修改成正常，不能再删除"}
		this.ServeJSON()
		return
	}
	err := DeleteOvertime(id)

	if err == nil {
		this.Data["json"] = map[string]interface{}{"code": 1, "message": "删除成功"}
	} else {
		this.Data["json"] = map[string]interface{}{"code": 0, "message": "删除失败"}
	}
	this.ServeJSON()
}

type AjaxOvertimeStatusController struct {
	controllers.BaseController
}

func (this *AjaxOvertimeStatusController) Post() {
	//权限检测
	if !strings.Contains(this.GetSession("userPermission").(string), "overtime-edit") {
		this.Abort("401")
	}
	id, _ := this.GetInt64("id")
	if id <= 0 {
		this.Data["json"] = map[string]interface{}{"code": 0, "message": "参数出错"}
		this.ServeJSON()
		return
	}
	overtime, _ := GetOvertime(int64(id))

	if overtime.Userid != this.BaseController.UserUserId {
		this.Data["json"] = map[string]interface{}{"code": 0, "message": "无权操作"}
		this.ServeJSON()
		return
	}
	if overtime.Status != 1 {
		this.Data["json"] = map[string]interface{}{"code": 0, "message": "加班状态修改成正常，不能再删除"}
		this.ServeJSON()
		return
	}
	err := ChangeOvertimeStatus(id, 2)

	if err == nil {
		this.Data["json"] = map[string]interface{}{"code": 1, "message": "状态修改成功"}
	} else {
		this.Data["json"] = map[string]interface{}{"code": 0, "message": "状态修改失败"}
	}
	this.ServeJSON()
}
