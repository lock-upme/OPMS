package leaves

import (
	"fmt"
	"opms/models"
	"opms/utils"
	"time"

	"github.com/astaxie/beego"
	"github.com/astaxie/beego/orm"
)

type Leaves struct {
	Id          int64 `orm:"pk;column(leaveid);"`
	Userid      int64
	Type        int
	Started     int64
	Ended       int64
	Days        float64
	Reason      string
	Picture     string
	Result      int
	Status      int
	Approverids string
	Created     int64
	Changed     int64
}

func (this *Leaves) TableName() string {
	return models.TableName("leaves")
}

func init() {
	orm.RegisterModel(new(Leaves))
}

func AddLeave(upd Leaves) error {
	o := orm.NewOrm()
	leave := new(Leaves)

	leave.Id = upd.Id
	leave.Userid = upd.Userid
	leave.Type = upd.Type
	leave.Started = upd.Started
	leave.Ended = upd.Ended
	leave.Days = upd.Days
	leave.Reason = upd.Reason
	leave.Picture = upd.Picture
	leave.Status = 1
	leave.Approverids = upd.Approverids
	leave.Created = time.Now().Unix()
	leave.Changed = time.Now().Unix()
	_, err := o.Insert(leave)
	return err
}

func UpdateLeave(id int64, upd Leaves) error {
	var leave Leaves
	o := orm.NewOrm()
	leave = Leaves{Id: id}

	leave.Type = upd.Type
	leave.Started = upd.Started
	leave.Ended = upd.Ended
	leave.Days = upd.Days
	leave.Reason = upd.Reason

	leave.Changed = time.Now().Unix()
	var err error
	if "" != upd.Picture {
		leave.Picture = upd.Picture
		_, err = o.Update(&leave, "type", "started", "ended", "days", "picture", "reason", "changed")
	} else {
		_, err = o.Update(&leave, "type", "started", "ended", "days", "reason", "changed")
	}

	return err
}

func ListLeave(condArr map[string]string, page int, offset int) (num int64, err error, ops []Leaves) {
	o := orm.NewOrm()
	o.Using("default")
	qs := o.QueryTable(models.TableName("leaves"))
	cond := orm.NewCondition()

	if condArr["status"] != "" {
		cond = cond.And("status", condArr["status"])
	}
	if condArr["userid"] != "" {
		cond = cond.And("userid", condArr["userid"])
	}
	if condArr["type"] != "" {
		cond = cond.And("type", condArr["type"])
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
	qs = qs.OrderBy("-leaveid")
	var leave []Leaves
	num, errs := qs.Limit(offset, start).All(&leave)
	return num, errs, leave
}

func CountLeave(condArr map[string]string) int64 {
	o := orm.NewOrm()
	qs := o.QueryTable(models.TableName("leaves"))
	cond := orm.NewCondition()

	if condArr["status"] != "" {
		cond = cond.And("status", condArr["status"])
	}
	if condArr["userid"] != "" {
		cond = cond.And("userid", condArr["userid"])
	}
	if condArr["type"] != "" {
		cond = cond.And("type", condArr["type"])
	}
	if condArr["result"] != "" {
		cond = cond.And("result", condArr["result"])
	}
	num, _ := qs.SetCond(cond).Count()
	return num
}

//待审批
func ListLeaveApproval(condArr map[string]string, page int, offset int) (num int64, err error, ops []Leaves) {
	if page < 1 {
		page = 1
	}
	if offset < 1 {
		offset, _ = beego.AppConfig.Int("pageoffset")
	}
	start := (page - 1) * offset
	var leave []Leaves
	qb, _ := orm.NewQueryBuilder("mysql")
	qb.Select("l.leaveid", "l.type", "l.userid", "l.started", "l.ended", "l.days", "l.approverids", "la.status").From("pms_leaves_approver AS la").
		LeftJoin("pms_leaves AS l").On("l.leaveid = la.leaveid").
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

	nums, err := o.Raw(sql, condArr["userid"]).QueryRows(&leave)
	return nums, err, leave
}

type TmpLeaveCount struct {
	Num int64
}

func CountLeaveApproval(condArr map[string]string) int64 {
	qb, _ := orm.NewQueryBuilder("mysql")
	qb.Select("Count(1) AS num").From("pms_leaves_approver AS la").
		LeftJoin("pms_leaves AS l").On("l.leaveid = la.leaveid").
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
	var tmp TmpLeaveCount
	err := o.Raw(sql, condArr["userid"]).QueryRow(&tmp)
	if err == nil {
		return tmp.Num
	} else {
		return 0
	}
}

func GetLeave(id int64) (Leaves, error) {
	var leave Leaves
	var err error

	err = utils.GetCache("GetLeave.id."+fmt.Sprintf("%d", id), &leave)
	if err != nil {
		cache_expire, _ := beego.AppConfig.Int("cache_expire")
		o := orm.NewOrm()
		leave = Leaves{Id: id}
		err = o.Read(&leave)
		utils.SetCache("GetLeave.id."+fmt.Sprintf("%d", id), leave, cache_expire)
	}
	return leave, err
}

func ChangeLeaveStatus(id int64, status int) error {
	o := orm.NewOrm()

	leave := Leaves{Id: id}
	err := o.Read(&leave, "leaveid")
	if nil != err {
		return err
	} else {
		leave.Status = status
		_, err := o.Update(&leave)
		return err
	}
}

func ChangeLeaveResult(id int64, result int) error {
	o := orm.NewOrm()

	leave := Leaves{Id: id}
	err := o.Read(&leave, "leaveid")
	if nil != err {
		return err
	} else {
		leave.Result = result
		_, err := o.Update(&leave)
		return err
	}
}

func DeleteLeave(id int64) error {
	o := orm.NewOrm()
	_, err := o.Delete(&Leaves{Id: id})

	if err == nil {
		_, err = o.Raw("DELETE FROM "+models.TableName("leaves_approver")+" WHERE leaveid = ?", id).Exec()
	}
	return err
}
