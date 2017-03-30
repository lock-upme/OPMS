package users

import (
	"fmt"
	"opms/models"
	"opms/utils"
	//"sort"
	"strings"

	"github.com/astaxie/beego"
	"github.com/astaxie/beego/orm"
)

type UsersPermissions struct {
	Id         int64 `orm:"pk;column(userid);"`
	Permission string
	Model      string
	Modelc     string
}

func (this *UsersPermissions) TableName() string {
	return models.TableName("users_permissions")
}
func init() {
	orm.RegisterModel(new(UsersPermissions))
}

func GetPermissions(id int64) string {
	var err error
	var name string
	err = utils.GetCache("GetPermissionsName.id."+fmt.Sprintf("%d", id), &name)
	if err != nil {
		cache_expire, _ := beego.AppConfig.Int("cache_expire")
		var permission UsersPermissions
		o := orm.NewOrm()
		o.QueryTable(models.TableName("users_permissions")).Filter("userid", id).One(&permission, "permission")
		name = permission.Permission
		utils.SetCache("GetPermissions.id."+fmt.Sprintf("%d", id), name, cache_expire)
	}
	return name
}

type UsersPermissionsAll struct {
	Permission string
	Groupid    string
}

func GetPermissionsAll(id int64) (UsersPermissionsAll, error) {
	var pers []UsersPermissionsAll
	var err error

	qb, _ := orm.NewQueryBuilder("mysql")

	qb.Select("p.ename AS permission", "gu.groupid").From("pms_groups_user AS gu").
		LeftJoin("pms_groups_permission AS gp").On("gp.groupid = gu.groupid").
		LeftJoin("pms_permissions AS p").On("p.permissionid = gp.permissionid").
		Where("gu.userid=?")
	sql := qb.String()
	o := orm.NewOrm()
	_, err = o.Raw(sql, id).QueryRows(&pers)

	var permissionstring = ""
	var groupidstring = ""
	for _, v := range pers {
		permissionstring += v.Permission + ","
		groupidstring += v.Groupid + ","
	}
	groupidstrings := strings.Split(strings.Trim(groupidstring, ","), ",")
	groupMap := utils.RemoveDuplicatesAndEmpty(groupidstrings)
	groupidstring = ""
	//sort.Strings(groupMap)
	for _, v := range groupMap {
		groupidstring += v + ","
	}
	var per UsersPermissionsAll
	per.Permission = strings.Trim(permissionstring, ",")
	per.Groupid = strings.Trim(groupidstring, ",")
	return per, err
}

func GetPermissionsAllOld(id int64) (UsersPermissions, error) {
	var per UsersPermissions
	var err error
	o := orm.NewOrm()

	per = UsersPermissions{Id: id}
	err = o.Read(&per)

	if err == orm.ErrNoRows {
		return per, nil
	}
	return per, err
}

func AddPermissions(updDep UsersPermissions) error {
	o := orm.NewOrm()
	o.Using("default")
	per := new(UsersPermissions)

	per.Id = updDep.Id
	per.Permission = updDep.Permission
	per.Model = updDep.Model
	per.Modelc = updDep.Modelc
	_, err := o.Insert(per)

	return err
}

func UpdatePermissions(id int64, updDep UsersPermissions) error {
	var per UsersPermissions
	o := orm.NewOrm()
	per = UsersPermissions{Id: id}

	per.Permission = updDep.Permission
	per.Model = updDep.Model
	per.Modelc = updDep.Modelc
	_, err := o.Update(&per, "permission", "model", "modelc")
	return err
}
