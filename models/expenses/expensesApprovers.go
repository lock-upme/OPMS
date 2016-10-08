package expenses

import (
	//"fmt"
	"opms/models"
	//"opms/utils"
	"time"

	//"github.com/astaxie/beego"
	"github.com/astaxie/beego/orm"
)

type ExpensesApprover struct {
	Id        int64 `orm:"pk;column(approverid);"`
	Expenseid int64
	Userid    int64
	Summary   string
	Status    int
	Created   int64
	Changed   int64
}

func (this *ExpensesApprover) TableName() string {
	return models.TableName("expenses_approver")
}

func init() {
	orm.RegisterModel(new(ExpensesApprover))
}

func AddExpensesApprover(upd ExpensesApprover) error {
	o := orm.NewOrm()
	expense := new(ExpensesApprover)

	expense.Id = upd.Id
	expense.Userid = upd.Userid
	expense.Expenseid = upd.Expenseid
	//expense.Summary = upd.Summary
	expense.Status = 0
	expense.Created = time.Now().Unix()
	expense.Changed = time.Now().Unix()
	_, err := o.Insert(expense)
	return err
}

func UpdateExpensesApprover(id int64, upd ExpensesApprover) error {
	var expense ExpensesApprover
	o := orm.NewOrm()
	expense = ExpensesApprover{Id: id}

	expense.Summary = upd.Summary
	expense.Status = upd.Status
	expense.Changed = time.Now().Unix()
	_, err := o.Update(&expense, "summary", "status", "changed")
	if err == nil {
		//直接结束
		if upd.Status == 2 {
			ChangeExpenseResult(upd.Expenseid, 2)
			o.Raw("UPDATE pms_expenses_approver SET status = ?,summary = ?, changed = ? WHERE expenseid = ? AND approverid != ?", 2, "前审批人拒绝，后面审批人默认为拒绝状态", time.Now().Unix(), upd.Expenseid, id).Exec()
		} else {
			_, _, approvers := ListExpenseApproverProcess(upd.Expenseid)
			//检测审批顺序
			var ApproverNum = 0
			for _, v := range approvers {
				if v.Status == 1 {
					ApproverNum++
				}
			}
			if ApproverNum == len(approvers) {
				ChangeExpenseResult(upd.Expenseid, 1)
			}
		}
	}
	return err
}

type ExpenseApproverProcess struct {
	Userid   int64
	Realname string
	Avatar   string
	Position string
	Status   int
	Summary  string
	Changed  int64
}

func ListExpenseApproverProcess(expenseid int64) (num int64, err error, user []ExpenseApproverProcess) {
	var users []ExpenseApproverProcess
	qb, _ := orm.NewQueryBuilder("mysql")
	qb.Select("upr.userid", "upr.realname", "p.name AS position", "u.avatar", "la.status", "la.summary", "la.changed").From("pms_expenses_approver AS la").
		LeftJoin("pms_users AS u").On("u.userid = la.userid").
		LeftJoin("pms_users_profile AS upr").On("upr.userid = u.userid").
		LeftJoin("pms_positions AS p").On("p.positionid = upr.positionid").
		Where("la.expenseid=?").
		OrderBy("la.approverid").
		Asc()
	sql := qb.String()
	o := orm.NewOrm()
	nums, err := o.Raw(sql, expenseid).QueryRows(&users)
	return nums, err, users
}

func ListExpenseApproverProcessHtml(expenseid int64) string {
	nums, _, users := ListExpenseApproverProcess(expenseid)
	var html, avatar, css, status string
	var num = int(nums)
	for i, v := range users {
		if "" == v.Avatar {
			avatar = "/static/img/avatar/1.jpg"
		} else {
			avatar = v.Avatar
		}
		if v.Status == 1 {
			status = "同意"
		} else if v.Status == 2 {
			//css = "gray"
			status = "拒绝"
		} else {
			css = "gray"
			status = "未处"
		}

		html += "<a href='javascript:;' title='" + v.Realname + "'><img class='" + css + "' src='" + avatar + "' alt='" + v.Realname + "'>" + status + "</a>"
		if i < (num - 1) {
			html += "<span>..........</span>"
		}
	}
	return html
}

//检测是否已经审批
func CheckExpenseApprover(id, userId int64) (int64, int) {
	var expense ExpensesApprover
	o := orm.NewOrm()
	o.QueryTable(models.TableName("expenses_approver")).Filter("expenseid", id).Filter("userid", userId).One(&expense, "approverid", "status")

	return expense.Id, expense.Status
}
