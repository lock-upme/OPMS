package albums

import (
	"fmt"
	"opms/controllers"
	. "opms/models/albums"
	. "opms/models/messages"
	"opms/utils"
)

type AddCommentController struct {
	controllers.BaseController
}

func (this *AddCommentController) Post() {
	albumid, _ := this.GetInt64("albumid")
	if albumid <= 0 {
		this.Data["json"] = map[string]interface{}{"code": 0, "message": "参数出错"}
		this.ServeJSON()
		return
	}
	content := this.GetString("comment")
	if "" == content {
		this.Data["json"] = map[string]interface{}{"code": 0, "message": "请填写评论内容"}
		this.ServeJSON()
		return
	}

	var err error
	var comment AlbumsComment
	comment.Id = utils.SnowFlakeId()
	comment.Userid = this.BaseController.UserUserId
	comment.Albumid = albumid
	comment.Content = content

	err = AddAlbumComment(comment)

	if err == nil {
		//消息通知
		album, _ := GetAlbum(albumid)
		var msg Messages
		msg.Id = utils.SnowFlakeId()
		msg.Userid = this.BaseController.UserUserId
		msg.Touserid = album.Userid
		msg.Type = 1
		msg.Subtype = 12
		msg.Title = album.Title
		msg.Url = "/album/" + fmt.Sprintf("%d", albumid)
		AddMessages(msg)
		this.Data["json"] = map[string]interface{}{"code": 1, "message": "评价添加成功"}
	} else {
		this.Data["json"] = map[string]interface{}{"code": 0, "message": "添加失败"}
	}
	this.ServeJSON()
}

type AjaxLaudController struct {
	controllers.BaseController
}

func (this *AjaxLaudController) Post() {
	albumid, _ := this.GetInt64("albumid")
	if albumid <= 0 {
		this.Data["json"] = map[string]interface{}{"code": 0, "message": "参数出错"}
		this.ServeJSON()
		return
	}

	laudexit, _ := GetAlbumLaud(albumid)
	if laudexit.Userid == this.BaseController.UserUserId {
		this.Data["json"] = map[string]interface{}{"code": 0, "message": "已经点过赞"}
		this.ServeJSON()
	}

	var err error
	var laud AlbumsLaud
	laud.Id = utils.SnowFlakeId()
	laud.Userid = this.BaseController.UserUserId
	laud.Albumid = albumid

	err = AddAlbumLaud(laud)

	if err == nil {
		//消息通知
		album, _ := GetAlbum(albumid)
		var msg Messages
		msg.Id = utils.SnowFlakeId()
		msg.Userid = this.BaseController.UserUserId
		msg.Touserid = album.Userid
		msg.Type = 2
		msg.Subtype = 22
		msg.Title = album.Title
		msg.Url = "/album/" + fmt.Sprintf("%d", albumid)
		AddMessages(msg)
		this.Data["json"] = map[string]interface{}{"code": 1, "message": "点赞成功"}
	} else {
		this.Data["json"] = map[string]interface{}{"code": 0, "message": "点赞失败"}
	}
	this.ServeJSON()
}
