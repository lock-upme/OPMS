package expenses

import (
	"fmt"
	"opms/controllers"
	. "opms/models/expenses"
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
type ManageExpenseController struct {
	controllers.BaseController
}

func (this *ManageExpenseController) Get() {
	//权限检测
	if !strings.Contains(this.GetSession("userPermission").(string), "expense-manage") {
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

	countExpense := CountExpense(condArr)

	paginator := pagination.SetPaginator(this.Ctx, offset, countExpense)
	_, _, expenses := ListExpense(condArr, page, offset)

	this.Data["paginator"] = paginator
	this.Data["condArr"] = condArr
	this.Data["expenses"] = expenses
	this.Data["countExpense"] = countExpense

	this.TplName = "expenses/index.tpl"
}

//审批
type ApprovalExpenseController struct {
	controllers.BaseController
}

func (this *ApprovalExpenseController) Get() {
	//权限检测
	if !strings.Contains(this.GetSession("userPermission").(string), "expense-approval") {
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

	countExpense := CountExpenseApproval(condArr)

	paginator := pagination.SetPaginator(this.Ctx, offset, countExpense)
	_, _, expenses := ListExpenseApproval(condArr, page, offset)

	this.Data["paginator"] = paginator
	this.Data["condArr"] = condArr
	this.Data["expenses"] = expenses
	this.Data["countExpense"] = countExpense

	this.TplName = "expenses/approval.tpl"
}

type ShowExpenseController struct {
	controllers.BaseController
}

func (this *ShowExpenseController) Get() {
	//权限检测
	if !strings.Contains(this.GetSession("userPermission").(string), "expense-view") {
		this.Abort("401")
	}
	idstr := this.Ctx.Input.Param(":id")
	id, err := strconv.Atoi(idstr)
	expense, err := GetExpense(int64(id))
	if err != nil {
		this.Abort("404")

	}
	this.Data["expense"] = expense
	_, _, approvers := ListExpenseApproverProcess(expense.Id)
	this.Data["approvers"] = approvers

	if this.BaseController.UserUserId != expense.Userid {

		//检测是否可以审批和是否已审批过
		checkApproverid, checkStatus := CheckExpenseApprover(expense.Id, this.BaseController.UserUserId)
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

	this.TplName = "expenses/detail.tpl"
}

func (this *ShowExpenseController) Post() {
	//权限检测
	if !strings.Contains(this.GetSession("userPermission").(string), "expense-approval") {
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

	expenseid, _ := this.GetInt64("expenseid")
	if expenseid <= 0 {
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

	var expense ExpensesApprover
	expense.Status = status
	expense.Summary = summary
	expense.Expenseid = expenseid
	err := UpdateExpensesApprover(approverid, expense)

	if err == nil {
		//消息通知
		exp, _ := GetExpense(expenseid)
		var msg Messages
		msg.Id = utils.SnowFlakeId()
		msg.Userid = this.BaseController.UserUserId
		msg.Touserid = exp.Userid
		msg.Type = 3
		msg.Subtype = 33
		if status == 1 {
			msg.Title = "同意"
		} else if status == 2 {
			msg.Title = "拒绝"
		}
		msg.Url = "/expense/approval/" + fmt.Sprintf("%d", expenseid)
		AddMessages(msg)
		this.Data["json"] = map[string]interface{}{"code": 1, "message": "审批成功"}
	} else {
		this.Data["json"] = map[string]interface{}{"code": 0, "message": "审批失败"}
	}
	this.ServeJSON()
}

type AddExpenseController struct {
	controllers.BaseController
}

func (this *AddExpenseController) Get() {
	//权限检测
	if !strings.Contains(this.GetSession("userPermission").(string), "expense-add") {
		this.Abort("401")
	}
	var expense Expenses
	this.Data["expense"] = expense

	_, _, users := ListUserFind()
	this.Data["users"] = users

	this.TplName = "expenses/form.tpl"
}
func (this *AddExpenseController) Post() {
	//权限检测
	if !strings.Contains(this.GetSession("userPermission").(string), "expense-add") {
		this.Data["json"] = map[string]interface{}{"code": 0, "message": "无权设置"}
		this.ServeJSON()
		return
	}

	amounts := make([]string, 0)
	this.Ctx.Input.Bind(&amounts, "amounts")
	if len(amounts) < 0 {
		this.Data["json"] = map[string]interface{}{"code": 0, "message": "请填写报销金额"}
		this.ServeJSON()
		return
	}
	var total float64
	for _, v := range amounts {
		tmp, _ := strconv.ParseFloat(v, 64)
		total = total + tmp
	}

	types := make([]string, 0)
	this.Ctx.Input.Bind(&types, "types")
	if len(types) < 0 {
		this.Data["json"] = map[string]interface{}{"code": 0, "message": "请填写报销类型"}
		this.ServeJSON()
		return
	}
	contents := make([]string, 0)
	this.Ctx.Input.Bind(&contents, "contents")
	if len(contents) < 0 {
		this.Data["json"] = map[string]interface{}{"code": 0, "message": "请填写报销明细"}
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

	var expense Expenses
	expenseid := utils.SnowFlakeId()
	expense.Id = expenseid
	expense.Userid = this.BaseController.UserUserId
	expense.Amounts = strings.Join(amounts, "||")
	expense.Types = strings.Join(types, "||")
	expense.Contents = strings.Join(contents, "||")
	expense.Total = total
	expense.Picture = filepath
	expense.Approverids = approverids

	err = AddExpense(expense)

	if err == nil {
		//审批人入库
		var expenseApp ExpensesApprover
		userids := strings.Split(approverids, ",")
		for _, v := range userids {
			userid, _ := strconv.Atoi(v)
			id := utils.SnowFlakeId()
			expenseApp.Id = id
			expenseApp.Userid = int64(userid)
			expenseApp.Expenseid = expenseid
			AddExpensesApprover(expenseApp)
		}

		this.Data["json"] = map[string]interface{}{"code": 1, "message": "添加成功。请‘我的报销单’中设置为正常，审批人才可以看到", "id": fmt.Sprintf("%d", expenseid)}
	} else {
		this.Data["json"] = map[string]interface{}{"code": 0, "message": "报销添加失败"}
	}
	this.ServeJSON()
}

type EditExpenseController struct {
	controllers.BaseController
}

func (this *EditExpenseController) Get() {
	//权限检测
	if !strings.Contains(this.GetSession("userPermission").(string), "expense-edit") {
		this.Abort("401")
	}
	idstr := this.Ctx.Input.Param(":id")
	id, _ := strconv.Atoi(idstr)
	expense, _ := GetExpense(int64(id))

	if expense.Userid != this.BaseController.UserUserId {
		this.Abort("401")
	}
	if expense.Status != 1 {
		this.Abort("401")
	}

	/*
		type Test struct {
			Typep   string
			Content string
			Amount  float64
		}
		var test []Test
		amounts := strings.Split(expense.Amounts, "||")
		var amountsMap = make(map[int]float64)
		for i, v := range amounts {
			amount, _ := strconv.ParseFloat(v, 64)
			amountsMap[i] = amount
		}

		types := strings.Split(expense.Types, "||")
		var typesMap = make(map[int]string)
		for i, v := range types {
			typesMap[i] = v
		}

		contents := strings.Split(expense.Contents, "||")
		var contentsMap = make(map[int]string)
		for i, v := range contents {
			contentsMap[i] = v
		}
		this.Data["amountsMap"] = amountsMap
		this.Data["typesMap"] = typesMap
		this.Data["contentsMap"] = contentsMap
	*/
	this.Data["expense"] = expense
	this.TplName = "expenses/form.tpl"
}
func (this *EditExpenseController) Post() {
	//权限检测
	if !strings.Contains(this.GetSession("userPermission").(string), "expense-edit") {
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

	amounts := make([]string, 0)
	this.Ctx.Input.Bind(&amounts, "amounts")
	if len(amounts) < 0 {
		this.Data["json"] = map[string]interface{}{"code": 0, "message": "请填写报销金额"}
		this.ServeJSON()
		return
	}
	var total float64
	for _, v := range amounts {
		tmp, _ := strconv.ParseFloat(v, 64)
		total = total + tmp
	}

	types := make([]string, 0)
	this.Ctx.Input.Bind(&types, "types")
	if len(types) < 0 {
		this.Data["json"] = map[string]interface{}{"code": 0, "message": "请填写报销类型"}
		this.ServeJSON()
		return
	}
	contents := make([]string, 0)
	this.Ctx.Input.Bind(&contents, "contents")
	if len(contents) < 0 {
		this.Data["json"] = map[string]interface{}{"code": 0, "message": "请填写报销明细"}
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

	var expense Expenses
	expense.Amounts = strings.Join(amounts, "||")
	expense.Types = strings.Join(types, "||")
	expense.Contents = strings.Join(contents, "||")
	expense.Total = total
	expense.Picture = filepath

	err = UpdateExpense(id, expense)

	if err == nil {
		this.Data["json"] = map[string]interface{}{"code": 1, "message": "报销修改成功", "id": fmt.Sprintf("%d", id)}
	} else {
		this.Data["json"] = map[string]interface{}{"code": 0, "message": "报销修改失败"}
	}
	this.ServeJSON()
}

type AjaxExpenseDeleteController struct {
	controllers.BaseController
}

func (this *AjaxExpenseDeleteController) Post() {
	//权限检测
	if !strings.Contains(this.GetSession("userPermission").(string), "expense-edit") {
		this.Abort("401")
	}
	id, _ := this.GetInt64("id")
	if id <= 0 {
		this.Data["json"] = map[string]interface{}{"code": 0, "message": "参数出错"}
		this.ServeJSON()
		return
	}
	expense, _ := GetExpense(int64(id))

	if expense.Userid != this.BaseController.UserUserId {
		this.Data["json"] = map[string]interface{}{"code": 0, "message": "无权操作"}
		this.ServeJSON()
		return
	}
	if expense.Status != 1 {
		this.Data["json"] = map[string]interface{}{"code": 0, "message": "报销状态修改成正常，不能再删除"}
		this.ServeJSON()
		return
	}
	err := DeleteExpense(id)

	if err == nil {
		this.Data["json"] = map[string]interface{}{"code": 1, "message": "删除成功"}
	} else {
		this.Data["json"] = map[string]interface{}{"code": 0, "message": "删除失败"}
	}
	this.ServeJSON()
}

type AjaxExpenseStatusController struct {
	controllers.BaseController
}

func (this *AjaxExpenseStatusController) Post() {
	//权限检测
	if !strings.Contains(this.GetSession("userPermission").(string), "expense-edit") {
		this.Abort("401")
	}
	id, _ := this.GetInt64("id")
	if id <= 0 {
		this.Data["json"] = map[string]interface{}{"code": 0, "message": "参数出错"}
		this.ServeJSON()
		return
	}
	expense, _ := GetExpense(int64(id))

	if expense.Userid != this.BaseController.UserUserId {
		this.Data["json"] = map[string]interface{}{"code": 0, "message": "无权操作"}
		this.ServeJSON()
		return
	}
	if expense.Status != 1 {
		this.Data["json"] = map[string]interface{}{"code": 0, "message": "报销状态修改成正常，不能再删除"}
		this.ServeJSON()
		return
	}
	err := ChangeExpenseStatus(id, 2)

	if err == nil {
		userids := strings.Split(expense.Approverids, ",")
		for _, v := range userids {
			//消息通知
			userid, _ := strconv.Atoi(v)
			var msg Messages
			msg.Id = utils.SnowFlakeId()
			msg.Userid = this.BaseController.UserUserId
			msg.Touserid = int64(userid)
			msg.Type = 4
			msg.Subtype = 33
			msg.Title = "去审批处理"
			msg.Url = "/expense/approval/" + fmt.Sprintf("%d", expense.Id)
			AddMessages(msg)
		}
		this.Data["json"] = map[string]interface{}{"code": 1, "message": "状态修改成功"}
	} else {
		this.Data["json"] = map[string]interface{}{"code": 0, "message": "状态修改失败"}
	}
	this.ServeJSON()
}
