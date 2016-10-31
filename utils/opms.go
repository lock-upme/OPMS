package utils

import (
	"fmt"
	"math/rand"
	"strings"
)

func GetNeedsStatus(status int) string {
	var txt string
	switch status {
	case 1:
		txt = "草稿"
	case 2:
		txt = "激活"
	case 3:
		txt = "已变更"
	case 4:
		txt = "待关闭"
	case 5:
		txt = "已关闭"
	}
	return txt
}

func GetNeedsSource(source int) string {
	var txt string
	switch source {
	case 1:
		txt = "客户"
	case 2:
		txt = "用户"
	case 3:
		txt = "产品经理"
	case 4:
		txt = "市场"
	case 5:
		txt = "客服"
	case 6:
		txt = "竞争对手"
	case 7:
		txt = "合作伙伴"
	case 8:
		txt = "开发人员"
	case 9:
		txt = "测试人员"
	case 10:
		txt = "其他"
	}
	return txt
}

func GetNeedsStage(stage int) string {
	var txt string
	switch stage {
	case 1:
		txt = "未开始"
	case 2:
		txt = "已计划"
	case 3:
		txt = "已立项"
	case 4:
		txt = "研发中"
	case 5:
		txt = "研发完毕"
	case 6:
		txt = "测试中"
	case 7:
		txt = "测试完毕"
	case 8:
		txt = "已验收"
	case 9:
		txt = "已发布"
	}
	return txt
}

func GetTaskStatus(status int) string {
	var txt string
	switch status {
	case 1:
		txt = "未开始"
	case 2:
		txt = "进行中"
	case 3:
		txt = "已完成"
	case 4:
		txt = "已暂停"
	case 5:
		txt = "已取消"
	case 6:
		txt = "已关闭"
	}
	return txt
}

func GetTaskType(tasktype int) string {
	var txt string
	switch tasktype {
	case 1:
		txt = "设计"
	case 2:
		txt = "开发"
	case 3:
		txt = "测试"
	case 4:
		txt = "研究"
	case 5:
		txt = "讨论"
	case 6:
		txt = "界面"
	case 7:
		txt = "事务"
	case 8:
		txt = "其他"
	}
	return txt
}

func GetTestStatus(status int) string {
	var txt string
	switch status {
	case 1:
		txt = "设计如此"
	case 2:
		txt = "重复Bug"
	case 3:
		txt = "外部原因"
	case 4:
		txt = "已解决"
	case 5:
		txt = "无法重现"
	case 6:
		txt = "延期处理"
	case 7:
		txt = "不予解决"
	}
	return txt
}

func GetOs(os string) string {
	var txt string
	switch os {
	case "all":
		txt = "全部"
	case "windows":
		txt = "windows"
	case "win8":
		txt = "Windows 8"
	case "vista":
		txt = "Windows Vista"
	case "win7":
		txt = "Windows 7"
	case "winxp":
		txt = "Windows XP"
	case "win2012":
		txt = "Windows 2012"
	case "win2008":
		txt = "Windows 2008"
	case "win2003":
		txt = "Windows 2003"
	case "win2000":
		txt = "Windows 2000"
	case "android":
		txt = "Android"
	case "ios":
		txt = "IOS"
	case "wp8":
		txt = "WP8"
	case "wp7":
		txt = "WP7"
	case "symbian":
		txt = "Symbian"
	case "linux":
		txt = "Linux"
	case "freebsd":
		txt = "FreeBSD"
	case "osx":
		txt = "OS X"
	case "unix":
		txt = "Unix"
	case "other":
		txt = "其他"
	}
	return txt
}

func GetBrowser(browser string) string {
	var txt string
	switch browser {
	case "all":
		txt = "全部"
	case "ie":
		txt = "IE系列"
	case "ie11":
		txt = "IE11"
	case "ie10":
		txt = "IE10"
	case "ie9":
		txt = "IE9"
	case "ie8":
		txt = "IE8"
	case "ie7":
		txt = "IE7"
	case "ie6":
		txt = "IE6"
	case "chrome":
		txt = "chrome"
	case "firefox":
		txt = "firefox"
	case "opera":
		txt = "opera"
	case "safari":
		txt = "safari"
	case "maxthon":
		txt = "傲游"
	case "uc":
		txt = "UC"
	case "other":
		txt = "其他"
	}
	return txt
}

func GetAvatarSource(avatar string) string {
	if "" == avatar {
		return "/static/uploadfile/2016-8/17/picture.jpg"
	}
	return strings.Replace(avatar, "-cropper", "", -1)
}

func GetAvatar(avatar string) string {
	if "" == avatar {
		return fmt.Sprintf("/static/img/avatar/%d.jpg", rand.Intn(5))
	}
	return avatar
}
func GetEdu(edu int) string {
	var txt string
	switch edu {
	case 1:
		txt = "小学"
	case 2:
		txt = "中专"
	case 3:
		txt = "初中"
	case 4:
		txt = "高中"
	case 5:
		txt = "技校"
	case 6:
		txt = "大专"
	case 7:
		txt = "本科"
	case 8:
		txt = "硕士"
	case 9:
		txt = "博士"
	case 10:
		txt = "博士后"
	}
	return txt
}

func GetWorkYear(year int) string {
	var txt string
	switch year {
	case 1:
		txt = "应届毕业生"
	case 2:
		txt = "1年以下"
	case 3:
		txt = "1-2年"
	case 4:
		txt = "3-5年"
	case 5:
		txt = "6-7年"
	case 6:
		txt = "8-10年"
	case 7:
		txt = "10年以上"
	}
	return txt
}

func GetResumeStatus(status int) string {
	var txt string
	switch status {
	case 1:
		txt = "入档"
	case 2:
		txt = "通知面试"
	case 3:
		txt = "违约"
	case 4:
		txt = "录用"
	case 5:
		txt = "不录用"
	}
	return txt
}

func GetLeaveType(ltype int) string {
	var txt string
	switch ltype {
	case 1:
		txt = "事假"
	case 2:
		txt = "病假"
	case 3:
		txt = "年假"
	case 4:
		txt = "调休"
	case 5:
		txt = "婚假"
	case 6:
		txt = "产假"
	case 7:
		txt = "陪产假"
	case 8:
		txt = "路途假"
	case 9:
		txt = "其他"
	}
	return txt
}

func GetCheckworkType(ctype int) string {
	var txt string
	switch ctype {
	case 1:
		txt = "正常"
	case 2:
		txt = "迟到"
	case 3:
		txt = "早退"
	case 4:
		txt = "加班"
	}
	return txt
}

func GetMessageType(ctype int) string {
	var txt string
	switch ctype {
	case 1:
		txt = "评论"
	case 2:
		txt = "赞"
	case 3:
		txt = "审批"
	case 4:
		txt = "新加"
	}
	return txt
}

//11知识评论12相册评论21知识赞22相册赞31请假审批32加班33报销34出差35外出36物品
func GetMessageSubtype(subtype int) string {
	var txt string
	switch subtype {
	case 11:
		txt = "知识"
	case 12:
		txt = "相册"
	case 21:
		txt = "知识"
	case 22:
		txt = "相册"
	case 31:
		txt = "请假"
	case 32:
		txt = "加班"
	case 33:
		txt = "报销"
	case 34:
		txt = "出差"
	case 35:
		txt = "外出"
	case 36:
		txt = "物品"
	}
	return txt
}
