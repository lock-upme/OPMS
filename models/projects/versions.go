package projects

import (
	"fmt"
	"opms/models"
	"opms/utils"
	"time"

	"github.com/astaxie/beego"
	"github.com/astaxie/beego/orm"
)

type ProjectsVersions struct {
	Id         int64 `orm:"pk;column(versionid);"`
	Projectid  int64
	Userid     int64
	Title      string
	Versioned  int64
	Content    string
	Sourceurl  string
	Downurl    string
	Attachment string
	Created    int64
	Changed    int64
}

func (this *ProjectsVersions) TableName() string {
	return models.TableName("projects_version")
}
func init() {
	orm.RegisterModel(new(ProjectsVersions))
}

func AddVersions(upd ProjectsVersions) error {
	o := orm.NewOrm()
	version := new(ProjectsVersions)

	version.Id = upd.Id
	version.Projectid = upd.Projectid
	version.Userid = upd.Userid
	version.Title = upd.Title
	version.Versioned = upd.Versioned
	version.Content = upd.Content
	version.Sourceurl = upd.Sourceurl
	version.Downurl = upd.Downurl
	version.Created = time.Now().Unix()
	version.Changed = time.Now().Unix()
	version.Attachment = upd.Attachment

	_, err := o.Insert(version)
	return err
}

func UpdateVersions(id int64, upd ProjectsVersions) error {
	var version ProjectsVersions
	o := orm.NewOrm()
	version = ProjectsVersions{Id: id}

	version.Title = upd.Title
	version.Versioned = upd.Versioned
	version.Content = upd.Content
	version.Sourceurl = upd.Sourceurl
	version.Downurl = upd.Downurl
	version.Changed = time.Now().Unix()

	if upd.Attachment != "" {
		version.Attachment = upd.Attachment
		_, err := o.Update(&version, "title", "versioned", "content", "sourceurl", "downurl", "changed", "attachment")
		return err
	} else {
		_, err := o.Update(&version, "title", "versioned", "content", "sourceurl", "downurl", "changed")
		return err
	}
}

func GetProjectVersionsTitle(id int64) string {
	var err error
	var title string
	err = utils.GetCache("GetProjectVersionsTitle.id."+fmt.Sprintf("%d", id), &title)
	if err != nil {
		cache_expire, _ := beego.AppConfig.Int("cache_expire")
		var version ProjectsVersions
		o := orm.NewOrm()
		o.QueryTable(models.TableName("projects_version")).Filter("versionid", id).One(&version, "title")
		title = version.Title
		utils.SetCache("GetProjectVersionsTitle.id."+fmt.Sprintf("%d", id), title, cache_expire)
	}
	return title
}

func GetProjectVersions(id int64) (ProjectsVersions, error) {
	var version ProjectsVersions
	var err error
	o := orm.NewOrm()
	version = ProjectsVersions{Id: id}
	err = o.Read(&version)

	if err == orm.ErrNoRows {
		return version, nil
	}
	return version, err
}

func ListVersionsForForm(projectId int64, page, offset int) (ops []ProjectsVersions) {
	if page < 1 {
		page = 1
	}
	if offset < 1 {
		offset = 100
	}
	start := (page - 1) * offset

	var version []ProjectsVersions
	var err error

	err = utils.GetCache("ListVersionsForForm.id."+fmt.Sprintf("%d", projectId), &version)
	if err != nil {
		cache_expire, _ := beego.AppConfig.Int("cache_expire")
		o := orm.NewOrm()
		o.Using("default")
		qs := o.QueryTable(models.TableName("projects_version"))
		cond := orm.NewCondition()
		if projectId > 0 {
			cond = cond.And("projectid", projectId)
		}
		qs = qs.SetCond(cond)
		qs.Limit(offset, start).All(&version)
		utils.SetCache("ListVersionsForForm.id."+fmt.Sprintf("%d", projectId), version, cache_expire)
	}
	return version
}

//列表
func ListProjectVersions(condArr map[string]string, page int, offset int) (num int64, err error, ops []ProjectsVersions) {
	o := orm.NewOrm()
	o.Using("default")
	if page < 1 {
		page = 1
	}
	if offset < 1 {
		offset, _ = beego.AppConfig.Int("pageoffset")
	}
	start := (page - 1) * offset

	var version []ProjectsVersions

	qs := o.QueryTable(models.TableName("projects_version"))
	cond := orm.NewCondition()
	if condArr["projectid"] != "" {
		cond = cond.And("projectid", condArr["projectid"])
	}
	if condArr["keywords"] != "" {
		cond = cond.And("title__icontains", condArr["keywords"])
	}
	if condArr["userid"] != "" {
		cond = cond.And("userid", condArr["userid"])
	}
	qs = qs.SetCond(cond)
	qs = qs.OrderBy("-versionid")
	nums, errs := qs.Limit(offset, start).All(&version)
	return nums, errs, version
}

//统计数量
func CountVersions(condArr map[string]string) int64 {
	o := orm.NewOrm()
	qs := o.QueryTable(models.TableName("projects_version"))
	cond := orm.NewCondition()

	if condArr["projectid"] != "" {
		cond = cond.And("projectid", condArr["projectid"])
	}
	if condArr["keywords"] != "" {
		cond = cond.And("title__icontains", condArr["keywords"])
	}
	if condArr["userid"] != "" {
		cond = cond.And("userid", condArr["userid"])
	}
	num, _ := qs.SetCond(cond).Count()
	return num
}

func DeleteVersion(ids string, userid int64) error {
	o := orm.NewOrm()
	_, err := o.Raw("DELETE FROM "+models.TableName("projects_version")+" WHERE versionid IN("+ids+") AND userid=?", userid).Exec()
	return err
}
