package resumes

import (
	//"fmt"
	"opms/models"
	//"opms/utils"
	"time"

	"github.com/astaxie/beego"
	"github.com/astaxie/beego/orm"
)

type Resumes struct {
	Id         int64 `orm:"pk;column(resumeid);"`
	Realname   string
	Sex        int
	Birth      int64
	Edu        int
	Work       int
	Attachment string
	Created    int64
	Status     int
	Note       string
	Phone      string
}

func (this *Resumes) TableName() string {
	return models.TableName("resumes")
}
func init() {
	orm.RegisterModel(new(Resumes))
}

func GetResumes(id int64) (Resumes, error) {
	var resume Resumes
	var err error
	o := orm.NewOrm()

	resume = Resumes{Id: id}
	err = o.Read(&resume)

	if err == orm.ErrNoRows {
		return resume, nil
	}
	return resume, err
}

func UpdateResumes(id int64, upd Resumes) error {
	o := orm.NewOrm()
	res := Resumes{Id: id}

	res.Realname = upd.Realname
	res.Sex = upd.Sex
	res.Birth = upd.Birth
	res.Edu = upd.Edu
	res.Work = upd.Work
	res.Attachment = upd.Attachment
	res.Status = upd.Status
	res.Note = upd.Note
	res.Phone = upd.Phone

	if upd.Attachment != "" {
		res.Attachment = upd.Attachment
		_, err := o.Update(&res, "realname", "sex", "birth", "edu", "work", "note", "phone", "status", "attachment")
		return err
	} else {
		_, err := o.Update(&res, "realname", "sex", "birth", "edu", "work", "note", "phone", "status")
		return err
	}
}

func AddResumes(upd Resumes) error {
	o := orm.NewOrm()
	o.Using("default")
	res := new(Resumes)

	res.Id = upd.Id
	res.Realname = upd.Realname
	res.Sex = upd.Sex
	res.Birth = upd.Birth
	res.Edu = upd.Edu
	res.Work = upd.Work
	res.Attachment = upd.Attachment
	res.Created = time.Now().Unix()
	res.Status = upd.Status
	res.Note = upd.Note
	res.Phone = upd.Phone
	_, err := o.Insert(res)
	return err
}

func ListResumes(condArr map[string]string, page int, offset int) (num int64, err error, res []Resumes) {
	o := orm.NewOrm()
	o.Using("default")
	qs := o.QueryTable(models.TableName("resumes"))
	cond := orm.NewCondition()

	if condArr["keywords"] != "" {
		cond = cond.AndCond(cond.And("realname__icontains", condArr["keywords"]))
	}
	if condArr["status"] != "" {
		cond = cond.And("status", condArr["status"])
	}
	if condArr["sex"] != "" {
		cond = cond.And("sex", condArr["sex"])
	}

	qs = qs.SetCond(cond)
	if page < 1 {
		page = 1
	}
	if offset < 1 {
		offset, _ = beego.AppConfig.Int("pageoffset")
	}
	start := (page - 1) * offset

	var reses []Resumes
	qs = qs.OrderBy("-resumeid")
	num, err1 := qs.Limit(offset, start).All(&reses)
	return num, err1, reses
}

//统计数量
func CountResumes(condArr map[string]string) int64 {
	o := orm.NewOrm()
	qs := o.QueryTable(models.TableName("resumes"))
	cond := orm.NewCondition()
	if condArr["keywords"] != "" {
		cond = cond.AndCond(cond.And("realname__icontains", condArr["keywords"]))
	}
	if condArr["status"] != "" {
		cond = cond.And("status", condArr["status"])
	}
	num, _ := qs.SetCond(cond).Count()
	return num
}

func ChangeResumeStatus(id int64, status int) error {
	o := orm.NewOrm()

	res := Resumes{Id: id}
	err := o.Read(&res, "resumeid")
	if nil != err {
		return err
	} else {
		res.Status = status
		_, err := o.Update(&res)
		return err
	}
}
