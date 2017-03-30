package projects

import (
	"fmt"
	"opms/models"
	"opms/utils"
	"time"

	"github.com/astaxie/beego"
	"github.com/astaxie/beego/orm"
)

type ProjectsDocs struct {
	Id         int64 `orm:"pk;column(docid);"`
	Projectid  int64
	Userid     int64
	Title      string
	Sort       int
	Keyword    string
	Content    string
	Url        string
	Attachment string
	Created    int64
	Changed    int64
}

func (this *ProjectsDocs) TableName() string {
	return models.TableName("projects_doc")
}
func init() {
	orm.RegisterModel(new(ProjectsDocs))
}

func AddDocs(upd ProjectsDocs) error {
	o := orm.NewOrm()
	doc := new(ProjectsDocs)

	doc.Id = upd.Id
	doc.Projectid = upd.Projectid
	doc.Userid = upd.Userid
	doc.Title = upd.Title
	doc.Keyword = upd.Keyword
	doc.Sort = upd.Sort
	doc.Content = upd.Content
	doc.Url = upd.Url
	doc.Created = time.Now().Unix()
	doc.Changed = time.Now().Unix()
	doc.Attachment = upd.Attachment

	_, err := o.Insert(doc)
	return err
}

func UpdateDocs(id int64, upd ProjectsDocs) error {
	var doc ProjectsDocs
	o := orm.NewOrm()
	doc = ProjectsDocs{Id: id}

	doc.Title = upd.Title
	doc.Keyword = upd.Keyword
	doc.Sort = upd.Sort
	doc.Content = upd.Content
	doc.Url = upd.Url
	doc.Changed = time.Now().Unix()

	if upd.Attachment != "" {
		doc.Attachment = upd.Attachment
		_, err := o.Update(&doc, "title", "keyword", "sort", "content", "url", "changed", "attachment")
		return err
	} else {
		_, err := o.Update(&doc, "title", "keyword", "sort", "content", "url", "changed")
		return err
	}
}

func GetProjectDocsTitle(id int64) string {
	var err error
	var title string
	err = utils.GetCache("GetProjectDocsTitle.id."+fmt.Sprintf("%d", id), &title)
	if err != nil {
		cache_expire, _ := beego.AppConfig.Int("cache_expire")
		var doc ProjectsDocs
		o := orm.NewOrm()
		o.QueryTable(models.TableName("projects_doc")).Filter("docid", id).One(&doc, "title")
		title = doc.Title
		utils.SetCache("GetProjectDocsTitle.id."+fmt.Sprintf("%d", id), title, cache_expire)
	}
	return title
}

func GetProjectDocs(id int64) (ProjectsDocs, error) {
	var doc ProjectsDocs
	var err error
	o := orm.NewOrm()
	doc = ProjectsDocs{Id: id}
	err = o.Read(&doc)

	if err == orm.ErrNoRows {
		return doc, nil
	}
	return doc, err
}

func ListDocsForForm(projectId int64, page, offset int) (ops []ProjectsDocs) {
	if page < 1 {
		page = 1
	}
	if offset < 1 {
		offset = 100
	}
	start := (page - 1) * offset

	var doc []ProjectsDocs
	var err error

	err = utils.GetCache("ListDocsForForm.id."+fmt.Sprintf("%d", projectId), &doc)
	if err != nil {
		cache_expire, _ := beego.AppConfig.Int("cache_expire")
		o := orm.NewOrm()
		o.Using("default")
		qs := o.QueryTable(models.TableName("projects_doc"))
		cond := orm.NewCondition()
		if projectId > 0 {
			cond = cond.And("projectid", projectId)
		}
		qs = qs.SetCond(cond)
		qs.Limit(offset, start).All(&doc)
		utils.SetCache("ListDocsForForm.id."+fmt.Sprintf("%d", projectId), doc, cache_expire)
	}
	return doc
}

//列表
func ListProjectDocs(condArr map[string]string, page int, offset int) (num int64, err error, ops []ProjectsDocs) {
	o := orm.NewOrm()
	o.Using("default")
	if page < 1 {
		page = 1
	}
	if offset < 1 {
		offset, _ = beego.AppConfig.Int("pageoffset")
	}
	start := (page - 1) * offset

	var doc []ProjectsDocs

	qs := o.QueryTable(models.TableName("projects_doc"))
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
	if condArr["sort"] != "" {
		cond = cond.And("sort", condArr["sort"])
	}
	qs = qs.SetCond(cond)
	qs = qs.OrderBy("-docid")
	nums, errs := qs.Limit(offset, start).All(&doc)
	return nums, errs, doc
}

//统计数量
func CountDocs(condArr map[string]string) int64 {
	o := orm.NewOrm()
	qs := o.QueryTable(models.TableName("projects_doc"))
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
	if condArr["sort"] != "" {
		cond = cond.And("sort", condArr["sort"])
	}
	num, _ := qs.SetCond(cond).Count()
	return num
}

func DeleteDoc(ids string, userid int64) error {
	o := orm.NewOrm()
	_, err := o.Raw("DELETE FROM "+models.TableName("projects_doc")+" WHERE docid IN("+ids+") AND userid=?", userid).Exec()
	return err
}
