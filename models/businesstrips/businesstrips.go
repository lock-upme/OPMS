package businesstrips

import (
	"fmt"
	"opms/models"
	"opms/utils"
	"time"

	"github.com/astaxie/beego"
	"github.com/astaxie/beego/orm"
)

type Businesstrips struct {
	Id           int64 `orm:"pk;column(businesstripid);"`
	Userid       int64
	Destinations string
	Starteds     string
	Endeds       string
	Days         int
	Reason       string
	Picture      string
	Result       int
	Status       int
	Approverids  string
	Created      int64
	Changed      int64
}

func (this *Businesstrips) TableName() string {
	return models.TableName("businesstrips")
}

func init() {
	orm.RegisterModel(new(Businesstrips))
}

func AddBusinesstrip(upd Businesstrips) error {
	o := orm.NewOrm()
	businesstrip := new(Businesstrips)

	businesstrip.Id = upd.Id
	businesstrip.Userid = upd.Userid
	businesstrip.Destinations = upd.Destinations
	businesstrip.Starteds = upd.Starteds
	businesstrip.Endeds = upd.Endeds
	businesstrip.Days = upd.Days
	businesstrip.Reason = upd.Reason
	businesstrip.Picture = upd.Picture
	businesstrip.Status = 1
	businesstrip.Approverids = upd.Approverids
	businesstrip.Created = time.Now().Unix()
	businesstrip.Changed = time.Now().Unix()
	_, err := o.Insert(businesstrip)
	return err
}

func UpdateBusinesstrip(id int64, upd Businesstrips) error {
	var businesstrip Businesstrips
	o := orm.NewOrm()
	businesstrip = Businesstrips{Id: id}

	businesstrip.Destinations = upd.Destinations
	businesstrip.Starteds = upd.Starteds
	businesstrip.Endeds = upd.Endeds
	businesstrip.Days = upd.Days
	businesstrip.Reason = upd.Reason
	businesstrip.Changed = time.Now().Unix()

	var err error
	if "" != upd.Picture {
		businesstrip.Picture = upd.Picture
		_, err = o.Update(&businesstrip, "Destinations", "Starteds", "Endeds", "Days", "Reason", "picture", "changed")
	} else {
		_, err = o.Update(&businesstrip, "Destinations", "Starteds", "Endeds", "Days", "Reason", "changed")
	}

	return err
}

func ListBusinesstrip(condArr map[string]string, page int, offset int) (num int64, err error, ops []Businesstrips) {
	o := orm.NewOrm()
	o.Using("default")
	qs := o.QueryTable(models.TableName("businesstrips"))
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
	qs = qs.OrderBy("-businesstripid")
	var businesstrip []Businesstrips
	num, errs := qs.Limit(offset, start).All(&businesstrip)
	return num, errs, businesstrip
}

func CountBusinesstrip(condArr map[string]string) int64 {
	o := orm.NewOrm()
	qs := o.QueryTable(models.TableName("businesstrips"))
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
func ListBusinesstripApproval(condArr map[string]string, page int, offset int) (num int64, err error, ops []Businesstrips) {
	if page < 1 {
		page = 1
	}
	if offset < 1 {
		offset, _ = beego.AppConfig.Int("pageoffset")
	}
	start := (page - 1) * offset
	var businesstrip []Businesstrips
	qb, _ := orm.NewQueryBuilder("mysql")
	qb.Select("l.businesstripid", "l.userid", "l.days", "l.changed", "l.approverids", "la.status").From("pms_businesstrips_approver AS la").
		LeftJoin("pms_businesstrips AS l").On("l.businesstripid = la.businesstripid").
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

	nums, err := o.Raw(sql, condArr["userid"]).QueryRows(&businesstrip)
	return nums, err, businesstrip
}

type TmpBusinesstripCount struct {
	Num int64
}

func CountBusinesstripApproval(condArr map[string]string) int64 {
	qb, _ := orm.NewQueryBuilder("mysql")
	qb.Select("Count(1) AS num").From("pms_businesstrips_approver AS la").
		LeftJoin("pms_businesstrips AS l").On("l.businesstripid = la.businesstripid").
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
	var tmp TmpBusinesstripCount
	err := o.Raw(sql, condArr["userid"]).QueryRow(&tmp)
	if err == nil {
		return tmp.Num
	} else {
		return 0
	}
}

func GetBusinesstrip(id int64) (Businesstrips, error) {
	var businesstrip Businesstrips
	var err error

	err = utils.GetCache("GetBusinesstrip.id."+fmt.Sprintf("%d", id), &businesstrip)
	if err != nil {
		cache_expire, _ := beego.AppConfig.Int("cache_expire")
		o := orm.NewOrm()
		businesstrip = Businesstrips{Id: id}
		err = o.Read(&businesstrip)
		utils.SetCache("GetBusinesstrip.id."+fmt.Sprintf("%d", id), businesstrip, cache_expire)
	}
	return businesstrip, err
}

func ChangeBusinesstripStatus(id int64, status int) error {
	o := orm.NewOrm()

	businesstrip := Businesstrips{Id: id}
	err := o.Read(&businesstrip, "businesstripid")
	if nil != err {
		return err
	} else {
		businesstrip.Status = status
		_, err := o.Update(&businesstrip)
		return err
	}
}

func ChangeBusinesstripResult(id int64, result int) error {
	o := orm.NewOrm()

	businesstrip := Businesstrips{Id: id}
	err := o.Read(&businesstrip, "businesstripid")
	if nil != err {
		return err
	} else {
		businesstrip.Result = result
		_, err := o.Update(&businesstrip)
		return err
	}
}

func DeleteBusinesstrip(id int64) error {
	o := orm.NewOrm()
	_, err := o.Delete(&Businesstrips{Id: id})

	if err == nil {
		_, err = o.Raw("DELETE FROM "+models.TableName("businesstrips_approver")+" WHERE businesstripid = ?", id).Exec()
	}
	return err
}
