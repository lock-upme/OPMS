package controllers

import (
	//"opms/initial"

	"strconv"
	"strings"
	//"fmt"

	"github.com/astaxie/beego"
)

type BaseController struct {
	beego.Controller
	IsLogin bool
	//UserInfo string
	UserUserId   int64
	UserUsername string
	UserAvatar   string
}

func (this *BaseController) Prepare() {
	userLogin := this.GetSession("userLogin")
	if userLogin == nil {
		this.IsLogin = false
		//this.Redirect("/login", 302)
	} else {
		this.IsLogin = true
		tmp := strings.Split((this.GetSession("userLogin")).(string), "||")

		//id, _ := strconv.Atoi(tmp[0])
		userid, _ := strconv.Atoi(tmp[0])
		longid := int64(userid)
		this.Data["LoginUserid"] = longid
		this.Data["LoginUsername"] = tmp[1]
		this.Data["LoginAvatar"] = tmp[2]

		this.UserUserId = longid
		this.UserUsername = tmp[1]
		this.UserAvatar = tmp[2]

		this.Data["PermissionModel"] = this.GetSession("userPermissionModel")
		this.Data["PermissionModelc"] = this.GetSession("userPermissionModelc")
	}
	this.Data["IsLogin"] = this.IsLogin

}
