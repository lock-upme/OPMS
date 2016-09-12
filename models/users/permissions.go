package users

import (
	"fmt"
	"opms/models"
	"opms/utils"

	"github.com/astaxie/beego"
	"github.com/astaxie/beego/orm"
)

type Permissions struct {
	Id         int64 `orm:"pk;column(userid);"`
	Permission string
}

func (this *Permissions) TableName() string {
	return models.TableName("permissions")
}
func init() {
	orm.RegisterModel(new(Permissions))
}

func GetPermissions(id int64) string {
	var err error
	var name string
	err = utils.GetCache("GetPermissionsName.id."+fmt.Sprintf("%d", id), &name)
	if err != nil {
		cache_expire, _ := beego.AppConfig.Int("cache_expire")
		var permission Permissions
		o := orm.NewOrm()
		o.QueryTable(models.TableName("permissions")).Filter("userid", id).One(&permission, "permission")
		name = permission.Permission
		utils.SetCache("GetPermissions.id."+fmt.Sprintf("%d", id), name, cache_expire)
	}
	return name
}

func AddPermissions(updDep Permissions) error {
	o := orm.NewOrm()
	o.Using("default")
	per := new(Permissions)

	per.Id = updDep.Id
	per.Permission = updDep.Permission
	_, err := o.Insert(per)

	return err
}

func UpdatePermissions(id int64, updDep Permissions) error {
	var per Permissions
	o := orm.NewOrm()
	per = Permissions{Id: id}

	per.Permission = updDep.Permission
	_, err := o.Update(&per, "permission")
	return err
}
