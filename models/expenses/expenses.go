package expenses

import (
	"fmt"
	"opms/models"
	"opms/utils"
	"time"

	"github.com/astaxie/beego"
	"github.com/astaxie/beego/orm"
)

type Expenses struct {
	Id          int64 `orm:"pk;column(expenseid);"`
	Userid      int64
	Amounts     string
	Types       string
	Contents    string
	Total       float64
	Picture     string
	Result      int
	Status      int
	Approverids string
	Created     int64
	Changed     int64
}

func (this *Expenses) TableName() string {
	return models.TableName("expenses")
}

func init() {
	orm.RegisterModel(new(Expenses))
}

func AddExpense(upd Expenses) error {
	o := orm.NewOrm()
	expense := new(Expenses)

	expense.Id = upd.Id
	expense.Userid = upd.Userid
	expense.Amounts = upd.Amounts
	expense.Types = upd.Types
	expense.Contents = upd.Contents
	expense.Total = upd.Total
	expense.Picture = upd.Picture
	expense.Status = 1
	expense.Approverids = upd.Approverids
	expense.Created = time.Now().Unix()
	expense.Changed = time.Now().Unix()
	_, err := o.Insert(expense)
	return err
}

func UpdateExpense(id int64, upd Expenses) error {
	var expense Expenses
	o := orm.NewOrm()
	expense = Expenses{Id: id}

	expense.Amounts = upd.Amounts
	expense.Types = upd.Types
	expense.Contents = upd.Contents
	expense.Total = upd.Total
	expense.Changed = time.Now().Unix()

	var err error
	if "" != upd.Picture {
		expense.Picture = upd.Picture
		_, err = o.Update(&expense, "amounts", "types", "contents", "picture", "total", "changed")
	} else {
		_, err = o.Update(&expense, "amounts", "types", "contents", "total", "changed")
	}

	return err
}

func ListExpense(condArr map[string]string, page int, offset int) (num int64, err error, ops []Expenses) {
	o := orm.NewOrm()
	o.Using("default")
	qs := o.QueryTable(models.TableName("expenses"))
	cond := orm.NewCondition()

	if condArr["status"] != "" {
		cond = cond.And("status", condArr["status"])
	}
	if condArr["userid"] != "" {
		cond = cond.And("userid", condArr["userid"])
	}
	if condArr["result"] != "" {
		cond = cond.And("result", condArr["result"])
	}
	qs = qs.SetCond(cond)
	if page < 1 {
		page = 1
	}
	if offset < 1 {
		offset, _ = beego.AppConfig.Int("pageoffset")
	}
	start := (page - 1) * offset
	qs = qs.OrderBy("-expenseid")
	var expense []Expenses
	num, errs := qs.Limit(offset, start).All(&expense)
	return num, errs, expense
}

func CountExpense(condArr map[string]string) int64 {
	o := orm.NewOrm()
	qs := o.QueryTable(models.TableName("expenses"))
	cond := orm.NewCondition()

	if condArr["status"] != "" {
		cond = cond.And("status", condArr["status"])
	}
	if condArr["userid"] != "" {
		cond = cond.And("userid", condArr["userid"])
	}
	if condArr["result"] != "" {
		cond = cond.And("result", condArr["result"])
	}
	num, _ := qs.SetCond(cond).Count()
	return num
}

//待审批
func ListExpenseApproval(condArr map[string]string, page int, offset int) (num int64, err error, ops []Expenses) {
	if page < 1 {
		page = 1
	}
	if offset < 1 {
		offset, _ = beego.AppConfig.Int("pageoffset")
	}
	start := (page - 1) * offset
	var expense []Expenses
	qb, _ := orm.NewQueryBuilder("mysql")
	qb.Select("l.expenseid", "l.userid", "l.total", "l.changed", "l.approverids", "la.status").From("pms_expenses_approver AS la").
		LeftJoin("pms_expenses AS l").On("l.expenseid = la.expenseid").
		Where("la.userid=?").
		And("l.status=2")

	if condArr["status"] == "0" {
		qb.And("la.status=0")
		qb.And("l.result=0")
	} else if condArr["status"] == "1" {
		qb.And("la.status>0")
	}
	qb.OrderBy("la.approverid").
		Desc().
		Limit(offset).
		Offset(start)

	sql := qb.String()
	o := orm.NewOrm()

	nums, err := o.Raw(sql, condArr["userid"]).QueryRows(&expense)
	return nums, err, expense
}

type TmpExpenseCount struct {
	Num int64
}

func CountExpenseApproval(condArr map[string]string) int64 {
	qb, _ := orm.NewQueryBuilder("mysql")
	qb.Select("Count(1) AS num").From("pms_expenses_approver AS la").
		LeftJoin("pms_expenses AS l").On("l.expenseid = la.expenseid").
		Where("la.userid=?").
		And("l.status=2")
	if condArr["status"] == "0" {
		qb.And("la.status=0")
		qb.And("l.result=0")
	} else if condArr["status"] == "1" {
		qb.And("la.status>0")
	}
	sql := qb.String()
	o := orm.NewOrm()
	var tmp TmpExpenseCount
	err := o.Raw(sql, condArr["userid"]).QueryRow(&tmp)
	if err == nil {
		return tmp.Num
	} else {
		return 0
	}
}

func GetExpense(id int64) (Expenses, error) {
	var expense Expenses
	var err error

	err = utils.GetCache("GetExpense.id."+fmt.Sprintf("%d", id), &expense)
	if err != nil {
		cache_expire, _ := beego.AppConfig.Int("cache_expire")
		o := orm.NewOrm()
		expense = Expenses{Id: id}
		err = o.Read(&expense)
		utils.SetCache("GetExpense.id."+fmt.Sprintf("%d", id), expense, cache_expire)
	}
	return expense, err
}

func ChangeExpenseStatus(id int64, status int) error {
	o := orm.NewOrm()

	expense := Expenses{Id: id}
	err := o.Read(&expense, "expenseid")
	if nil != err {
		return err
	} else {
		expense.Status = status
		_, err := o.Update(&expense)
		return err
	}
}

func ChangeExpenseResult(id int64, result int) error {
	o := orm.NewOrm()

	expense := Expenses{Id: id}
	err := o.Read(&expense, "expenseid")
	if nil != err {
		return err
	} else {
		expense.Result = result
		_, err := o.Update(&expense)
		return err
	}
}

func DeleteExpense(id int64) error {
	o := orm.NewOrm()
	_, err := o.Delete(&Expenses{Id: id})

	if err == nil {
		_, err = o.Raw("DELETE FROM "+models.TableName("expenses_approver")+" WHERE expenseid = ?", id).Exec()
	}
	return err
}
