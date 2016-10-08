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

type ProjectsTask struct {
	Id         int64 `orm:"pk;column(taskid);"`
	Needsid    int64
	Projectid  int64
	Userid     int64
	Acceptid   int64
	Ccid       string
	Completeid int64
	Name       string
	Desc       string
	Note       string
	Type       int
	Level      int
	Tasktime   int
	Started    int64
	Ended      int64
	Attachment string
	Created    int64
	Changed    int64
	Status     int
	Closeid    int64
	Cancelid   int64
}

type ProjectsTaskLog struct {
	Id      int64 `orm:"pk;"`
	Taskid  int64
	Userid  int64
	Note    string
	Created int64
}

func (this *ProjectsTask) TableName() string {
	return models.TableName("projects_task")
}

func (this *ProjectsTaskLog) TableName() string {
	return models.TableName("projects_task_log")
}
func init() {
	orm.RegisterModel(new(ProjectsTask), new(ProjectsTaskLog))
}

func AddTask(upd ProjectsTask) error {
	o := orm.NewOrm()
	task := new(ProjectsTask)

	task.Id = upd.Id
	task.Needsid = upd.Needsid
	task.Projectid = upd.Projectid
	task.Userid = upd.Userid
	task.Acceptid = upd.Acceptid
	task.Ccid = upd.Ccid
	task.Name = upd.Name
	task.Desc = upd.Desc
	task.Note = upd.Note
	task.Level = upd.Level
	task.Type = upd.Type
	task.Tasktime = upd.Tasktime
	task.Started = upd.Started
	task.Ended = upd.Ended
	task.Status = 1
	task.Created = time.Now().Unix()
	task.Attachment = upd.Attachment
	_, err := o.Insert(task)

	if upd.Acceptid > 0 {
		email := users.GetUserEmail(upd.Acceptid)
		link := beego.AppConfig.String("domain") + "/task/show/" + fmt.Sprintf("%d", upd.Id)
		content := upd.Desc + "<br/><a href=\"" + link + "\">" + link + "</a>"
		go utils.SendMail(email, "新任务："+upd.Name, content)
	}

	//操作日志
	idpk := utils.SnowFlakeId()
	var log ProjectsTaskLog
	log.Id = idpk
	log.Userid = upd.Userid
	log.Taskid = upd.Id
	log.Note = users.GetRealname(upd.Userid) + "创建了任务"
	log.Created = time.Now().Unix()
	err = AddTaskLog(log)

	return err
}

func UpdateTask(id int64, upd ProjectsTask) error {
	var task ProjectsTask
	o := orm.NewOrm()
	task = ProjectsTask{Id: id}

	task.Needsid = upd.Needsid
	task.Acceptid = upd.Acceptid
	task.Ccid = upd.Ccid
	task.Name = upd.Name
	task.Desc = upd.Desc
	task.Note = upd.Note
	task.Level = upd.Level
	task.Type = upd.Type
	task.Tasktime = upd.Tasktime
	task.Started = upd.Started
	task.Ended = upd.Ended
	task.Changed = time.Now().Unix()

	//操作日志
	var log ProjectsTaskLog
	log.Id = utils.SnowFlakeId()
	log.Userid = upd.Userid //当前登录用户
	log.Taskid = id
	log.Note = users.GetRealname(upd.Userid) + "编辑了任务"
	log.Created = time.Now().Unix()
	AddTaskLog(log)

	if upd.Attachment != "" {
		task.Attachment = upd.Attachment
		_, err := o.Update(&task, "needsid", "acceptid", "ccid", "name", "desc", "note", "level", "type", "tasktime", "started", "ended", "changed", "attachment")
		return err
	} else {
		_, err := o.Update(&task, "needsid", "acceptid", "ccid", "name", "desc", "note", "level", "type", "tasktime", "started", "ended", "changed")
		return err
	}
}

func AddTaskLog(upd ProjectsTaskLog) error {
	o := orm.NewOrm()
	log := new(ProjectsTaskLog)
	log.Id = upd.Id
	log.Userid = upd.Userid
	log.Taskid = upd.Taskid
	log.Note = upd.Note
	log.Created = time.Now().Unix()
	_, err := o.Insert(log)
	return err
}

func GetProjectTask(id int64) (ProjectsTask, error) {
	var task ProjectsTask
	var err error
	o := orm.NewOrm()

	task = ProjectsTask{Id: id}
	err = o.Read(&task)

	if err == orm.ErrNoRows {
		return task, nil
	}
	return task, err
}

func ListTaskForForm(projectId int64, page, offset int) (ops []ProjectsTask) {
	if page < 1 {
		page = 1
	}
	if offset < 1 {
		offset = 100
	}
	start := (page - 1) * offset

	var task []ProjectsTask
	var err error
	err = utils.GetCache("ListTaskForForm.id."+fmt.Sprintf("%d", projectId), &task)
	if err != nil {
		cache_expire, _ := beego.AppConfig.Int("cache_expire")
		o := orm.NewOrm()
		o.Using("default")
		qs := o.QueryTable(models.TableName("projects_task"))
		cond := orm.NewCondition()
		if projectId > 0 {
			cond = cond.And("projectid", projectId)
		}
		qs = qs.SetCond(cond)
		qs.Limit(offset, start).All(&task)
		utils.SetCache("ListTaskForForm.id."+fmt.Sprintf("%d", projectId), task, cache_expire)
	}
	return task
}

