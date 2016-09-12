package users

import (
	"fmt"
	"opms/models"
	"opms/utils"

	"github.com/astaxie/beego"
	"github.com/astaxie/beego/orm"
)

type Positions struct {
	Id     int64 `orm:"pk;column(positionid);"`
	Name   string
	Desc   string
	Status int
}

func (this *Positions) TableName() string {
	return models.TableName("positions")
}
func init() {
	orm.RegisterModel(new(Positions))
}

func GetPositions(id int64) (Positions, error) {
	var pos Positions
	var err error
	o := orm.NewOrm()

	pos = Positions{Id: id}
	err = o.Read(&pos)

	if err == orm.ErrNoRows {
		return pos, nil
	}
	return pos, err
}

func GetPositionsName(id int64) string {
	var err error
	var name string
	err = utils.GetCache("GetPositionsName.id."+fmt.Sprintf("%d", id), &name)
	if err != nil {
		cache_expire, _ := beego.AppConfig.Int("cache_expire")
		var pos Positions
		o := orm.NewOrm()
		o.QueryTable(models.TableName("positions")).Filter("positionid", id).One(&pos, "name")
		name = pos.Name
		utils.SetCache("GetPositionsName.id."+fmt.Sprintf("%d", id), name, cache_expire)
	}
	return name
}

func UpdatePositions(id int64, updPos Positions) error {
	var pos Positions
	o := orm.NewOrm()
	pos = Positions{Id: id}

	pos.Name = updPos.Name
	pos.Desc = updPos.Desc
	_, err := o.Update(&pos, "name", "desc")
	return err
}

func AddPositions(updPos Positions) error {
	o := orm.NewOrm()
	o.Using("default")
	pos := new(Positions)

	pos.Id = updPos.Id
	pos.Name = updPos.Name
	pos.Desc = updPos.Desc
	pos.Status = 1
	_, err := o.Insert(pos)

	return err
}

func ListPositions(condArr map[string]string, page int, offset int) (num int64, err error, pos []Positions) {
	o := orm.NewOrm()
	o.Using("default")
	qs := o.QueryTable(models.TableName("positions"))
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

	var deps []Positions
	num, err1 := qs.Limit(offset, start).All(&deps)
	return num, err1, deps
}

//统计数量
func CountPositions(condArr map[string]string) int64 {
	o := orm.NewOrm()
	qs := o.QueryTable(models.TableName("positions"))
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
func ChangePositionStatus(id int64, status int) error {
	o := orm.NewOrm()

	pos := Positions{Id: id}
	err := o.Read(&pos, "positionid")
	if nil != err {
		return err
	} else {
		pos.Status = status
		_, err := o.Update(&pos)
		return err
	}
}
