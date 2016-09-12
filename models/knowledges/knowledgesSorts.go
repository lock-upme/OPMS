package knowledges

import (
	//"fmt"
	"opms/models"
	"opms/utils"
	//"time"

	"github.com/astaxie/beego"
	"github.com/astaxie/beego/orm"
)

type KnowledgesSort struct {
	Id     int64 `orm:"pk;column(sortid);"`
	Name   string
	Desc   string
	Status int
}

func (this *KnowledgesSort) TableName() string {
	return models.TableName("knowledges_sort")
}

func init() {
	orm.RegisterModel(new(KnowledgesSort))
}

func ListKnowledgeSort() (num int64, err error, ops []KnowledgesSort) {
	var sort []KnowledgesSort
	var errs error

	page := 1
	offset := 100

	start := (page - 1) * offset

	errs = utils.GetCache("ListKnowledgeSort", &sort)
	if errs != nil {
		cache_expire, _ := beego.AppConfig.Int("cache_expire")
		o := orm.NewOrm()
		o.Using("default")
		qs := o.QueryTable(models.TableName("knowledges_sort"))
		cond := orm.NewCondition()
		cond = cond.And("status", 1)
		qs = qs.SetCond(cond)

		qs.Limit(offset, start).All(&sort)
		utils.SetCache("ListKnowledgeSort", sort, cache_expire)
	}
	return num, errs, sort
}
