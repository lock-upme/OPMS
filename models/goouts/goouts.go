package goouts

import (
	"fmt"
	"opms/models"
	"opms/utils"
	"time"

	"github.com/astaxie/beego"
	"github.com/astaxie/beego/orm"
)

type Goouts struct {
	Id          int64 `orm:"pk;column(gooutid);"`
	Userid      int64
	Started     int64
	Ended       int64
	Hours       float64
	Reason      string
	Picture     string
	Result      int
	Status      int
	Approverids string
	Created     int64
	Changed     int64
}

func (this *Goouts) TableName() string {
	return models.TableName("goouts")
}

func init() {
	orm.RegisterModel(new(Goouts))
}

func AddGoout(upd Goouts) error {
	o := orm.NewOrm()
	goout := new(Goouts)

	goout.Id = upd.Id
	goout.Userid = upd.Userid
	goout.Started = upd.Started
	goout.Ended = upd.Ended
	goout.Hours = upd.Hours
	goout.Reason = upd.Reason
	goout.Picture = upd.Picture
	goout.Status = 1
	goout.Approverids = upd.Approverids
	goout.Created = time.Now().Unix()
	goout.Changed = time.Now().Unix()
	_, err := o.Insert(goout)
	return err
}

func UpdateGoout(id int64, upd Goouts) error {
	var goout Goouts
	o := orm.NewOrm()
	goout = Goouts{Id: id}

	goout.Started = upd.Started
	goout.Ended = upd.Ended
	goout.Hours = upd.Hours
	goout.Reason = upd.Reason

	goout.Changed = time.Now().Unix()
	var err error
	if "" != upd.Picture {
		goout.Picture = upd.Picture
		_, err = o.Update(&goout, "started", "ended", "hours", "picture", "reason", "changed")
	} else {
		_, err = o.Update(&goout, "started", "ended", "hours", "reason", "changed")
	}

	return err
}

func ListGoout(condArr map[string]string, page int, offset int) (num int64, err error, ops []Goouts) {
	o := orm.NewOrm()
	o.Using("default")
	qs := o.QueryTable(models.TableName("goouts"))
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
	qs = qs.OrderBy("-gooutid")
	var goout []Goouts
	num, errs := qs.Limit(offset, start).All(&goout)
	return num, errs, goout
}

func CountGoout(condArr map[string]string) int64 {
	o := orm.NewOrm()
	qs := o.QueryTable(models.TableName("goouts"))
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
func ListGooutApproval(condArr map[string]string, page int, offset int) (num int64, err error, ops []Goouts) {
	if page < 1 {
		page = 1
	}
	if offset < 1 {
		offset, _ = beego.AppConfig.Int("pageoffset")
	}
	start := (page - 1) * offset
	var goout []Goouts
	qb, _ := orm.NewQueryBuilder("mysql")
	qb.Select("l.gooutid", "l.userid", "l.started", "l.ended", "l.hours", "l.approverids", "la.status").From("pms_goouts_approver AS la").
		LeftJoin("pms_goouts AS l").On("l.gooutid = la.gooutid").
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

	nums, err := o.Raw(sql, condArr["userid"]).QueryRows(&goout)
	return nums, err, goout
}

type TmpGooutCount struct {
	Num int64
}

func CountGooutApproval(condArr map[string]string) int64 {
	qb, _ := orm.NewQueryBuilder("mysql")
	qb.Select("Count(1) AS num").From("pms_goouts_approver AS la").
		LeftJoin("pms_goouts AS l").On("l.gooutid = la.gooutid").
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
	var tmp TmpGooutCount
	err := o.Raw(sql, condArr["userid"]).QueryRow(&tmp)
	if err == nil {
		return tmp.Num
	} else {
		return 0
	}
}

func GetGoout(id int64) (Goouts, error) {
	var goout Goouts
	var err error

	err = utils.GetCache("GetGoout.id."+fmt.Sprintf("%d", id), &goout)
	if err != nil {
		cache_expire, _ := beego.AppConfig.Int("cache_expire")
		o := orm.NewOrm()
		goout = Goouts{Id: id}
		err = o.Read(&goout)
		utils.SetCache("GetGoout.id."+fmt.Sprintf("%d", id), goout, cache_expire)
	}
	return goout, err
}

func ChangeGooutStatus(id int64, status int) error {
	o := orm.NewOrm()

	goout := Goouts{Id: id}
	err := o.Read(&goout, "gooutid")
	if nil != err {
		return err
	} else {
		goout.Status = status
		_, err := o.Update(&goout)
		return err
	}
}

func ChangeGooutResult(id int64, result int) error {
	o := orm.NewOrm()

	goout := Goouts{Id: id}
	err := o.Read(&goout, "gooutid")
	if nil != err {
		return err
	} else {
		goout.Result = result
		_, err := o.Update(&goout)
		return err
	}
}

func DeleteGoout(id int64) error {
	o := orm.NewOrm()
	_, err := o.Delete(&Goouts{Id: id})

	if err == nil {
		_, err = o.Raw("DELETE FROM "+models.TableName("goouts_approver")+" WHERE gooutid = ?", id).Exec()
	}
	return err
}
