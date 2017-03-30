package albums

import (
	"fmt"
	"io"
	"opms/controllers"
	. "opms/models/albums"
	"opms/utils"
	"os"
	"strconv"
	"strings"
	"time"

	"github.com/astaxie/beego"
	"github.com/astaxie/beego/utils/pagination"
)

type UploadAlbumController struct {
	controllers.BaseController
}

func (this *UploadAlbumController) Get() {
	//权限检测
	if !strings.Contains(this.GetSession("userPermission").(string), "album-upload") {
		this.Abort("401")
	}
	this.TplName = "albums/upload.tpl"
}

type EditAlbumController struct {
	controllers.BaseController
}

func (this *EditAlbumController) Post() {
	//权限检测
	if !strings.Contains(this.GetSession("userPermission").(string), "album-edit") {
		this.Data["json"] = map[string]interface{}{"code": 0, "message": "无权设置"}
		this.ServeJSON()
		return
	}
	id, err := this.GetInt64("id")
	title := this.GetString("title")
	summary := this.GetString("summary")
	status, _ := this.GetInt("status")

	if "" == title {
		this.Data["json"] = map[string]interface{}{"code": 0, "message": "请填写标题"}
		this.ServeJSON()
	}
	_, errAttr := GetAlbum(id)
	if errAttr != nil {
		this.Data["json"] = map[string]interface{}{"code": 0, "message": "相册不存在"}
		this.ServeJSON()
	}

	var alb Albums
	alb.Title = title
	alb.Summary = summary
	alb.Status = status

	err = UpdateAlbum(id, alb)

	if err == nil {
		this.Data["json"] = map[string]interface{}{"code": 1, "message": "相册修改成功", "id": fmt.Sprintf("%d", id)}
	} else {
		this.Data["json"] = map[string]interface{}{"code": 0, "message": "相册修改出错"}
	}
	this.ServeJSON()
}

//列表
type ListAlbumController struct {
	controllers.BaseController
}

func (this *ListAlbumController) Get() {
	//权限检测
	if !strings.Contains(this.GetSession("userPermission").(string), "album-manage") {
		this.Abort("401")
	}
	//添加上传的图片到表
	str := this.GetSession("uploadMultiPic")
	if str != nil {
		str = strings.Trim(str.(string), "||")
		strPic := strings.Split(str.(string), "||")

		strn := this.GetSession("uploadMultiName")
		strn = strings.Trim(strn.(string), "||")
		strName := strings.Split(strn.(string), "||")

		for i, pic := range strPic {
			var alb Albums
			alb.Id = utils.SnowFlakeId()
			alb.Userid = this.BaseController.UserUserId
			alb.Picture = pic
			alb.Summary = "我想知道相片背后的故事"
			alb.Title = strName[i]
			alb.Status = 1

			AddAlbum(alb)
		}
		this.DelSession("uploadMultiName")
		this.DelSession("uploadMultiPic")
	}

	page, err1 := this.GetInt("p")
	title := this.GetString("title")
	keywords := this.GetString("keywords")
	filter := this.GetString("filter")
	if "" == filter {
		filter = ""
	}
	if err1 != nil {
		page = 1
	}
	offset, err2 := beego.AppConfig.Int("pageoffset")
	if err2 != nil {
		offset = 15
	}

	condArr := make(map[string]string)
	condArr["title"] = title
	condArr["keywords"] = keywords
	condArr["filter"] = filter
	if filter == "me" {
		condArr["userid"] = fmt.Sprintf("%d", this.BaseController.UserUserId)
	}
	countAlbum := CountAlbum(condArr)

	paginator := pagination.SetPaginator(this.Ctx, offset, countAlbum)
	_, _, albums := ListAlbum(condArr, page, offset)

	this.Data["paginator"] = paginator
	this.Data["albums"] = albums
	this.Data["condArr"] = condArr
	this.TplName = "albums/index.tpl"
}

type ShowAlbumController struct {
	controllers.BaseController
}

func (this *ShowAlbumController) Get() {
	//权限检测
	if !strings.Contains(this.GetSession("userPermission").(string), "album-view") {
		this.Abort("401")
	}
	idstr := this.Ctx.Input.Param(":id")
	id, err := strconv.Atoi(idstr)
	album, err := GetAlbum(int64(id))
	if err != nil {
		this.Abort("404")
	}
	this.Data["album"] = album
	ChangeAlbumRelationNum(album.Id, "view")
	comments := ListAlbumComment(album.Id, 1, 100)
	this.Data["comments"] = comments
	this.TplName = "albums/detail.tpl"
}

//多文件上传
type UploadMultiController struct {
	controllers.BaseController
}

