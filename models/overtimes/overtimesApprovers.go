package overtimes

import (
	//"fmt"
	"opms/models"
	//"opms/utils"
	"time"

	//"github.com/astaxie/beego"
	"github.com/astaxie/beego/orm"
)

type OvertimesApprover struct {
	Id         int64 `orm:"pk;column(approverid);"`
	Overtimeid int64
	Userid     int64
	Summary    string
	Status     int
	Created    int64
	Changed    int64
}

func (this *OvertimesApprover) TableName() string {
	return models.TableName("overtimes_approver")
}

func init() {
	orm.RegisterModel(new(OvertimesApprover))
}

func AddOvertimesApprover(upd OvertimesApprover) error {
	o := orm.NewOrm()
	overtime := new(OvertimesApprover)

	overtime.Id = upd.Id
	overtime.Userid = upd.Userid
	overtime.Overtimeid = upd.Overtimeid
	//overtime.Summary = upd.Summary
	overtime.Status = 0
	overtime.Created = time.Now().Unix()
	overtime.Changed = time.Now().Unix()
	_, err := o.Insert(overtime)
	return err
}

func UpdateOvertimesApprover(id int64, upd OvertimesApprover) error {
	var overtime OvertimesApprover
	o := orm.NewOrm()
	overtime = OvertimesApprover{Id: id}

	overtime.Summary = upd.Summary
	overtime.Status = upd.Status
	overtime.Changed = time.Now().Unix()
	_, err := o.Update(&overtime, "summary", "status", "changed")
	if err == nil {
		//直接结束
		if upd.Status == 2 {
			ChangeOvertimeResult(upd.Overtimeid, 2)
			o.Raw("UPDATE pms_overtimes_approver SET status = ?,summary = ?, changed = ? WHERE overtimeid = ? AND approverid != ?", 2, "前审批人拒绝，后面审批人默认为拒绝状态", time.Now().Unix(), upd.Overtimeid, id).Exec()
		} else {
			_, _, approvers := ListOvertimeApproverProcess(upd.Overtimeid)
			//检测审批顺序
			var ApproverNum = 0
			for _, v := range approvers {
				if v.Status == 1 {
					ApproverNum++
				}
			}
			if ApproverNum == len(approvers) {
				ChangeOvertimeResult(upd.Overtimeid, 1)
			}
		}
	}
	return err
}

type OvertimeApproverProcess struct {
	Userid   int64
	Realname string
	Avatar   string
	Position string
	Status   int
	Summary  string
	Changed  int64
}

func ListOvertimeApproverProcess(overtimeid int64) (num int64, err error, user []OvertimeApproverProcess) {
	var users []OvertimeApproverProcess
	qb, _ := orm.NewQueryBuilder("mysql")
	qb.Select("upr.userid", "upr.realname", "p.name AS position", "u.avatar", "la.status", "la.summary", "la.changed").From("pms_overtimes_approver AS la").
		LeftJoin("pms_users AS u").On("u.userid = la.userid").
		LeftJoin("pms_users_profile AS upr").On("upr.userid = u.userid").
		LeftJoin("pms_positions AS p").On("p.positionid = upr.positionid").
		Where("la.overtimeid=?").
		OrderBy("la.approverid").
		Asc()
	sql := qb.String()
	o := orm.NewOrm()
	nums, err := o.Raw(sql, overtimeid).QueryRows(&users)
	return nums, err, users
}

func ListOvertimeApproverProcessHtml(overtimeid int64) string {
	nums, _, users := ListOvertimeApproverProcess(overtimeid)
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
func CheckOvertimeApprover(id, userId int64) (int64, int) {
	var overtime OvertimesApprover
	o := orm.NewOrm()
	o.QueryTable(models.TableName("overtimes_approver")).Filter("overtimeid", id).Filter("userid", userId).One(&overtime, "approverid", "status")

	return overtime.Id, overtime.Status
}
