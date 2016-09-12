package knowledges

import (
	"fmt"
	"opms/models"
	"opms/utils"
	"time"

	"github.com/astaxie/beego"
	"github.com/astaxie/beego/orm"
)

type Knowledges struct {
	Id       int64 `orm:"pk;column(knowid);"`
	Userid   int64
	Sortid   int64
	Title    string
	Tag      string
	Summary  string
	Url      string
	Color    string
	Content  string
	Viewnum  int
	Comtnum  int
	Laudnum  int
	Ispublis int
	Status   int
	Created  int64
	Changed  int64
}

func (this *Knowledges) TableName() string {
	return models.TableName("knowledges")
}

func init() {
	orm.RegisterModel(new(Knowledges))
}

func AddKnowledge(upd Knowledges) error {
	o := orm.NewOrm()
	knowledge := new(Knowledges)

	knowledge.Id = upd.Id
	knowledge.Userid = upd.Userid
	knowledge.Sortid = upd.Sortid
	knowledge.Title = upd.Title
	knowledge.Tag = upd.Tag
	knowledge.Summary = upd.Summary
	knowledge.Content = upd.Content
	knowledge.Url = upd.Url
	knowledge.Color = upd.Color
	knowledge.Viewnum = 0
	knowledge.Comtnum = 0
	knowledge.Laudnum = 0
	knowledge.Ispublis = 1
	knowledge.Status = 1
	knowledge.Created = time.Now().Unix()
	knowledge.Changed = time.Now().Unix()
	_, err := o.Insert(knowledge)
	return err
}

func UpdateKnowledge(id int64, upd Knowledges) error {
	var knowledge Knowledges
	o := orm.NewOrm()
	knowledge = Knowledges{Id: id}

	knowledge.Userid = upd.Userid
	knowledge.Sortid = upd.Sortid
	knowledge.Title = upd.Title
	knowledge.Tag = upd.Tag
	knowledge.Summary = upd.Summary
	knowledge.Content = upd.Content
	knowledge.Url = upd.Url
	knowledge.Color = upd.Color
	knowledge.Ispublis = 1
	knowledge.Status = 1
	knowledge.Changed = time.Now().Unix()
	_, err := o.Update(&knowledge)
	return err
}

func ListKnowledge(condArr map[string]string, page int, offset int) (num int64, err error, ops []Knowledges) {
	o := orm.NewOrm()
	o.Using("default")
	qs := o.QueryTable(models.TableName("knowledges"))
	cond := orm.NewCondition()
	if condArr["keywords"] != "" {
		cond = cond.AndCond(cond.And("title__icontains", condArr["keywords"]).Or("tag__icontains", condArr["keywords"]))
	}
	if condArr["status"] != "" {
		cond = cond.And("status", condArr["status"])
	}
	if condArr["userid"] != "" {
		cond = cond.And("userid", condArr["userid"])
	}
	if condArr["sortid"] != "" {
		cond = cond.And("sortid", condArr["sortid"])
	}
	qs = qs.SetCond(cond)
	if page < 1 {
		page = 1
	}
	if offset < 1 {
		offset, _ = beego.AppConfig.Int("pageoffset")
	}
	start := (page - 1) * offset

	var knowledge []Knowledges
	num, errs := qs.Limit(offset, start).All(&knowledge)
	return num, errs, knowledge
}

func CountKnowledge(condArr map[string]string) int64 {
	o := orm.NewOrm()
	qs := o.QueryTable(models.TableName("knowledges"))
	cond := orm.NewCondition()
	if condArr["keywords"] != "" {
		cond = cond.AndCond(cond.And("title__icontains", condArr["keywords"]).Or("tag__icontains", condArr["keywords"]))
	}
	if condArr["status"] != "" {
		cond = cond.And("status", condArr["status"])
	}
	if condArr["userid"] != "" {
		cond = cond.And("userid", condArr["userid"])
	}
	if condArr["sortid"] != "" {
		cond = cond.And("sortid", condArr["sortid"])
	}
	num, _ := qs.SetCond(cond).Count()
	return num
}

func GetKnowledge(id int64) (Knowledges, error) {
	var knowledge Knowledges
	var err error

	err = utils.GetCache("GetKnowledge.id."+fmt.Sprintf("%d", id), &knowledge)
	if err != nil {
		cache_expire, _ := beego.AppConfig.Int("cache_expire")
		o := orm.NewOrm()
		knowledge = Knowledges{Id: id}
		err = o.Read(&knowledge)
		utils.SetCache("GetKnowledge.id."+fmt.Sprintf("%d", id), knowledge, cache_expire)
	}
	return knowledge, err
}

func DeleteKnowledge(id int64) error {
	o := orm.NewOrm()
	_, err := o.Delete(&Knowledges{Id: id})
	return err
}

func ChangeRelationNum(id int64, record string) error {
	o := orm.NewOrm()
	var updateRecord string
	var know Knowledges
	o.QueryTable(models.TableName("knowledges")).Filter("knowid", id).One(&know, "viewnum", "laudnum", "comtnum")
	knowledge := Knowledges{Id: id}
	//o.Read(&knowledge, "viewnum", "laudnum", "comtnum")
	if record == "view" {
		knowledge.Viewnum = know.Viewnum + 1
		updateRecord = "viewnum"
	} else if record == "laud" {
		knowledge.Laudnum = know.Laudnum + 1
		updateRecord = "laudnum"
	} else if record == "comment" {
		knowledge.Comtnum = know.Comtnum + 1
		updateRecord = "comtnum"
	}
	_, err := o.Update(&knowledge, updateRecord)
	return err
}
