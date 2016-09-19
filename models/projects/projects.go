package projects

import (
	"fmt"
	"opms/models"
	"opms/utils"
	"time"

	"github.com/astaxie/beego"
	"github.com/astaxie/beego/orm"
)

type Projects struct {
	Id         int64 `orm:"pk;column(projectid);"`
	Userid     int64
	Name       string
	Aliasname  string
	Started    int64
	Ended      int64
	Desc       string
	Created    int64
	Status     int
	Projuserid int64
	Produserid int64
	Testuserid int64
	Publuserid int64
}

func (this *Projects) TableName() string {
	return models.TableName("projects")
}
func init() {
	orm.RegisterModel(new(Projects))
}

func GetProject(id int64) (Projects, error) {
	var project Projects
	var err error

	//err = utils.GetCache("GetProject.id."+fmt.Sprintf("%d", id), &project)
	//if err != nil {
	o := orm.NewOrm()
	project = Projects{Id: id}
	err = o.Read(&project)
	//utils.SetCache("GetProject.id."+fmt.Sprintf("%d", id), project, 600)
	//}
	return project, err
}

func GetProjectName(id int64) string {
	var err error
	var name string

	err = utils.GetCache("GetProjectName.id."+fmt.Sprintf("%d", id), &name)
	if err != nil {
		cache_expire, _ := beego.AppConfig.Int("cache_expire")
		var project Projects
		o := orm.NewOrm()
		o.QueryTable(models.TableName("projects")).Filter("projectid", id).One(&project, "name")
		name = project.Name
		utils.SetCache("GetProjectName.id."+fmt.Sprintf("%d", id), name, cache_expire)
	}
	return name
}

func UpdateProject(id int64, updPro Projects) error {
	var pro Projects
	o := orm.NewOrm()
	pro = Projects{Id: id}

	pro.Name = updPro.Name
	pro.Aliasname = updPro.Aliasname
	pro.Started = updPro.Started
	pro.Ended = updPro.Ended
	pro.Desc = updPro.Desc
	pro.Projuserid = updPro.Projuserid
	pro.Produserid = updPro.Produserid
	pro.Testuserid = updPro.Testuserid
	pro.Publuserid = updPro.Publuserid
	//pro.Status = updPro.Status
	_, err := o.Update(&pro, "name", "aliasname", "started", "ended", "desc", "projuserid", "produserid", "testuserid", "publuserid")
	return err
}

func AddProject(updPro Projects) error {
	o := orm.NewOrm()
	pro := new(Projects)

	pro.Id = updPro.Id
	pro.Userid = updPro.Userid
	pro.Name = updPro.Name
	pro.Aliasname = updPro.Aliasname
	pro.Started = updPro.Started
	pro.Ended = updPro.Ended
	pro.Desc = updPro.Desc
	pro.Created = time.Now().Unix()
	pro.Status = 1
	_, err := o.Insert(pro)
	return err
}

//项目列表
func ListProject(condArr map[string]string, page int, offset int) (num int64, err error, user []Projects) {
	o := orm.NewOrm()
	o.Using("default")
	qs := o.QueryTable(models.TableName("projects"))
	cond := orm.NewCondition()
	if condArr["keywords"] != "" {
		cond = cond.AndCond(cond.And("name__icontains", condArr["keywords"]).Or("aliasname__icontains", condArr["keywords"]))
	}
	if condArr["status"] != "" {
		cond = cond.And("status", condArr["status"])
	}
	qs = qs.SetCond(cond)
	if page < 1 {
		page = 1
	}
	if offset < 1 {
		offset, _ = beego.AppConfig.Int("pageoffset")
	}
	start := (page - 1) * offset
	qs = qs.RelatedSel()

	var projects []Projects
	num, err1 := qs.Limit(offset, start).All(&projects)
	return num, err1, projects
}

//统计数量
func CountProject(condArr map[string]string) int64 {
	o := orm.NewOrm()
	qs := o.QueryTable(models.TableName("projects"))
	qs = qs.RelatedSel()
	cond := orm.NewCondition()
	if condArr["keywords"] != "" {
		cond = cond.AndCond(cond.And("name__icontains", condArr["keywords"]).Or("aliasname__icontains", condArr["keywords"]))
	}
	if condArr["status"] != "" {
		cond = cond.And("status", condArr["status"])
	}
	num, _ := qs.SetCond(cond).Count()
	return num
}

func ListMyProject(userId int64, page int, offset int) (num int64, err error, ops []Projects) {
	if page < 1 {
		page = 1
	}
	if offset < 1 {
		offset, _ = beego.AppConfig.Int("pageoffset")
	}
	start := (page - 1) * offset

	var projects []Projects

	qb, _ := orm.NewQueryBuilder("mysql")
	qb.Select("p.projectid", "p.name", "p.aliasname", "p.ended", "p.status", "p.projuserid").From("pms_projects_team AS t").
		LeftJoin("pms_projects AS p").On("p.projectid = t.projectid").
		Where("t.userid=?").
		Limit(offset).Offset(start)
	sql := qb.String()
	o := orm.NewOrm()
	nums, err := o.Raw(sql, userId).QueryRows(&projects)
	return nums, err, projects
}

func ChangeProjectStatus(id int64, status int) error {
	o := orm.NewOrm()

	pro := Projects{Id: id}
	err := o.Read(&pro, "projectid")
	if nil != err {
		return err
	} else {
		pro.Status = status
		_, err := o.Update(&pro)
		return err
	}
}

//统计项目
type ChartProject struct {
	Value int
	Name  string
}
type ChartProjectInt struct {
	Value int
	Name  int
}

