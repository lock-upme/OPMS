package businesstrips

import (
	//"fmt"
	"opms/models"
	//"opms/utils"
	"time"

	//"github.com/astaxie/beego"
	"github.com/astaxie/beego/orm"
)

type BusinesstripsApprover struct {
	Id             int64 `orm:"pk;column(approverid);"`
	Businesstripid int64
	Userid         int64
	Summary        string
	Status         int
	Created        int64
	Changed        int64
}

func (this *BusinesstripsApprover) TableName() string {
	return models.TableName("businesstrips_approver")
}

func init() {
	orm.RegisterModel(new(BusinesstripsApprover))
}

func AddBusinesstripsApprover(upd BusinesstripsApprover) error {
	o := orm.NewOrm()
	businesstrip := new(BusinesstripsApprover)

	businesstrip.Id = upd.Id
	businesstrip.Userid = upd.Userid
	businesstrip.Businesstripid = upd.Businesstripid
	//businesstrip.Summary = upd.Summary
	businesstrip.Status = 0
	businesstrip.Created = time.Now().Unix()
	businesstrip.Changed = time.Now().Unix()
	_, err := o.Insert(businesstrip)
	return err
}

func UpdateBusinesstripsApprover(id int64, upd BusinesstripsApprover) error {
	var businesstrip BusinesstripsApprover
	o := orm.NewOrm()
	businesstrip = BusinesstripsApprover{Id: id}

	businesstrip.Summary = upd.Summary
	businesstrip.Status = upd.Status
	businesstrip.Changed = time.Now().Unix()
	_, err := o.Update(&businesstrip, "summary", "status", "changed")
	if err == nil {
		//直接结束
		if upd.Status == 2 {
			ChangeBusinesstripResult(upd.Businesstripid, 2)
			o.Raw("UPDATE pms_businesstrips_approver SET status = ?,summary = ?, changed = ? WHERE businesstripid = ? AND approverid != ?", 2, "前审批人拒绝，后面审批人默认为拒绝状态", time.Now().Unix(), upd.Businesstripid, id).Exec()
		} else {
			_, _, approvers := ListBusinesstripApproverProcess(upd.Businesstripid)
			//检测审批顺序
			var ApproverNum = 0
			for _, v := range approvers {
				if v.Status == 1 {
					ApproverNum++
				}
			}
			if ApproverNum == len(approvers) {
				ChangeBusinesstripResult(upd.Businesstripid, 1)
			}
		}
	}
	return err
}

type BusinesstripApproverProcess struct {
	Userid   int64
	Realname string
	Avatar   string
	Position string
	Status   int
	Summary  string
	Changed  int64
}

func ListBusinesstripApproverProcess(businesstripid int64) (num int64, err error, user []BusinesstripApproverProcess) {
	var users []BusinesstripApproverProcess
	qb, _ := orm.NewQueryBuilder("mysql")
	qb.Select("upr.userid", "upr.realname", "p.name AS position", "u.avatar", "la.status", "la.summary", "la.changed").From("pms_businesstrips_approver AS la").
		LeftJoin("pms_users AS u").On("u.userid = la.userid").
		LeftJoin("pms_users_profile AS upr").On("upr.userid = u.userid").
		LeftJoin("pms_positions AS p").On("p.positionid = upr.positionid").
		Where("la.businesstripid=?").
		OrderBy("la.approverid").
		Asc()
	sql := qb.String()
	o := orm.NewOrm()
	nums, err := o.Raw(sql, businesstripid).QueryRows(&users)
	return nums, err, users
}

func ListBusinesstripApproverProcessHtml(businesstripid int64) string {
	nums, _, users := ListBusinesstripApproverProcess(businesstripid)
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
func CheckBusinesstripApprover(id, userId int64) (int64, int) {
	var businesstrip BusinesstripsApprover
	o := orm.NewOrm()
	o.QueryTable(models.TableName("businesstrips_approver")).Filter("businesstripid", id).Filter("userid", userId).One(&businesstrip, "approverid", "status")

	return businesstrip.Id, businesstrip.Status
}
