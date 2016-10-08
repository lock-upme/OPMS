package oagoods

import (
	"fmt"
	"opms/models"
	"opms/utils"
	"time"

	"github.com/astaxie/beego"
	"github.com/astaxie/beego/orm"
)

type Oagoods struct {
	Id          int64 `orm:"pk;column(oagoodid);"`
	Userid      int64
	Purpose     string
	Names       string
	Quantitys   string
	Content     string
	Picture     string
	Result      int
	Status      int
	Approverids string
	Created     int64
	Changed     int64
}

func (this *Oagoods) TableName() string {
	return models.TableName("oagoods")
}

func init() {
	orm.RegisterModel(new(Oagoods))
}

func AddOagood(upd Oagoods) error {
	o := orm.NewOrm()
	oagood := new(Oagoods)

	oagood.Id = upd.Id
	oagood.Userid = upd.Userid
	oagood.Purpose = upd.Purpose
	oagood.Names = upd.Names
	oagood.Quantitys = upd.Quantitys
	oagood.Content = upd.Content
	oagood.Picture = upd.Picture
	oagood.Status = 1
	oagood.Approverids = upd.Approverids
	oagood.Created = time.Now().Unix()
	oagood.Changed = time.Now().Unix()
	_, err := o.Insert(oagood)
	return err
}

func UpdateOagood(id int64, upd Oagoods) error {
	var oagood Oagoods
	o := orm.NewOrm()
	oagood = Oagoods{Id: id}

	oagood.Purpose = upd.Purpose
	oagood.Names = upd.Names
	oagood.Quantitys = upd.Quantitys
	oagood.Content = upd.Content
	oagood.Changed = time.Now().Unix()

	var err error
	if "" != upd.Picture {
		oagood.Picture = upd.Picture
		_, err = o.Update(&oagood, "purpose", "names", "quantitys", "picture", "content", "changed")
	} else {
		_, err = o.Update(&oagood, "purpose", "names", "quantitys", "content", "changed")
	}

	return err
}

func ListOagood(condArr map[string]string, page int, offset int) (num int64, err error, ops []Oagoods) {
	o := orm.NewOrm()
	o.Using("default")
	qs := o.QueryTable(models.TableName("oagoods"))
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
	qs = qs.OrderBy("-oagoodid")
	var oagood []Oagoods
	num, errs := qs.Limit(offset, start).All(&oagood)
	return num, errs, oagood
}

func CountOagood(condArr map[string]string) int64 {
	o := orm.NewOrm()
	qs := o.QueryTable(models.TableName("oagoods"))
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
func ListOagoodApproval(condArr map[string]string, page int, offset int) (num int64, err error, ops []Oagoods) {
	if page < 1 {
		page = 1
	}
	if offset < 1 {
		offset, _ = beego.AppConfig.Int("pageoffset")
	}
	start := (page - 1) * offset
	var oagood []Oagoods
	qb, _ := orm.NewQueryBuilder("mysql")
	qb.Select("l.oagoodid", "l.purpose", "l.userid", "l.changed", "l.approverids", "la.status").From("pms_oagoods_approver AS la").
		LeftJoin("pms_oagoods AS l").On("l.oagoodid = la.oagoodid").
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

	nums, err := o.Raw(sql, condArr["userid"]).QueryRows(&oagood)
	return nums, err, oagood
}

type TmpOagoodCount struct {
	Num int64
}

func CountOagoodApproval(condArr map[string]string) int64 {
	qb, _ := orm.NewQueryBuilder("mysql")
	qb.Select("Count(1) AS num").From("pms_oagoods_approver AS la").
		LeftJoin("pms_oagoods AS l").On("l.oagoodid = la.oagoodid").
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
	var tmp TmpOagoodCount
	err := o.Raw(sql, condArr["userid"]).QueryRow(&tmp)
	if err == nil {
		return tmp.Num
	} else {
		return 0
	}
}

func GetOagood(id int64) (Oagoods, error) {
	var oagood Oagoods
	var err error

	err = utils.GetCache("GetOagood.id."+fmt.Sprintf("%d", id), &oagood)
	if err != nil {
		cache_expire, _ := beego.AppConfig.Int("cache_expire")
		o := orm.NewOrm()
		oagood = Oagoods{Id: id}
		err = o.Read(&oagood)
		utils.SetCache("GetOagood.id."+fmt.Sprintf("%d", id), oagood, cache_expire)
	}
	return oagood, err
}

func ChangeOagoodStatus(id int64, status int) error {
	o := orm.NewOrm()

	oagood := Oagoods{Id: id}
	err := o.Read(&oagood, "oagoodid")
	if nil != err {
		return err
	} else {
		oagood.Status = status
		_, err := o.Update(&oagood)
		return err
	}
}

func ChangeOagoodResult(id int64, result int) error {
	o := orm.NewOrm()

	oagood := Oagoods{Id: id}
	err := o.Read(&oagood, "oagoodid")
	if nil != err {
		return err
	} else {
		oagood.Result = result
		_, err := o.Update(&oagood)
		return err
	}
}

func DeleteOagood(id int64) error {
	o := orm.NewOrm()
	_, err := o.Delete(&Oagoods{Id: id})

	if err == nil {
		_, err = o.Raw("DELETE FROM "+models.TableName("oagoods_approver")+" WHERE oagoodid = ?", id).Exec()
	}
	return err
}
