package goouts

import (
	//"fmt"
	"opms/models"
	//"opms/utils"
	"time"

	//"github.com/astaxie/beego"
	"github.com/astaxie/beego/orm"
)

type GooutsApprover struct {
	Id      int64 `orm:"pk;column(approverid);"`
	Gooutid int64
	Userid  int64
	Summary string
	Status  int
	Created int64
	Changed int64
}

func (this *GooutsApprover) TableName() string {
	return models.TableName("goouts_approver")
}

func init() {
	orm.RegisterModel(new(GooutsApprover))
}

func AddGooutsApprover(upd GooutsApprover) error {
	o := orm.NewOrm()
	goout := new(GooutsApprover)

	goout.Id = upd.Id
	goout.Userid = upd.Userid
	goout.Gooutid = upd.Gooutid
	//goout.Summary = upd.Summary
	goout.Status = 0
	goout.Created = time.Now().Unix()
	goout.Changed = time.Now().Unix()
	_, err := o.Insert(goout)
	return err
}

func UpdateGooutsApprover(id int64, upd GooutsApprover) error {
	var goout GooutsApprover
	o := orm.NewOrm()
	goout = GooutsApprover{Id: id}

	goout.Summary = upd.Summary
	goout.Status = upd.Status
	goout.Changed = time.Now().Unix()
	_, err := o.Update(&goout, "summary", "status", "changed")
	if err == nil {
		//直接结束
		if upd.Status == 2 {
			ChangeGooutResult(upd.Gooutid, 2)
			o.Raw("UPDATE pms_goouts_approver SET status = ?,summary = ?, changed = ? WHERE gooutid = ? AND approverid != ?", 2, "前审批人拒绝，后面审批人默认为拒绝状态", time.Now().Unix(), upd.Gooutid, id).Exec()
		} else {
			_, _, approvers := ListGooutApproverProcess(upd.Gooutid)
			//检测审批顺序
			var ApproverNum = 0
			for _, v := range approvers {
				if v.Status == 1 {
					ApproverNum++
				}
			}
			if ApproverNum == len(approvers) {
				ChangeGooutResult(upd.Gooutid, 1)
			}
		}
	}
	return err
}

type GooutApproverProcess struct {
	Userid   int64
	Realname string
	Avatar   string
	Position string
	Status   int
	Summary  string
	Changed  int64
}

func ListGooutApproverProcess(gooutid int64) (num int64, err error, user []GooutApproverProcess) {
	var users []GooutApproverProcess
	qb, _ := orm.NewQueryBuilder("mysql")
	qb.Select("upr.userid", "upr.realname", "p.name AS position", "u.avatar", "la.status", "la.summary", "la.changed").From("pms_goouts_approver AS la").
		LeftJoin("pms_users AS u").On("u.userid = la.userid").
		LeftJoin("pms_users_profile AS upr").On("upr.userid = u.userid").
		LeftJoin("pms_positions AS p").On("p.positionid = upr.positionid").
		Where("la.gooutid=?").
		OrderBy("la.approverid").
		Asc()
	sql := qb.String()
	o := orm.NewOrm()
	nums, err := o.Raw(sql, gooutid).QueryRows(&users)
	return nums, err, users
}

func ListGooutApproverProcessHtml(gooutid int64) string {
	nums, _, users := ListGooutApproverProcess(gooutid)
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
func CheckGooutApprover(id, userId int64) (int64, int) {
	var goout GooutsApprover
	o := orm.NewOrm()
	o.QueryTable(models.TableName("goouts_approver")).Filter("gooutid", id).Filter("userid", userId).One(&goout, "approverid", "status")

	return goout.Id, goout.Status
}
