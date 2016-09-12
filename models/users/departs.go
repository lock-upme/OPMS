package users

import (
	"fmt"
	"opms/models"
	"opms/utils"

	"github.com/astaxie/beego"
	"github.com/astaxie/beego/orm"
)

type Departs struct {
	Id     int64 `orm:"pk;column(departid);"`
	Name   string
	Desc   string
	Status int
}

func (this *Departs) TableName() string {
	return models.TableName("departs")
}
func init() {
	orm.RegisterModel(new(Departs))
}

func GetDeparts(id int64) (Departs, error) {
	var depart Departs
	var err error
	o := orm.NewOrm()

	depart = Departs{Id: id}
	err = o.Read(&depart)

	if err == orm.ErrNoRows {
		return depart, nil
	}
	return depart, err
}

func GetDepartsName(id int64) string {
	var err error
	var name string
	err = utils.GetCache("GetDepartsName.id."+fmt.Sprintf("%d", id), &name)
	if err != nil {
		cache_expire, _ := beego.AppConfig.Int("cache_expire")
		var depart Departs
		o := orm.NewOrm()
		o.QueryTable(models.TableName("departs")).Filter("departid", id).One(&depart, "name")
		name = depart.Name
		utils.SetCache("GetDepartsName.id."+fmt.Sprintf("%d", id), name, cache_expire)
	}
	return name
}

func UpdateDeparts(id int64, updDep Departs) error {
	var dep Departs
	o := orm.NewOrm()
	dep = Departs{Id: id}

	dep.Name = updDep.Name
	dep.Desc = updDep.Desc
	_, err := o.Update(&dep, "name", "desc")
	return err
}

func AddDeparts(updDep Departs) error {
	o := orm.NewOrm()
	o.Using("default")
	dep := new(Departs)

	dep.Id = updDep.Id
	dep.Name = updDep.Name
	dep.Desc = updDep.Desc
	dep.Status = 1
	_, err := o.Insert(dep)

	return err
}

func ListDeparts(condArr map[string]string, page int, offset int) (num int64, err error, dep []Departs) {
	o := orm.NewOrm()
	o.Using("default")
	qs := o.QueryTable(models.TableName("departs"))
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

	var deps []Departs
	num, err1 := qs.Limit(offset, start).All(&deps)
	return num, err1, deps
}

//统计数量
func CountDeparts(condArr map[string]string) int64 {
	o := orm.NewOrm()
	qs := o.QueryTable(models.TableName("departs"))
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

//更改用户状态
func ChangeDepartStatus(id int64, status int) error {
	o := orm.NewOrm()

	dep := Departs{Id: id}
	err := o.Read(&dep, "departid")
	if nil != err {
		return err
	} else {
		dep.Status = status
		_, err := o.Update(&dep)
		return err
	}
}
