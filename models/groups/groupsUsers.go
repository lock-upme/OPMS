package groups

import (
	"fmt"
	"opms/models"
	"opms/utils"

	"github.com/astaxie/beego"
	"github.com/astaxie/beego/orm"
)

type GroupsUser struct {
	Id      int64 `orm:"pk;"`
	Groupid int64
	Userid  int64
}

type GroupsUserName struct {
	Id       int64
	Userid   int64
	Realname string
	Groupid  int64
}

func (this *GroupsUser) TableName() string {
	return models.TableName("groups_user")
}

func init() {
	orm.RegisterModel(new(GroupsUser))
}

func AddGroupsUser(upd GroupsUser) error {
	o := orm.NewOrm()
	user := new(GroupsUser)

	user.Id = upd.Id
	user.Groupid = upd.Groupid
	user.Userid = upd.Userid
	_, err := o.Insert(user)
	return err
}

func DeleteGroupsUser(id int64) error {
	o := orm.NewOrm()
	_, err := o.Raw("DELETE FROM "+models.TableName("groups_user")+" WHERE id = ?", id).Exec()
	return err
}

func ListGroupsUserAndName(groupid int64) (num int64, err error, user []GroupsUserName) {
	var users []GroupsUserName
	qb, _ := orm.NewQueryBuilder("mysql")
	qb.Select("upr.userid", "upr.realname", "gu.groupid", "gu.id").
		From("pms_groups_user AS gu").
		LeftJoin("pms_users_profile AS upr").On("upr.userid = gu.userid").
		Where("gu.groupid=?").
		OrderBy("gu.id").
		Asc()
	sql := qb.String()
	o := orm.NewOrm()
	nums, err := o.Raw(sql, groupid).QueryRows(&users)
	return nums, err, users
}

func ListGroupsUser(groupid int64, page, offset int) (ops []GroupsUser) {
	if page < 1 {
		page = 1
	}
	if offset < 1 {
		offset, _ = beego.AppConfig.Int("pageoffset")
	}
	start := (page - 1) * offset

	var users []GroupsUser
	var err error
	err = utils.GetCache("ListGroupsUser.id."+fmt.Sprintf("%d", groupid), &users)
	if err != nil {
		cache_expire, _ := beego.AppConfig.Int("cache_expire")
		o := orm.NewOrm()
		o.Using("default")
		qs := o.QueryTable(models.TableName("groups_user"))
		cond := orm.NewCondition()
		cond = cond.And("groupid", groupid)
		qs = qs.SetCond(cond)
		qs.Limit(offset, start).All(&users)
		utils.SetCache("ListGroupsUser.id."+fmt.Sprintf("%d", groupid), users, cache_expire)
	}
	return users
}
