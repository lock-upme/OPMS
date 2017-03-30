package groups

import (
	"fmt"
	"opms/models"
	"opms/utils"

	"github.com/astaxie/beego"
	"github.com/astaxie/beego/orm"
)

type GroupsPermission struct {
	Id           int64 `orm:"pk;"`
	Groupid      int64
	Permissionid int64
}

func (this *GroupsPermission) TableName() string {
	return models.TableName("groups_permission")
}

func init() {
	orm.RegisterModel(new(GroupsPermission))
}

func AddGroupsPermission(upd GroupsPermission) error {
	o := orm.NewOrm()
	permission := new(GroupsPermission)

	permission.Id = upd.Id
	permission.Groupid = upd.Groupid
	permission.Permissionid = upd.Permissionid
	_, err := o.Insert(permission)
	return err
}

func DeleteGroupsPermission(id int64) error {
	o := orm.NewOrm()
	_, err := o.Raw("DELETE FROM "+models.TableName("groups_permission")+" WHERE id = ?", id).Exec()
	return err
}
func DeleteGroupsPermissionForGroupid(groupid int64) error {
	o := orm.NewOrm()
	_, err := o.Raw("DELETE FROM "+models.TableName("groups_permission")+" WHERE groupid = ?", groupid).Exec()
	return err
}

func ListGroupsPermission(groupid int64) (ops []GroupsPermission) {
	var permissions []GroupsPermission

	o := orm.NewOrm()
	o.Using("default")
	qs := o.QueryTable(models.TableName("groups_permission"))
	cond := orm.NewCondition()
	cond = cond.And("groupid", groupid)
	qs = qs.SetCond(cond)
	qs.All(&permissions)

	return permissions
}

type GroupsUserPermission struct {
	Name  string
	Ename string
	Icon  string
}

func ListGroupsUserPermission(groupid string) (num int64, err error, ops []GroupsUserPermission) {
	var users []GroupsUserPermission
	err = utils.GetCache("ListGroupsUserPermission.id."+fmt.Sprintf("%d", groupid), &users)
	var nums int64
	if err != nil {
		cache_expire, _ := beego.AppConfig.Int("cache_expire")
		qb, _ := orm.NewQueryBuilder("mysql")

		qb.Select("pp.name", "pp.ename", "pp.icon").From("pms_groups_permission AS gp").
			LeftJoin("pms_permissions AS p").On("gp.permissionid = p.permissionid").
			LeftJoin("pms_permissions AS pp").On("pp.permissionid = p.parentid").
			Where("gp.groupid IN (" + groupid + ")").
			GroupBy("p.parentid")
		sql := qb.String()
		o := orm.NewOrm()
		nums, err = o.Raw(sql).QueryRows(&users)
		utils.SetCache("ListGroupsUserPermission.id."+fmt.Sprintf("%d", groupid), users, cache_expire)
	}
	return nums, err, users
}