//统计项目成员职称比例
func ChartProjectTeam(projectId int64) (num int64, err error, team []ChartProject) {
	var teams []ChartProject
	qb, _ := orm.NewQueryBuilder("mysql")

	qb.Select("COUNT(1) AS value", "p.name").From("pms_projects_team AS pt").
		LeftJoin("pms_users_profile AS up").On("up.userid = pt.userid").
		LeftJoin("pms_positions AS p").On("p.positionid = up.positionid").
		Where("pt.projectid=?").
		GroupBy("p.`name`")
	sql := qb.String()
	o := orm.NewOrm()
	nums, err := o.Raw(sql, projectId).QueryRows(&teams)
	return nums, err, teams
}

//统计需求指派人数量比例
func ChartProjectNeed(op string, projectId int64) (num int64, err error, need []ChartProject) {
	var needs []ChartProject
	qb, _ := orm.NewQueryBuilder("mysql")

	if op == "accept" {
		qb.Select("COUNT(1) AS value", "up.realname AS name").From("pms_projects_needs AS pn").
			LeftJoin("pms_users_profile AS up").On("up.userid = pn.acceptid").
			Where("pn.projectid=?").
			GroupBy("pn.`acceptid`")
	} else if op == "user" {
		qb.Select("COUNT(1) AS value", "up.realname AS name").From("pms_projects_needs AS pn").
			LeftJoin("pms_users_profile AS up").On("up.userid = pn.userid").
			Where("pn.projectid=?").
			GroupBy("pn.`userid`")
	} /*else if op == "source" {
		qb.Select("COUNT(1) AS value", "pn.source AS name").From("pms_projects_needs AS pn").
			Where("pn.projectid=?").
			GroupBy("pn.`source`")
	}*/
	sql := qb.String()
	o := orm.NewOrm()
	nums, err := o.Raw(sql, projectId).QueryRows(&needs)
	return nums, err, needs
}
func ChartProjectNeedSource(projectId int64) (num int64, err error, need []ChartProjectInt) {
	var needs []ChartProjectInt
	qb, _ := orm.NewQueryBuilder("mysql")

	qb.Select("COUNT(1) AS value", "pn.source AS name").From("pms_projects_needs AS pn").
		Where("pn.projectid=?").
		GroupBy("pn.`source`")

	sql := qb.String()
	o := orm.NewOrm()
	nums, err := o.Raw(sql, projectId).QueryRows(&needs)
	return nums, err, needs
}

//统计任务指派人数量比例
func ChartProjectTask(op string, projectId int64) (num int64, err error, task []ChartProject) {
	var tasks []ChartProject
	qb, _ := orm.NewQueryBuilder("mysql")

	if op == "accept" {
		qb.Select("COUNT(1) AS value", "up.realname AS name").From("pms_projects_task AS pt").
			LeftJoin("pms_users_profile AS up").On("up.userid = pt.acceptid").
			Where("pt.projectid=?").
			GroupBy("pt.`acceptid`")
	} else if op == "user" {
		qb.Select("COUNT(1) AS value", "up.realname AS name").From("pms_projects_task AS pt").
			LeftJoin("pms_users_profile AS up").On("up.userid = pt.userid").
			Where("pt.projectid=?").
			GroupBy("pt.`userid`")
	} else if op == "complete" {
		qb.Select("COUNT(1) AS value", "up.realname AS name").From("pms_projects_task AS pt").
			LeftJoin("pms_users_profile AS up").On("up.userid = pt.completeid").
			Where("pt.projectid=? AND pt.completeid !=0").
			GroupBy("pt.`completeid`")
	}
	sql := qb.String()
	o := orm.NewOrm()
	nums, err := o.Raw(sql, projectId).QueryRows(&tasks)
	return nums, err, tasks
}
func ChartProjectTaskSource(projectId int64) (num int64, err error, task []ChartProjectInt) {
	var tasks []ChartProjectInt
	qb, _ := orm.NewQueryBuilder("mysql")

	qb.Select("COUNT(1) AS value", "pt.type AS name").From("pms_projects_task AS pt").
		Where("pt.projectid=?").
		GroupBy("pt.`type`")

	sql := qb.String()
	o := orm.NewOrm()
	nums, err := o.Raw(sql, projectId).QueryRows(&tasks)
	return nums, err, tasks
}

//统计Bug指派人数量比例
func ChartProjectTest(op string, projectId int64) (num int64, err error, test []ChartProject) {
	var tests []ChartProject
	qb, _ := orm.NewQueryBuilder("mysql")

	if op == "accept" {
		qb.Select("COUNT(1) AS value", "up.realname AS name").From("pms_projects_test AS pt").
			LeftJoin("pms_users_profile AS up").On("up.userid = pt.acceptid").
			Where("pt.projectid=?").
			GroupBy("pt.`acceptid`")
	} else if op == "user" {
		qb.Select("COUNT(1) AS value", "up.realname AS name").From("pms_projects_test AS pt").
			LeftJoin("pms_users_profile AS up").On("up.userid = pt.userid").
			Where("pt.projectid=?").
			GroupBy("pt.`userid`")
	} else if op == "complete" {
		qb.Select("COUNT(1) AS value", "up.realname AS name").From("pms_projects_test AS pt").
			LeftJoin("pms_users_profile AS up").On("up.userid = pt.completeid").
			Where("pt.projectid=? AND pt.completeid !=0").
			GroupBy("pt.`completeid`")
	}
	sql := qb.String()
	o := orm.NewOrm()
	nums, err := o.Raw(sql, projectId).QueryRows(&tests)
	return nums, err, tests
}
