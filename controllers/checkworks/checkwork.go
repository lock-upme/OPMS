package checkworks

import (
	"fmt"

	"opms/controllers"
	. "opms/models/checkworks"
	"opms/utils"
	//"os"
	//"strconv"
	"strings"
	"time"

	"github.com/astaxie/beego"

	//"github.com/astaxie/beego/utils/pagination"
)

//用户个人考勤
type ManageCheckworkController struct {
	controllers.BaseController
}

func (this *ManageCheckworkController) Get() {
	//权限检测
	if !strings.Contains(this.GetSession("userPermission").(string), "checkwork-manage") {
		this.Abort("401")
	}

	typec := this.GetString("type")
	date := this.GetString("date")
	if "" == date {
		date = time.Now().Format("2006-01")
	}

	condArr := make(map[string]string)
	condArr["type"] = typec
	condArr["date"] = date
	condArr["userId"] = fmt.Sprintf("%d", this.BaseController.UserUserId)
	_, _, checkworks := ListCheckwork(condArr)
	this.Data["condArr"] = condArr
	this.Data["checkworks"] = checkworks

	this.Data["year"] = time.Now().Format("2006")
	this.Data["month"] = time.Now().Format("01")

	//统计
	countCheckworks, _ := CountCheckwork(date, this.BaseController.UserUserId)
	this.Data["countCheckworks"] = countCheckworks

	_, _, countCheckTypes := CountCheckworkType(date, this.BaseController.UserUserId)
	this.Data["countCheckTypes"] = countCheckTypes

	cleaves, _ := CountCheck("leaves", date, this.BaseController.UserUserId)
	this.Data["cleaves"] = cleaves

	//cbusiness, _ := CountCheck("businesstrips", date, this.BaseController.UserUserId)
	//this.Data["cbusiness"] = cbusiness

	cgoouts, _ := CountCheck("goouts", date, this.BaseController.UserUserId)
	this.Data["cgoouts"] = cgoouts

	this.TplName = "checkworks/index.tpl"
}

//全部用户考勤
type ManageCheckworkAllController struct {
	controllers.BaseController
}

func (this *ManageCheckworkAllController) Get() {
	//权限检测
	if !strings.Contains(this.GetSession("userPermission").(string), "checkwork-all") {
		this.Abort("401")
	}

	date := this.GetString("date")
	if "" == date {
		date = time.Now().Format("2006-01")
	}

	userId, err := this.GetInt64("userid")
	if err != nil {
		userId = this.BaseController.UserUserId
	}

	condArr := make(map[string]string)
	condArr["date"] = date
	condArr["userId"] = fmt.Sprintf("%d", userId)

	_, _, checkworks := ListCheckworkAll(condArr)
	fmt.Println(checkworks)
	this.Data["condArr"] = condArr
	this.Data["checkworks"] = checkworks

	this.Data["year"] = time.Now().Format("2006")
	this.Data["month"] = time.Now().Format("01")

	//统计
	countCheckworks, _ := CountCheckwork(date, userId)
	this.Data["countCheckworks"] = countCheckworks

	_, _, countCheckTypes := CountCheckworkType(date, userId)
	this.Data["countCheckTypes"] = countCheckTypes

	cleaves, _ := CountCheck("leaves", date, userId)
	this.Data["cleaves"] = cleaves

	//cbusiness, _ := CountCheck("businesstrips", date, userId)
	//this.Data["cbusiness"] = cbusiness

	cgoouts, _ := CountCheck("goouts", date, userId)
	this.Data["cgoouts"] = cgoouts

	this.TplName = "checkworks/all.tpl"
}

//打卡
type AjaxClockUserController struct {
	controllers.BaseController
}

func (this *AjaxClockUserController) Post() {
	clock := this.GetString("clock")
	if "" == clock {
		this.Data["json"] = map[string]interface{}{"code": 0, "message": "参数出错"}
		this.ServeJSON()
		return
	}
	checkNum := CountClock(this.BaseController.UserUserId)
	if checkNum >= 2 {
		this.Data["json"] = map[string]interface{}{"code": 0, "message": "你今天打卡次数超过了2次"}
		this.ServeJSON()
		return
	}

	//type 1正常2迟到3早退4加班
	clockon := beego.AppConfig.String("clockon")
	clockoff := beego.AppConfig.String("clockoff")
	clockover := beego.AppConfig.String("clockover")

	time1 := time.Now().Format("2006-01-02") + " " + clock
	t1, _ := time.Parse("2006-01-02 15:04:05", time1)

	var typec int
	if checkNum <= 0 {
		time2 := time.Now().Format("2006-01-02") + " " + clockon
		t2, _ := time.Parse("2006-01-02 15:04:05", time2)
		if t1.Before(t2) {
			typec = 1
		} else {
			typec = 2
		}
	}

	if checkNum == 1 {
		time2 := time.Now().Format("2006-01-02") + " " + clockoff
		t2, _ := time.Parse("2006-01-02 15:04:05", time2)
		if t1.Before(t2) {
			typec = 3
		} else {
			time2 := time.Now().Format("2006-01-02") + " " + clockover
			t2, _ := time.Parse("2006-01-02 15:04:05", time2)
			if t1.After(t2) {
				typec = 4
			} else {
				typec = 1
			}
		}

	}
	var check Checkworks
	check.Id = utils.SnowFlakeId()
	check.Userid = this.BaseController.UserUserId
	check.Clock = clock
	check.Type = typec
	check.Ip = this.Ctx.Input.IP()
	err := AddCheckwork(check)
	if err == nil {
		this.Data["json"] = map[string]interface{}{"code": 1, "message": "打卡成功"}
	} else {
		this.Data["json"] = map[string]interface{}{"code": 0, "message": "打卡失败"}
	}
	this.ServeJSON()
}
