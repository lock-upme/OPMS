/*
Navicat MySQL Data Transfer

Source Server         : z-local
Source Server Version : 50626
Source Host           : localhost:3306
Source Database       : aiopms

Target Server Type    : MYSQL
Target Server Version : 50626
File Encoding         : 65001

Date: 2016-08-30 15:25:23
*/

SET FOREIGN_KEY_CHECKS=0;

-- ----------------------------
-- Table structure for pms_albums
-- ----------------------------
DROP TABLE IF EXISTS `pms_albums`;
CREATE TABLE `pms_albums` (
  `albumid` bigint(20) NOT NULL,
  `userid` bigint(20) DEFAULT NULL,
  `title` varchar(255) NOT NULL DEFAULT '' COMMENT '文章标题',
  `picture` varchar(255) DEFAULT '' COMMENT 'Picture',
  `keywords` varchar(2550) DEFAULT '' COMMENT '关键词',
  `summary` varchar(255) DEFAULT '',
  `created` int(10) DEFAULT '0' COMMENT '发布时间',
  `viewnum` int(10) DEFAULT '0' COMMENT '阅读数',
  `comtnum` int(10) DEFAULT '0' COMMENT '评论数',
  `laudnum` int(10) DEFAULT '0' COMMENT '赞数',
  `status` tinyint(1) DEFAULT '1' COMMENT '状态: 1发布0屏蔽',
  PRIMARY KEY (`albumid`),
  KEY `INDEX_TCVS` (`userid`,`title`,`created`,`viewnum`,`status`) USING BTREE
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COMMENT='相册表';

-- ----------------------------
-- Records of pms_albums
-- ----------------------------

-- ----------------------------
-- Table structure for pms_albums_comment
-- ----------------------------
DROP TABLE IF EXISTS `pms_albums_comment`;
CREATE TABLE `pms_albums_comment` (
  `comtid` bigint(20) NOT NULL,
  `userid` bigint(20) DEFAULT NULL,
  `albumid` bigint(20) DEFAULT NULL,
  `content` varchar(255) DEFAULT NULL,
  `created` int(10) DEFAULT NULL,
  `status` tinyint(1) DEFAULT '1' COMMENT '1正常2屏蔽',
  PRIMARY KEY (`comtid`),
  KEY `INDEX_UKCS` (`userid`,`albumid`,`created`,`status`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COMMENT='相册评论表';

-- ----------------------------
-- Records of pms_albums_comment
-- ----------------------------

-- ----------------------------
-- Table structure for pms_albums_laud
-- ----------------------------
DROP TABLE IF EXISTS `pms_albums_laud`;
CREATE TABLE `pms_albums_laud` (
  `laudid` bigint(20) NOT NULL,
  `userid` bigint(20) DEFAULT NULL,
  `albumid` bigint(20) DEFAULT NULL,
  `created` int(10) DEFAULT NULL,
  `status` tinyint(1) DEFAULT '1' COMMENT '1正常2屏蔽',
  PRIMARY KEY (`laudid`),
  KEY `INDEX_UKCS` (`userid`,`albumid`,`created`,`status`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COMMENT='相册点赞表';

-- ----------------------------
-- Records of pms_albums_laud
-- ----------------------------

-- ----------------------------
-- Table structure for pms_departs
-- ----------------------------
DROP TABLE IF EXISTS `pms_departs`;
CREATE TABLE `pms_departs` (
  `departid` bigint(20) NOT NULL COMMENT '部门ID',
  `name` varchar(30) DEFAULT NULL COMMENT '名称',
  `desc` varchar(255) DEFAULT NULL COMMENT '描述',
  `status` tinyint(1) DEFAULT '1' COMMENT '1正常2屏蔽',
  PRIMARY KEY (`departid`),
  KEY `INDEX_NS` (`name`,`status`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COMMENT='部门表';

-- ----------------------------
-- Records of pms_departs
-- ----------------------------
INSERT INTO `pms_departs` VALUES ('1462290164626094232', '运营部', '微信运营组，PC运营组', '1');
INSERT INTO `pms_departs` VALUES ('1462290199274575028', '市场部', '前端销售，后端销售，商务组', '1');
INSERT INTO `pms_departs` VALUES ('1462290127694985332', '研发部', '研发部，GO组，PHP组，UI组', '1');
INSERT INTO `pms_departs` VALUES ('1462290228639093428', '行政部', '日常后勤，人事', '1');
INSERT INTO `pms_departs` VALUES ('1462290248393045132', '财务部', '掌管经济大权', '1');

-- ----------------------------
-- Table structure for pms_knowledges
-- ----------------------------
DROP TABLE IF EXISTS `pms_knowledges`;
CREATE TABLE `pms_knowledges` (
  `knowid` bigint(20) NOT NULL,
  `userid` bigint(20) DEFAULT NULL COMMENT '用户ID',
  `sortid` bigint(20) DEFAULT NULL COMMENT '分类ID',
  `title` varchar(100) DEFAULT NULL COMMENT '标题',
  `tag` varchar(100) DEFAULT NULL COMMENT '标签',
  `summary` varchar(255) DEFAULT NULL COMMENT '简介',
  `url` varchar(255) DEFAULT NULL COMMENT 'URL',
  `color` varchar(10) DEFAULT NULL COMMENT '标题颜色',
  `content` text COMMENT '正文',
  `viewnum` int(10) DEFAULT '0' COMMENT '浏览数',
  `comtnum` int(10) DEFAULT '0' COMMENT '评论数',
  `laudnum` int(10) DEFAULT '0' COMMENT '赞数',
  `ispublis` tinyint(1) DEFAULT '1' COMMENT '1发布2草稿',
  `status` tinyint(1) DEFAULT '1' COMMENT '1正常2屏蔽',
  `created` int(10) DEFAULT NULL,
  `changed` int(10) DEFAULT NULL,
  PRIMARY KEY (`knowid`),
  KEY `INDEX_UALL` (`userid`,`sortid`,`title`,`tag`,`viewnum`,`ispublis`,`status`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COMMENT='知识分享表';

-- ----------------------------
-- Records of pms_knowledges
-- ----------------------------

-- ----------------------------
-- Table structure for pms_knowledges_comment
-- ----------------------------
DROP TABLE IF EXISTS `pms_knowledges_comment`;
CREATE TABLE `pms_knowledges_comment` (
  `comtid` bigint(20) NOT NULL,
  `userid` bigint(20) DEFAULT NULL,
  `knowid` bigint(20) DEFAULT NULL,
  `content` varchar(255) DEFAULT NULL,
  `created` int(10) DEFAULT NULL,
  `status` tinyint(1) DEFAULT '1' COMMENT '1正常2屏蔽',
  PRIMARY KEY (`comtid`),
  KEY `INDEX_UKCS` (`userid`,`knowid`,`created`,`status`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COMMENT='知识评论表';

-- ----------------------------
-- Records of pms_knowledges_comment
-- ----------------------------

-- ----------------------------
-- Table structure for pms_knowledges_laud
-- ----------------------------
DROP TABLE IF EXISTS `pms_knowledges_laud`;
CREATE TABLE `pms_knowledges_laud` (
  `laudid` bigint(20) NOT NULL,
  `userid` bigint(20) DEFAULT NULL,
  `knowid` bigint(20) DEFAULT NULL,
  `created` int(10) DEFAULT NULL,
  `status` tinyint(1) DEFAULT '1' COMMENT '1正常2屏蔽',
  PRIMARY KEY (`laudid`),
  KEY `INDEX_UKCS` (`userid`,`knowid`,`created`,`status`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COMMENT='知识点赞表';

-- ----------------------------
-- Records of pms_knowledges_laud
-- ----------------------------

-- ----------------------------
-- Table structure for pms_knowledges_sort
-- ----------------------------
DROP TABLE IF EXISTS `pms_knowledges_sort`;
CREATE TABLE `pms_knowledges_sort` (
  `sortid` bigint(20) NOT NULL,
  `name` varchar(30) DEFAULT NULL COMMENT '名称',
  `desc` varchar(255) DEFAULT NULL COMMENT '描述',
  `status` tinyint(1) DEFAULT '1' COMMENT '1显示，0屏蔽',
  PRIMARY KEY (`sortid`),
  KEY `INDEX_NS` (`name`,`status`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COMMENT='知识分享分类表';

-- ----------------------------
-- Records of pms_knowledges_sort
-- ----------------------------
INSERT INTO `pms_knowledges_sort` VALUES ('1', '企业文化', null, '1');
INSERT INTO `pms_knowledges_sort` VALUES ('2', '管理知识', null, '1');
INSERT INTO `pms_knowledges_sort` VALUES ('3', '财务知识', null, '1');
INSERT INTO `pms_knowledges_sort` VALUES ('4', '技术分享', null, '1');
INSERT INTO `pms_knowledges_sort` VALUES ('5', '服务器', null, '1');
INSERT INTO `pms_knowledges_sort` VALUES ('6', '市场营销', null, '1');
INSERT INTO `pms_knowledges_sort` VALUES ('7', '运营', null, '1');
INSERT INTO `pms_knowledges_sort` VALUES ('8', '随笔', null, '1');

-- ----------------------------
-- Table structure for pms_notices
-- ----------------------------
DROP TABLE IF EXISTS `pms_notices`;
CREATE TABLE `pms_notices` (
  `noticeid` bigint(20) NOT NULL,
  `title` varchar(100) DEFAULT NULL,
  `content` text,
  `created` int(10) DEFAULT NULL,
  `status` tinyint(1) DEFAULT NULL,
  PRIMARY KEY (`noticeid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of pms_notices
-- ----------------------------

-- ----------------------------
-- Table structure for pms_permissions
-- ----------------------------
DROP TABLE IF EXISTS `pms_permissions`;
CREATE TABLE `pms_permissions` (
  `userid` bigint(20) NOT NULL,
  `permission` varchar(500) DEFAULT NULL,
  PRIMARY KEY (`userid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of pms_permissions
-- ----------------------------
INSERT INTO `pms_permissions` VALUES ('1461312703628858832', 'user-manage,user-add,user-edit,user-permission,department-manage,department-add,department-edit,position-manage,position-add,position-edit,project-manage,project-add,project-edit,project-team,team-add,team-delete,project-need,need-add,need-edit,project-task,task-add,task-edit,project-test,test-add,test-edit,knowledge-manage,knowledge-add,knowledge-edit,album-manage,album-upload,album-edit,resume-manage,resume-add,resume-edit,notice-manage,notice-add,notice-edit');

-- ----------------------------
-- Table structure for pms_positions
-- ----------------------------
DROP TABLE IF EXISTS `pms_positions`;
CREATE TABLE `pms_positions` (
  `positionid` bigint(20) NOT NULL COMMENT '部门ID',
  `name` varchar(30) DEFAULT NULL COMMENT '名称',
  `desc` varchar(255) DEFAULT NULL COMMENT '描述',
  `status` tinyint(1) DEFAULT '1' COMMENT '1正常2屏蔽',
  PRIMARY KEY (`positionid`),
  KEY `INDEX_NS` (`name`,`status`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COMMENT='部门表';

-- ----------------------------
-- Records of pms_positions
-- ----------------------------
INSERT INTO `pms_positions` VALUES ('1462292006260420932', '总经理', '管理公司日常事务', '1');
INSERT INTO `pms_positions` VALUES ('1462292041515367932', '部门经理', '负责部门事务', '1');
INSERT INTO `pms_positions` VALUES ('1462292053049130632', '主管', '小组主管', '1');
INSERT INTO `pms_positions` VALUES ('1462292065226423828', '组长', '小组领队', '1');
INSERT INTO `pms_positions` VALUES ('1462292078258175728', '员工', '公司员工', '1');

-- ----------------------------
-- Table structure for pms_projects
-- ----------------------------
DROP TABLE IF EXISTS `pms_projects`;
CREATE TABLE `pms_projects` (
  `projectid` bigint(20) NOT NULL,
  `userid` bigint(20) DEFAULT NULL COMMENT '创建人',
  `name` varchar(100) DEFAULT NULL COMMENT '项目名称',
  `aliasname` varchar(100) DEFAULT NULL COMMENT '项目别名代号',
  `started` int(10) DEFAULT NULL COMMENT '开始时间',
  `ended` int(10) DEFAULT NULL COMMENT '结束时间',
  `desc` text COMMENT '描述',
  `created` int(10) DEFAULT NULL COMMENT '添加日期',
  `status` tinyint(1) DEFAULT '1' COMMENT '1挂起中,2延期中,3进行中,4结束',
  `projuserid` bigint(20) DEFAULT NULL COMMENT '项目负责人',
  `produserid` bigint(20) DEFAULT NULL COMMENT '产品负责人',
  `testuserid` bigint(20) DEFAULT NULL COMMENT '测试负责人',
  `publuserid` bigint(20) DEFAULT NULL COMMENT '发布负责人',
  PRIMARY KEY (`projectid`),
  KEY `INDEX_UNCS` (`userid`,`name`,`created`,`status`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COMMENT='项目表';

-- ----------------------------
-- Records of pms_projects
-- ----------------------------

-- ----------------------------
-- Table structure for pms_projects_needs
-- ----------------------------
DROP TABLE IF EXISTS `pms_projects_needs`;
CREATE TABLE `pms_projects_needs` (
  `needsid` bigint(20) NOT NULL,
  `projectid` bigint(20) DEFAULT NULL COMMENT '项目ID',
  `userid` bigint(20) DEFAULT NULL COMMENT '创建人',
  `name` varchar(100) DEFAULT NULL COMMENT '需求名称',
  `desc` text COMMENT '描述',
  `acceptid` bigint(20) DEFAULT NULL COMMENT '指派人userid',
  `source` tinyint(2) DEFAULT '0' COMMENT '来源1客户,2用户,3产品经理,4市场,5客服,6竞争对手,7合作伙伴,8开发人员,9测试人员,10其他',
  `acceptance` text COMMENT '验收标准',
  `level` tinyint(1) DEFAULT NULL COMMENT '优先级1,2,3,4,5,6',
  `tasktime` tinyint(4) DEFAULT NULL COMMENT '预计工时',
  `attachment` varchar(255) DEFAULT NULL COMMENT '附件',
  `created` int(10) DEFAULT NULL,
  `changed` int(10) DEFAULT NULL,
  `stage` tinyint(1) unsigned DEFAULT '1' COMMENT '1未开始,2已计划,3已立项,4研发中,5研发完毕,6测试中,7测试完毕,8已验收,9已发布',
  `status` tinyint(1) DEFAULT '1' COMMENT '1草稿，2激活，3已变更，4待关闭，5已关闭',
  PRIMARY KEY (`needsid`),
  KEY `INDEX_PUNC` (`projectid`,`userid`,`name`,`created`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COMMENT='项目需求表';

-- ----------------------------
-- Records of pms_projects_needs
-- ----------------------------

-- ----------------------------
-- Table structure for pms_projects_task
-- ----------------------------
DROP TABLE IF EXISTS `pms_projects_task`;
CREATE TABLE `pms_projects_task` (
  `taskid` bigint(20) NOT NULL,
  `needsid` bigint(20) DEFAULT NULL,
  `userid` bigint(20) DEFAULT NULL COMMENT '创建人',
  `projectid` bigint(20) DEFAULT NULL COMMENT '项目ID',
  `acceptid` bigint(20) DEFAULT NULL COMMENT '任务接受人ID',
  `ccid` varchar(100) DEFAULT NULL COMMENT '抄送给',
  `completeid` bigint(20) DEFAULT NULL COMMENT '完成者id',
  `name` varchar(100) DEFAULT NULL COMMENT '任务名称',
  `desc` text COMMENT '描述',
  `note` text COMMENT '备注',
  `type` tinyint(1) DEFAULT '8' COMMENT '任务类型1设计,2开发,3测试,4研究,5讨论,6界面,7事务,8其他',
  `level` tinyint(1) DEFAULT NULL COMMENT '优先级1,2,3,4,5,6',
  `tasktime` tinyint(4) DEFAULT NULL COMMENT '预计工时',
  `ended` int(10) DEFAULT NULL COMMENT '截止日期',
  `started` int(10) DEFAULT NULL COMMENT '预计开始时间',
  `attachment` varchar(255) DEFAULT NULL COMMENT '附件',
  `created` int(10) DEFAULT NULL,
  `changed` int(10) DEFAULT NULL,
  `status` tinyint(1) DEFAULT '1' COMMENT '1未开始,2进行中,3已完成,4已暂停,5已取消,6已关闭',
  `closeid` bigint(20) DEFAULT NULL COMMENT '关闭者ID',
  `cancelid` bigint(20) DEFAULT NULL COMMENT '取消者ID',
  PRIMARY KEY (`taskid`),
  KEY `INDEX_NSPACS` (`needsid`,`userid`,`projectid`,`acceptid`,`created`,`status`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COMMENT='项目需求任务表';

-- ----------------------------
-- Records of pms_projects_task
-- ----------------------------

-- ----------------------------
-- Table structure for pms_projects_task_log
-- ----------------------------
DROP TABLE IF EXISTS `pms_projects_task_log`;
CREATE TABLE `pms_projects_task_log` (
  `id` bigint(20) DEFAULT NULL,
  `taskid` bigint(20) DEFAULT NULL,
  `userid` bigint(20) DEFAULT NULL COMMENT '操作人',
  `note` text,
  `created` int(10) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of pms_projects_task_log
-- ----------------------------

-- ----------------------------
-- Table structure for pms_projects_team
-- ----------------------------
DROP TABLE IF EXISTS `pms_projects_team`;
CREATE TABLE `pms_projects_team` (
  `id` bigint(20) NOT NULL,
  `projectid` bigint(20) DEFAULT NULL COMMENT '项目ID',
  `userid` bigint(20) DEFAULT NULL COMMENT '成员ID',
  `created` int(10) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `INDEX_PU` (`projectid`,`userid`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COMMENT='项目成员表';

-- ----------------------------
-- Records of pms_projects_team
-- ----------------------------

-- ----------------------------
-- Table structure for pms_projects_test
-- ----------------------------
DROP TABLE IF EXISTS `pms_projects_test`;
CREATE TABLE `pms_projects_test` (
  `testid` bigint(20) NOT NULL,
  `taskid` bigint(20) DEFAULT NULL,
  `needsid` bigint(20) DEFAULT NULL,
  `userid` bigint(20) DEFAULT NULL COMMENT '创建人',
  `projectid` bigint(20) DEFAULT NULL COMMENT '项目ID',
  `acceptid` bigint(20) DEFAULT NULL COMMENT '任务接受人ID',
  `completeid` bigint(20) DEFAULT NULL COMMENT '完成者uid',
  `ccid` varchar(100) DEFAULT NULL COMMENT '抄送者',
  `name` varchar(100) DEFAULT NULL COMMENT 'bug名称',
  `desc` text COMMENT '描述',
  `level` tinyint(1) DEFAULT NULL COMMENT '优先级1,2,3,4,5,6',
  `os` varchar(20) DEFAULT NULL COMMENT '操作系统',
  `browser` varchar(20) DEFAULT NULL COMMENT '浏览器',
  `attachment` varchar(255) DEFAULT NULL COMMENT '附件',
  `completed` int(10) DEFAULT NULL COMMENT '解决日期',
  `created` int(10) NOT NULL,
  `changed` int(10) DEFAULT NULL,
  `status` tinyint(1) DEFAULT '0' COMMENT '解决方案:1设计如此,2重复Bug,3外部原因,4已解决,5无法重现,6延期处理,7不予解决',
  PRIMARY KEY (`testid`),
  KEY `INDEX_TNUPAC` (`taskid`,`needsid`,`userid`,`projectid`,`acceptid`,`created`,`status`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COMMENT='项目任务bug表';

-- ----------------------------
-- Records of pms_projects_test
-- ----------------------------

-- ----------------------------
-- Table structure for pms_projects_test_log
-- ----------------------------
DROP TABLE IF EXISTS `pms_projects_test_log`;
CREATE TABLE `pms_projects_test_log` (
  `id` bigint(20) DEFAULT NULL,
  `testid` bigint(20) DEFAULT NULL,
  `userid` bigint(20) DEFAULT NULL COMMENT '操作人',
  `note` text,
  `created` int(10) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of pms_projects_test_log
-- ----------------------------

-- ----------------------------
-- Table structure for pms_resumes
-- ----------------------------
DROP TABLE IF EXISTS `pms_resumes`;
CREATE TABLE `pms_resumes` (
  `resumeid` bigint(20) unsigned NOT NULL,
  `realname` varchar(20) DEFAULT NULL,
  `sex` tinyint(1) DEFAULT NULL,
  `birth` int(10) DEFAULT NULL,
  `edu` tinyint(1) DEFAULT NULL,
  `work` tinyint(1) DEFAULT NULL,
  `attachment` varchar(255) DEFAULT NULL,
  `created` int(10) DEFAULT NULL,
  `status` tinyint(1) DEFAULT '1' COMMENT '1入档2通知面试3违约4录用5不录用',
  `note` varchar(255) DEFAULT NULL,
  `phone` varchar(11) DEFAULT NULL,
  PRIMARY KEY (`resumeid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of pms_resumes
-- ----------------------------

-- ----------------------------
-- Table structure for pms_users
-- ----------------------------
DROP TABLE IF EXISTS `pms_users`;
CREATE TABLE `pms_users` (
  `userid` bigint(20) NOT NULL,
  `profile_id` bigint(20) DEFAULT NULL,
  `username` varchar(15) DEFAULT NULL COMMENT '用户名',
  `password` varchar(255) DEFAULT NULL COMMENT '密码',
  `avatar` varchar(100) DEFAULT NULL,
  `status` tinyint(1) DEFAULT '1' COMMENT '状态1正常，2屏蔽',
  PRIMARY KEY (`userid`),
  KEY `INDEX_US` (`username`,`status`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='用户主表';

-- ----------------------------
-- Records of pms_users
-- ----------------------------
INSERT INTO `pms_users` VALUES ('1461312703628858832', '1461312703628858832', 'libai', 'e10adc3949ba59abbe56e057f20f883e', '/static/uploadfile/2016-8/17/b6f932aecb3f012e9a37021aeea0e61b-cropper.jpg', '1');

-- ----------------------------
-- Table structure for pms_users_profile
-- ----------------------------
DROP TABLE IF EXISTS `pms_users_profile`;
CREATE TABLE `pms_users_profile` (
  `userid` bigint(20) NOT NULL,
  `realname` varchar(15) DEFAULT NULL COMMENT '姓名',
  `sex` tinyint(1) DEFAULT '1' COMMENT '1男2女',
  `birth` varchar(15) DEFAULT NULL,
  `email` varchar(30) DEFAULT NULL COMMENT '邮箱',
  `webchat` varchar(15) DEFAULT NULL COMMENT '微信号',
  `qq` varchar(15) DEFAULT NULL COMMENT 'qq号',
  `phone` varchar(15) DEFAULT NULL COMMENT '手机',
  `tel` varchar(20) DEFAULT NULL COMMENT '电话',
  `address` varchar(100) DEFAULT NULL COMMENT '地址',
  `emercontact` varchar(15) DEFAULT NULL COMMENT '紧急联系人',
  `emerphone` varchar(15) DEFAULT NULL COMMENT '紧急电话',
  `departid` bigint(20) DEFAULT NULL COMMENT '部门ID',
  `positionid` bigint(20) DEFAULT NULL COMMENT '职位id',
  `lognum` int(10) DEFAULT '0' COMMENT '登录次数',
  `ip` varchar(15) DEFAULT NULL COMMENT '最近登录IP',
  `lasted` int(10) DEFAULT NULL COMMENT '最近登录时间',
  PRIMARY KEY (`userid`),
  KEY `INDEX_RSL` (`realname`,`sex`,`lasted`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='用户详情表';

-- ----------------------------
-- Records of pms_users_profile
-- ----------------------------
INSERT INTO `pms_users_profile` VALUES ('1461312703628858832', '李白', '1', '1985-12-12', 'test@163.com', 'milu365', '49732343', '13754396432', '021-3432423', '九新公路华西办公楼7楼', 'zfancy', '137245613126', '1462290228639093428', '1462292006260420932', '0', '', '0');
