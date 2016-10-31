package businesstrips

import (
	"fmt"
	"opms/controllers"
	. "opms/models/businesstrips"
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
type ManageBusinesstripController struct {
	controllers.BaseController
}

func (this *ManageBusinesstripController) Get() {
	//权限检测
	if !strings.Contains(this.GetSession("userPermission").(string), "businesstrip-manage") {
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

	countBusinesstrip := CountBusinesstrip(condArr)

	paginator := pagination.SetPaginator(this.Ctx, offset, countBusinesstrip)
	_, _, businesstrips := ListBusinesstrip(condArr, page, offset)

	this.Data["paginator"] = paginator
	this.Data["condArr"] = condArr
	this.Data["businesstrips"] = businesstrips
	this.Data["countBusinesstrip"] = countBusinesstrip

	this.TplName = "businesstrips/index.tpl"
}

//审批
type ApprovalBusinesstripController struct {
	controllers.BaseController
}

func (this *ApprovalBusinesstripController) Get() {
	//权限检测
	if !strings.Contains(this.GetSession("userPermission").(string), "businesstrip-approval") {
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

	countBusinesstrip := CountBusinesstripApproval(condArr)

	paginator := pagination.SetPaginator(this.Ctx, offset, countBusinesstrip)
	_, _, businesstrips := ListBusinesstripApproval(condArr, page, offset)

	this.Data["paginator"] = paginator
	this.Data["condArr"] = condArr
	this.Data["businesstrips"] = businesstrips
	this.Data["countBusinesstrip"] = countBusinesstrip

	this.TplName = "businesstrips/approval.tpl"
}

type ShowBusinesstripController struct {
	controllers.BaseController
}

func (this *ShowBusinesstripController) Get() {
	if !strings.Contains(this.GetSession("userPermission").(string), "businesstrip-view") {
		this.Abort("401")
	}
	idstr := this.Ctx.Input.Param(":id")
	id, err := strconv.Atoi(idstr)
	businesstrip, err := GetBusinesstrip(int64(id))
	if err != nil {
		this.Abort("404")

	}
	this.Data["businesstrip"] = businesstrip
	_, _, approvers := ListBusinesstripApproverProcess(businesstrip.Id)
	this.Data["approvers"] = approvers

	if this.BaseController.UserUserId != businesstrip.Userid {

		//检测是否可以审批和是否已审批过
		checkApproverid, checkStatus := CheckBusinesstripApprover(businesstrip.Id, this.BaseController.UserUserId)
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

	this.TplName = "businesstrips/detail.tpl"
}

func (this *ShowBusinesstripController) Post() {
	//权限检测
	if !strings.Contains(this.GetSession("userPermission").(string), "businesstrip-approval") {
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

	businesstripid, _ := this.GetInt64("businesstripid")
	if businesstripid <= 0 {
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

	var businesstrip BusinesstripsApprover
	businesstrip.Status = status
	businesstrip.Summary = summary
	businesstrip.Businesstripid = businesstripid
	err := UpdateBusinesstripsApprover(approverid, businesstrip)

	if err == nil {
		//消息通知
		bs, _ := GetBusinesstrip(businesstripid)
		var msg Messages
		msg.Id = utils.SnowFlakeId()
		msg.Userid = this.BaseController.UserUserId
		msg.Touserid = bs.Userid
		msg.Type = 3
		msg.Subtype = 34
		if status == 1 {
			msg.Title = "同意"
		} else if status == 2 {
			msg.Title = "拒绝"
		}
		msg.Url = "/businesstrip/approval/" + fmt.Sprintf("%d", businesstripid)
		AddMessages(msg)
		this.Data["json"] = map[string]interface{}{"code": 1, "message": "审批成功"}
	} else {
		this.Data["json"] = map[string]interface{}{"code": 0, "message": "审批失败"}
	}
	this.ServeJSON()
}

type AddBusinesstripController struct {
	controllers.BaseController
}

func (this *AddBusinesstripController) Get() {
	//权限检测
	if !strings.Contains(this.GetSession("userPermission").(string), "businesstrip-add") {
		this.Abort("401")
	}
	var businesstrip Businesstrips
	this.Data["businesstrip"] = businesstrip

	_, _, users := ListUserFind()
	this.Data["users"] = users

	this.TplName = "businesstrips/form.tpl"
}
func (this *AddBusinesstripController) Post() {
	//权限检测
	if !strings.Contains(this.GetSession("userPermission").(string), "businesstrip-add") {
		this.Data["json"] = map[string]interface{}{"code": 0, "message": "无权设置"}
		this.ServeJSON()
		return
	}

	destinations := make([]string, 0)
	this.Ctx.Input.Bind(&destinations, "destinations")
	if len(destinations) < 0 {
		this.Data["json"] = map[string]interface{}{"code": 0, "message": "请填写目的地"}
		this.ServeJSON()
		return
	}

	starteds := make([]string, 0)
	this.Ctx.Input.Bind(&starteds, "starteds")
	if len(starteds) < 0 {
		this.Data["json"] = map[string]interface{}{"code": 0, "message": "请填写开始日期"}
		this.ServeJSON()
		return
	}
	endeds := make([]string, 0)
	this.Ctx.Input.Bind(&endeds, "endeds")
	if len(endeds) < 0 {
		this.Data["json"] = map[string]interface{}{"code": 0, "message": "请填写结束日期"}
		this.ServeJSON()
		return
	}

	approverids := strings.Trim(this.GetString("approverid"), ",")
	if "" == approverids {
		this.Data["json"] = map[string]interface{}{"code": 0, "message": "请选择审核批人"}
		this.ServeJSON()
		return
	}

	days, _ := this.GetInt("days")
	if days <= 0 {
		this.Data["json"] = map[string]interface{}{"code": 0, "message": "请填写出差天数"}
		this.ServeJSON()
		return
	}
	reason := this.GetString("reason")
	if "" == reason {
		this.Data["json"] = map[string]interface{}{"code": 0, "message": "请填写出差原因"}
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

	var businesstrip Businesstrips
	businesstripid := utils.SnowFlakeId()
	businesstrip.Id = businesstripid
	businesstrip.Userid = this.BaseController.UserUserId
	businesstrip.Destinations = strings.Join(destinations, "||")
	businesstrip.Starteds = strings.Join(starteds, "||")
	businesstrip.Endeds = strings.Join(endeds, "||")
	businesstrip.Days = days
	businesstrip.Reason = reason
	businesstrip.Picture = filepath
	businesstrip.Approverids = approverids

	err = AddBusinesstrip(businesstrip)

	if err == nil {
		//审批人入库
		var businesstripApp BusinesstripsApprover
		userids := strings.Split(approverids, ",")
		for _, v := range userids {
			userid, _ := strconv.Atoi(v)
			id := utils.SnowFlakeId()
			businesstripApp.Id = id
			businesstripApp.Userid = int64(userid)
			businesstripApp.Businesstripid = businesstripid
			AddBusinesstripsApprover(businesstripApp)
		}

		this.Data["json"] = map[string]interface{}{"code": 1, "message": "添加成功。请‘我的出差’中设置为正常，审批人才可以看到", "id": fmt.Sprintf("%d", businesstripid)}
	} else {
		this.Data["json"] = map[string]interface{}{"code": 0, "message": "报销添加失败"}
	}
	this.ServeJSON()
}

type EditBusinesstripController struct {
	controllers.BaseController
}

func (this *EditBusinesstripController) Get() {
	//权限检测
	if !strings.Contains(this.GetSession("userPermission").(string), "businesstrip-edit") {
		this.Abort("401")
	}
	idstr := this.Ctx.Input.Param(":id")
	id, _ := strconv.Atoi(idstr)
	businesstrip, _ := GetBusinesstrip(int64(id))

	if businesstrip.Userid != this.BaseController.UserUserId {
		this.Abort("401")
	}
	if businesstrip.Status != 1 {
		this.Abort("401")
	}

	this.Data["businesstrip"] = businesstrip
	this.TplName = "businesstrips/form.tpl"
}
func (this *EditBusinesstripController) Post() {
	//权限检测
	if !strings.Contains(this.GetSession("userPermission").(string), "businesstrip-edit") {
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

	destinations := make([]string, 0)
	this.Ctx.Input.Bind(&destinations, "destinations")
	if len(destinations) < 0 {
		this.Data["json"] = map[string]interface{}{"code": 0, "message": "请填写目的地"}
		this.ServeJSON()
		return
	}

	starteds := make([]string, 0)
	this.Ctx.Input.Bind(&starteds, "starteds")
	if len(starteds) < 0 {
		this.Data["json"] = map[string]interface{}{"code": 0, "message": "请填写开始日期"}
		this.ServeJSON()
		return
	}
	endeds := make([]string, 0)
	this.Ctx.Input.Bind(&endeds, "endeds")
	if len(endeds) < 0 {
		this.Data["json"] = map[string]interface{}{"code": 0, "message": "请填写结束日期"}
		this.ServeJSON()
		return
	}

	days, _ := this.GetInt("days")
	if days <= 0 {
		this.Data["json"] = map[string]interface{}{"code": 0, "message": "请填写出差天数"}
		this.ServeJSON()
		return
	}
	reason := this.GetString("reason")
	if "" == reason {
		this.Data["json"] = map[string]interface{}{"code": 0, "message": "请填写出差原因"}
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

	var businesstrip Businesstrips
	businesstrip.Destinations = strings.Join(destinations, "||")
	businesstrip.Starteds = strings.Join(starteds, "||")
	businesstrip.Endeds = strings.Join(endeds, "||")
	businesstrip.Days = days
	businesstrip.Reason = reason
	businesstrip.Picture = filepath

	err = UpdateBusinesstrip(id, businesstrip)

	if err == nil {
		this.Data["json"] = map[string]interface{}{"code": 1, "message": "报销修改成功", "id": fmt.Sprintf("%d", id)}
	} else {
		this.Data["json"] = map[string]interface{}{"code": 0, "message": "报销修改失败"}
	}
	this.ServeJSON()
}

type AjaxBusinesstripDeleteController struct {
	controllers.BaseController
}

func (this *AjaxBusinesstripDeleteController) Post() {
	//权限检测
	if !strings.Contains(this.GetSession("userPermission").(string), "businesstrip-edit") {
		this.Abort("401")
	}
	id, _ := this.GetInt64("id")
	if id <= 0 {
		this.Data["json"] = map[string]interface{}{"code": 0, "message": "参数出错"}
		this.ServeJSON()
		return
	}
	businesstrip, _ := GetBusinesstrip(int64(id))

	if businesstrip.Userid != this.BaseController.UserUserId {
		this.Data["json"] = map[string]interface{}{"code": 0, "message": "无权操作"}
		this.ServeJSON()
		return
	}
	if businesstrip.Status != 1 {
		this.Data["json"] = map[string]interface{}{"code": 0, "message": "报销状态修改成正常，不能再删除"}
		this.ServeJSON()
		return
	}
	err := DeleteBusinesstrip(id)

	if err == nil {
		this.Data["json"] = map[string]interface{}{"code": 1, "message": "删除成功"}
	} else {
		this.Data["json"] = map[string]interface{}{"code": 0, "message": "删除失败"}
	}
	this.ServeJSON()
}

type AjaxBusinesstripStatusController struct {
	controllers.BaseController
}

func (this *AjaxBusinesstripStatusController) Post() {
	//权限检测
	if !strings.Contains(this.GetSession("userPermission").(string), "businesstrip-edit") {
		this.Abort("401")
	}
	id, _ := this.GetInt64("id")
	if id <= 0 {
		this.Data["json"] = map[string]interface{}{"code": 0, "message": "参数出错"}
		this.ServeJSON()
		return
	}
	businesstrip, _ := GetBusinesstrip(int64(id))

	if businesstrip.Userid != this.BaseController.UserUserId {
		this.Data["json"] = map[string]interface{}{"code": 0, "message": "无权操作"}
		this.ServeJSON()
		return
	}
	if businesstrip.Status != 1 {
		this.Data["json"] = map[string]interface{}{"code": 0, "message": "报销状态修改成正常，不能再删除"}
		this.ServeJSON()
		return
	}
	err := ChangeBusinesstripStatus(id, 2)

	if err == nil {
		userids := strings.Split(businesstrip.Approverids, ",")
		for _, v := range userids {
			//消息通知
			userid, _ := strconv.Atoi(v)
			var msg Messages
			msg.Id = utils.SnowFlakeId()
			msg.Userid = this.BaseController.UserUserId
			msg.Touserid = int64(userid)
			msg.Type = 4
			msg.Subtype = 34
			msg.Title = "去审批处理"
			msg.Url = "/businesstrip/approval/" + fmt.Sprintf("%d", businesstrip.Id)
			AddMessages(msg)
		}
		this.Data["json"] = map[string]interface{}{"code": 1, "message": "状态修改成功"}
	} else {
		this.Data["json"] = map[string]interface{}{"code": 0, "message": "状态修改失败"}
	}
	this.ServeJSON()
}