func ListProjectTask(condArr map[string]string, page int, offset int) (num int64, err error, ops []ProjectsTask) {
	o := orm.NewOrm()
	o.Using("default")
	if page < 1 {
		page = 1
	}
	if offset < 1 {
		offset, _ = beego.AppConfig.Int("pageoffset")
	}
	start := (page - 1) * offset

	var task []ProjectsTask

	qs := o.QueryTable(models.TableName("projects_task"))
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
	if condArr["closeid"] != "" {
		cond = cond.And("closeid", condArr["closeid"])
	}
	if condArr["cancelid"] != "" {
		cond = cond.And("cancelid", condArr["cancelid"])
	}
	if condArr["keywords"] != "" {
		cond = cond.And("name__icontains", condArr["keywords"])
	}
	if condArr["status"] != "" {
		cond = cond.And("status", condArr["status"])
	}
	if condArr["type"] != "" {
		cond = cond.And("type", condArr["type"])
	}
	qs = qs.SetCond(cond)

	nums, errs := qs.Limit(offset, start).All(&task)
	qs = qs.OrderBy("-taskid")
	return nums, errs, task
}

func CountTask(condArr map[string]string) int64 {
	o := orm.NewOrm()
	qs := o.QueryTable(models.TableName("projects_task"))
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
	if condArr["closeid"] != "" {
		cond = cond.And("closeid", condArr["closeid"])
	}
	if condArr["cancelid"] != "" {
		cond = cond.And("cancelid", condArr["cancelid"])
	}
	if condArr["keywords"] != "" {
		cond = cond.And("name__icontains", condArr["keywords"])
	}
	if condArr["status"] != "" {
		cond = cond.And("status", condArr["status"])
	}
	if condArr["type"] != "" {
		cond = cond.And("type", condArr["type"])
	}
	num, _ := qs.SetCond(cond).Count()
	return num
}

func ListProjectTaskLog(taskId int64) (ops []ProjectsTaskLog) {
	var logs []ProjectsTaskLog
	var err error
	err = utils.GetCache("ListProjectTaskLog.id."+fmt.Sprintf("%d", taskId), &logs)
	if err != nil {
		cache_expire, _ := beego.AppConfig.Int("cache_expire")
		o := orm.NewOrm()
		o.Using("default")
		qs := o.QueryTable(models.TableName("projects_task_log"))
		cond := orm.NewCondition()
		if taskId > 0 {
			cond = cond.And("taskId", taskId)
		}
		qs = qs.SetCond(cond)
		qs.All(&logs)
		utils.SetCache("ListProjectTaskLog.id."+fmt.Sprintf("%d", taskId), logs, cache_expire)
	}
	return logs
}

func ChangeProjectTaskStatus(id int64, userid int64, status int) error {
	o := orm.NewOrm()

	task := ProjectsTask{Id: id}
	err := o.Read(&task, "taskid")
	if nil != err {
		return err
	} else {
		task.Status = status
		if 3 == status {
			task.Completeid = userid
		} else if 5 == status {
			task.Cancelid = userid
		} else if 6 == status {
			task.Closeid = userid
		}
		_, err := o.Update(&task)

		//操作日志
		var log ProjectsTaskLog
		log.Id = utils.SnowFlakeId()
		log.Userid = userid
		log.Taskid = id
		log.Note = users.GetRealname(userid) + "更改任务状态为" + utils.GetTaskStatus(status)
		log.Created = time.Now().Unix()
		err = AddTaskLog(log)

		return err
	}
}

func ChangeProjectTaskAccept(id int64, acceptid int64, userid int64, note string) error {
	o := orm.NewOrm()

	task := ProjectsTask{Id: id}
	err := o.Read(&task, "taskid")
	if nil != err {
		return err
	} else {
		task.Acceptid = acceptid
		//task.Note = note
		_, err := o.Update(&task)

		email := users.GetUserEmail(acceptid)
		link := beego.AppConfig.String("domain") + "/task/show/" + fmt.Sprintf("%d", task.Id)
		content := task.Desc + "<br/><a href=\"" + link + "\">" + link + "</a>"
		go utils.SendMail(email, "新任务："+task.Name, content)

		//操作日志
		var log ProjectsTaskLog
		log.Id = utils.SnowFlakeId()
		log.Userid = userid
		log.Taskid = id
		log.Note = users.GetRealname(userid) + "指派给" + users.GetRealname(acceptid) + "。" + note
		log.Created = time.Now().Unix()
		err = AddTaskLog(log)

		return err
	}
}

func DeleteProjectTask(id int64) error {
	o := orm.NewOrm()
	_, err := o.Delete(&ProjectsTask{Id: id})

	if err == nil {
		_, err = o.Raw("DELETE FROM "+models.TableName("projects_task_log")+" WHERE taskid = ?", id).Exec()
	}
	return err
}
