package routers

import (
	"opms/controllers/albums"
	"opms/controllers/businesstrips"
	"opms/controllers/checkworks"
	"opms/controllers/expenses"
	"opms/controllers/goouts"
	"opms/controllers/knowledges"
	"opms/controllers/leaves"
	"opms/controllers/messages"
	"opms/controllers/oagoods"
	"opms/controllers/overtimes"
	"opms/controllers/projects"
	"opms/controllers/resumes"
	"opms/controllers/users"

	"github.com/astaxie/beego"
)

func init() {
	beego.Router("/", &users.MainController{})

	//用户
	beego.Router("/user/manage", &users.ManageUserController{})
	beego.Router("/user/ajax/status", &users.AjaxStatusUserController{})
	beego.Router("/user/edit/:id", &users.EditUserController{})
	beego.Router("/user/add", &users.AddUserController{})
	beego.Router("/user/avatar", &users.AvatarUserController{})
	beego.Router("/user/ajax/search", &users.AjaxSearchUserController{}) //搜索用户名匹配
	beego.Router("/user/show/:id", &users.ShowUserController{})
	beego.Router("/user/profile", &users.EditUserProfileController{})
	beego.Router("/user/password", &users.EditUserPasswordController{})

	beego.Router("/user/permission/:id", &users.PermissionController{})

	beego.Router("/login", &users.LoginUserController{})
	beego.Router("/logout", &users.LogoutUserController{})

	//部门
	beego.Router("/department/manage", &users.ManageDepartmentController{})
	beego.Router("/department/ajax/status", &users.AjaxStatusDepartmentController{})
	beego.Router("/department/edit/:id", &users.EditDepartmentController{})
	beego.Router("/department/add", &users.AddDepartmentController{})

	//职位
	beego.Router("/position/manage", &users.ManagePositionController{})
	beego.Router("/position/ajax/status", &users.AjaxStatusPositionController{})
	beego.Router("/position/edit/:id", &users.EditPositionController{})
	beego.Router("/position/add", &users.AddPositionController{})

	//公告
	beego.Router("/notice/manage", &users.ManageNoticeController{})
	beego.Router("/notice/ajax/status", &users.AjaxStatusNoticeController{})
	beego.Router("/notice/ajax/delete", &users.AjaxDeleteNoticeController{})
	beego.Router("/notice/edit/:id", &users.EditNoticeController{})
	beego.Router("/notice/add", &users.AddNoticeController{})

	//项目
	beego.Router("/project/manage", &projects.ManageProjectController{})
	beego.Router("/project/ajax/status", &projects.AjaxStatusProjectController{})
	beego.Router("/project/edit/:id", &projects.EditProjectController{})
	beego.Router("/project/add", &projects.AddProjectController{})
	beego.Router("/project/:id", &projects.ShowProjectController{})

	beego.Router("/my/project", &projects.MyProjectController{})
	beego.Router("/project/chart/:id", &projects.ChartProjectController{})

	//项目成员
	beego.Router("/project/team/:id", &projects.TeamProjectController{})
	beego.Router("/team/ajax/delete", &projects.AjaxDeleteTeamProjectController{})
	beego.Router("/team/add/:id", &projects.AddTeamProjectController{})

	//项目需求
	beego.Router("/project/need/:id", &projects.NeedsProjectController{})
	beego.Router("/need/edit/:id", &projects.EditNeedsProjectController{})
	beego.Router("/need/add/:id", &projects.AddNeedsProjectController{})
	beego.Router("/need/show/:id", &projects.ShowNeedsProjectController{})
	beego.Router("/need/ajax/status", &projects.AjaxStatusNeedProjectController{})

	beego.Router("/my/need", &projects.MyNeedProjectController{})

	//项目任务
	beego.Router("/project/task/:id", &projects.TaskProjectController{})
	beego.Router("/task/edit/:id", &projects.EditTaskProjectController{})
	beego.Router("/task/add/:id", &projects.AddTaskProjectController{})
	beego.Router("/task/ajax/accept", &projects.AjaxAcceptTaskController{})
	beego.Router("/task/ajax/status", &projects.AjaxStatusTaskController{})
	beego.Router("/task/ajax/delete", &projects.DeleteTaskProjectController{})
	beego.Router("/task/show/:id", &projects.ShowTaskProjectController{})

	beego.Router("/my/task", &projects.MyTaskProjectController{})

	//项目测试Bug
	beego.Router("/project/test/:id", &projects.TestProjectController{})
	beego.Router("/test/edit/:id", &projects.EditTestProjectController{})
	beego.Router("/test/add/:id", &projects.AddTestProjectController{})
	beego.Router("/test/ajax/accept", &projects.AjaxAcceptTestController{})
	beego.Router("/test/ajax/status", &projects.AjaxStatusTestController{})
	beego.Router("/test/ajax/delete", &projects.DeleteTestProjectController{})
	beego.Router("/test/show/:id", &projects.ShowTestProjectController{})

	beego.Router("/my/test", &projects.MyTestProjectController{})

	//知识分享
	beego.Router("/knowledge/list", &knowledges.ManageKnowledgeController{})
	beego.Router("/knowledge/add", &knowledges.AddKnowledgeController{})
	beego.Router("/knowledge/edit/:id", &knowledges.EditKnowledgeController{})
	beego.Router("/knowledge/:id", &knowledges.ShowKnowledgeController{})
	beego.Router("/knowledge/comment/add", &knowledges.AddCommentController{})
	beego.Router("/knowledge/ajax/laud", &knowledges.AjaxLaudController{})

	//beego.Router("/task/ajax/status", &projects.AjaxAcceptTaskController{}, "*:AddPost")

	//相片
	beego.Router("/album/list", &albums.ListAlbumController{})
	beego.Router("/album/upload", &albums.UploadAlbumController{})
	beego.Router("/album/edit", &albums.EditAlbumController{})
	beego.Router("/uploadmulti", &albums.UploadMultiController{})
	beego.Router("/album/:id", &albums.ShowAlbumController{})
	beego.Router("/album/comment/add", &albums.AddCommentController{})
	beego.Router("/album/ajax/laud", &albums.AjaxLaudController{})

	//简历
	beego.Router("/resume/list", &resumes.ManageResumeController{})
	beego.Router("/resume/add", &resumes.AddResumeController{})
	beego.Router("/resume/edit/:id", &resumes.EditResumeController{})
	beego.Router("/resume/ajax/status", &resumes.AjaxStatusResumeController{})
	beego.Router("/resume/ajax/delete", &resumes.AjaxDeleteResumeController{})

	beego.Router("/kindeditor/upload", &albums.UploadKindController{})

	//请假
	beego.Router("/leave/manage", &leaves.ManageLeaveController{})
	beego.Router("/leave/approval", &leaves.ApprovalLeaveController{})
	beego.Router("/leave/approval/:id", &leaves.ShowLeaveController{})
	beego.Router("/leave/edit/:id", &leaves.EditLeaveController{})
	beego.Router("/leave/add", &leaves.AddLeaveController{})
	beego.Router("/leave/ajax/status", &leaves.AjaxLeaveStatusController{})
	beego.Router("/leave/ajax/delete", &leaves.AjaxLeaveDeleteController{})

	//报销
	beego.Router("/expense/manage", &expenses.ManageExpenseController{})
	beego.Router("/expense/approval", &expenses.ApprovalExpenseController{})
	beego.Router("/expense/approval/:id", &expenses.ShowExpenseController{})
	beego.Router("/expense/edit/:id", &expenses.EditExpenseController{})
	beego.Router("/expense/add", &expenses.AddExpenseController{})
	beego.Router("/expense/ajax/status", &expenses.AjaxExpenseStatusController{})
	beego.Router("/expense/ajax/delete", &expenses.AjaxExpenseDeleteController{})

	//出差
	beego.Router("/businesstrip/manage", &businesstrips.ManageBusinesstripController{})
	beego.Router("/businesstrip/approval", &businesstrips.ApprovalBusinesstripController{})
	beego.Router("/businesstrip/approval/:id", &businesstrips.ShowBusinesstripController{})
	beego.Router("/businesstrip/edit/:id", &businesstrips.EditBusinesstripController{})
	beego.Router("/businesstrip/add", &businesstrips.AddBusinesstripController{})
	beego.Router("/businesstrip/ajax/status", &businesstrips.AjaxBusinesstripStatusController{})
	beego.Router("/businesstrip/ajax/delete", &businesstrips.AjaxBusinesstripDeleteController{})

	//外出
	beego.Router("/goout/manage", &goouts.ManageGooutController{})
	beego.Router("/goout/approval", &goouts.ApprovalGooutController{})
	beego.Router("/goout/approval/:id", &goouts.ShowGooutController{})
	beego.Router("/goout/edit/:id", &goouts.EditGooutController{})
	beego.Router("/goout/add", &goouts.AddGooutController{})
	beego.Router("/goout/ajax/status", &goouts.AjaxGooutStatusController{})
	beego.Router("/goout/ajax/delete", &goouts.AjaxGooutDeleteController{})

	//物品领用
	beego.Router("/oagood/manage", &oagoods.ManageOagoodController{})
	beego.Router("/oagood/approval", &oagoods.ApprovalOagoodController{})
	beego.Router("/oagood/approval/:id", &oagoods.ShowOagoodController{})
	beego.Router("/oagood/edit/:id", &oagoods.EditOagoodController{})
	beego.Router("/oagood/add", &oagoods.AddOagoodController{})
	beego.Router("/oagood/ajax/status", &oagoods.AjaxOagoodStatusController{})
	beego.Router("/oagood/ajax/delete", &oagoods.AjaxOagoodDeleteController{})

	//加班
	beego.Router("/overtime/manage", &overtimes.ManageOvertimeController{})
	beego.Router("/overtime/approval", &overtimes.ApprovalOvertimeController{})
	beego.Router("/overtime/approval/:id", &overtimes.ShowOvertimeController{})
	beego.Router("/overtime/edit/:id", &overtimes.EditOvertimeController{})
	beego.Router("/overtime/add", &overtimes.AddOvertimeController{})
	beego.Router("/overtime/ajax/status", &overtimes.AjaxOvertimeStatusController{})
	beego.Router("/overtime/ajax/delete", &overtimes.AjaxOvertimeDeleteController{})

	//考勤打卡
	beego.Router("/checkwork/list", &checkworks.ManageCheckworkController{})
	beego.Router("/checkwork/all", &checkworks.ManageCheckworkAllController{})
	beego.Router("/checkwork/ajax/clock", &checkworks.AjaxClockUserController{})

	//消息
	beego.Router("/message/list", &messages.ManageMessageController{})
	beego.Router("/message/ajax/delete", &messages.AjaxDeleteMessageController{})
	beego.Router("/message/ajax/status", &messages.AjaxStatusMessageController{})

}
