package overtimes

import (
	"fmt"
	"opms/models"
	"opms/utils"
	"time"

	"github.com/astaxie/beego"
	"github.com/astaxie/beego/orm"
)

type Overtimes struct {
	Id          int64 `orm:"pk;column(overtimeid);"`
	Userid      int64
	Started     int64
	Ended       int64
	Longtime    float64
	Holiday     int
	Way         int
	Reason      string
	Result      int
	Status      int
	Approverids string
	Created     int64
	Changed     int64
}

func (this *Overtimes) TableName() string {
	return models.TableName("overtimes")
}

func init() {
	orm.RegisterModel(new(Overtimes))
}

func AddOvertime(upd Overtimes) error {
	o := orm.NewOrm()
	overtime := new(Overtimes)

	overtime.Id = upd.Id
	overtime.Userid = upd.Userid
	overtime.Started = upd.Started
	overtime.Ended = upd.Ended
	overtime.Longtime = upd.Longtime
	overtime.Holiday = upd.Holiday
	overtime.Way = upd.Way
	overtime.Reason = upd.Reason
	overtime.Status = 1
	overtime.Approverids = upd.Approverids
	overtime.Created = time.Now().Unix()
	overtime.Changed = time.Now().Unix()
	_, err := o.Insert(overtime)
	return err
}

func UpdateOvertime(id int64, upd Overtimes) error {
	var overtime Overtimes
	o := orm.NewOrm()
	overtime = Overtimes{Id: id}

	overtime.Started = upd.Started
	overtime.Ended = upd.Ended
	overtime.Longtime = upd.Longtime
	overtime.Holiday = upd.Holiday
	overtime.Way = upd.Way
	overtime.Reason = upd.Reason

	overtime.Changed = time.Now().Unix()
	var err error
	_, err = o.Update(&overtime, "started", "ended", "longtime", "holiday", "way", "reason", "changed")
	return err
}

func ListOvertime(condArr map[string]string, page int, offset int) (num int64, err error, ops []Overtimes) {
	o := orm.NewOrm()
	o.Using("default")
	qs := o.QueryTable(models.TableName("overtimes"))
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
	qs = qs.OrderBy("-overtimeid")
	var overtime []Overtimes
	num, errs := qs.Limit(offset, start).All(&overtime)
	return num, errs, overtime
}

func CountOvertime(condArr map[string]string) int64 {
	o := orm.NewOrm()
	qs := o.QueryTable(models.TableName("overtimes"))
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
func ListOvertimeApproval(condArr map[string]string, page int, offset int) (num int64, err error, ops []Overtimes) {
	if page < 1 {
		page = 1
	}
	if offset < 1 {
		offset, _ = beego.AppConfig.Int("pageoffset")
	}
	start := (page - 1) * offset
	var overtime []Overtimes
	qb, _ := orm.NewQueryBuilder("mysql")
	qb.Select("l.overtimeid", "l.userid", "l.started", "l.ended", "l.longtime", "l.holiday", "l.way", "l.approverids", "la.status").From("pms_overtimes_approver AS la").
		LeftJoin("pms_overtimes AS l").On("l.overtimeid = la.overtimeid").
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

	nums, err := o.Raw(sql, condArr["userid"]).QueryRows(&overtime)
	return nums, err, overtime
}

type TmpOvertimeCount struct {
	Num int64
}

func CountOvertimeApproval(condArr map[string]string) int64 {
	qb, _ := orm.NewQueryBuilder("mysql")
	qb.Select("Count(1) AS num").From("pms_overtimes_approver AS la").
		LeftJoin("pms_overtimes AS l").On("l.overtimeid = la.overtimeid").
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
	var tmp TmpOvertimeCount
	err := o.Raw(sql, condArr["userid"]).QueryRow(&tmp)
	if err == nil {
		return tmp.Num
	} else {
		return 0
	}
}

func GetOvertime(id int64) (Overtimes, error) {
	var overtime Overtimes
	var err error

	err = utils.GetCache("GetOvertime.id."+fmt.Sprintf("%d", id), &overtime)
	if err != nil {
		cache_expire, _ := beego.AppConfig.Int("cache_expire")
		o := orm.NewOrm()
		overtime = Overtimes{Id: id}
		err = o.Read(&overtime)
		utils.SetCache("GetOvertime.id."+fmt.Sprintf("%d", id), overtime, cache_expire)
	}
	return overtime, err
}

func ChangeOvertimeStatus(id int64, status int) error {
	o := orm.NewOrm()

	overtime := Overtimes{Id: id}
	err := o.Read(&overtime, "overtimeid")
	if nil != err {
		return err
	} else {
		overtime.Status = status
		_, err := o.Update(&overtime)
		return err
	}
}

func ChangeOvertimeResult(id int64, result int) error {
	o := orm.NewOrm()

	overtime := Overtimes{Id: id}
	err := o.Read(&overtime, "overtimeid")
	if nil != err {
		return err
	} else {
		overtime.Result = result
		_, err := o.Update(&overtime)
		return err
	}
}

func DeleteOvertime(id int64) error {
	o := orm.NewOrm()
	_, err := o.Delete(&Overtimes{Id: id})

	if err == nil {
		_, err = o.Raw("DELETE FROM "+models.TableName("overtimes_approver")+" WHERE overtimeid = ?", id).Exec()
	}
	return err
}
