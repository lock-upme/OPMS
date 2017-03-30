package albums

import (
	"opms/models"
	"time"

	"github.com/astaxie/beego"
	"github.com/astaxie/beego/orm"
)

type Albums struct {
	Id       int64 `orm:"pk;column(albumid);"`
	Userid   int64
	Title    string
	Picture  string
	Keywords string
	Summary  string
	Created  int64
	Viewnum  int
	Comtnum  int
	Laudnum  int
	Status   int
}

func (this *Albums) TableName() string {
	return models.TableName("albums")
}

func init() {
	orm.RegisterModel(new(Albums))
}

/*
 * 获取相册详情
 */
func GetAlbum(id int64) (Albums, error) {
	o := orm.NewOrm()
	o.Using("default")
	alb := Albums{Id: id}
	err := o.Read(&alb)

	//if err == orm.ErrNoRows {
	//return alb, nil
	//}
	return alb, err
}

func UpdateAlbum(id int64, updAlb Albums) error {
	o := orm.NewOrm()
	o.Using("default")
	alb := Albums{Id: id}

	alb.Title = updAlb.Title
	alb.Keywords = updAlb.Keywords
	alb.Summary = updAlb.Summary
	alb.Status = updAlb.Status
	_, err := o.Update(&alb, "title", "keywords", "summary", "status")
	return err
}

func AddAlbum(updAlb Albums) (int64, error) {
	o := orm.NewOrm()
	o.Using("default")
	alb := new(Albums)
	alb.Id = updAlb.Id
	alb.Userid = updAlb.Userid
	alb.Title = updAlb.Title
	alb.Picture = updAlb.Picture
	alb.Keywords = updAlb.Keywords
	alb.Summary = updAlb.Summary
	alb.Created = time.Now().Unix()
	alb.Viewnum = 1
	alb.Comtnum = 0
	alb.Laudnum = 0
	alb.Status = updAlb.Status

	id, err := o.Insert(alb)
	return id, err
}

func ListAlbum(condArr map[string]string, page int, offset int) (num int64, err error, alb []Albums) {
	o := orm.NewOrm()
	qs := o.QueryTable(models.TableName("albums"))
	cond := orm.NewCondition()
	if condArr["title"] != "" {
		cond = cond.And("title__icontains", condArr["title"])
	}
	if condArr["keywords"] != "" {
		cond = cond.Or("keywords__icontains", condArr["keywords"])
	}
	if condArr["userid"] != "" {
		cond = cond.And("userid", condArr["userid"])
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
	qs = qs.OrderBy("-albumid")
	start := (page - 1) * offset
	var albums []Albums
	num, err1 := qs.Limit(offset, start).All(&albums)
	return num, err1, albums
}

func CountAlbum(condArr map[string]string) int64 {
	o := orm.NewOrm()
	qs := o.QueryTable(models.TableName("albums"))
	cond := orm.NewCondition()
	if condArr["title"] != "" {
		cond = cond.And("title__icontains", condArr["title"])
	}
	if condArr["keywords"] != "" {
		cond = cond.Or("keywords__icontains", condArr["keywords"])
	}
	if condArr["userid"] != "" {
		cond = cond.And("userid", condArr["userid"])
	}
	if condArr["status"] != "" {
		cond = cond.And("status", condArr["status"])
	}
	num, _ := qs.SetCond(cond).Count()
	return num
}

func ChangeAlbumRelationNum(id int64, record string) error {
	o := orm.NewOrm()
	var updateRecord string
	album := Albums{Id: id}
	var alb Albums
	o.QueryTable(models.TableName("albums")).Filter("albumid", id).One(&alb, "viewnum", "laudnum", "comtnum")

	if record == "view" {
		album.Viewnum = alb.Viewnum + 1
		updateRecord = "viewnum"
	} else if record == "laud" {
		album.Laudnum = alb.Laudnum + 1
		updateRecord = "laudnum"
	} else if record == "comment" {
		album.Comtnum = alb.Comtnum + 1
		updateRecord = "comtnum"
	}
	_, err := o.Update(&album, updateRecord)
	return err
}

func DeleteAlbum(id int64, userid int64) error {
	o := orm.NewOrm()
	_, err := o.Raw("DELETE FROM "+models.TableName("albums")+" WHERE albumid=? AND userid=?", id, userid).Exec()
	o.Raw("DELETE FROM "+models.TableName("albums_comment")+" WHERE albumid=?", id).Exec()
	o.Raw("DELETE FROM "+models.TableName("albums_laud")+" WHERE albumid=?", id).Exec()

	return err
}
