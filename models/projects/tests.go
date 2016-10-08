package projects

import (
	"fmt"
	"opms/models"
	"opms/models/users"
	"opms/utils"
	"time"

	"github.com/astaxie/beego"
	"github.com/astaxie/beego/orm"
)

type ProjectsTest struct {
	Id         int64 `orm:"pk;column(testid);"`
	Taskid     int64
	Needsid    int64
	Projectid  int64
	Userid     int64
	Acceptid   int64
	Ccid       string
	Completeid int64
	Name       string
	Desc       string
	Level      int
	Attachment string
	Completed  int64
	Os         string
	Browser    string
	Created    int64
	Changed    int64
	Status     int
}

type ProjectsTestLog struct {
	Id      int64 `orm:"pk;"`
	Testid  int64
	Userid  int64
	Note    string
	Created int64
}

func (this *ProjectsTest) TableName() string {
	return models.TableName("projects_test")
}

func (this *ProjectsTestLog) TableName() string {
	return models.TableName("projects_test_log")
}
func init() {
	orm.RegisterModel(new(ProjectsTest), new(ProjectsTestLog))
}

func AddTest(upd ProjectsTest) error {
	o := orm.NewOrm()
	test := new(ProjectsTest)

	test.Id = upd.Id
	test.Taskid = upd.Taskid
	test.Needsid = upd.Needsid
	test.Projectid = upd.Projectid
	test.Userid = upd.Userid
	test.Acceptid = upd.Acceptid
	test.Ccid = upd.Ccid
	test.Name = upd.Name
	test.Desc = upd.Desc
	test.Level = upd.Level
	test.Os = upd.Os
	test.Browser = upd.Browser
	test.Status = 0
	test.Created = time.Now().Unix()
	test.Attachment = upd.Attachment
	_, err := o.Insert(test)

	if upd.Acceptid > 0 {
		email := users.GetUserEmail(upd.Acceptid)
		link := beego.AppConfig.String("domain") + "/test/show/" + fmt.Sprintf("%d", upd.Id)
		content := upd.Desc + "<br/><a href=\"" + link + "\">" + link + "</a>"
		go utils.SendMail(email, "新Bug："+upd.Name, content)
	}

	//操作日志
	idpk := utils.SnowFlakeId()
	var log ProjectsTestLog
	log.Id = idpk
	log.Userid = upd.Userid
	log.Testid = upd.Id
	log.Note = users.GetRealname(upd.Userid) + "创建了测试"
	log.Created = time.Now().Unix()
	err = AddTestLog(log)

	return err
}

func UpdateTest(id int64, upd ProjectsTest) error {
	var test ProjectsTest
	o := orm.NewOrm()
	test = ProjectsTest{Id: id}
	test.Acceptid = upd.Acceptid
	test.Ccid = upd.Ccid
	test.Name = upd.Name
	test.Desc = upd.Desc
	test.Level = upd.Level
	test.Os = upd.Os
	test.Browser = upd.Browser
	test.Changed = time.Now().Unix()

	//操作日志
	var log ProjectsTestLog
	log.Id = utils.SnowFlakeId()
	log.Userid = upd.Userid
	log.Testid = id
	log.Note = users.GetRealname(upd.Userid) + "编辑了测试"
	log.Created = time.Now().Unix()
	AddTestLog(log)

	if upd.Attachment != "" {
		test.Attachment = upd.Attachment
		_, err := o.Update(&test, "acceptid", "ccid", "name", "desc", "level", "os", "browser", "changed", "attachment")
		return err
	} else {
		_, err := o.Update(&test, "acceptid", "ccid", "name", "desc", "level", "os", "browser", "changed")
		return err
	}
}

func AddTestLog(upd ProjectsTestLog) error {
	o := orm.NewOrm()
	log := new(ProjectsTestLog)
	log.Id = upd.Id
	log.Userid = upd.Userid
	log.Testid = upd.Testid
	log.Note = upd.Note
	log.Created = time.Now().Unix()
	_, err := o.Insert(log)
	return err
}

func GetProjectTest(id int64) (ProjectsTest, error) {
	var test ProjectsTest
	var err error
	o := orm.NewOrm()

	test = ProjectsTest{Id: id}
	err = o.Read(&test)

	if err == orm.ErrNoRows {
		return test, nil
	}
	return test, err
}

