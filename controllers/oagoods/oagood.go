package oagoods

import (
	"fmt"
	"opms/controllers"
	. "opms/models/messages"
	. "opms/models/oagoods"
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
type ManageOagoodController struct {
	controllers.BaseController
}

func (this *ManageOagoodController) Get() {
	//权限检测
	if !strings.Contains(this.GetSession("userPermission").(string), "oagood-manage") {
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

	countOagood := CountOagood(condArr)

	paginator := pagination.SetPaginator(this.Ctx, offset, countOagood)
	_, _, oagoods := ListOagood(condArr, page, offset)

	this.Data["paginator"] = paginator
	this.Data["condArr"] = condArr
	this.Data["oagoods"] = oagoods
	this.Data["countOagood"] = countOagood

	this.TplName = "oagoods/index.tpl"
}

//审批
type ApprovalOagoodController struct {
	controllers.BaseController
}

func (this *ApprovalOagoodController) Get() {
	//权限检测
	if !strings.Contains(this.GetSession("userPermission").(string), "oagood-approval") {
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

	countOagood := CountOagoodApproval(condArr)

	paginator := pagination.SetPaginator(this.Ctx, offset, countOagood)
	_, _, oagoods := ListOagoodApproval(condArr, page, offset)

	this.Data["paginator"] = paginator
	this.Data["condArr"] = condArr
	this.Data["oagoods"] = oagoods
	this.Data["countOagood"] = countOagood

	this.TplName = "oagoods/approval.tpl"
}

type ShowOagoodController struct {
	controllers.BaseController
}

func (this *ShowOagoodController) Get() {
	//权限检测
	if !strings.Contains(this.GetSession("userPermission").(string), "oagood-view") {
		this.Abort("401")
	}
	idstr := this.Ctx.Input.Param(":id")
	id, err := strconv.Atoi(idstr)
	oagood, err := GetOagood(int64(id))
	if err != nil {
		this.Abort("404")

	}
	this.Data["oagood"] = oagood
	_, _, approvers := ListOagoodApproverProcess(oagood.Id)
	this.Data["approvers"] = approvers

	if this.BaseController.UserUserId != oagood.Userid {

		//检测是否可以审批和是否已审批过
		checkApproverid, checkStatus := CheckOagoodApprover(oagood.Id, this.BaseController.UserUserId)
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

	this.TplName = "oagoods/detail.tpl"
}

func (this *ShowOagoodController) Post() {
	//权限检测
	if !strings.Contains(this.GetSession("userPermission").(string), "oagood-approval") {
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

	oagoodid, _ := this.GetInt64("oagoodid")
	if oagoodid <= 0 {
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

	var oagood OagoodsApprover
	oagood.Status = status
	oagood.Summary = summary
	oagood.Oagoodid = oagoodid
	err := UpdateOagoodsApprover(approverid, oagood)

	if err == nil {
		//消息通知
		og, _ := GetOagood(oagoodid)
		var msg Messages
		msg.Id = utils.SnowFlakeId()
		msg.Userid = this.BaseController.UserUserId
		msg.Touserid = og.Userid
		msg.Type = 3
		msg.Subtype = 36
		if status == 1 {
			msg.Title = "同意"
		} else if status == 2 {
			msg.Title = "拒绝"
		}
		msg.Url = "/oagood/approval/" + fmt.Sprintf("%d", oagoodid)
		AddMessages(msg)
		this.Data["json"] = map[string]interface{}{"code": 1, "message": "审批成功"}
	} else {
		this.Data["json"] = map[string]interface{}{"code": 0, "message": "审批失败"}
	}
	this.ServeJSON()
}

type AddOagoodController struct {
	controllers.BaseController
}

func (this *AddOagoodController) Get() {
	//权限检测
	if !strings.Contains(this.GetSession("userPermission").(string), "oagood-add") {
		this.Abort("401")
	}
	var oagood Oagoods
	this.Data["oagood"] = oagood

	_, _, users := ListUserFind()
	this.Data["users"] = users

	this.TplName = "oagoods/form.tpl"
}
func (this *AddOagoodController) Post() {
	//权限检测
	if !strings.Contains(this.GetSession("userPermission").(string), "oagood-add") {
		this.Data["json"] = map[string]interface{}{"code": 0, "message": "无权设置"}
		this.ServeJSON()
		return
	}

	purpose := this.GetString("purpose")
	if "" == purpose {
		this.Data["json"] = map[string]interface{}{"code": 0, "message": "请填写物品用途"}
		this.ServeJSON()
		return
	}

	names := make([]string, 0)
	this.Ctx.Input.Bind(&names, "names")
	if len(names) < 0 {
		this.Data["json"] = map[string]interface{}{"code": 0, "message": "请填写物品名称"}
		this.ServeJSON()
		return
	}

	quantitys := make([]string, 0)
	this.Ctx.Input.Bind(&quantitys, "quantitys")
	if len(quantitys) < 0 {
		this.Data["json"] = map[string]interface{}{"code": 0, "message": "请填写物品数量"}
		this.ServeJSON()
		return
	}

	content := this.GetString("content")

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

	var oagood Oagoods
	oagoodid := utils.SnowFlakeId()
	oagood.Id = oagoodid
	oagood.Userid = this.BaseController.UserUserId
	oagood.Purpose = purpose
	oagood.Names = strings.Join(names, "||")
	oagood.Quantitys = strings.Join(quantitys, "||")
	oagood.Content = content
	oagood.Picture = filepath
	oagood.Approverids = approverids

	err = AddOagood(oagood)

	if err == nil {
		//审批人入库
		var oagoodApp OagoodsApprover
		userids := strings.Split(approverids, ",")
		for _, v := range userids {
			userid, _ := strconv.Atoi(v)
			id := utils.SnowFlakeId()
			oagoodApp.Id = id
			oagoodApp.Userid = int64(userid)
			oagoodApp.Oagoodid = oagoodid
			AddOagoodsApprover(oagoodApp)
		}

		this.Data["json"] = map[string]interface{}{"code": 1, "message": "添加成功。请‘我的物品领用单’中设置为正常，审批人才可以看到", "id": fmt.Sprintf("%d", oagoodid)}
	} else {
		this.Data["json"] = map[string]interface{}{"code": 0, "message": "物品领用添加失败"}
	}
	this.ServeJSON()
}

type EditOagoodController struct {
	controllers.BaseController
}

func (this *EditOagoodController) Get() {
	//权限检测
	if !strings.Contains(this.GetSession("userPermission").(string), "oagood-edit") {
		this.Abort("401")
	}
	idstr := this.Ctx.Input.Param(":id")
	id, _ := strconv.Atoi(idstr)
	oagood, _ := GetOagood(int64(id))

	if oagood.Userid != this.BaseController.UserUserId {
		this.Abort("401")
	}
	if oagood.Status != 1 {
		this.Abort("401")
	}

	this.Data["oagood"] = oagood
	this.TplName = "oagoods/form.tpl"
}
func (this *EditOagoodController) Post() {
	//权限检测
	if !strings.Contains(this.GetSession("userPermission").(string), "oagood-edit") {
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

	purpose := this.GetString("purpose")
	if "" == purpose {
		this.Data["json"] = map[string]interface{}{"code": 0, "message": "请填写物品用途"}
		this.ServeJSON()
		return
	}

	names := make([]string, 0)
	this.Ctx.Input.Bind(&names, "names")
	if len(names) < 0 {
		this.Data["json"] = map[string]interface{}{"code": 0, "message": "请填写物品名称"}
		this.ServeJSON()
		return
	}

	quantitys := make([]string, 0)
	this.Ctx.Input.Bind(&quantitys, "quantitys")
	if len(quantitys) < 0 {
		this.Data["json"] = map[string]interface{}{"code": 0, "message": "请填写物品数量"}
		this.ServeJSON()
		return
	}

	content := this.GetString("content")

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

	var oagood Oagoods
	oagood.Purpose = purpose
	oagood.Names = strings.Join(names, "||")
	oagood.Quantitys = strings.Join(quantitys, "||")
	oagood.Content = content
	oagood.Picture = filepath

	err = UpdateOagood(id, oagood)

	if err == nil {
		this.Data["json"] = map[string]interface{}{"code": 1, "message": "物品领用修改成功", "id": fmt.Sprintf("%d", id)}
	} else {
		this.Data["json"] = map[string]interface{}{"code": 0, "message": "物品领用修改失败"}
	}
	this.ServeJSON()
}

type AjaxOagoodDeleteController struct {
	controllers.BaseController
}

func (this *AjaxOagoodDeleteController) Post() {
	//权限检测
	if !strings.Contains(this.GetSession("userPermission").(string), "oagood-edit") {
		this.Abort("401")
	}
	id, _ := this.GetInt64("id")
	if id <= 0 {
		this.Data["json"] = map[string]interface{}{"code": 0, "message": "参数出错"}
		this.ServeJSON()
		return
	}
	oagood, _ := GetOagood(int64(id))

	if oagood.Userid != this.BaseController.UserUserId {
		this.Data["json"] = map[string]interface{}{"code": 0, "message": "无权操作"}
		this.ServeJSON()
		return
	}
	if oagood.Status != 1 {
		this.Data["json"] = map[string]interface{}{"code": 0, "message": "物品领用状态修改成正常，不能再删除"}
		this.ServeJSON()
		return
	}
	err := DeleteOagood(id)

	if err == nil {
		this.Data["json"] = map[string]interface{}{"code": 1, "message": "删除成功"}
	} else {
		this.Data["json"] = map[string]interface{}{"code": 0, "message": "删除失败"}
	}
	this.ServeJSON()
}

type AjaxOagoodStatusController struct {
	controllers.BaseController
}

func (this *AjaxOagoodStatusController) Post() {
	//权限检测
	if !strings.Contains(this.GetSession("userPermission").(string), "oagood-edit") {
		this.Abort("401")
	}
	id, _ := this.GetInt64("id")
	if id <= 0 {
		this.Data["json"] = map[string]interface{}{"code": 0, "message": "参数出错"}
		this.ServeJSON()
		return
	}
	oagood, _ := GetOagood(int64(id))

	if oagood.Userid != this.BaseController.UserUserId {
		this.Data["json"] = map[string]interface{}{"code": 0, "message": "无权操作"}
		this.ServeJSON()
		return
	}
	if oagood.Status != 1 {
		this.Data["json"] = map[string]interface{}{"code": 0, "message": "物品领用状态修改成正常，不能再删除"}
		this.ServeJSON()
		return
	}
	err := ChangeOagoodStatus(id, 2)

	if err == nil {
		userids := strings.Split(oagood.Approverids, ",")
		for _, v := range userids {
			//消息通知
			userid, _ := strconv.Atoi(v)
			var msg Messages
			msg.Id = utils.SnowFlakeId()
			msg.Userid = this.BaseController.UserUserId
			msg.Touserid = int64(userid)
			msg.Type = 4
			msg.Subtype = 36
			msg.Title = "去审批处理"
			msg.Url = "/oagood/approval/" + fmt.Sprintf("%d", oagood.Id)
			AddMessages(msg)
		}
		this.Data["json"] = map[string]interface{}{"code": 1, "message": "状态修改成功"}
	} else {
		this.Data["json"] = map[string]interface{}{"code": 0, "message": "状态修改失败"}
	}
	this.ServeJSON()
}
