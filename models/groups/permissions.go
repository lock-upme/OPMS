package groups

import (
	"fmt"
	"opms/models"
	"opms/utils"

	"github.com/astaxie/beego"
	"github.com/astaxie/beego/orm"
)

type Permissions struct {
	Id       int64 `orm:"pk;column(permissionid);"`
	Parentid int64
	Name     string
	Ename    string
	Type     int
	Weight   int
	Icon     string
}

func (this *Permissions) TableName() string {
	return models.TableName("permissions")
}

func init() {
	orm.RegisterModel(new(Permissions))
}

func AddPermission(upd Permissions) error {
	o := orm.NewOrm()
	permission := new(Permissions)

	permission.Id = upd.Id
	permission.Parentid = upd.Parentid
	permission.Name = upd.Name
	permission.Ename = upd.Ename
	permission.Type = upd.Type
	permission.Weight = upd.Weight
	permission.Icon = upd.Icon
	_, err := o.Insert(permission)
	return err
}

func UpdatePermission(id int64, upd Permissions) error {
	var permission Permissions
	o := orm.NewOrm()
	permission = Permissions{Id: id}

	permission.Parentid = upd.Parentid
	permission.Name = upd.Name
	permission.Ename = upd.Ename
	permission.Type = upd.Type
	permission.Weight = upd.Weight
	permission.Icon = upd.Icon
	var err error
	_, err = o.Update(&permission)

	return err
}

func ListPermission(condArr map[string]string, page int, offset int) (num int64, err error, ops []Permissions) {
	o := orm.NewOrm()
	o.Using("default")
	qs := o.QueryTable(models.TableName("permissions"))
	cond := orm.NewCondition()

	if condArr["keywords"] != "" {
		cond = cond.And("name__icontains", condArr["keywords"])
	}
	if condArr["parentid"] != "" {
		cond = cond.And("parentid", condArr["parentid"])
	}
	qs = qs.SetCond(cond)
	if page < 1 {
		page = 1
	}
	if offset < 1 {
		offset, _ = beego.AppConfig.Int("pageoffset")
	}
	start := (page - 1) * offset
	qs = qs.OrderBy("permissionid")
	var permission []Permissions
	num, errs := qs.Limit(offset, start).All(&permission)
	return num, errs, permission
}

func CountPermission(condArr map[string]string) int64 {
	o := orm.NewOrm()
	qs := o.QueryTable(models.TableName("permissions"))
	cond := orm.NewCondition()

	if condArr["keywords"] != "" {
		cond = cond.And("name__icontains", condArr["keywords"])
	}
	if condArr["parentid"] != "" {
		cond = cond.And("parentid", condArr["parentid"])
	}
	num, _ := qs.SetCond(cond).Count()
	return num
}

func GetPermission(id int64) (Permissions, error) {
	var permission Permissions
	var err error

	err = utils.GetCache("GetPermission.id."+fmt.Sprintf("%d", id), &permission)
	if err != nil {
		cache_expire, _ := beego.AppConfig.Int("cache_expire")
		o := orm.NewOrm()
		permission = Permissions{Id: id}
		err = o.Read(&permission)
		utils.SetCache("GetPermission.id."+fmt.Sprintf("%d", id), permission, cache_expire)
	}
	return permission, err
}

func GetPermissiontName(id int64) string {
	var err error
	var name string

	err = utils.GetCache("GetPermissiontName.id."+fmt.Sprintf("%d", id), &name)
	if err != nil {
		cache_expire, _ := beego.AppConfig.Int("cache_expire")
		var permission Permissions
		o := orm.NewOrm()
		o.QueryTable(models.TableName("permissions")).Filter("permissionid", id).One(&permission, "name")
		name = permission.Name
		if "" == name {
			name = "主栏目"
		}
		utils.SetCache("GetPermissiontName.id."+fmt.Sprintf("%d", id), name, cache_expire)
	}
	return name
}

func DeletePermission(ids string) error {
	o := orm.NewOrm()
	_, err := o.Raw("DELETE FROM " + models.TableName("permissions") + " WHERE permissionid IN(" + ids + ")").Exec()
	return err
}
