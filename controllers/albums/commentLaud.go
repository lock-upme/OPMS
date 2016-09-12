package albums

import (
	"opms/controllers"
	. "opms/models/albums"
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
		this.Data["json"] = map[string]interface{}{"code": 1, "message": "点赞成功"}
	} else {
		this.Data["json"] = map[string]interface{}{"code": 0, "message": "点赞失败"}
	}
	this.ServeJSON()
}
