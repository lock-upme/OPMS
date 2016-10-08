package oagoods

import (
	//"fmt"
	"opms/models"
	//"opms/utils"
	"time"

	//"github.com/astaxie/beego"
	"github.com/astaxie/beego/orm"
)

type OagoodsApprover struct {
	Id       int64 `orm:"pk;column(approverid);"`
	Oagoodid int64
	Userid   int64
	Summary  string
	Status   int
	Created  int64
	Changed  int64
}

func (this *OagoodsApprover) TableName() string {
	return models.TableName("oagoods_approver")
}

func init() {
	orm.RegisterModel(new(OagoodsApprover))
}

func AddOagoodsApprover(upd OagoodsApprover) error {
	o := orm.NewOrm()
	oagood := new(OagoodsApprover)

	oagood.Id = upd.Id
	oagood.Userid = upd.Userid
	oagood.Oagoodid = upd.Oagoodid
	//oagood.Summary = upd.Summary
	oagood.Status = 0
	oagood.Created = time.Now().Unix()
	oagood.Changed = time.Now().Unix()
	_, err := o.Insert(oagood)
	return err
}

func UpdateOagoodsApprover(id int64, upd OagoodsApprover) error {
	var oagood OagoodsApprover
	o := orm.NewOrm()
	oagood = OagoodsApprover{Id: id}

	oagood.Summary = upd.Summary
	oagood.Status = upd.Status
	oagood.Changed = time.Now().Unix()
	_, err := o.Update(&oagood, "summary", "status", "changed")
	if err == nil {
		//直接结束
		if upd.Status == 2 {
			ChangeOagoodResult(upd.Oagoodid, 2)
			o.Raw("UPDATE pms_oagoods_approver SET status = ?,summary = ?, changed = ? WHERE oagoodid = ? AND approverid != ?", 2, "前审批人拒绝，后面审批人默认为拒绝状态", time.Now().Unix(), upd.Oagoodid, id).Exec()
		} else {
			_, _, approvers := ListOagoodApproverProcess(upd.Oagoodid)
			//检测审批顺序
			var ApproverNum = 0
			for _, v := range approvers {
				if v.Status == 1 {
					ApproverNum++
				}
			}
			if ApproverNum == len(approvers) {
				ChangeOagoodResult(upd.Oagoodid, 1)
			}
		}
	}
	return err
}

type OagoodApproverProcess struct {
	Userid   int64
	Realname string
	Avatar   string
	Position string
	Status   int
	Summary  string
	Changed  int64
}

func ListOagoodApproverProcess(oagoodid int64) (num int64, err error, user []OagoodApproverProcess) {
	var users []OagoodApproverProcess
	qb, _ := orm.NewQueryBuilder("mysql")
	qb.Select("upr.userid", "upr.realname", "p.name AS position", "u.avatar", "la.status", "la.summary", "la.changed").From("pms_oagoods_approver AS la").
		LeftJoin("pms_users AS u").On("u.userid = la.userid").
		LeftJoin("pms_users_profile AS upr").On("upr.userid = u.userid").
		LeftJoin("pms_positions AS p").On("p.positionid = upr.positionid").
		Where("la.oagoodid=?").
		OrderBy("la.approverid").
		Asc()
	sql := qb.String()
	o := orm.NewOrm()
	nums, err := o.Raw(sql, oagoodid).QueryRows(&users)
	return nums, err, users
}

func ListOagoodApproverProcessHtml(oagoodid int64) string {
	nums, _, users := ListOagoodApproverProcess(oagoodid)
	var html, avatar, css, status string
	var num = int(nums)
	for i, v := range users {
		if "" == v.Avatar {
			avatar = "/static/img/avatar/1.jpg"
		} else {
			avatar = v.Avatar
		}
		if v.Status == 1 {
			status = "同意"
		} else if v.Status == 2 {
			//css = "gray"
			status = "拒绝"
		} else {
			css = "gray"
			status = "未处"
		}

		html += "<a href='javascript:;' title='" + v.Realname + "'><img class='" + css + "' src='" + avatar + "' alt='" + v.Realname + "'>" + status + "</a>"
		if i < (num - 1) {
			html += "<span>..........</span>"
		}
	}
	return html
}

//检测是否已经审批
func CheckOagoodApprover(id, userId int64) (int64, int) {
	var oagood OagoodsApprover
	o := orm.NewOrm()
	o.QueryTable(models.TableName("oagoods_approver")).Filter("oagoodid", id).Filter("userid", userId).One(&oagood, "approverid", "status")

	return oagood.Id, oagood.Status
}
