package users

import (
	"opms/models"
	"time"

	"github.com/astaxie/beego"
	"github.com/astaxie/beego/orm"
)

type Notices struct {
	Id      int64 `orm:"pk;column(noticeid);"`
	Title   string
	Content string
	Created int64
	Status  int
}

func (this *Notices) TableName() string {
	return models.TableName("notices")
}
func init() {
	orm.RegisterModel(new(Notices))
}

func GetNotices(id int64) (Notices, error) {
	var not Notices
	var err error
	o := orm.NewOrm()

	not = Notices{Id: id}
	err = o.Read(&not)

	if err == orm.ErrNoRows {
		return not, nil
	}
	return not, err
}

func UpdateNotices(id int64, upd Notices) error {
	var not Notices
	o := orm.NewOrm()
	not = Notices{Id: id}

	not.Title = upd.Title
	not.Content = upd.Content
	_, err := o.Update(&not, "title", "content")
	return err
}

func AddNotices(updDep Notices) error {
	o := orm.NewOrm()
	o.Using("default")
	not := new(Notices)

	not.Id = updDep.Id
	not.Title = updDep.Title
	not.Content = updDep.Content
	not.Status = 1
	not.Created = time.Now().Unix()
	_, err := o.Insert(not)

	return err
}

func ListNotices(condArr map[string]string, page int, offset int) (num int64, err error, dep []Notices) {
	o := orm.NewOrm()
	o.Using("default")
	qs := o.QueryTable(models.TableName("notices"))
	cond := orm.NewCondition()

	if condArr["keywords"] != "" {
		cond = cond.AndCond(cond.And("name__icontains", condArr["keywords"]))
	}
	if condArr["status"] != "" {
		cond = cond.And("status", condArr["status"])
	}

	qs = qs.SetCond(cond)
	if page < 1 {
		page = 1
	}
	if offset < 1 {
		offset, _ = beego.AppConfig.Int("pageoffset")
	}
	start := (page - 1) * offset

	var deps []Notices
	qs = qs.OrderBy("noticeid")
	num, err1 := qs.Limit(offset, start).All(&deps)
	return num, err1, deps
}

//统计数量
func CountNotices(condArr map[string]string) int64 {
	o := orm.NewOrm()
	qs := o.QueryTable(models.TableName("notices"))
	cond := orm.NewCondition()
	if condArr["keywords"] != "" {
		cond = cond.AndCond(cond.And("name__icontains", condArr["keywords"]))
	}
	if condArr["status"] != "" {
		cond = cond.And("status", condArr["status"])
	}
	num, _ := qs.SetCond(cond).Count()
	return num
}

//更改状态
func ChangeNoticeStatus(id int64, status int) error {
	o := orm.NewOrm()

	not := Notices{Id: id}
	err := o.Read(&not, "noticeid")
	if nil != err {
		return err
	} else {
		not.Status = status
		_, err := o.Update(&not)
		return err
	}
}

func DeleteNotice(id int64) error {
	o := orm.NewOrm()
	_, err := o.Delete(&Notices{Id: id})
	return err
}
