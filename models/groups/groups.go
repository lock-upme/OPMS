package groups

import (
	"fmt"
	"opms/models"
	"opms/utils"
	"time"

	"github.com/astaxie/beego"
	"github.com/astaxie/beego/orm"
)

type Groups struct {
	Id      int64 `orm:"pk;column(groupid);"`
	Name    string
	Summary string
	Created int64
	Changed int64
}

func (this *Groups) TableName() string {
	return models.TableName("groups")
}

func init() {
	orm.RegisterModel(new(Groups))
}

func AddGroup(upd Groups) error {
	o := orm.NewOrm()
	group := new(Groups)

	group.Id = upd.Id
	group.Name = upd.Name
	group.Summary = upd.Summary
	group.Created = time.Now().Unix()
	group.Changed = time.Now().Unix()
	_, err := o.Insert(group)
	return err
}

func UpdateGroup(id int64, upd Groups) error {
	var group Groups
	o := orm.NewOrm()
	group = Groups{Id: id}

	group.Name = upd.Name
	group.Summary = upd.Summary
	group.Changed = time.Now().Unix()
	var err error
	_, err = o.Update(&group, "name", "summary", "changed")

	return err
}

func ListGroup(condArr map[string]string, page int, offset int) (num int64, err error, ops []Groups) {
	o := orm.NewOrm()
	o.Using("default")
	qs := o.QueryTable(models.TableName("groups"))
	cond := orm.NewCondition()

	if condArr["keywords"] != "" {
		cond = cond.And("name__icontains", condArr["keywords"])
	}
	qs = qs.SetCond(cond)
	if page < 1 {
		page = 1
	}
	if offset < 1 {
		offset, _ = beego.AppConfig.Int("pageoffset")
	}
	start := (page - 1) * offset
	qs = qs.OrderBy("-groupid")
	var group []Groups
	num, errs := qs.Limit(offset, start).All(&group)
	return num, errs, group
}

func CountGroup(condArr map[string]string) int64 {
	o := orm.NewOrm()
	qs := o.QueryTable(models.TableName("groups"))
	cond := orm.NewCondition()

	if condArr["keywords"] != "" {
		cond = cond.And("name__icontains", condArr["keywords"])
	}
	num, _ := qs.SetCond(cond).Count()
	return num
}

func GetGroup(id int64) (Groups, error) {
	var group Groups
	var err error

	err = utils.GetCache("GetGroup.id."+fmt.Sprintf("%d", id), &group)
	if err != nil {
		cache_expire, _ := beego.AppConfig.Int("cache_expire")
		o := orm.NewOrm()
		group = Groups{Id: id}
		err = o.Read(&group)
		utils.SetCache("GetGroup.id."+fmt.Sprintf("%d", id), group, cache_expire)
	}
	return group, err
}

func DeleteGroup(ids string) error {
	o := orm.NewOrm()
	_, err := o.Raw("DELETE FROM " + models.TableName("groups") + " WHERE groupid IN(" + ids + ")").Exec()
	return err
}
