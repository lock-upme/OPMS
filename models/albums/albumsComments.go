package albums

import (
	"fmt"
	"opms/models"
	"opms/utils"
	"time"

	"github.com/astaxie/beego"
	"github.com/astaxie/beego/orm"
)

type AlbumsComment struct {
	Id      int64 `orm:"pk;column(comtid);"`
	Userid  int64
	Albumid int64
	Content string
	Created int64
	Status  int
}

func (this *AlbumsComment) TableName() string {
	return models.TableName("albums_comment")
}

func init() {
	orm.RegisterModel(new(AlbumsComment))
}

func AddAlbumComment(upd AlbumsComment) error {
	o := orm.NewOrm()
	comment := new(AlbumsComment)

	comment.Id = upd.Id
	comment.Userid = upd.Userid
	comment.Albumid = upd.Albumid
	comment.Content = upd.Content
	comment.Status = 1
	comment.Created = time.Now().Unix()
	_, err := o.Insert(comment)
	if err == nil {
		ChangeAlbumRelationNum(upd.Albumid, "comment")
	}
	return err
}

func ListAlbumComment(albumid int64, page, offset int) (ops []AlbumsComment) {
	if page < 1 {
		page = 1
	}
	if offset < 1 {
		offset = 100
	}
	start := (page - 1) * offset

	var comments []AlbumsComment
	var err error
	err = utils.GetCache("ListAlbumComment.id."+fmt.Sprintf("%d", albumid), &comments)
	if err != nil {
		cache_expire, _ := beego.AppConfig.Int("cache_expire")
		o := orm.NewOrm()
		o.Using("default")
		qs := o.QueryTable(models.TableName("albums_comment"))
		cond := orm.NewCondition()
		cond = cond.And("albumid", albumid)
		cond = cond.And("status", 1)
		qs = qs.SetCond(cond)
		qs.Limit(offset, start).All(&comments)
		utils.SetCache("ListAlbumComment.id."+fmt.Sprintf("%d", albumid), comments, cache_expire)
	}
	return comments
}
