package leaves

import (
	//"fmt"
	"opms/models"
	//"opms/utils"
	"time"

	//"github.com/astaxie/beego"
	"github.com/astaxie/beego/orm"
)

type LeavesApprover struct {
	Id      int64 `orm:"pk;column(approverid);"`
	Leaveid int64
	Userid  int64
	Summary string
	Status  int
	Created int64
	Changed int64
}

func (this *LeavesApprover) TableName() string {
	return models.TableName("leaves_approver")
}

func init() {
	orm.RegisterModel(new(LeavesApprover))
}

func AddLeavesApprover(upd LeavesApprover) error {
	o := orm.NewOrm()
	leave := new(LeavesApprover)

	leave.Id = upd.Id
	leave.Userid = upd.Userid
	leave.Leaveid = upd.Leaveid
	//leave.Summary = upd.Summary
	leave.Status = 0
	leave.Created = time.Now().Unix()
	leave.Changed = time.Now().Unix()
	_, err := o.Insert(leave)
	return err
}

func UpdateLeavesApprover(id int64, upd LeavesApprover) error {
	var leave LeavesApprover
	o := orm.NewOrm()
	leave = LeavesApprover{Id: id}

	leave.Summary = upd.Summary
	leave.Status = upd.Status
	leave.Changed = time.Now().Unix()
	_, err := o.Update(&leave, "summary", "status", "changed")
	if err == nil {
		//直接结束
		if upd.Status == 2 {
			ChangeLeaveResult(upd.Leaveid, 2)
			o.Raw("UPDATE pms_leaves_approver SET status = ?,summary = ?, changed = ? WHERE leaveid = ? AND approverid != ?", 2, "前审批人拒绝，后面审批人默认为拒绝状态", time.Now().Unix(), upd.Leaveid, id).Exec()
		} else {
			_, _, approvers := ListLeaveApproverProcess(upd.Leaveid)
			//检测审批顺序
			var ApproverNum = 0
			for _, v := range approvers {
				if v.Status == 1 {
					ApproverNum++
				}
			}
			if ApproverNum == len(approvers) {
				ChangeLeaveResult(upd.Leaveid, 1)
			}
		}
	}
	return err
}

type LeaveApproverProcess struct {
	Userid   int64
	Realname string
	Avatar   string
	Position string
	Status   int
	Summary  string
	Changed  int64
}

func ListLeaveApproverProcess(leaveid int64) (num int64, err error, user []LeaveApproverProcess) {
	var users []LeaveApproverProcess
	qb, _ := orm.NewQueryBuilder("mysql")
	qb.Select("upr.userid", "upr.realname", "p.name AS position", "u.avatar", "la.status", "la.summary", "la.changed").From("pms_leaves_approver AS la").
		LeftJoin("pms_users AS u").On("u.userid = la.userid").
		LeftJoin("pms_users_profile AS upr").On("upr.userid = u.userid").
		LeftJoin("pms_positions AS p").On("p.positionid = upr.positionid").
		Where("la.leaveid=?").
		OrderBy("la.approverid").
		Asc()
	sql := qb.String()
	o := orm.NewOrm()
	nums, err := o.Raw(sql, leaveid).QueryRows(&users)
	return nums, err, users
}

func ListLeaveApproverProcessHtml(leaveid int64) string {
	nums, _, users := ListLeaveApproverProcess(leaveid)
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
func CheckLeaveApprover(id, userId int64) (int64, int) {
	var leave LeavesApprover
	o := orm.NewOrm()
	o.QueryTable(models.TableName("leaves_approver")).Filter("leaveid", id).Filter("userid", userId).One(&leave, "approverid", "status")

	return leave.Id, leave.Status
}
