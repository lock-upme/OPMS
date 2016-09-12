package projects

import (
	"fmt"
	"opms/models"
	"opms/utils"
	"time"

	"github.com/astaxie/beego"
	"github.com/astaxie/beego/orm"
)

type ProjectsTeam struct {
	Id        int64 `orm:"pk;"`
	Projectid int64
	Userid    int64
	Created   int64
}

func (this *ProjectsTeam) TableName() string {
	return models.TableName("projects_team")
}
func init() {
	orm.RegisterModel(new(ProjectsTeam))
}

func AddTeam(upd ProjectsTeam) error {
	o := orm.NewOrm()
	team := new(ProjectsTeam)

	team.Id = upd.Id
	team.Projectid = upd.Projectid
	team.Userid = upd.Userid
	team.Created = time.Now().Unix()
	_, err := o.Insert(team)
	return err
}

func ListProjectTeam(projectId int64, page int, offset int) (num int64, err error, ops []ProjectsTeam) {
	var teams []ProjectsTeam
	var errs error

	if page < 1 {
		page = 1
	}
	if offset < 1 {
		offset, _ = beego.AppConfig.Int("pageoffset")
	}
	start := (page - 1) * offset
	errs = utils.GetCache("ListProjectTeam.id."+fmt.Sprintf("%d", projectId), &teams)
	if errs != nil {
		cache_expire, _ := beego.AppConfig.Int("cache_expire")
		o := orm.NewOrm()
		o.Using("default")
		qs := o.QueryTable(models.TableName("projects_team"))
		cond := orm.NewCondition()
		if projectId > 0 {
			cond = cond.And("projectid", projectId)
		}
		qs = qs.SetCond(cond)

		qs.Limit(offset, start).All(&teams)
		utils.SetCache("ListProjectTeam.id."+fmt.Sprintf("%d", projectId), teams, cache_expire)
	}
	return num, errs, teams
}

func DeleteProjectTeam(id int64) error {
	o := orm.NewOrm()
	_, err := o.Delete(&ProjectsTeam{Id: id})
	return err
}

func GetProjectTeam(userid, projectid int64) (ProjectsTeam, error) {
	var team ProjectsTeam
	o := orm.NewOrm()
	qs := o.QueryTable(models.TableName("projects_team"))
	err := qs.Filter("userid", userid).Filter("projectid", projectid).One(&team)
	if err == orm.ErrNoRows {
		return team, nil
	}
	return team, err
}
