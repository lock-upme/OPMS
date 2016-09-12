package projects

import (
	"fmt"
	"opms/models"
	"opms/utils"
	"time"

	"github.com/astaxie/beego"
	"github.com/astaxie/beego/orm"
)

type ProjectsNeeds struct {
	Id         int64 `orm:"pk;column(needsid);"`
	Projectid  int64
	Userid     int64
	Name       string
	Desc       string
	Acceptid   int64
	Source     int
	Acceptance string
	Level      int
	Tasktime   int
	Attachment string
	Created    int64
	Changed    int64
	Stage      int
	Status     int
}

func (this *ProjectsNeeds) TableName() string {
	return models.TableName("projects_needs")
}
func init() {
	orm.RegisterModel(new(ProjectsNeeds))
}

func AddNeeds(upd ProjectsNeeds) error {
	o := orm.NewOrm()
	needs := new(ProjectsNeeds)

	needs.Id = upd.Id
	needs.Projectid = upd.Projectid
	needs.Userid = upd.Userid
	needs.Name = upd.Name
	needs.Desc = upd.Desc
	needs.Acceptid = upd.Acceptid
	needs.Source = upd.Source
	needs.Acceptance = upd.Acceptance
	needs.Level = upd.Level
	needs.Tasktime = upd.Tasktime
	needs.Created = time.Now().Unix()
	needs.Stage = upd.Stage
	needs.Status = upd.Status
	needs.Attachment = upd.Attachment

	_, err := o.Insert(needs)
	return err
}

func UpdateNeeds(id int64, upd ProjectsNeeds) error {
	var needs ProjectsNeeds
	o := orm.NewOrm()
	needs = ProjectsNeeds{Id: id}

	needs.Name = upd.Name
	needs.Desc = upd.Desc
	needs.Acceptid = upd.Acceptid
	needs.Source = upd.Source
	needs.Acceptance = upd.Acceptance
	needs.Level = upd.Level
	needs.Tasktime = upd.Tasktime
	needs.Stage = upd.Stage

	needs.Changed = time.Now().Unix()

	if upd.Attachment != "" {
		needs.Attachment = upd.Attachment
		_, err := o.Update(&needs, "name", "desc", "acceptid", "source", "acceptance", "level", "tasktime", "changed", "attachment", "stage")
		return err
	} else {
		_, err := o.Update(&needs, "name", "desc", "acceptid", "source", "acceptance", "level", "tasktime", "changed", "stage")
		return err
	}
}

func GetProjectNeedsName(id int64) string {
	var err error
	var name string
	err = utils.GetCache("GetProjectNeedsName.id."+fmt.Sprintf("%d", id), &name)
	if err != nil {
		cache_expire, _ := beego.AppConfig.Int("cache_expire")
		var needs ProjectsNeeds
		o := orm.NewOrm()
		o.QueryTable(models.TableName("projects_needs")).Filter("needsid", id).One(&needs, "name")
		name = needs.Name
		utils.SetCache("GetProjectNeedsName.id."+fmt.Sprintf("%d", id), name, cache_expire)
	}
	return name
}

func GetProjectNeeds(id int64) (ProjectsNeeds, error) {
	var needs ProjectsNeeds
	var err error
	o := orm.NewOrm()
	needs = ProjectsNeeds{Id: id}
	err = o.Read(&needs)

	if err == orm.ErrNoRows {
		return needs, nil
	}
	return needs, err
}

func ListNeedsForForm(projectId int64, page, offset int) (ops []ProjectsNeeds) {
	if page < 1 {
		page = 1
	}
	if offset < 1 {
		offset = 100
	}
	start := (page - 1) * offset

	var needs []ProjectsNeeds
	var err error

	err = utils.GetCache("ListNeedsForForm.id."+fmt.Sprintf("%d", projectId), &needs)
	if err != nil {
		cache_expire, _ := beego.AppConfig.Int("cache_expire")
		o := orm.NewOrm()
		o.Using("default")
		qs := o.QueryTable(models.TableName("projects_needs"))
		cond := orm.NewCondition()
		if projectId > 0 {
			cond = cond.And("projectid", projectId)
		}
		qs = qs.SetCond(cond)
		qs.Limit(offset, start).All(&needs)
		utils.SetCache("ListNeedsForForm.id."+fmt.Sprintf("%d", projectId), needs, cache_expire)
	}
	return needs
}

//列表
func ListProjectNeeds(condArr map[string]string, page int, offset int) (num int64, err error, ops []ProjectsNeeds) {
	o := orm.NewOrm()
	o.Using("default")
	if page < 1 {
		page = 1
	}
	if offset < 1 {
		offset, _ = beego.AppConfig.Int("pageoffset")
	}
	start := (page - 1) * offset

	var needs []ProjectsNeeds

	qs := o.QueryTable(models.TableName("projects_needs"))
	cond := orm.NewCondition()
	if condArr["projectid"] != "" {
		cond = cond.And("projectid", condArr["projectid"])
	}
	if condArr["keywords"] != "" {
		cond = cond.And("name__icontains", condArr["keywords"])
	}
	if condArr["status"] != "" {
		cond = cond.And("status", condArr["status"])
	}
	if condArr["stage"] != "" {
		cond = cond.And("stage", condArr["stage"])
	}
	if condArr["acceptid"] != "" {
		cond = cond.And("acceptid", condArr["acceptid"])
	}
	if condArr["userid"] != "" {
		cond = cond.And("userid", condArr["userid"])
	}
	qs = qs.SetCond(cond)

	nums, errs := qs.Limit(offset, start).All(&needs)
	return nums, errs, needs
}

//统计数量
func CountNeeds(condArr map[string]string) int64 {
	o := orm.NewOrm()
	qs := o.QueryTable(models.TableName("projects_needs"))
	cond := orm.NewCondition()

	if condArr["projectid"] != "" {
		cond = cond.And("projectid", condArr["projectid"])
	}
	if condArr["keywords"] != "" {
		cond = cond.And("name__icontains", condArr["keywords"])
	}
	if condArr["status"] != "" {
		cond = cond.And("status", condArr["status"])
	}
	if condArr["stage"] != "" {
		cond = cond.And("stage", condArr["stage"])
	}
	if condArr["acceptid"] != "" {
		cond = cond.And("acceptid", condArr["acceptid"])
	}
	if condArr["userid"] != "" {
		cond = cond.And("userid", condArr["userid"])
	}
	num, _ := qs.SetCond(cond).Count()
	return num
}

func ChangeProjectNeedsStatus(id int64, status int) error {
	o := orm.NewOrm()
	need := ProjectsNeeds{Id: id}
	err := o.Read(&need, "needsid")
	if nil != err {
		return err
	} else {
		need.Status = status
		_, err := o.Update(&need)
		return err
	}
}
