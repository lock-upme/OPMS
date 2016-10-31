package messages

import (
	//"fmt"
	"opms/models"
	//"opms/utils"
	"time"

	"github.com/astaxie/beego"
	"github.com/astaxie/beego/orm"
)

type Messages struct {
	Id       int64 `orm:"pk;column(msgid);"`
	Userid   int64
	Touserid int64
	Type     int
	Subtype  int
	Title    string
	Url      string
	View     int
	Created  int64
}

func (this *Messages) TableName() string {
	return models.TableName("messages")
}
func init() {
	orm.RegisterModel(new(Messages))
}

func AddMessages(upd Messages) error {
	o := orm.NewOrm()
	o.Using("default")
	msg := new(Messages)

	msg.Id = upd.Id
	msg.Userid = upd.Userid
	msg.Touserid = upd.Touserid
	msg.Type = upd.Type
	msg.Subtype = upd.Subtype
	msg.Title = upd.Title
	msg.Url = upd.Url
	msg.View = 1
	msg.Created = time.Now().Unix()
	_, err := o.Insert(msg)
	return err
}

func ListMessages(condArr map[string]string, page int, offset int) (num int64, err error, msg []Messages) {
	o := orm.NewOrm()
	o.Using("default")
	qs := o.QueryTable(models.TableName("messages"))
	cond := orm.NewCondition()

	if condArr["touserid"] != "" {
		cond = cond.And("touserid", condArr["touserid"])
	}
	if condArr["view"] != "" {
		cond = cond.And("view", condArr["view"])
	}
	if condArr["type"] != "" {
		cond = cond.And("type", condArr["type"])
	}

	qs = qs.SetCond(cond)
	if page < 1 {
		page = 1
	}
	if offset < 1 {
		offset, _ = beego.AppConfig.Int("pageoffset")
	}
	start := (page - 1) * offset

	qs = qs.OrderBy("-msgid")
	nums, errs := qs.Limit(offset, start).All(&msg)
	return nums, errs, msg
}

//统计数量
func CountMessages(condArr map[string]string) int64 {
	o := orm.NewOrm()
	qs := o.QueryTable(models.TableName("messages"))
	cond := orm.NewCondition()
	if condArr["touserid"] != "" {
		cond = cond.And("touserid", condArr["touserid"])
	}
	if condArr["view"] != "" {
		cond = cond.And("view", condArr["view"])
	}
	if condArr["type"] != "" {
		cond = cond.And("type", condArr["type"])
	}
	num, _ := qs.SetCond(cond).Count()
	return num
}

func ChangeMessagesStatus(id int64, view int) error {
	o := orm.NewOrm()

	msg := Messages{Id: id}
	err := o.Read(&msg, "msgid")
	if nil != err {
		return err
	} else {
		msg.View = view
		_, err := o.Update(&msg)
		return err
	}
}

func ChangeMessagesStatusAll(touserid int64) error {
	o := orm.NewOrm()
	_, err := o.Raw("UPDATE "+models.TableName("messages")+" SET view=2 WHERE touserid=? AND view=1", touserid).Exec()
	return err
}

func DeleteMessages(ids string) error {
	o := orm.NewOrm()
	_, err := o.Raw("DELETE FROM " + models.TableName("messages") + " WHERE msgid IN(" + ids + ")").Exec()
	return err
}
