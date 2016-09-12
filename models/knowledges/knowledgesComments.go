package knowledges

import (
	"fmt"
	"opms/models"
	"opms/utils"
	"time"

	"github.com/astaxie/beego"
	"github.com/astaxie/beego/orm"
)

type KnowledgesComment struct {
	Id      int64 `orm:"pk;column(comtid);"`
	Userid  int64
	Knowid  int64
	Content string
	Created int64
	Status  int
}

func (this *KnowledgesComment) TableName() string {
	return models.TableName("knowledges_comment")
}

func init() {
	orm.RegisterModel(new(KnowledgesComment))
}

func AddKnowledgeComment(upd KnowledgesComment) error {
	o := orm.NewOrm()
	comment := new(KnowledgesComment)

	comment.Id = upd.Id
	comment.Userid = upd.Userid
	comment.Knowid = upd.Knowid
	comment.Content = upd.Content
	comment.Status = 1
	comment.Created = time.Now().Unix()
	_, err := o.Insert(comment)
	if err == nil {
		ChangeRelationNum(upd.Knowid, "comment")
	}
	return err
}

func ListKnowledgeComment(knowid int64, page, offset int) (ops []KnowledgesComment) {
	if page < 1 {
		page = 1
	}
	if offset < 1 {
		offset = 100
	}
	start := (page - 1) * offset

	var comments []KnowledgesComment
	var err error
	err = utils.GetCache("ListKnowledgeComment.id."+fmt.Sprintf("%d", knowid), &comments)
	if err != nil {
		cache_expire, _ := beego.AppConfig.Int("cache_expire")
		o := orm.NewOrm()
		o.Using("default")
		qs := o.QueryTable(models.TableName("knowledges_comment"))
		cond := orm.NewCondition()
		cond = cond.And("knowid", knowid)
		cond = cond.And("status", 1)
		qs = qs.SetCond(cond)
		qs.Limit(offset, start).All(&comments)
		utils.SetCache("ListKnowledgeComment.id."+fmt.Sprintf("%d", knowid), comments, cache_expire)
	}
	return comments
}
