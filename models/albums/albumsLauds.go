package albums

import (
	"fmt"
	"opms/models"
	"opms/utils"
	"time"

	"github.com/astaxie/beego"
	"github.com/astaxie/beego/orm"
)

type AlbumsLaud struct {
	Id      int64 `orm:"pk;column(laudid);"`
	Userid  int64
	Albumid int64
	Created int64
	Status  int
}

func (this *AlbumsLaud) TableName() string {
	return models.TableName("albums_laud")
}

func init() {
	orm.RegisterModel(new(AlbumsLaud))
}

func AddAlbumLaud(upd AlbumsLaud) error {
	o := orm.NewOrm()
	laud := new(AlbumsLaud)

	laud.Id = upd.Id
	laud.Userid = upd.Userid
	laud.Albumid = upd.Albumid
	laud.Status = 1
	laud.Created = time.Now().Unix()
	_, err := o.Insert(laud)
	if err == nil {
		ChangeAlbumRelationNum(upd.Albumid, "laud")
	}
	return err
}

func ListAlbumLaud(albumid int64, page, offset int) (ops []AlbumsLaud) {
	if page < 1 {
		page = 1
	}
	if offset < 1 {
		offset = 100
	}
	start := (page - 1) * offset

	var lauds []AlbumsLaud
	var err error
	err = utils.GetCache("ListAlbumLaud.id."+fmt.Sprintf("%d", albumid), &lauds)
	if err != nil {
		cache_expire, _ := beego.AppConfig.Int("cache_expire")
		o := orm.NewOrm()
		o.Using("default")
		qs := o.QueryTable(models.TableName("albums_laud"))
		cond := orm.NewCondition()
		cond = cond.And("albumid", albumid)
		cond = cond.And("status", 1)
		qs = qs.SetCond(cond)
		qs.Limit(offset, start).All(&lauds)
		utils.SetCache("ListAlbumLaud.id."+fmt.Sprintf("%d", albumid), lauds, cache_expire)
	}
	return lauds
}

func GetAlbumLaud(id int64) (AlbumsLaud, error) {
	var laud AlbumsLaud
	var err error

	err = utils.GetCache("GetAlbumLaud.id."+fmt.Sprintf("%d", id), &laud)
	if err != nil {
		cache_expire, _ := beego.AppConfig.Int("cache_expire")
		o := orm.NewOrm()
		err = o.QueryTable(models.TableName("albums_laud")).Filter("albumid", id).One(&laud, "userid")
		utils.SetCache("GetAlbumLaud.id."+fmt.Sprintf("%d", id), laud, cache_expire)
	}
	return laud, err
}