func ListProjectTest(condArr map[string]string, page int, offset int) (num int64, err error, ops []ProjectsTest) {
	o := orm.NewOrm()
	o.Using("default")
	if page < 1 {
		page = 1
	}
	if offset < 1 {
		offset, _ = beego.AppConfig.Int("pageoffset")
	}
	start := (page - 1) * offset

	var test []ProjectsTest

	qs := o.QueryTable(models.TableName("projects_test"))
	cond := orm.NewCondition()
	if condArr["projectid"] != "" {
		cond = cond.And("projectid", condArr["projectid"])
	}
	if condArr["acceptid"] != "" {
		cond = cond.And("acceptid", condArr["acceptid"])
	}
	if condArr["completeid"] != "" {
		cond = cond.And("completeid", condArr["completeid"])
	}
	if condArr["userid"] != "" {
		cond = cond.And("userid", condArr["userid"])
	}
	if condArr["keywords"] != "" {
		cond = cond.And("name__icontains", condArr["keywords"])
	}
	if condArr["status"] != "" {
		cond = cond.And("status", condArr["status"])
	}
	qs = qs.SetCond(cond).OrderBy("-testid")
	nums, errs := qs.Limit(offset, start).All(&test)
	return nums, errs, test
}

func CountTest(condArr map[string]string) int64 {
	o := orm.NewOrm()
	qs := o.QueryTable(models.TableName("projects_test"))
	cond := orm.NewCondition()
	if condArr["projectid"] != "" {
		cond = cond.And("projectid", condArr["projectid"])
	}
	if condArr["acceptid"] != "" {
		cond = cond.And("acceptid", condArr["acceptid"])
	}
	if condArr["completeid"] != "" {
		cond = cond.And("completeid", condArr["completeid"])
	}
	if condArr["userid"] != "" {
		cond = cond.And("userid", condArr["userid"])
	}
	if condArr["keywords"] != "" {
		cond = cond.And("name__icontains", condArr["keywords"])
	}
	if condArr["status"] != "" {
		cond = cond.And("status", condArr["status"])
	}
	num, _ := qs.SetCond(cond).Count()
	return num
}

func ListProjectTestLog(testId int64) (ops []ProjectsTestLog) {
	var logs []ProjectsTestLog
	var err error
	err = utils.GetCache("ListProjectTestLog.id."+fmt.Sprintf("%d", testId), &logs)
	if err != nil {
		cache_expire, _ := beego.AppConfig.Int("cache_expire")
		o := orm.NewOrm()
		o.Using("default")
		qs := o.QueryTable(models.TableName("projects_test_log"))
		cond := orm.NewCondition()
		if testId > 0 {
			cond = cond.And("testId", testId)
		}
		qs = qs.SetCond(cond)
		qs.All(&logs)
		utils.SetCache("ListProjectTestLog.id."+fmt.Sprintf("%d", testId), logs, cache_expire)
	}
	return logs
}

func ChangeProjectTestStatus(id int64, userid int64, status int, note string) error {
	o := orm.NewOrm()

	test := ProjectsTest{Id: id}
	err := o.Read(&test, "testid")
	if nil != err {
		return err
	} else {
		test.Status = status

		test.Completeid = userid
		test.Completed = time.Now().Unix()

		_, err := o.Update(&test)

		//操作日志
		var log ProjectsTestLog
		log.Id = utils.SnowFlakeId()
		log.Userid = userid
		log.Testid = id
		log.Note = users.GetRealname(userid) + "更改测试状态为" + utils.GetTestStatus(status) + "<br>" + note
		log.Created = time.Now().Unix()
		err = AddTestLog(log)

		return err
	}
}

func ChangeProjectTestAccept(id int64, acceptid int64, userid int64, note string) error {
	o := orm.NewOrm()

	test := ProjectsTest{Id: id}
	err := o.Read(&test, "testid")
	if nil != err {
		return err
	} else {
		test.Acceptid = acceptid
		//test.Note = note
		_, err := o.Update(&test)

		email := users.GetUserEmail(acceptid)
		link := beego.AppConfig.String("domain") + "/test/show/" + fmt.Sprintf("%d", test.Id)
		content := test.Desc + "<br/><a href=\"" + link + "\">" + link + "</a>"
		go utils.SendMail(email, "新Bug："+test.Name, content)

		//操作日志
		var log ProjectsTestLog
		log.Id = utils.SnowFlakeId()
		log.Userid = userid
		log.Testid = id
		log.Note = users.GetRealname(userid) + "指派给" + users.GetRealname(acceptid) + "。<br/>" + note
		log.Created = time.Now().Unix()
		err = AddTestLog(log)
		return err
	}
}

func DeleteProjectTest(id int64) error {
	o := orm.NewOrm()
	_, err := o.Delete(&ProjectsTest{Id: id})

	if err == nil {
		_, err = o.Raw("DELETE FROM "+models.TableName("projects_test_log")+" WHERE testid = ?", id).Exec()
	}
	return err
}
