package models

import (
	"github.com/astaxie/beego"
)

func TableName(name string) string {
	return beego.AppConfig.String("mysqlpre") + name
}
