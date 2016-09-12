package knowledges

import (
	"fmt"
	"opms/models"
	"opms/utils"
	"time"

	"github.com/astaxie/beego"
	"github.com/astaxie/beego/orm"
)

type KnowledgesLaud struct {
	Id      int64 `orm:"pk;column(laudid);"`
	Userid  int64
	Knowid  int64
	Created int64
	Status  int
}

func (this *KnowledgesLaud) TableName() string {
	return models.TableName("knowledges_laud")
}

func init() {
	orm.RegisterModel(new(KnowledgesLaud))
}

func AddKnowledgeLaud(upd KnowledgesLaud) error {
	o := orm.NewOrm()
	laud := new(KnowledgesLaud)

	laud.Id = upd.Id
	laud.Userid = upd.Userid
	laud.Knowid = upd.Knowid
	laud.Status = 1
	laud.Created = time.Now().Unix()
	_, err := o.Insert(laud)
	if err == nil {
		ChangeRelationNum(upd.Knowid, "laud")
	}
	return err
}

func ListKnowledgeLaud(knowid int64, page, offset int) (ops []KnowledgesLaud) {
	if page < 1 {
		page = 1
	}
	if offset < 1 {
		offset = 100
	}
	start := (page - 1) * offset

	var lauds []KnowledgesLaud
	var err error
	err = utils.GetCache("ListKnowledgeLaud.id."+fmt.Sprintf("%d", knowid), &lauds)
	if err != nil {
		cache_expire, _ := beego.AppConfig.Int("cache_expire")
		o := orm.NewOrm()
		o.Using("default")
		qs := o.QueryTable(models.TableName("knowledges_laud"))
		cond := orm.NewCondition()
		cond = cond.And("knowid", knowid)
		cond = cond.And("status", 1)
		qs = qs.SetCond(cond)
		qs.Limit(offset, start).All(&lauds)
		utils.SetCache("ListKnowledgeLaud.id."+fmt.Sprintf("%d", knowid), lauds, cache_expire)
	}
	return lauds
}

func GetKnowledgeLaud(id int64) (KnowledgesLaud, error) {
	var laud KnowledgesLaud
	var err error

	err = utils.GetCache("GetKnowledgeLaud.id."+fmt.Sprintf("%d", id), &laud)
	if err != nil {
		cache_expire, _ := beego.AppConfig.Int("cache_expire")
		o := orm.NewOrm()
		err = o.QueryTable(models.TableName("knowledges_laud")).Filter("knowid", id).One(&laud, "userid")
		utils.SetCache("GetKnowledgeLaud.id."+fmt.Sprintf("%d", id), laud, cache_expire)
	}
	return laud, err
}