func (this *UploadMultiController) Post() {
	//权限检测
	if !strings.Contains(this.GetSession("userPermission").(string), "album-upload") {
		this.Data["json"] = map[string]interface{}{"code": 0, "message": "无权设置"}
		this.ServeJSON()
		return
	}
	files, err := this.GetFiles("uploadFiles")
	if err != nil {
		this.Data["json"] = map[string]interface{}{"code": 0, "message": "目录权限不够"}
		this.ServeJSON()
		return
	}

	//生成上传路径
	now := time.Now()
	dir := "./static/uploadfile/" + strconv.Itoa(now.Year()) + "-" + strconv.Itoa(int(now.Month())) + "/" + strconv.Itoa(now.Day())
	err1 := os.MkdirAll(dir, 0755)
	if err1 != nil {
		this.Data["json"] = map[string]interface{}{"code": 0, "message": "目录权限不够"}
		this.ServeJSON()
		return
	}

	resfilestr := ""
	resfilename := ""
	for i, _ := range files {
		file, err := files[i].Open()
		defer file.Close()
		if err != nil {
			this.Data["json"] = map[string]interface{}{"code": 0, "message": err}
			this.ServeJSON()
			return
		}

		//生成新的文件名
		filename := files[i].Filename
		resfilename += utils.GetFileSuffix(filename) + "||"

		//ext := utils.SubString(filename, strings.LastIndex(filename, "."), 5)
		ext := utils.SubString(utils.Unicode(filename), strings.LastIndex(utils.Unicode(filename), "."), 5)
		filename = utils.GetGuid() + ext
		dst, err := os.Create(dir + "/" + filename)

		defer dst.Close()
		if err != nil {
			this.Data["json"] = map[string]interface{}{"code": 0, "message": err}
			this.ServeJSON()
			return
		}
		if _, err := io.Copy(dst, file); err != nil {
			this.Data["json"] = map[string]interface{}{"code": 0, "message": err}
			this.ServeJSON()
			return
		}
		resfilestr += strings.Replace(dir, ".", "", 1) + "/" + filename + "||"
	}
	this.SetSession("uploadMultiPic", resfilestr)
	this.SetSession("uploadMultiName", resfilename)

	this.Data["json"] = map[string]interface{}{"code": 1, "message": "上传成功", "url": resfilestr}
	this.ServeJSON()
	return
}

//单文件上传
type UploadKindController struct {
	controllers.BaseController
}

func (this *UploadKindController) Post() {
	//imgFile
	f, h, err := this.GetFile("imgFile")
	if err != nil {
		this.Data["json"] = map[string]interface{}{"code": 0, "message": "目录权限不够"}
		this.ServeJSON()
		return
	}
	defer f.Close()

	//生成上传路径
	now := time.Now()
	dir := "./static/uploadfile/" + strconv.Itoa(now.Year()) + "-" + strconv.Itoa(int(now.Month())) + "/" + strconv.Itoa(now.Day())
	err1 := os.MkdirAll(dir, 0755)
	if err1 != nil {
		this.Data["json"] = map[string]interface{}{"error": 1, "message": "目录权限不够"}
		this.ServeJSON()
		return
	}
	//生成新的文件名
	filename := h.Filename
	//ext := utils.SubString(filename, strings.LastIndex(filename, "."), 5)
	ext := utils.SubString(utils.Unicode(filename), strings.LastIndex(utils.Unicode(filename), "."), 5)
	filename = utils.GetGuid() + ext

	if err != nil {
		this.Data["json"] = map[string]interface{}{"error": 1, "message": err}
	} else {
		this.SaveToFile("imgFile", dir+"/"+filename)
		this.Data["json"] = map[string]interface{}{"error": 0, "url": strings.Replace(dir, ".", "", 1) + "/" + filename}
	}
	this.ServeJSON()
}

type AjaxDeleteAlbumController struct {
	controllers.BaseController
}

func (this *AjaxDeleteAlbumController) Post() {
	//权限检测
	if !strings.Contains(this.GetSession("userPermission").(string), "album-delete") {
		this.Data["json"] = map[string]interface{}{"code": 0, "message": "无权设置"}
		this.ServeJSON()
		return
	}
	id, _ := this.GetInt64("id")
	if id < 0 {
		this.Data["json"] = map[string]interface{}{"code": 0, "message": "请选择要删除的选项"}
		this.ServeJSON()
		return
	}

	err := DeleteAlbum(id, this.BaseController.UserUserId)

	if err == nil {
		this.Data["json"] = map[string]interface{}{"code": 1, "message": "删除成功"}
	} else {
		this.Data["json"] = map[string]interface{}{"code": 0, "message": "删除失败"}
	}
	this.ServeJSON()
}
