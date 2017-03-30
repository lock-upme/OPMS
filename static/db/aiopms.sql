/*
Navicat MySQL Data Transfer

Source Server         : localhost
Source Server Version : 50505
Source Host           : localhost:3306
Source Database       : aiopms

Target Server Type    : MYSQL
Target Server Version : 50505
File Encoding         : 65001

Date: 2017-03-28 17:23:47
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
INSERT INTO `pms_albums` VALUES ('66621261991645184', '1461312703628858832', '海边漫步', '/static/uploadfile/2017-3/28/f739b6c6351a82a4953d8d8b44cd426d.jpg', '', '我想知道相片背后的故事', '1490686634', '1', '0', '0', '1');
INSERT INTO `pms_albums` VALUES ('66621261995839488', '1461312703628858832', '那一处', '/static/uploadfile/2017-3/28/eac2a34d2cd6f3d0df1b233a0f589bce.jpg', '', '我想知道相片背后的故事', '1490686634', '2', '0', '0', '1');
INSERT INTO `pms_albums` VALUES ('66621262004228096', '1461312703628858832', '那个镇', '/static/uploadfile/2017-3/28/6b4b9957ffbd6ec1c8515025fba39818.jpg', '', '我想知道相片背后的故事', '1490686634', '1', '0', '0', '1');
INSERT INTO `pms_albums` VALUES ('66621262008422400', '1461312703628858832', '满上遍野', '/static/uploadfile/2017-3/28/48b77d930cb7a02824874ed9c6be434c.jpg', '', '我想知道相片背后的故事', '1490686634', '2', '0', '0', '1');
INSERT INTO `pms_albums` VALUES ('66621262012616704', '1461312703628858832', '油菜花', '/static/uploadfile/2017-3/28/73434f8343c3780b5e8af114e8825b9c.jpg', '', '我想知道相片背后的故事', '1490686634', '3', '1', '0', '1');

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
INSERT INTO `pms_albums_comment` VALUES ('66639445419364352', '1461312703628858832', '66621262012616704', 'LIFE BT', '1490690969', '1');

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
-- Table structure for pms_businesstrips
-- ----------------------------
DROP TABLE IF EXISTS `pms_businesstrips`;
CREATE TABLE `pms_businesstrips` (
  `businesstripid` bigint(20) NOT NULL,
  `userid` bigint(20) DEFAULT NULL,
  `destinations` varchar(50) NOT NULL COMMENT '目的地',
  `starteds` varchar(200) DEFAULT NULL COMMENT '开始日期',
  `endeds` varchar(200) DEFAULT NULL COMMENT '结束日期',
  `days` tinyint(4) DEFAULT NULL COMMENT '天数',
  `reason` varchar(500) DEFAULT NULL COMMENT '出差事由',
  `picture` varchar(100) DEFAULT NULL COMMENT '1同',
  `result` tinyint(1) DEFAULT NULL COMMENT '1同意2拒绝',
  `status` tinyint(1) DEFAULT '1' COMMENT '1草稿2正常发布',
  `approverids` varchar(200) DEFAULT NULL COMMENT '审批人串',
  `created` int(10) DEFAULT NULL,
  `changed` int(10) DEFAULT NULL,
  PRIMARY KEY (`businesstripid`),
  KEY `INDEX_URSC` (`userid`,`result`,`status`,`created`,`changed`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='出差表';

-- ----------------------------
-- Records of pms_businesstrips
-- ----------------------------

-- ----------------------------
-- Table structure for pms_businesstrips_approver
-- ----------------------------
DROP TABLE IF EXISTS `pms_businesstrips_approver`;
CREATE TABLE `pms_businesstrips_approver` (
  `approverid` bigint(20) NOT NULL,
  `businesstripid` bigint(20) DEFAULT NULL COMMENT '出差表ID',
  `userid` bigint(20) DEFAULT NULL COMMENT '审批人Userid',
  `summary` varchar(500) DEFAULT NULL COMMENT '说明',
  `status` tinyint(1) DEFAULT NULL COMMENT '1同意2拒绝',
  `created` int(10) DEFAULT NULL,
  `changed` int(10) DEFAULT NULL,
  PRIMARY KEY (`approverid`),
  KEY `INDEX_LUSC` (`businesstripid`,`userid`,`status`,`created`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='出差审批人表';

-- ----------------------------
-- Records of pms_businesstrips_approver
-- ----------------------------

-- ----------------------------
-- Table structure for pms_checkworks
-- ----------------------------
DROP TABLE IF EXISTS `pms_checkworks`;
CREATE TABLE `pms_checkworks` (
  `checkid` bigint(20) NOT NULL,
  `userid` bigint(20) DEFAULT NULL,
  `clock` varchar(8) DEFAULT NULL COMMENT '打卡时间',
  `type` tinyint(1) DEFAULT NULL COMMENT '1正常2迟到3早退4加班',
  `ip` varchar(20) DEFAULT NULL,
  `created` int(10) DEFAULT NULL COMMENT '时间',
  PRIMARY KEY (`checkid`),
  KEY `INDEX_UTC` (`userid`,`type`,`created`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='考勤打卡表';

-- ----------------------------
-- Records of pms_checkworks
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
-- Table structure for pms_expenses
-- ----------------------------
DROP TABLE IF EXISTS `pms_expenses`;
CREATE TABLE `pms_expenses` (
  `expenseid` bigint(20) NOT NULL,
  `userid` bigint(20) DEFAULT NULL,
  `amounts` varchar(8) NOT NULL COMMENT '报销金额json',
  `types` varchar(200) DEFAULT NULL COMMENT '明细类型json',
  `contents` varchar(1000) DEFAULT NULL COMMENT '明细json',
  `total` varchar(8) DEFAULT NULL COMMENT '总金额',
  `picture` varchar(100) DEFAULT NULL COMMENT '1同',
  `result` tinyint(1) DEFAULT NULL COMMENT '1同意2拒绝',
  `status` tinyint(1) DEFAULT '1' COMMENT '1草稿2正常发布',
  `approverids` varchar(200) DEFAULT NULL COMMENT '审批人串',
  `created` int(10) DEFAULT NULL,
  `changed` int(10) DEFAULT NULL,
  PRIMARY KEY (`expenseid`),
  KEY `INDEX_UTRSC` (`userid`,`types`,`result`,`status`,`created`,`changed`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='报销表';

-- ----------------------------
-- Records of pms_expenses
-- ----------------------------

-- ----------------------------
-- Table structure for pms_expenses_approver
-- ----------------------------
DROP TABLE IF EXISTS `pms_expenses_approver`;
CREATE TABLE `pms_expenses_approver` (
  `approverid` bigint(20) NOT NULL,
  `expenseid` bigint(20) DEFAULT NULL COMMENT '报销表ID',
  `userid` bigint(20) DEFAULT NULL COMMENT '审批人Userid',
  `summary` varchar(500) DEFAULT NULL COMMENT '说明',
  `status` tinyint(1) DEFAULT NULL COMMENT '1同意2拒绝',
  `created` int(10) DEFAULT NULL,
  `changed` int(10) DEFAULT NULL,
  PRIMARY KEY (`approverid`),
  KEY `INDEX_LUSC` (`expenseid`,`userid`,`status`,`created`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='报销审批人表';

-- ----------------------------
-- Records of pms_expenses_approver
-- ----------------------------

-- ----------------------------
-- Table structure for pms_goouts
-- ----------------------------
DROP TABLE IF EXISTS `pms_goouts`;
CREATE TABLE `pms_goouts` (
  `gooutid` bigint(20) NOT NULL,
  `userid` bigint(20) DEFAULT NULL COMMENT '请假人',
  `started` int(10) DEFAULT NULL COMMENT '开始时间',
  `ended` int(10) DEFAULT NULL COMMENT '结束时间',
  `hours` float DEFAULT NULL COMMENT '外出小时数',
  `reason` varchar(500) DEFAULT NULL COMMENT '原因',
  `picture` varchar(100) DEFAULT NULL COMMENT '图片',
  `result` tinyint(1) DEFAULT NULL COMMENT '1同意2拒绝',
  `status` tinyint(1) DEFAULT '1' COMMENT '1草稿2正常发布',
  `approverids` varchar(200) DEFAULT NULL COMMENT '审批人串',
  `created` int(10) DEFAULT NULL,
  `changed` int(10) DEFAULT NULL,
  PRIMARY KEY (`gooutid`),
  KEY `INDEX_UTC` (`userid`,`created`,`changed`,`result`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='外出表';

-- ----------------------------
-- Records of pms_goouts
-- ----------------------------

-- ----------------------------
-- Table structure for pms_goouts_approver
-- ----------------------------
DROP TABLE IF EXISTS `pms_goouts_approver`;
CREATE TABLE `pms_goouts_approver` (
  `approverid` bigint(20) NOT NULL,
  `gooutid` bigint(20) DEFAULT NULL COMMENT '请假表ID',
  `userid` bigint(20) DEFAULT NULL COMMENT '审批人Userid',
  `summary` varchar(500) DEFAULT NULL COMMENT '说明',
  `status` tinyint(1) DEFAULT NULL COMMENT '1同意2拒绝',
  `created` int(10) DEFAULT NULL,
  `changed` int(10) DEFAULT NULL,
  PRIMARY KEY (`approverid`),
  KEY `INDEX_LUSC` (`gooutid`,`userid`,`status`,`created`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='外出审批人表';

-- ----------------------------
-- Records of pms_goouts_approver
-- ----------------------------

-- ----------------------------
-- Table structure for pms_groups
-- ----------------------------
DROP TABLE IF EXISTS `pms_groups`;
CREATE TABLE `pms_groups` (
  `groupid` bigint(20) NOT NULL,
  `name` varchar(30) DEFAULT NULL COMMENT '组名称',
  `summary` varchar(500) DEFAULT NULL COMMENT '组描述',
  `created` int(10) DEFAULT NULL,
  `changed` int(10) DEFAULT NULL,
  PRIMARY KEY (`groupid`),
  KEY `INDEX_NCC` (`name`,`created`,`changed`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='组成员表';

-- ----------------------------
-- Records of pms_groups
-- ----------------------------
INSERT INTO `pms_groups` VALUES ('37623600177483776', '测试组', '项目功能测试，白盒黑盒测试', '1483773053', '1483773321');
INSERT INTO `pms_groups` VALUES ('1468755197309162133', '其他', '普通员工', '1474866966', '1474866966');
INSERT INTO `pms_groups` VALUES ('1468755197309162134', '产品', '产品经理', '1474866966', '1474866966');
INSERT INTO `pms_groups` VALUES ('1468755197309162135', '研发', '技术人员', '1474866966', '1474866966');
INSERT INTO `pms_groups` VALUES ('1468755197309162136', '高层管理', '公司高层', '1474866966', '1474866966');
INSERT INTO `pms_groups` VALUES ('1468755197309162137', '管理员', '系统管理员', '1474866966', '1474866966');

-- ----------------------------
-- Table structure for pms_groups_permission
-- ----------------------------
DROP TABLE IF EXISTS `pms_groups_permission`;
CREATE TABLE `pms_groups_permission` (
  `id` bigint(20) NOT NULL,
  `groupid` bigint(20) DEFAULT NULL,
  `permissionid` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `INDEX_GP` (`groupid`,`permissionid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='组权限表';

-- ----------------------------
-- Records of pms_groups_permission
-- ----------------------------
INSERT INTO `pms_groups_permission` VALUES ('64082362622808064', '1468755197309162133', '41980651519348736');
INSERT INTO `pms_groups_permission` VALUES ('64082362723471360', '1468755197309162133', '41980770788577280');
INSERT INTO `pms_groups_permission` VALUES ('64082362874466304', '1468755197309162133', '42334265874059264');
INSERT INTO `pms_groups_permission` VALUES ('64082362975129600', '1468755197309162133', '42334379363536896');
INSERT INTO `pms_groups_permission` VALUES ('64082363075792896', '1468755197309162133', '42334463782293504');
INSERT INTO `pms_groups_permission` VALUES ('64082363176456192', '1468755197309162133', '42334539376234496');
INSERT INTO `pms_groups_permission` VALUES ('64082363277119488', '1468755197309162133', '42334628953985024');
INSERT INTO `pms_groups_permission` VALUES ('64082363428114432', '1468755197309162133', '42334838946009088');
INSERT INTO `pms_groups_permission` VALUES ('64082363528777728', '1468755197309162133', '42334976082972672');
INSERT INTO `pms_groups_permission` VALUES ('64082363629441024', '1468755197309162133', '42335081259339776');
INSERT INTO `pms_groups_permission` VALUES ('64082363730104320', '1468755197309162133', '42335209235943424');
INSERT INTO `pms_groups_permission` VALUES ('64082363830767616', '1468755197309162133', '42335311539212288');
INSERT INTO `pms_groups_permission` VALUES ('64082363931430912', '1468755197309162133', '42335402681438208');
INSERT INTO `pms_groups_permission` VALUES ('64082364082425856', '1468755197309162133', '42335721133969408');
INSERT INTO `pms_groups_permission` VALUES ('64082364183089152', '1468755197309162133', '42335817183531008');
INSERT INTO `pms_groups_permission` VALUES ('64082364350861312', '1468755197309162133', '42335940605120512');
INSERT INTO `pms_groups_permission` VALUES ('64082364535410688', '1468755197309162133', '42336024805773312');
INSERT INTO `pms_groups_permission` VALUES ('64082364988395520', '1468755197309162133', '42336123501940736');
INSERT INTO `pms_groups_permission` VALUES ('64082365089058816', '1468755197309162133', '42336206301696000');
INSERT INTO `pms_groups_permission` VALUES ('64082365189722112', '1468755197309162133', '42336271770587136');
INSERT INTO `pms_groups_permission` VALUES ('64082365340717056', '1468755197309162133', '42336347972702208');
INSERT INTO `pms_groups_permission` VALUES ('64082365441380352', '1468755197309162133', '42336433490366464');
INSERT INTO `pms_groups_permission` VALUES ('64082365542043648', '1468755197309162133', '42336599123431424');
INSERT INTO `pms_groups_permission` VALUES ('64082365642706944', '1468755197309162133', '42336697060429824');
INSERT INTO `pms_groups_permission` VALUES ('64082365743370240', '1468755197309162133', '42336773992353792');
INSERT INTO `pms_groups_permission` VALUES ('64082365844033536', '1468755197309162133', '42336853726072832');
INSERT INTO `pms_groups_permission` VALUES ('64082365995028480', '1468755197309162133', '42336946441162752');
INSERT INTO `pms_groups_permission` VALUES ('64082366095691776', '1468755197309162133', '42337029878452224');
INSERT INTO `pms_groups_permission` VALUES ('64082366196355072', '1468755197309162133', '42337132236247040');
INSERT INTO `pms_groups_permission` VALUES ('64082366297018368', '1468755197309162133', '42337204650905600');
INSERT INTO `pms_groups_permission` VALUES ('64082366397681664', '1468755197309162133', '42337301711294464');
INSERT INTO `pms_groups_permission` VALUES ('64082366481567744', '1468755197309162133', '42337378299285504');
INSERT INTO `pms_groups_permission` VALUES ('64082366599008256', '1468755197309162133', '42337629286436864');
INSERT INTO `pms_groups_permission` VALUES ('64082366699671552', '1468755197309162133', '42337745028255744');
INSERT INTO `pms_groups_permission` VALUES ('64082366800334848', '1468755197309162133', '42337817904287744');
INSERT INTO `pms_groups_permission` VALUES ('64082366900998144', '1468755197309162133', '42338384647032832');
INSERT INTO `pms_groups_permission` VALUES ('64082367051993088', '1468755197309162133', '42338452590563328');
INSERT INTO `pms_groups_permission` VALUES ('64082367202988032', '1468755197309162133', '42338538640904192');
INSERT INTO `pms_groups_permission` VALUES ('64082367303651328', '1468755197309162133', '42338630085120000');
INSERT INTO `pms_groups_permission` VALUES ('64082367404314624', '1468755197309162133', '42338743775924224');
INSERT INTO `pms_groups_permission` VALUES ('64082367504977920', '1468755197309162133', '42356198170693632');
INSERT INTO `pms_groups_permission` VALUES ('64082367605641216', '1468755197309162133', '42356266030338048');
INSERT INTO `pms_groups_permission` VALUES ('64082362492784640', '1468755197309162133', '61562786651574272');
INSERT INTO `pms_groups_permission` VALUES ('65091376714354688', '1468755197309162135', '42354812125188096');
INSERT INTO `pms_groups_permission` VALUES ('65091376945041408', '1468755197309162135', '42354905771413504');
INSERT INTO `pms_groups_permission` VALUES ('65091377121202176', '1468755197309162135', '42354988550197248');
INSERT INTO `pms_groups_permission` VALUES ('65091377196699648', '1468755197309162135', '42355171505737728');
INSERT INTO `pms_groups_permission` VALUES ('65091377272197120', '1468755197309162135', '42355325336031232');
INSERT INTO `pms_groups_permission` VALUES ('65091377725181952', '1468755197309162135', '42355402511224832');
INSERT INTO `pms_groups_permission` VALUES ('65091377800679424', '1468755197309162135', '42355510552301568');
INSERT INTO `pms_groups_permission` VALUES ('65091377876176896', '1468755197309162135', '42355596724277248');
INSERT INTO `pms_groups_permission` VALUES ('65091377976840192', '1468755197309162135', '42355693625282560');
INSERT INTO `pms_groups_permission` VALUES ('65091378052337664', '1468755197309162135', '42355773019262976');
INSERT INTO `pms_groups_permission` VALUES ('65091378127835136', '1468755197309162135', '42355862622179328');
INSERT INTO `pms_groups_permission` VALUES ('65091378203332608', '1468755197309162135', '42355935212998656');
INSERT INTO `pms_groups_permission` VALUES ('65091378278830080', '1468755197309162135', '42356020873269248');
INSERT INTO `pms_groups_permission` VALUES ('65091378375299072', '1468755197309162135', '42356198170693632');
INSERT INTO `pms_groups_permission` VALUES ('65091378454990848', '1468755197309162135', '42356266030338048');
INSERT INTO `pms_groups_permission` VALUES ('65091378580819968', '1468755197309162135', '64059892574457856');
INSERT INTO `pms_groups_permission` VALUES ('65091378656317440', '1468755197309162135', '64059999378214912');
INSERT INTO `pms_groups_permission` VALUES ('65091378731814912', '1468755197309162135', '64060145163833344');
INSERT INTO `pms_groups_permission` VALUES ('65091378807312384', '1468755197309162135', '64060216546693120');
INSERT INTO `pms_groups_permission` VALUES ('65091378928947200', '1468755197309162135', '64060546483228672');
INSERT INTO `pms_groups_permission` VALUES ('65091379008638976', '1468755197309162135', '64060742327865344');
INSERT INTO `pms_groups_permission` VALUES ('65091379084136448', '1468755197309162135', '64060871856361472');
INSERT INTO `pms_groups_permission` VALUES ('65091379159633920', '1468755197309162135', '64060949748781056');
INSERT INTO `pms_groups_permission` VALUES ('65091379235131392', '1468755197309162135', '64061137204809728');
INSERT INTO `pms_groups_permission` VALUES ('65091379310628864', '1468755197309162135', '64061220927311872');
INSERT INTO `pms_groups_permission` VALUES ('65091379432263680', '1468755197309162135', '64061290498232320');
INSERT INTO `pms_groups_permission` VALUES ('65091379511955456', '1468755197309162135', '64061357862948864');
INSERT INTO `pms_groups_permission` VALUES ('65091061193641984', '1468755197309162136', '41969113630773248');
INSERT INTO `pms_groups_permission` VALUES ('65091061344636928', '1468755197309162136', '41969192357859328');
INSERT INTO `pms_groups_permission` VALUES ('65091061420134400', '1468755197309162136', '41969252499984384');
INSERT INTO `pms_groups_permission` VALUES ('65091061520797696', '1468755197309162136', '41976726762295296');
INSERT INTO `pms_groups_permission` VALUES ('65091061596295168', '1468755197309162136', '41976831846387712');
INSERT INTO `pms_groups_permission` VALUES ('65091061696958464', '1468755197309162136', '41976904223297536');
INSERT INTO `pms_groups_permission` VALUES ('65091061772455936', '1468755197309162136', '41977259501817856');
INSERT INTO `pms_groups_permission` VALUES ('65091061847953408', '1468755197309162136', '41977400967303168');
INSERT INTO `pms_groups_permission` VALUES ('65091061923450880', '1468755197309162136', '41977528792911872');
INSERT INTO `pms_groups_permission` VALUES ('65091061998948352', '1468755197309162136', '41977654831747072');
INSERT INTO `pms_groups_permission` VALUES ('65091062074445824', '1468755197309162136', '41977734154424320');
INSERT INTO `pms_groups_permission` VALUES ('65091062149943296', '1468755197309162136', '41977922247987200');
INSERT INTO `pms_groups_permission` VALUES ('65091062225440768', '1468755197309162136', '41978045921234944');
INSERT INTO `pms_groups_permission` VALUES ('65091062351269888', '1468755197309162136', '41978134387494912');
INSERT INTO `pms_groups_permission` VALUES ('65091062426767360', '1468755197309162136', '41978216994312192');
INSERT INTO `pms_groups_permission` VALUES ('65091062502264832', '1468755197309162136', '41978289807429632');
INSERT INTO `pms_groups_permission` VALUES ('65091062602928128', '1468755197309162136', '41978468690300928');
INSERT INTO `pms_groups_permission` VALUES ('65091062678425600', '1468755197309162136', '41978566618910720');
INSERT INTO `pms_groups_permission` VALUES ('65091062753923072', '1468755197309162136', '41978664295862272');
INSERT INTO `pms_groups_permission` VALUES ('65091062829420544', '1468755197309162136', '41978754309820416');
INSERT INTO `pms_groups_permission` VALUES ('65091062904918016', '1468755197309162136', '41978832399372288');
INSERT INTO `pms_groups_permission` VALUES ('65091062980415488', '1468755197309162136', '41980651519348736');
INSERT INTO `pms_groups_permission` VALUES ('65091063097856000', '1468755197309162136', '41980770788577280');
INSERT INTO `pms_groups_permission` VALUES ('65091063181742080', '1468755197309162136', '42337629286436864');
INSERT INTO `pms_groups_permission` VALUES ('65091063257239552', '1468755197309162136', '42337745028255744');
INSERT INTO `pms_groups_permission` VALUES ('65091063332737024', '1468755197309162136', '42337817904287744');
INSERT INTO `pms_groups_permission` VALUES ('65091063408234496', '1468755197309162136', '42338384647032832');
INSERT INTO `pms_groups_permission` VALUES ('65091063483731968', '1468755197309162136', '42338452590563328');
INSERT INTO `pms_groups_permission` VALUES ('65091063601172480', '1468755197309162136', '42338538640904192');
INSERT INTO `pms_groups_permission` VALUES ('65091063685058560', '1468755197309162136', '42338630085120000');
INSERT INTO `pms_groups_permission` VALUES ('65091063760556032', '1468755197309162136', '42338743775924224');
INSERT INTO `pms_groups_permission` VALUES ('65091060962955264', '1468755197309162136', '61562786651574272');
INSERT INTO `pms_groups_permission` VALUES ('65141224696188928', '1468755197309162137', '41969113630773248');
INSERT INTO `pms_groups_permission` VALUES ('65141224826212352', '1468755197309162137', '41969192357859328');
INSERT INTO `pms_groups_permission` VALUES ('65141224897515520', '1468755197309162137', '41969252499984384');
INSERT INTO `pms_groups_permission` VALUES ('65141224977207296', '1468755197309162137', '41976726762295296');
INSERT INTO `pms_groups_permission` VALUES ('65141225048510464', '1468755197309162137', '41976831846387712');
INSERT INTO `pms_groups_permission` VALUES ('65141225128202240', '1468755197309162137', '41976904223297536');
INSERT INTO `pms_groups_permission` VALUES ('65141225199505408', '1468755197309162137', '41977259501817856');
INSERT INTO `pms_groups_permission` VALUES ('65141225400832000', '1468755197309162137', '41977400967303168');
INSERT INTO `pms_groups_permission` VALUES ('65141225480523776', '1468755197309162137', '41977528792911872');
INSERT INTO `pms_groups_permission` VALUES ('65141225551826944', '1468755197309162137', '41977654831747072');
INSERT INTO `pms_groups_permission` VALUES ('65141225652490240', '1468755197309162137', '41977734154424320');
INSERT INTO `pms_groups_permission` VALUES ('65141225732182016', '1468755197309162137', '41977922247987200');
INSERT INTO `pms_groups_permission` VALUES ('65141225803485184', '1468755197309162137', '41978045921234944');
INSERT INTO `pms_groups_permission` VALUES ('65141225883176960', '1468755197309162137', '41978134387494912');
INSERT INTO `pms_groups_permission` VALUES ('65141225954480128', '1468755197309162137', '41978216994312192');
INSERT INTO `pms_groups_permission` VALUES ('65141226034171904', '1468755197309162137', '41978289807429632');
INSERT INTO `pms_groups_permission` VALUES ('65141226105475072', '1468755197309162137', '41978468690300928');
INSERT INTO `pms_groups_permission` VALUES ('65141226185166848', '1468755197309162137', '41978566618910720');
INSERT INTO `pms_groups_permission` VALUES ('65141226407464960', '1468755197309162137', '41978664295862272');
INSERT INTO `pms_groups_permission` VALUES ('65141226508128256', '1468755197309162137', '41978754309820416');
INSERT INTO `pms_groups_permission` VALUES ('65141226587820032', '1468755197309162137', '41978832399372288');
INSERT INTO `pms_groups_permission` VALUES ('65141227745447936', '1468755197309162137', '41980651519348736');
INSERT INTO `pms_groups_permission` VALUES ('65141227816751104', '1468755197309162137', '41980770788577280');
INSERT INTO `pms_groups_permission` VALUES ('65141227896442880', '1468755197309162137', '42334265874059264');
INSERT INTO `pms_groups_permission` VALUES ('65141227997106176', '1468755197309162137', '42334379363536896');
INSERT INTO `pms_groups_permission` VALUES ('65141228068409344', '1468755197309162137', '42334463782293504');
INSERT INTO `pms_groups_permission` VALUES ('65141228148101120', '1468755197309162137', '42334539376234496');
INSERT INTO `pms_groups_permission` VALUES ('65141228219404288', '1468755197309162137', '42334628953985024');
INSERT INTO `pms_groups_permission` VALUES ('65141228299096064', '1468755197309162137', '42334838946009088');
INSERT INTO `pms_groups_permission` VALUES ('65141228370399232', '1468755197309162137', '42334976082972672');
INSERT INTO `pms_groups_permission` VALUES ('65141228450091008', '1468755197309162137', '42335081259339776');
INSERT INTO `pms_groups_permission` VALUES ('65141228521394176', '1468755197309162137', '42335209235943424');
INSERT INTO `pms_groups_permission` VALUES ('65141228601085952', '1468755197309162137', '42335311539212288');
INSERT INTO `pms_groups_permission` VALUES ('65141228672389120', '1468755197309162137', '42335402681438208');
INSERT INTO `pms_groups_permission` VALUES ('65141228752080896', '1468755197309162137', '42335721133969408');
INSERT INTO `pms_groups_permission` VALUES ('65141228852744192', '1468755197309162137', '42335817183531008');
INSERT INTO `pms_groups_permission` VALUES ('65141228924047360', '1468755197309162137', '42335940605120512');
INSERT INTO `pms_groups_permission` VALUES ('65141229003739136', '1468755197309162137', '42336024805773312');
INSERT INTO `pms_groups_permission` VALUES ('65141229075042304', '1468755197309162137', '42336123501940736');
INSERT INTO `pms_groups_permission` VALUES ('65141229154734080', '1468755197309162137', '42336206301696000');
INSERT INTO `pms_groups_permission` VALUES ('65141229226037248', '1468755197309162137', '42336271770587136');
INSERT INTO `pms_groups_permission` VALUES ('65141229305729024', '1468755197309162137', '42336347972702208');
INSERT INTO `pms_groups_permission` VALUES ('65141229377032192', '1468755197309162137', '42336433490366464');
INSERT INTO `pms_groups_permission` VALUES ('65141229658050560', '1468755197309162137', '42336599123431424');
INSERT INTO `pms_groups_permission` VALUES ('65141229729353728', '1468755197309162137', '42336697060429824');
INSERT INTO `pms_groups_permission` VALUES ('65141229809045504', '1468755197309162137', '42336773992353792');
INSERT INTO `pms_groups_permission` VALUES ('65141229880348672', '1468755197309162137', '42336853726072832');
INSERT INTO `pms_groups_permission` VALUES ('65141229960040448', '1468755197309162137', '42336946441162752');
INSERT INTO `pms_groups_permission` VALUES ('65141230031343616', '1468755197309162137', '42337029878452224');
INSERT INTO `pms_groups_permission` VALUES ('65141230111035392', '1468755197309162137', '42337132236247040');
INSERT INTO `pms_groups_permission` VALUES ('65141230182338560', '1468755197309162137', '42337204650905600');
INSERT INTO `pms_groups_permission` VALUES ('65141230262030336', '1468755197309162137', '42337301711294464');
INSERT INTO `pms_groups_permission` VALUES ('65141230333333504', '1468755197309162137', '42337378299285504');
INSERT INTO `pms_groups_permission` VALUES ('65141230413025280', '1468755197309162137', '42337629286436864');
INSERT INTO `pms_groups_permission` VALUES ('65141230484328448', '1468755197309162137', '42337745028255744');
INSERT INTO `pms_groups_permission` VALUES ('65141230564020224', '1468755197309162137', '42337817904287744');
INSERT INTO `pms_groups_permission` VALUES ('65141230836649984', '1468755197309162137', '42338384647032832');
INSERT INTO `pms_groups_permission` VALUES ('65141230916341760', '1468755197309162137', '42338452590563328');
INSERT INTO `pms_groups_permission` VALUES ('65141230987644928', '1468755197309162137', '42338538640904192');
INSERT INTO `pms_groups_permission` VALUES ('65141231067336704', '1468755197309162137', '42338630085120000');
INSERT INTO `pms_groups_permission` VALUES ('65141231168000000', '1468755197309162137', '42338743775924224');
INSERT INTO `pms_groups_permission` VALUES ('65141231318994944', '1468755197309162137', '42338936218980352');
INSERT INTO `pms_groups_permission` VALUES ('65141231390298112', '1468755197309162137', '42339022474842112');
INSERT INTO `pms_groups_permission` VALUES ('65141231469989888', '1468755197309162137', '42339129958076416');
INSERT INTO `pms_groups_permission` VALUES ('65141231541293056', '1468755197309162137', '42339223352643584');
INSERT INTO `pms_groups_permission` VALUES ('65141231620984832', '1468755197309162137', '42354812125188096');
INSERT INTO `pms_groups_permission` VALUES ('65141231692288000', '1468755197309162137', '42354905771413504');
INSERT INTO `pms_groups_permission` VALUES ('65141231771979776', '1468755197309162137', '42354988550197248');
INSERT INTO `pms_groups_permission` VALUES ('65141231843282944', '1468755197309162137', '42355171505737728');
INSERT INTO `pms_groups_permission` VALUES ('65141231922974720', '1468755197309162137', '42355325336031232');
INSERT INTO `pms_groups_permission` VALUES ('65141231994277888', '1468755197309162137', '42355402511224832');
INSERT INTO `pms_groups_permission` VALUES ('65141232073969664', '1468755197309162137', '42355510552301568');
INSERT INTO `pms_groups_permission` VALUES ('65141232145272832', '1468755197309162137', '42355596724277248');
INSERT INTO `pms_groups_permission` VALUES ('65141232224964608', '1468755197309162137', '42355693625282560');
INSERT INTO `pms_groups_permission` VALUES ('65141232296267776', '1468755197309162137', '42355773019262976');
INSERT INTO `pms_groups_permission` VALUES ('65141232375959552', '1468755197309162137', '42355862622179328');
INSERT INTO `pms_groups_permission` VALUES ('65141232476622848', '1468755197309162137', '42355935212998656');
INSERT INTO `pms_groups_permission` VALUES ('65141232547926016', '1468755197309162137', '42356020873269248');
INSERT INTO `pms_groups_permission` VALUES ('65141232627617792', '1468755197309162137', '42356198170693632');
INSERT INTO `pms_groups_permission` VALUES ('65141232698920960', '1468755197309162137', '42356266030338048');
INSERT INTO `pms_groups_permission` VALUES ('65141224528416768', '1468755197309162137', '61562786651574272');
INSERT INTO `pms_groups_permission` VALUES ('65141232778612736', '1468755197309162137', '64059892574457856');
INSERT INTO `pms_groups_permission` VALUES ('65141232849915904', '1468755197309162137', '64059999378214912');
INSERT INTO `pms_groups_permission` VALUES ('65141232929607680', '1468755197309162137', '64060145163833344');
INSERT INTO `pms_groups_permission` VALUES ('65141233000910848', '1468755197309162137', '64060216546693120');
INSERT INTO `pms_groups_permission` VALUES ('65141233080602624', '1468755197309162137', '64060546483228672');
INSERT INTO `pms_groups_permission` VALUES ('65141233151905792', '1468755197309162137', '64060742327865344');
INSERT INTO `pms_groups_permission` VALUES ('65141233231597568', '1468755197309162137', '64060871856361472');
INSERT INTO `pms_groups_permission` VALUES ('65141233302900736', '1468755197309162137', '64060949748781056');
INSERT INTO `pms_groups_permission` VALUES ('65141233382592512', '1468755197309162137', '64061137204809728');
INSERT INTO `pms_groups_permission` VALUES ('65141233453895680', '1468755197309162137', '64061220927311872');
INSERT INTO `pms_groups_permission` VALUES ('65141233533587456', '1468755197309162137', '64061290498232320');
INSERT INTO `pms_groups_permission` VALUES ('65141233818800128', '1468755197309162137', '64061357862948864');
INSERT INTO `pms_groups_permission` VALUES ('65141230635323392', '1468755197309162137', '64738735329120256');
INSERT INTO `pms_groups_permission` VALUES ('65141226659123200', '1468755197309162137', '64739027659526144');
INSERT INTO `pms_groups_permission` VALUES ('65141226738814976', '1468755197309162137', '64739308640145408');
INSERT INTO `pms_groups_permission` VALUES ('65141226839478272', '1468755197309162137', '64739380002033664');
INSERT INTO `pms_groups_permission` VALUES ('65141226990473216', '1468755197309162137', '64739571354570752');
INSERT INTO `pms_groups_permission` VALUES ('65141227091136512', '1468755197309162137', '64739781774413824');
INSERT INTO `pms_groups_permission` VALUES ('65141227162439680', '1468755197309162137', '64739963341639680');
INSERT INTO `pms_groups_permission` VALUES ('65141227242131456', '1468755197309162137', '64740034804191232');
INSERT INTO `pms_groups_permission` VALUES ('65141227313434624', '1468755197309162137', '64740129687736320');
INSERT INTO `pms_groups_permission` VALUES ('65141227393126400', '1468755197309162137', '64740203201302528');
INSERT INTO `pms_groups_permission` VALUES ('65141227464429568', '1468755197309162137', '64740359808225280');
INSERT INTO `pms_groups_permission` VALUES ('65141227544121344', '1468755197309162137', '64809905348939776');
INSERT INTO `pms_groups_permission` VALUES ('65141227615424512', '1468755197309162137', '64815327690625024');
INSERT INTO `pms_groups_permission` VALUES ('65141230715015168', '1468755197309162137', '65140829198487552');
INSERT INTO `pms_groups_permission` VALUES ('65141231239303168', '1468755197309162137', '65140900749119488');

-- ----------------------------
-- Table structure for pms_groups_user
-- ----------------------------
DROP TABLE IF EXISTS `pms_groups_user`;
CREATE TABLE `pms_groups_user` (
  `id` bigint(20) NOT NULL,
  `groupid` bigint(20) DEFAULT NULL,
  `userid` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `INDEX_GU` (`groupid`,`userid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='组成员';

-- ----------------------------
-- Records of pms_groups_user
-- ----------------------------
INSERT INTO `pms_groups_user` VALUES ('64082500007235584', '1468755197309162133', '1468140265954907628');
INSERT INTO `pms_groups_user` VALUES ('65088655424753664', '1468755197309162135', '1467191338628906628');
INSERT INTO `pms_groups_user` VALUES ('64067989481197568', '1468755197309162136', '1467191338628906628');
INSERT INTO `pms_groups_user` VALUES ('66642626870251520', '1468755197309162137', '65140463652311040');
INSERT INTO `pms_groups_user` VALUES ('43355033198137344', '1468755197309162137', '1461312703628858832');

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
INSERT INTO `pms_knowledges` VALUES ('66618679508340736', '1461312703628858832', '8', 'OPMS 1.2 版本更新发布', 'OPMS', '主要新增消息通知及考勤管理，其他功能优化，样式优化', 'https://my.oschina.net/lockupme/blog/778857', '', '<p style=\"box-sizing:inherit;-webkit-tap-highlight-color:transparent;margin-bottom:16px;color:#3D464D;font-family:&quot;font-size:16px;white-space:normal;background-color:#F8F8F8;\">\n	主要新增消息通知及考勤管理，其他功能优化，样式优化\n</p>\n<p style=\"box-sizing:inherit;-webkit-tap-highlight-color:transparent;margin-bottom:16px;color:#3D464D;font-family:&quot;font-size:16px;white-space:normal;background-color:#F8F8F8;\">\n	1、修订用户登录后跳转<br style=\"box-sizing:inherit;-webkit-tap-highlight-color:transparent;\" />\n2、修订审批请假，天数不能输入小数问题<br style=\"box-sizing:inherit;-webkit-tap-highlight-color:transparent;\" />\n3、增加考勤管理<br style=\"box-sizing:inherit;-webkit-tap-highlight-color:transparent;\" />\n&nbsp; &nbsp;1、增加上下班考勤打卡<br style=\"box-sizing:inherit;-webkit-tap-highlight-color:transparent;\" />\n&nbsp; &nbsp;2、个人考勤列表、小计、搜索<br style=\"box-sizing:inherit;-webkit-tap-highlight-color:transparent;\" />\n&nbsp; &nbsp;3、全部员工考勤列表，小计<br style=\"box-sizing:inherit;-webkit-tap-highlight-color:transparent;\" />\n&nbsp; &nbsp;4、员工管理添加个人考勤快捷链接<br style=\"box-sizing:inherit;-webkit-tap-highlight-color:transparent;\" />\n4、增加消息通知功能<br style=\"box-sizing:inherit;-webkit-tap-highlight-color:transparent;\" />\n&nbsp; &nbsp;1、消息顶部红点显示<br style=\"box-sizing:inherit;-webkit-tap-highlight-color:transparent;\" />\n&nbsp; &nbsp;2、消息列表展示与删除<br style=\"box-sizing:inherit;-webkit-tap-highlight-color:transparent;\" />\n&nbsp; &nbsp;3、添加审批消息通知，审核通知<br style=\"box-sizing:inherit;-webkit-tap-highlight-color:transparent;\" />\n&nbsp; &nbsp;4、添加知识评论和赞通知<br style=\"box-sizing:inherit;-webkit-tap-highlight-color:transparent;\" />\n&nbsp; &nbsp;5、添加相册评论和赞通知\n</p>\n<p style=\"box-sizing:inherit;-webkit-tap-highlight-color:transparent;margin-bottom:16px;color:#3D464D;font-family:&quot;font-size:16px;white-space:normal;background-color:#F8F8F8;\">\n	5、增加公告删除功能<br style=\"box-sizing:inherit;-webkit-tap-highlight-color:transparent;\" />\n6、增加简历删除功能<br style=\"box-sizing:inherit;-webkit-tap-highlight-color:transparent;\" />\n7、优化表格抬头样式<br style=\"box-sizing:inherit;-webkit-tap-highlight-color:transparent;\" />\n8、初始化用户权限\n</p>\n<p style=\"box-sizing:inherit;-webkit-tap-highlight-color:transparent;margin-bottom:16px;color:#3D464D;font-family:&quot;font-size:16px;white-space:normal;background-color:#F8F8F8;\">\n	9、员工权限管理增加考勤设置、公告删除设置、简历删除设置<br style=\"box-sizing:inherit;-webkit-tap-highlight-color:transparent;\" />\n10、优化用户退出\n</p>', '6', '1', '0', '1', '1', '1490686018', '1490686018');
INSERT INTO `pms_knowledges` VALUES ('66635963073302528', '1461312703628858832', '4', 'OPMS 1.3 版本更新发布', '', '终于迎来了OPMS1.3版本的更新，群里的朋友一直在苦苦等待。本次改动的地方比较多，也优化了之前一些功能。在这里感谢各位OPMS使用者提供的意见反馈，希望后续提出更加宝贵的意见！', '', '', '<p>\n	<span style=\"font-size:14px;\">终于迎来了OPMS1.3版本的更新，群里的朋友一直在苦苦等待。本次改动的地方比较多，也优化了之前一些功能。在这里感谢各位OPMS使用者提供的意见反馈，希望后续提出更加宝贵的意见！</span>\n</p>\n<p>\n	<span style=\"font-size:14px;\">&nbsp;Fix如下：</span>\n</p>\n<ol>\n	<li>\n		<span style=\"font-size:14px;\">发布项目成功后，添加项目流程引导设置</span>\n	</li>\n	<li>\n		<span style=\"font-size:14px;\">调整项目管里各个栏目的样式</span>\n	</li>\n	<li>\n		<span style=\"font-size:14px;\">增加项目管理任务、bug、需求Table排序</span>\n	</li>\n	<li>\n		<span style=\"font-size:14px;\">增加我的相关任务、bug、需求Table排序</span>\n	</li>\n	<li>\n		<span style=\"font-size:14px;\">新增项目文档管理</span>\n	</li>\n	<li>\n		<span style=\"font-size:14px;\">新增项目版本管理</span>\n	</li>\n	<li>\n		<span style=\"font-size:14px;\">新增项目批量新建任务</span>\n	</li>\n	<li>\n		<span style=\"font-size:14px;\">新增项目克隆任务</span>\n	</li>\n	<li>\n		<span style=\"font-size:14px;\">新增知识分享、相册删除功能</span>\n	</li>\n	<li>\n		<span style=\"font-size:14px;\">修订审批人员选择功能</span>\n	</li>\n	<li>\n		<span style=\"font-size:14px;\">修订考勤日期搜索功能</span>\n	</li>\n	<li>\n		<span style=\"font-size:14px;\">新增组管理，完善后台权限管理，人员分配，人员可以多组</span>\n	</li>\n	<li>\n		<span style=\"font-size:14px;\">新增权限管理</span>\n	</li>\n	<li>\n		<span style=\"font-size:14px;\">调整相册样式</span>\n	</li>\n	<li>\n		<span style=\"font-size:14px;\">调整“我的主页”模块</span>\n	</li>\n	<li>\n		<span style=\"font-size:14px;\">调整项目管理中各个栏目样式图标</span>\n	</li>\n	<li>\n		<span style=\"font-size:14px;\">修订图片上传在有的电脑上，不能上传中文名称图片</span>\n	</li>\n	<li>\n		<span style=\"font-size:14px;\">调整和优化功能代码</span>\n	</li>\n	<li>\n		<span style=\"font-size:14px;\">优化后台左侧导航菜单</span>\n	</li>\n	<li>\n		<span style=\"font-size:14px;\">调整和优化相关表结构</span>\n	</li>\n</ol>\n<p>\n	<span style=\"font-size:14px;\"><img src=\"/static/uploadfile/2017-3/28/66ca879b967a225cf8ef76736dcd59ca.png\" alt=\"\" /><br />\n</span>\n</p>', '7', '0', '0', '1', '1', '1490690139', '1490690326');

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
INSERT INTO `pms_knowledges_comment` VALUES ('66626417361686528', '1461312703628858832', '66618679508340736', '下一版本更加精彩！', '1490687863', '1');

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
-- Table structure for pms_leaves
-- ----------------------------
DROP TABLE IF EXISTS `pms_leaves`;
CREATE TABLE `pms_leaves` (
  `leaveid` bigint(20) NOT NULL,
  `userid` bigint(20) DEFAULT NULL COMMENT '请假人',
  `type` tinyint(1) DEFAULT NULL COMMENT '1事假2病假3年假4调休5婚假6产假7陪产假8路途假9其他',
  `started` int(10) DEFAULT NULL COMMENT '开始时间',
  `ended` int(10) DEFAULT NULL COMMENT '结束时间',
  `days` float DEFAULT NULL COMMENT '请假天数',
  `reason` varchar(500) DEFAULT NULL COMMENT '原因',
  `picture` varchar(100) DEFAULT NULL COMMENT '图片',
  `result` tinyint(1) DEFAULT NULL COMMENT '1同意2拒绝',
  `status` tinyint(1) DEFAULT '1' COMMENT '1草稿2正常发布',
  `approverids` varchar(200) DEFAULT NULL COMMENT '审批人串',
  `created` int(10) DEFAULT NULL,
  `changed` int(10) DEFAULT NULL,
  PRIMARY KEY (`leaveid`),
  KEY `INDEX_UTC` (`userid`,`type`,`created`,`changed`,`result`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='请假表';

-- ----------------------------
-- Records of pms_leaves
-- ----------------------------
INSERT INTO `pms_leaves` VALUES ('66618286464307200', '1461312703628858832', '1', '1490976000', '1490976000', '1', '出去走一走，很久没有出行了！', '', '0', '2', '1469024587469707428', '1490685925', '1490685925');

-- ----------------------------
-- Table structure for pms_leaves_approver
-- ----------------------------
DROP TABLE IF EXISTS `pms_leaves_approver`;
CREATE TABLE `pms_leaves_approver` (
  `approverid` bigint(20) NOT NULL,
  `leaveid` bigint(20) DEFAULT NULL COMMENT '请假表ID',
  `userid` bigint(20) DEFAULT NULL COMMENT '审批人Userid',
  `summary` varchar(500) DEFAULT NULL COMMENT '说明',
  `status` tinyint(1) DEFAULT NULL COMMENT '1同意2拒绝',
  `created` int(10) DEFAULT NULL,
  `changed` int(10) DEFAULT NULL,
  PRIMARY KEY (`approverid`),
  KEY `INDEX_LUSC` (`leaveid`,`userid`,`status`,`created`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='请假审批人表';

-- ----------------------------
-- Records of pms_leaves_approver
-- ----------------------------
INSERT INTO `pms_leaves_approver` VALUES ('66618286627885056', '66618286464307200', '1469024587469707428', '', '0', '1490685925', '1490685925');

-- ----------------------------
-- Table structure for pms_messages
-- ----------------------------
DROP TABLE IF EXISTS `pms_messages`;
CREATE TABLE `pms_messages` (
  `msgid` bigint(20) NOT NULL,
  `userid` bigint(20) DEFAULT NULL,
  `touserid` bigint(20) DEFAULT NULL,
  `type` tinyint(2) DEFAULT NULL COMMENT '类型1评论2赞3审批',
  `subtype` tinyint(3) DEFAULT NULL COMMENT '11知识评论12相册评论21知识赞22相册赞31请假审批32加班33报销34出差35外出36物品',
  `title` varchar(200) DEFAULT NULL,
  `url` varchar(200) DEFAULT NULL,
  `view` tinyint(1) DEFAULT '1' COMMENT '1未看，2已看',
  `created` int(10) DEFAULT NULL,
  PRIMARY KEY (`msgid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT=' 消息表';

-- ----------------------------
-- Records of pms_messages
-- ----------------------------
INSERT INTO `pms_messages` VALUES ('66618325785907200', '1461312703628858832', '1469024587469707428', '4', '31', '去审批处理', '/leave/approval/66618286464307200', '1', '1490685934');
INSERT INTO `pms_messages` VALUES ('66626417378463744', '1461312703628858832', '1461312703628858832', '1', '11', 'OPMS 1.2 版本更新发布', '/knowledge/66618679508340736', '1', '1490687863');
INSERT INTO `pms_messages` VALUES ('66639445431947264', '1461312703628858832', '1461312703628858832', '1', '12', '油菜花', '/album/66621262012616704', '1', '1490690969');

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
  PRIMARY KEY (`noticeid`),
  KEY `INDEX_TCS` (`title`,`created`,`status`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='公告通知表';

-- ----------------------------
-- Records of pms_notices
-- ----------------------------
INSERT INTO `pms_notices` VALUES ('66623026262708224', '2017清明放假通知', '2017清明放假通知，连续放6天（2017-04-01至2017-04-06），请各部门注意~', '1490687055', '1');
INSERT INTO `pms_notices` VALUES ('66623026262708225', '10.1放假通知', '各部门注意，本次放假多放10天，共17天！', '1475137115', '1');

-- ----------------------------
-- Table structure for pms_oagoods
-- ----------------------------
DROP TABLE IF EXISTS `pms_oagoods`;
CREATE TABLE `pms_oagoods` (
  `oagoodid` bigint(20) NOT NULL,
  `userid` bigint(20) DEFAULT NULL,
  `purpose` varchar(100) DEFAULT NULL COMMENT '物品用途',
  `names` varchar(8) NOT NULL COMMENT '物品名称串',
  `quantitys` varchar(200) DEFAULT NULL COMMENT '数量串',
  `content` varchar(1000) DEFAULT NULL COMMENT '详情',
  `picture` varchar(100) DEFAULT NULL COMMENT '1同',
  `result` tinyint(1) DEFAULT NULL COMMENT '1同意2拒绝',
  `status` tinyint(1) DEFAULT '1' COMMENT '1草稿2正常发布',
  `approverids` varchar(200) DEFAULT NULL COMMENT '审批人串',
  `created` int(10) DEFAULT NULL,
  `changed` int(10) DEFAULT NULL,
  PRIMARY KEY (`oagoodid`),
  KEY `INDEX_UNRSC` (`userid`,`names`,`result`,`status`,`created`,`changed`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='物品领用表';

-- ----------------------------
-- Records of pms_oagoods
-- ----------------------------
INSERT INTO `pms_oagoods` VALUES ('1469091934239424332', '1461312703628858832', '公办用品', '笔记本||笔', '3||4', '自己用不行呀', '', '1', '2', '1468140265954907628', '1475203703', '1475203703');

-- ----------------------------
-- Table structure for pms_oagoods_approver
-- ----------------------------
DROP TABLE IF EXISTS `pms_oagoods_approver`;
CREATE TABLE `pms_oagoods_approver` (
  `approverid` bigint(20) NOT NULL,
  `oagoodid` bigint(20) DEFAULT NULL COMMENT '物品领用表ID',
  `userid` bigint(20) DEFAULT NULL COMMENT '审批人Userid',
  `summary` varchar(500) DEFAULT NULL COMMENT '说明',
  `status` tinyint(1) DEFAULT NULL COMMENT '1同意2拒绝',
  `created` int(10) DEFAULT NULL,
  `changed` int(10) DEFAULT NULL,
  PRIMARY KEY (`approverid`),
  KEY `INDEX_LUSC` (`oagoodid`,`userid`,`status`,`created`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='报销审批人表';

-- ----------------------------
-- Records of pms_oagoods_approver
-- ----------------------------
INSERT INTO `pms_oagoods_approver` VALUES ('1469091934280858732', '1469091934239424332', '1468140265954907628', '可以', '1', '1475203703', '1475204271');

-- ----------------------------
-- Table structure for pms_overtimes
-- ----------------------------
DROP TABLE IF EXISTS `pms_overtimes`;
CREATE TABLE `pms_overtimes` (
  `overtimeid` bigint(20) NOT NULL,
  `userid` bigint(20) DEFAULT NULL COMMENT '请假人',
  `started` int(10) DEFAULT NULL COMMENT '开始时间',
  `ended` int(10) DEFAULT NULL COMMENT '结束时间',
  `longtime` tinyint(4) DEFAULT NULL COMMENT '加班时长',
  `holiday` tinyint(1) DEFAULT NULL COMMENT '节假日1是2否',
  `way` tinyint(1) DEFAULT NULL COMMENT '核算方式1调休，2加班费',
  `reason` varchar(500) DEFAULT NULL COMMENT '原因',
  `result` tinyint(1) DEFAULT NULL COMMENT '1同意2拒绝',
  `status` tinyint(1) DEFAULT '1' COMMENT '1草稿2正常发布',
  `approverids` varchar(200) DEFAULT NULL COMMENT '审批人串',
  `created` int(10) DEFAULT NULL,
  `changed` int(10) DEFAULT NULL,
  PRIMARY KEY (`overtimeid`),
  KEY `INDEX_UTC` (`userid`,`longtime`,`created`,`changed`,`result`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='加班表';

-- ----------------------------
-- Records of pms_overtimes
-- ----------------------------

-- ----------------------------
-- Table structure for pms_overtimes_approver
-- ----------------------------
DROP TABLE IF EXISTS `pms_overtimes_approver`;
CREATE TABLE `pms_overtimes_approver` (
  `approverid` bigint(20) NOT NULL,
  `overtimeid` bigint(20) DEFAULT NULL COMMENT '加班表ID',
  `userid` bigint(20) DEFAULT NULL COMMENT '审批人Userid',
  `summary` varchar(500) DEFAULT NULL COMMENT '说明',
  `status` tinyint(1) DEFAULT NULL COMMENT '1同意2拒绝',
  `created` int(10) DEFAULT NULL,
  `changed` int(10) DEFAULT NULL,
  PRIMARY KEY (`approverid`),
  KEY `INDEX_LUSC` (`overtimeid`,`userid`,`status`,`created`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='加班审批人表';

-- ----------------------------
-- Records of pms_overtimes_approver
-- ----------------------------

-- ----------------------------
-- Table structure for pms_permissions
-- ----------------------------
DROP TABLE IF EXISTS `pms_permissions`;
CREATE TABLE `pms_permissions` (
  `permissionid` bigint(20) NOT NULL,
  `parentid` bigint(20) DEFAULT NULL,
  `name` varchar(50) DEFAULT NULL COMMENT '中文名称',
  `ename` varchar(50) DEFAULT NULL COMMENT '英文名称',
  `icon` varchar(20) DEFAULT NULL,
  `nav` tinyint(1) DEFAULT '0' COMMENT '1是0否导航',
  `type` tinyint(1) DEFAULT '0' COMMENT '0不显示1显示',
  `weight` tinyint(4) DEFAULT '0',
  PRIMARY KEY (`permissionid`),
  KEY `INDEX_PNETW` (`parentid`,`name`,`ename`,`type`,`weight`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='权限表';

-- ----------------------------
-- Records of pms_permissions
-- ----------------------------
INSERT INTO `pms_permissions` VALUES ('41965474417741824', '0', '我的主页', 'my', 'home', '1', '1', '99');
INSERT INTO `pms_permissions` VALUES ('41969010140516352', '0', '项目管理', 'project', 'book', '1', '0', '0');
INSERT INTO `pms_permissions` VALUES ('41969113630773248', '41969010140516352', '项目列表', 'project-manage', null, '0', '0', '0');
INSERT INTO `pms_permissions` VALUES ('41969192357859328', '41969010140516352', '添加项目', 'project-add', null, '0', '0', '0');
INSERT INTO `pms_permissions` VALUES ('41969252499984384', '41969010140516352', '编辑项目', 'project-edit', null, '0', '0', '0');
INSERT INTO `pms_permissions` VALUES ('41976726762295296', '41969010140516352', '团队列表', 'project-team', null, '0', '0', '0');
INSERT INTO `pms_permissions` VALUES ('41976831846387712', '41969010140516352', '添加团队', 'team-add', null, '0', '0', '0');
INSERT INTO `pms_permissions` VALUES ('41976904223297536', '41969010140516352', '团队删除', 'team-delete', null, '0', '0', '0');
INSERT INTO `pms_permissions` VALUES ('41977259501817856', '41969010140516352', '需求列表', 'project-need', null, '0', '0', '0');
INSERT INTO `pms_permissions` VALUES ('41977400967303168', '41969010140516352', '添加需求', 'need-add', null, '0', '0', '0');
INSERT INTO `pms_permissions` VALUES ('41977528792911872', '41969010140516352', '编辑需求', 'need-edit', null, '0', '0', '0');
INSERT INTO `pms_permissions` VALUES ('41977654831747072', '41969010140516352', '删除需求', 'need-delete', null, '0', '0', '0');
INSERT INTO `pms_permissions` VALUES ('41977734154424320', '41969010140516352', '需求查看', 'need-view', null, '0', '0', '0');
INSERT INTO `pms_permissions` VALUES ('41977922247987200', '41969010140516352', '任务列表', 'project-task', null, '0', '0', '0');
INSERT INTO `pms_permissions` VALUES ('41978045921234944', '41969010140516352', '添加任务', 'task-add', null, '0', '0', '0');
INSERT INTO `pms_permissions` VALUES ('41978134387494912', '41969010140516352', '编辑任务', 'task-edit', null, '0', '0', '0');
INSERT INTO `pms_permissions` VALUES ('41978216994312192', '41969010140516352', '任务删除', 'task-delete', null, '0', '0', '0');
INSERT INTO `pms_permissions` VALUES ('41978289807429632', '41969010140516352', '任务查看', 'task-view', null, '0', '0', '0');
INSERT INTO `pms_permissions` VALUES ('41978468690300928', '41969010140516352', 'Bug列表', 'project-test', null, '0', '0', '0');
INSERT INTO `pms_permissions` VALUES ('41978566618910720', '41969010140516352', '提Bug', 'test-add', null, '0', '0', '0');
INSERT INTO `pms_permissions` VALUES ('41978664295862272', '41969010140516352', '编辑Bug', 'test-edit', null, '0', '0', '0');
INSERT INTO `pms_permissions` VALUES ('41978754309820416', '41969010140516352', 'Bug查看', 'test-view', null, '0', '0', '0');
INSERT INTO `pms_permissions` VALUES ('41978832399372288', '41969010140516352', 'Bug删除', 'test-delete', null, '0', '0', '0');
INSERT INTO `pms_permissions` VALUES ('41980436594823168', '0', '考勤管理', 'checkwork', 'tasks', '1', '0', '0');
INSERT INTO `pms_permissions` VALUES ('41980651519348736', '41980436594823168', '我的考勤', 'checkwork-manage', null, '0', '0', '0');
INSERT INTO `pms_permissions` VALUES ('41980770788577280', '41980436594823168', '全部考勤', 'checkwork-all', null, '0', '0', '0');
INSERT INTO `pms_permissions` VALUES ('42334086215241728', '0', '审批管理', 'approval', 'suitcase', '1', '0', '0');
INSERT INTO `pms_permissions` VALUES ('42334265874059264', '42334086215241728', '请假', 'leave-manage', null, '1', '0', '0');
INSERT INTO `pms_permissions` VALUES ('42334379363536896', '42334086215241728', '申请请假', 'leave-add', null, '0', '0', '0');
INSERT INTO `pms_permissions` VALUES ('42334463782293504', '42334086215241728', '编辑请假', 'leave-edit', null, '0', '0', '0');
INSERT INTO `pms_permissions` VALUES ('42334539376234496', '42334086215241728', '请假查看', 'leave-view', null, '0', '0', '0');
INSERT INTO `pms_permissions` VALUES ('42334628953985024', '42334086215241728', '审批请假', 'leave-approval', null, '0', '0', '0');
INSERT INTO `pms_permissions` VALUES ('42334838946009088', '42334086215241728', '加班', 'overtime-manage', null, '1', '0', '0');
INSERT INTO `pms_permissions` VALUES ('42334976082972672', '42334086215241728', '申请加班', 'overtime-add', null, '0', '0', '0');
INSERT INTO `pms_permissions` VALUES ('42335081259339776', '42334086215241728', '编辑加班', 'overtime-edit', null, '0', '0', '0');
INSERT INTO `pms_permissions` VALUES ('42335209235943424', '42334086215241728', '查看加班', 'overtime-view', null, '0', '0', '0');
INSERT INTO `pms_permissions` VALUES ('42335311539212288', '42334086215241728', '审批加班', 'overtime-approval', null, '0', '0', '0');
INSERT INTO `pms_permissions` VALUES ('42335402681438208', '42334086215241728', '报销', 'expense-manage', null, '1', '0', '0');
INSERT INTO `pms_permissions` VALUES ('42335721133969408', '42334086215241728', '申请报销', 'expense-add', null, '0', '0', '0');
INSERT INTO `pms_permissions` VALUES ('42335817183531008', '42334086215241728', '编辑报销', 'expense-edit', null, '0', '0', '0');
INSERT INTO `pms_permissions` VALUES ('42335940605120512', '42334086215241728', '报销查看', 'expense-view', null, '0', '0', '0');
INSERT INTO `pms_permissions` VALUES ('42336024805773312', '42334086215241728', '审批报销', 'expense-approval', null, '0', '0', '0');
INSERT INTO `pms_permissions` VALUES ('42336123501940736', '42334086215241728', '出差', 'businesstrip-manage', null, '1', '0', '0');
INSERT INTO `pms_permissions` VALUES ('42336206301696000', '42334086215241728', '申请出差', 'businesstrip-add', null, '0', '0', '0');
INSERT INTO `pms_permissions` VALUES ('42336271770587136', '42334086215241728', '编辑出差', 'businesstrip-edit', null, '0', '0', '0');
INSERT INTO `pms_permissions` VALUES ('42336347972702208', '42334086215241728', '出差查看', 'businesstrip-view', null, '0', '0', '0');
INSERT INTO `pms_permissions` VALUES ('42336433490366464', '42334086215241728', '审批出差', 'businesstrip-approval', null, '0', '0', '0');
INSERT INTO `pms_permissions` VALUES ('42336599123431424', '42334086215241728', '外出', 'goout-manage', null, '1', '0', '0');
INSERT INTO `pms_permissions` VALUES ('42336697060429824', '42334086215241728', '申请外出', 'goout-add', null, '0', '0', '0');
INSERT INTO `pms_permissions` VALUES ('42336773992353792', '42334086215241728', '编辑外出', 'goout-edit', null, '0', '0', '0');
INSERT INTO `pms_permissions` VALUES ('42336853726072832', '42334086215241728', '外出查看', 'goout-view', null, '0', '0', '0');
INSERT INTO `pms_permissions` VALUES ('42336946441162752', '42334086215241728', '审批外出', 'goout-approval', null, '0', '0', '0');
INSERT INTO `pms_permissions` VALUES ('42337029878452224', '42334086215241728', '物品', 'oagood-manage', null, '1', '0', '0');
INSERT INTO `pms_permissions` VALUES ('42337132236247040', '42334086215241728', '申请物品', 'oagood-add', null, '0', '0', '0');
INSERT INTO `pms_permissions` VALUES ('42337204650905600', '42334086215241728', '编辑物品', 'oagood-edit', null, '0', '0', '0');
INSERT INTO `pms_permissions` VALUES ('42337301711294464', '42334086215241728', '物品查看', 'oagood-view', null, '0', '0', '0');
INSERT INTO `pms_permissions` VALUES ('42337378299285504', '42334086215241728', '审批物品', 'oagood-approval', null, '0', '0', '0');
INSERT INTO `pms_permissions` VALUES ('42337482720677888', '0', '知识分享', 'knowledge', 'tasks', '1', '0', '0');
INSERT INTO `pms_permissions` VALUES ('42337629286436864', '42337482720677888', '知识列表', 'knowledge-manage', null, '0', '0', '0');
INSERT INTO `pms_permissions` VALUES ('42337745028255744', '42337482720677888', '发布知识', 'knowledge-add', null, '0', '0', '0');
INSERT INTO `pms_permissions` VALUES ('42337817904287744', '42337482720677888', '编辑知识', 'knowledge-edit', null, '0', '0', '0');
INSERT INTO `pms_permissions` VALUES ('42338272126439424', '0', '员工相册', 'album', 'plane', '1', '0', '0');
INSERT INTO `pms_permissions` VALUES ('42338384647032832', '42338272126439424', '相册列表', 'album-manage', null, '0', '0', '0');
INSERT INTO `pms_permissions` VALUES ('42338452590563328', '42338272126439424', '上传相片', 'album-upload', null, '0', '0', '0');
INSERT INTO `pms_permissions` VALUES ('42338538640904192', '42338272126439424', '编辑相片', 'album-edit', null, '0', '0', '0');
INSERT INTO `pms_permissions` VALUES ('42338630085120000', '42338272126439424', '查看相册', 'album-view', null, '0', '0', '0');
INSERT INTO `pms_permissions` VALUES ('42338743775924224', '42338272126439424', '相册删除', 'album-delete', null, '0', '0', '0');
INSERT INTO `pms_permissions` VALUES ('42338841398349824', '0', '简历管理', 'resume', 'laptop', '1', '0', '0');
INSERT INTO `pms_permissions` VALUES ('42338936218980352', '42338841398349824', '简历列表', 'resume-manage', null, '0', '0', '0');
INSERT INTO `pms_permissions` VALUES ('42339022474842112', '42338841398349824', '添加简历', 'resume-add', null, '0', '0', '0');
INSERT INTO `pms_permissions` VALUES ('42339129958076416', '42338841398349824', '编辑简历', 'resume-edit', null, '0', '0', '0');
INSERT INTO `pms_permissions` VALUES ('42339223352643584', '42338841398349824', '删除简历', 'resume-delete', null, '0', '0', '0');
INSERT INTO `pms_permissions` VALUES ('42354722958479360', '0', '组织管理', 'user', 'user', '1', '0', '0');
INSERT INTO `pms_permissions` VALUES ('42354812125188096', '42354722958479360', '用户列表', 'user-manage', null, '1', '0', '0');
INSERT INTO `pms_permissions` VALUES ('42354905771413504', '42354722958479360', '添加用户', 'user-add', null, '0', '0', '0');
INSERT INTO `pms_permissions` VALUES ('42354988550197248', '42354722958479360', '编辑用户', 'user-edit', null, '0', '0', '0');
INSERT INTO `pms_permissions` VALUES ('42355171505737728', '42354722958479360', '部门列表', 'department-manage', null, '1', '0', '0');
INSERT INTO `pms_permissions` VALUES ('42355325336031232', '42354722958479360', '添加部门', 'department-add', null, '0', '0', '0');
INSERT INTO `pms_permissions` VALUES ('42355402511224832', '42354722958479360', '编辑部门', 'department-edit', null, '0', '0', '0');
INSERT INTO `pms_permissions` VALUES ('42355510552301568', '42354722958479360', '职称列表', 'position-manage', null, '1', '0', '0');
INSERT INTO `pms_permissions` VALUES ('42355596724277248', '42354722958479360', '添加职称', 'position-add', null, '0', '0', '0');
INSERT INTO `pms_permissions` VALUES ('42355693625282560', '42354722958479360', '编辑职称', 'position-edit', null, '0', '0', '0');
INSERT INTO `pms_permissions` VALUES ('42355773019262976', '42354722958479360', '公告列表', 'notice-manage', null, '1', '0', '0');
INSERT INTO `pms_permissions` VALUES ('42355862622179328', '42354722958479360', '添加公告', 'notice-add', null, '0', '0', '0');
INSERT INTO `pms_permissions` VALUES ('42355935212998656', '42354722958479360', '编辑公告', 'notice-edit', null, '0', '0', '0');
INSERT INTO `pms_permissions` VALUES ('42356020873269248', '42354722958479360', '删除公告', 'notice-delete', null, '0', '0', '0');
INSERT INTO `pms_permissions` VALUES ('42356198170693632', '42354722958479360', '消息列表', 'message-manage', null, '0', '0', '0');
INSERT INTO `pms_permissions` VALUES ('42356266030338048', '42354722958479360', '删除消息', 'message-delete', null, '0', '0', '0');
INSERT INTO `pms_permissions` VALUES ('61562786651574272', '41965474417741824', '查看主页', 'my-view', null, '0', '0', '0');
INSERT INTO `pms_permissions` VALUES ('64059892574457856', '42354722958479360', '组管理', 'group-manage', '', '0', '0', '0');
INSERT INTO `pms_permissions` VALUES ('64059999378214912', '42354722958479360', '添加组', 'group-add', '', '0', '0', '0');
INSERT INTO `pms_permissions` VALUES ('64060145163833344', '42354722958479360', '编辑组', 'group-edit', '', '0', '0', '0');
INSERT INTO `pms_permissions` VALUES ('64060216546693120', '42354722958479360', '删除组', 'group-delete', '', '0', '0', '0');
INSERT INTO `pms_permissions` VALUES ('64060546483228672', '42354722958479360', '组权限', 'group-permission', '', '0', '0', '0');
INSERT INTO `pms_permissions` VALUES ('64060742327865344', '42354722958479360', '组成员', 'group-user', '', '0', '0', '0');
INSERT INTO `pms_permissions` VALUES ('64060871856361472', '42354722958479360', '添加组成员', 'group-user-add', '', '0', '0', '0');
INSERT INTO `pms_permissions` VALUES ('64060949748781056', '42354722958479360', '删除组成员', 'group-user-delete', '', '0', '0', '0');
INSERT INTO `pms_permissions` VALUES ('64061137204809728', '42354722958479360', '权限管理', 'permission-manage', '', '0', '0', '0');
INSERT INTO `pms_permissions` VALUES ('64061220927311872', '42354722958479360', '添加权限', 'permission-add', '', '0', '0', '0');
INSERT INTO `pms_permissions` VALUES ('64061290498232320', '42354722958479360', '编辑权限', 'permission-edit', '', '0', '0', '0');
INSERT INTO `pms_permissions` VALUES ('64061357862948864', '42354722958479360', '删除权限', 'permission-delete', '', '0', '0', '0');
INSERT INTO `pms_permissions` VALUES ('64738735329120256', '42337482720677888', '知识删除', 'knowledge-delete', '', '0', '0', '0');
INSERT INTO `pms_permissions` VALUES ('64739027659526144', '41969010140516352', '文档列表', 'project-doc', '', '0', '0', '0');
INSERT INTO `pms_permissions` VALUES ('64739308640145408', '41969010140516352', '文档编辑', 'doc-edit', '', '0', '0', '0');
INSERT INTO `pms_permissions` VALUES ('64739380002033664', '41969010140516352', '文档添加', 'doc-add', '', '0', '0', '0');
INSERT INTO `pms_permissions` VALUES ('64739571354570752', '41969010140516352', '文档删除', 'doc-delete', '', '0', '0', '0');
INSERT INTO `pms_permissions` VALUES ('64739781774413824', '41969010140516352', '文档查看', 'doc-view', '', '0', '0', '0');
INSERT INTO `pms_permissions` VALUES ('64739963341639680', '41969010140516352', '版本列表', 'project-version', '', '0', '0', '0');
INSERT INTO `pms_permissions` VALUES ('64740034804191232', '41969010140516352', '版本编辑', 'version-edit', '', '0', '0', '0');
INSERT INTO `pms_permissions` VALUES ('64740129687736320', '41969010140516352', '版本添加', 'version-add', '', '0', '0', '0');
INSERT INTO `pms_permissions` VALUES ('64740203201302528', '41969010140516352', '版本删除', 'version-delete', '', '0', '0', '0');
INSERT INTO `pms_permissions` VALUES ('64740359808225280', '41969010140516352', '版本查看', 'version-view', '', '0', '0', '0');
INSERT INTO `pms_permissions` VALUES ('64809905348939776', '41969010140516352', '批量添加任务', 'task-batch-add', '', '0', '0', '0');
INSERT INTO `pms_permissions` VALUES ('64815327690625024', '41969010140516352', '任务克隆', 'task-clone', '', '0', '0', '0');
INSERT INTO `pms_permissions` VALUES ('65140829198487552', '42337482720677888', '知识查看', 'knowledge-view', '', '0', '0', '0');
INSERT INTO `pms_permissions` VALUES ('65140900749119488', '42338272126439424', '相册查看', 'album-view', '', '0', '0', '0');

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
INSERT INTO `pms_projects` VALUES ('66562760133054464', '1461312703628858832', '项目管理与OA办公', 'OPMS', '1490630400', '1509379200', '<ol>\n	<li>\n		项目管理与OA办公\n	</li>\n	<li>\n		简单轻便\n	</li>\n	<li>\n		工作流\n	</li>\n	<li>\n		日常办公管理\n	</li>\n	<li>\n		权限管理\n	</li>\n</ol>', '1490672686', '1', '1467191338628906628', '1468140265954907628', '1468140265954907628', '1461312703628858832');

-- ----------------------------
-- Table structure for pms_projects_doc
-- ----------------------------
DROP TABLE IF EXISTS `pms_projects_doc`;
CREATE TABLE `pms_projects_doc` (
  `docid` bigint(20) NOT NULL,
  `projectid` bigint(20) DEFAULT NULL,
  `userid` bigint(20) DEFAULT NULL,
  `title` varchar(100) DEFAULT NULL,
  `keyword` varchar(255) DEFAULT NULL,
  `sort` tinyint(1) DEFAULT '1' COMMENT '1正文2链接',
  `content` text,
  `url` varchar(255) DEFAULT NULL,
  `attachment` varchar(255) DEFAULT NULL,
  `created` int(10) DEFAULT NULL,
  `changed` int(10) DEFAULT NULL,
  PRIMARY KEY (`docid`),
  KEY `INDEX_PUTK` (`projectid`,`userid`,`title`,`keyword`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='项目文档表';

-- ----------------------------
-- Records of pms_projects_doc
-- ----------------------------
INSERT INTO `pms_projects_doc` VALUES ('66565795970289664', '66562760133054464', '1461312703628858832', 'OA办公参考网站', '', '2', '参考这个网站的功能，可以适当删减', 'http://www.milu365.com', '', '1490673410', '1490673440');
INSERT INTO `pms_projects_doc` VALUES ('66566140419117056', '66562760133054464', '1461312703628858832', 'PDF版思维导图', '', '1', '相关人员可以查看PDF思维导图', '', '/static/uploadfile/2017-3/28/0.jpg', '1490673492', '1490673492');

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
  `level` tinyint(1) DEFAULT '4' COMMENT '优先级1,2,3,4',
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
INSERT INTO `pms_projects_needs` VALUES ('66563530584756224', '66562760133054464', '1461312703628858832', '出思维导图', '出整个项目的思维导图，与需求方确认', '1467191338628906628', '3', '', '1', '8', '', '1490672870', '0', '3', '2');
INSERT INTO `pms_projects_needs` VALUES ('66563749770694656', '66562760133054464', '1461312703628858832', '用户相关模块', '用户登录，注册，忘记密码，手机验证码等', '1467191338628906628', '3', '', '2', '5', '', '1490672922', '0', '3', '2');
INSERT INTO `pms_projects_needs` VALUES ('66563918947946496', '66562760133054464', '1461312703628858832', '项目管理', '项目管理流程，团队，需求，任务，测试，版本，文档', '1467191338628906628', '4', '', '2', '6', '', '1490672962', '0', '3', '2');

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
  `level` tinyint(1) DEFAULT '4' COMMENT '优先级1,2,3,4',
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
INSERT INTO `pms_projects_task` VALUES ('66565030916657152', '66563530584756224', '1461312703628858832', '66562760133054464', '1467191338628906628', '', '0', '思维导图版本', '思维导图版本设计', '', '4', '1', '6', '0', '0', '', '1490673228', '0', '1', '0', '0');
INSERT INTO `pms_projects_task` VALUES ('66565031097012224', '66563530584756224', '1461312703628858832', '66562760133054464', '1467191338628906628', '', '0', '思维导图确认修订讨论', '', '', '4', '1', '5', '0', '0', '', '1490673228', '0', '1', '0', '0');
INSERT INTO `pms_projects_task` VALUES ('66565031201869824', '66563749770694656', '1461312703628858832', '66562760133054464', '1461312703628858832', '', '0', 'UI - 用户登录', '', '', '1', '2', '5', '0', '0', '', '1490673228', '0', '2', '0', '0');
INSERT INTO `pms_projects_task` VALUES ('66565031700992000', '66563749770694656', '1461312703628858832', '66562760133054464', '1461312703628858832', '', '0', 'UI - 用户注册', '', '', '1', '2', '3', '0', '0', '', '1490673228', '0', '1', '0', '0');
INSERT INTO `pms_projects_task` VALUES ('66565031851986944', '66563749770694656', '1461312703628858832', '66562760133054464', '1461312703628858832', '', '0', 'UI - 用户忘记密码', '', '', '1', '3', '3', '0', '0', '', '1490673228', '0', '1', '0', '0');
INSERT INTO `pms_projects_task` VALUES ('66565031935873024', '66563918947946496', '1461312703628858832', '66562760133054464', '1468140265954907628', '', '0', 'Front - 项目管理', '', '', '6', '3', '4', '0', '0', '', '1490673228', '0', '1', '0', '0');
INSERT INTO `pms_projects_task` VALUES ('66565032053313536', '66563918947946496', '1461312703628858832', '66562760133054464', '1468140265954907628', '', '0', 'Front - 发布项目', '', '', '6', '3', '5', '0', '0', '', '1490673228', '0', '1', '0', '0');
INSERT INTO `pms_projects_task` VALUES ('66565032137199616', '66563918947946496', '1461312703628858832', '66562760133054464', '1468140265954907628', '', '0', 'Front - 项目详情', '', '', '6', '3', '2', '0', '0', '', '1490673228', '0', '1', '0', '0');
INSERT INTO `pms_projects_task` VALUES ('66565032304971776', '66563918947946496', '1461312703628858832', '66562760133054464', '1468140265954907628', '', '0', '后端 - 项目管理开发', '', '', '2', '3', '2', '0', '0', '', '1490673228', '0', '1', '0', '0');
INSERT INTO `pms_projects_task` VALUES ('66565032388857856', '66563918947946496', '1461312703628858832', '66562760133054464', '1468140265954907628', '', '0', '后端 - 项目管理添加编辑', '', '', '2', '3', '8', '0', '0', '', '1490673228', '0', '1', '0', '0');

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
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='任务日志表';

-- ----------------------------
-- Records of pms_projects_task_log
-- ----------------------------
INSERT INTO `pms_projects_task_log` VALUES ('66565030920851456', '66565030916657152', '1461312703628858832', '李白创建了任务', '1490673228');
INSERT INTO `pms_projects_task_log` VALUES ('66565031109595136', '66565031097012224', '1461312703628858832', '李白创建了任务', '1490673228');
INSERT INTO `pms_projects_task_log` VALUES ('66565031214452736', '66565031201869824', '1461312703628858832', '李白创建了任务', '1490673228');
INSERT INTO `pms_projects_task_log` VALUES ('66565031713574912', '66565031700992000', '1461312703628858832', '李白创建了任务', '1490673228');
INSERT INTO `pms_projects_task_log` VALUES ('66565031864569856', '66565031851986944', '1461312703628858832', '李白创建了任务', '1490673228');
INSERT INTO `pms_projects_task_log` VALUES ('66565031948455936', '66565031935873024', '1461312703628858832', '李白创建了任务', '1490673228');
INSERT INTO `pms_projects_task_log` VALUES ('66565032065896448', '66565032053313536', '1461312703628858832', '李白创建了任务', '1490673228');
INSERT INTO `pms_projects_task_log` VALUES ('66565032149782528', '66565032137199616', '1461312703628858832', '李白创建了任务', '1490673228');
INSERT INTO `pms_projects_task_log` VALUES ('66565032317554688', '66565032304971776', '1461312703628858832', '李白创建了任务', '1490673228');
INSERT INTO `pms_projects_task_log` VALUES ('66565032401440768', '66565032388857856', '1461312703628858832', '李白创建了任务', '1490673228');
INSERT INTO `pms_projects_task_log` VALUES ('66566863257079808', '66565031201869824', '1461312703628858832', '李白更改任务状态为进行中', '1490673664');

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
INSERT INTO `pms_projects_team` VALUES ('66562826440806400', '66562760133054464', '1461312703628858832', '1490672702');
INSERT INTO `pms_projects_team` VALUES ('66562882074054656', '66562760133054464', '1468140265954907628', '1490672715');
INSERT INTO `pms_projects_team` VALUES ('66562919290114048', '66562760133054464', '1467191338628906628', '1490672724');

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
  `level` tinyint(1) DEFAULT '4' COMMENT '优先级1,2,3,4',
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
INSERT INTO `pms_projects_test` VALUES ('66565285141811200', '66565030916657152', '66563530584756224', '1461312703628858832', '66562760133054464', '1467191338628906628', '0', '', '思维导图打不开', '', '1', 'wp7', 'chrome', '', '0', '1490673288', '0', '0');
INSERT INTO `pms_projects_test` VALUES ('66565532245037056', '66565031201869824', '66563749770694656', '1461312703628858832', '66562760133054464', '1468140265954907628', '0', '', '用户登录设计缺少登录按钮', '用户登录设计缺少登录按钮，无法登录', '2', '', '', '', '0', '1490673347', '0', '0');
INSERT INTO `pms_projects_test` VALUES ('66622301705080832', '66565032304971776', '66563918947946496', '1461312703628858832', '66562760133054464', '1461312703628858832', '1461312703628858832', '', '发布项目出错，提示手机必填', '我发布的时候，手机号已经填写过了，提交还出现这问题~', '2', 'wp7', 'ie10', '', '1490686901', '1490686882', '0', '4');

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
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='测试Bug日志表';

-- ----------------------------
-- Records of pms_projects_test_log
-- ----------------------------
INSERT INTO `pms_projects_test_log` VALUES ('66565285150199808', '66565285141811200', '1461312703628858832', '李白创建了测试', '1490673288');
INSERT INTO `pms_projects_test_log` VALUES ('66565532249231360', '66565532245037056', '1461312703628858832', '李白创建了测试', '1490673347');
INSERT INTO `pms_projects_test_log` VALUES ('66622301709275136', '66622301705080832', '1461312703628858832', '李白创建了测试', '1490686882');
INSERT INTO `pms_projects_test_log` VALUES ('66622380088233984', '66622301705080832', '1461312703628858832', '李白更改测试状态为已解决<br>', '1490686901');

-- ----------------------------
-- Table structure for pms_projects_version
-- ----------------------------
DROP TABLE IF EXISTS `pms_projects_version`;
CREATE TABLE `pms_projects_version` (
  `versionid` bigint(20) NOT NULL,
  `projectid` bigint(20) DEFAULT NULL,
  `userid` bigint(20) DEFAULT NULL,
  `title` varchar(100) DEFAULT NULL,
  `versioned` int(10) DEFAULT NULL COMMENT '打包日期',
  `content` text,
  `sourceurl` varchar(255) DEFAULT NULL COMMENT '源代码',
  `downurl` varchar(255) DEFAULT NULL COMMENT '下载地址',
  `attachment` varchar(255) DEFAULT NULL,
  `created` int(10) DEFAULT NULL,
  `changed` int(10) DEFAULT NULL,
  PRIMARY KEY (`versionid`),
  KEY `INDEX_PUT` (`projectid`,`userid`,`title`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='项目版本表';

-- ----------------------------
-- Records of pms_projects_version
-- ----------------------------
INSERT INTO `pms_projects_version` VALUES ('66566450906664960', '66562760133054464', '1461312703628858832', 'OPMS产品原型V1', '1490630400', '第一版本产品原型，后续迭代更新！', 'https://github.com/lock-upme', 'https://github.com/lock-upme', '/static/uploadfile/2017-3/28/0.jpg', '1490673566', '1490673566');

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
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='简历表';

-- ----------------------------
-- Records of pms_resumes
-- ----------------------------
INSERT INTO `pms_resumes` VALUES ('66627732930301952', '刘星', '1', '353894400', '7', '5', '', '1490688177', '2', '生活让我变的更加坚强', '1356512523');
INSERT INTO `pms_resumes` VALUES ('1469028741058477628', '李芝芝', '2', '337564800', '10', '5', '', '1475140509', '4', '李芝芝曾留学国外，从事过人工智能方面的研究工作', '13524512531');

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
INSERT INTO `pms_users` VALUES ('65140463652311040', '65140463652311040', 'lock', '971b6101cfb78b2a161914f955011a62', '/static/img/avatar/1.jpg', '1');
INSERT INTO `pms_users` VALUES ('1461312703628858832', '1461312703628858832', 'libai', '4c90f367f320011ed5582a9b5fa0f3e6', '/static/uploadfile/2017-3/28/5b41faa955a4c1acdb6d7e6c116bce2f-cropper.jpg', '1');
INSERT INTO `pms_users` VALUES ('1467191338628906628', '1467191338628906628', 'zhangsan', '971b6101cfb78b2a161914f955011a62', '/static/img/avatar/3.jpg', '1');
INSERT INTO `pms_users` VALUES ('1468140265954907628', '1468140265954907628', 'lisi', '971b6101cfb78b2a161914f955011a62', '/static/img/avatar/2.jpg', '1');
INSERT INTO `pms_users` VALUES ('1468915433602979028', '1468915433602979028', 'fancy', '971b6101cfb78b2a161914f955011a62', '/static/img/avatar/1.jpg', '1');
INSERT INTO `pms_users` VALUES ('1469024587469707428', '1469024587469707428', 'xiaoxin', '971b6101cfb78b2a161914f955011a62', '/static/img/avatar/1.jpg', '1');

-- ----------------------------
-- Table structure for pms_users_permissions
-- ----------------------------
DROP TABLE IF EXISTS `pms_users_permissions`;
CREATE TABLE `pms_users_permissions` (
  `userid` bigint(20) NOT NULL,
  `permission` varchar(5000) DEFAULT NULL,
  `model` varchar(5000) DEFAULT NULL,
  `modelc` varchar(5000) DEFAULT NULL,
  PRIMARY KEY (`userid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='用户权限表（已弃用）';

-- ----------------------------
-- Records of pms_users_permissions
-- ----------------------------
INSERT INTO `pms_users_permissions` VALUES ('1461312703628858832', 'project-manage,project-add,project-edit,project-team,team-add,team-delete,project-need,need-add,need-edit,project-task,task-add,task-edit,project-test,test-add,test-edit,checkwork-manage,checkwork-all,message-manage,message-delete,leave-manage,leave-add,leave-edit,leave-view,leave-approval,overtime-manage,overtime-add,overtime-edit,overtime-view,overtime-approval,expense-manage,expense-add,expense-edit,expense-view,expense-approval,businesstrip-manage,businesstrip-add,businesstrip-edit,businesstrip-view,businesstrip-approval,goout-manage,goout-add,goout-edit,goout-view,goout-approval,oagood-manage,oagood-add,oagood-edit,oagood-view,oagood-approval,knowledge-manage,knowledge-add,knowledge-edit,album-manage,album-upload,album-edit,resume-manage,resume-add,resume-edit,resume-delete,user-manage,user-add,user-edit,user-permission,department-manage,department-add,department-edit,position-manage,position-add,position-edit,notice-manage,notice-add,notice-edit,notice-delete', '项目管理-project-book||project-manage,考勤管理-checkwork-tasks||checkwork-list,审批管理-approval-suitcase||#,知识分享-knowledge-tasks||knowledge-list,员工相册-album-plane||album-list,简历管理-resume-laptop||resume-list,员工管理-user-user||#', '请假-approval||leave-manage,加班-approval||overtime-manage,报销-approval||expense-manage,出差-approval||businesstrip-manage,外出-approval||goout-manage,物品-approval||oagood-manage,员工-user||user-manage,部门-user||department-manage,职称-user||position-manage,公告-user||notice-manage');
INSERT INTO `pms_users_permissions` VALUES ('1467191338628906628', 'project-team,team-add,team-delete,project-need,need-add,need-edit,project-task,task-add,task-edit,project-test,test-add,test-edit,checkwork-manage,message-manage,message-delete,leave-manage,leave-add,leave-edit,leave-view,leave-approval,overtime-manage,overtime-add,overtime-edit,overtime-view,overtime-approval,expense-manage,expense-add,expense-edit,expense-view,expense-approval,businesstrip-manage,businesstrip-add,businesstrip-edit,businesstrip-view,businesstrip-approval,goout-manage,goout-add,goout-edit,goout-view,goout-approval,oagood-manage,oagood-add,oagood-edit,oagood-view,oagood-approval,knowledge-manage,knowledge-add,knowledge-edit,album-manage,album-upload,album-edit', '项目管理-project-book||project-manage,考勤管理-checkwork-tasks||checkwork-list,审批管理-approval-suitcase||#,知识分享-knowledge-tasks||knowledge-list,员工相册-album-plane||album-list', '请假-approval||leave-manage,加班-approval||overtime-manage,报销-approval||expense-manage,出差-approval||businesstrip-manage,外出-approval||goout-manage,物品-approval||oagood-manage');
INSERT INTO `pms_users_permissions` VALUES ('1468140265954907628', 'project-team,team-add,team-delete,project-need,need-add,need-edit,project-task,task-add,task-edit,project-test,test-add,test-edit,checkwork-manage,checkwork-all,message-manage,message-delete,leave-manage,leave-add,leave-edit,leave-view,leave-approval,overtime-manage,overtime-add,overtime-edit,overtime-view,overtime-approval,expense-manage,expense-add,expense-edit,expense-view,expense-approval,businesstrip-manage,businesstrip-add,businesstrip-edit,businesstrip-view,businesstrip-approval,goout-manage,goout-add,goout-edit,goout-view,goout-approval,oagood-manage,oagood-add,oagood-edit,oagood-view,oagood-approval,knowledge-manage,knowledge-add,knowledge-edit,album-manage,album-upload,album-edit', '项目管理-project-book||project-manage,考勤管理-checkwork-tasks||checkwork-list,审批管理-approval-suitcase||#,知识分享-knowledge-tasks||knowledge-list,员工相册-album-plane||album-list', '请假-approval||leave-manage,加班-approval||overtime-manage,报销-approval||expense-manage,出差-approval||businesstrip-manage,外出-approval||goout-manage,物品-approval||oagood-manage');
INSERT INTO `pms_users_permissions` VALUES ('1468915433602979028', 'project-team,team-add,team-delete,project-need,need-add,need-edit,project-task,task-add,task-edit,project-test,test-add,test-edit,leave-manage,leave-add,leave-edit,leave-view,leave-approval,overtime-manage,overtime-add,overtime-edit,overtime-view,overtime-approval,expense-manage,expense-add,expense-edit,expense-view,expense-approval,businesstrip-manage,businesstrip-add,businesstrip-edit,businesstrip-view,businesstrip-approval,goout-manage,goout-add,goout-edit,goout-view,goout-approval,oagood-manage,oagood-add,oagood-edit,oagood-view,oagood-approval,knowledge-manage,knowledge-add,knowledge-edit,album-manage,album-upload,album-edit', '项目管理-project-book||project-manage,审批管理-approval-suitcase||#,知识分享-knowledge-tasks||knowledge-list,员工相册-album-plane||album-list', '请假-approval||leave-manage,加班-approval||overtime-manage,报销-approval||expense-manage,出差-approval||businesstrip-manage,外出-approval||goout-manage,物品-approval||oagood-manage');
INSERT INTO `pms_users_permissions` VALUES ('1469024587469707428', 'project-team,team-add,team-delete,project-need,need-add,need-edit,project-task,task-add,task-edit,project-test,test-add,test-edit,leave-manage,leave-add,leave-edit,leave-view,leave-approval,overtime-manage,overtime-add,overtime-edit,overtime-view,overtime-approval,expense-manage,expense-add,expense-edit,expense-view,expense-approval,businesstrip-manage,businesstrip-add,businesstrip-edit,businesstrip-view,businesstrip-approval,goout-manage,goout-add,goout-edit,goout-view,goout-approval,oagood-manage,oagood-add,oagood-edit,oagood-view,oagood-approval,knowledge-manage,knowledge-add,knowledge-edit,album-manage,album-upload,album-edit', '项目管理-project-book||project-manage,审批管理-approval-suitcase||#,知识分享-knowledge-tasks||knowledge-list,员工相册-album-plane||album-list', '请假-approval||leave-manage,加班-approval||overtime-manage,报销-approval||expense-manage,出差-approval||businesstrip-manage,外出-approval||goout-manage,物品-approval||oagood-manage');

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
INSERT INTO `pms_users_profile` VALUES ('65140463652311040', 'lock', '1', '1993-03-06', 'lock888@tom.com', '', '', '13524612512', '', '', 'lock', '13524396382', '1462290127694985332', '1462292065226423828', '0', '', '0');
INSERT INTO `pms_users_profile` VALUES ('1461312703628858832', '李白', '1', '1985-12-12', 'test@163.com', 'milu365', '49732343', '13754396432', '021-3432423', '九新公路华西办公楼7楼', 'zfancy', '137245613126', '1462290228639093428', '1462292041515367932', '1', '', '1490691863');
INSERT INTO `pms_users_profile` VALUES ('1467191338628906628', '张三', '1', '1985-12-12', 'test@test.com', 'zs-milu365', '903561702', '13524512531', '021-84122521', '九新公路', 'lock', '135245132623', '1462290199274575028', '1462292041515367932', '0', '', '0');
INSERT INTO `pms_users_profile` VALUES ('1468140265954907628', '李四', '1', '1994-08-11', 'cto@nahehuo.com', 'zs-milu365', '903561702', '13524396586', '021-84122521', '九新公路华西办公楼', 'lock', '135245132623', '1462290127694985332', '1462292053049130632', '0', '', '0');
INSERT INTO `pms_users_profile` VALUES ('1468915433602979028', '朱笑天', '1', '1992-09-10', 'test@test.coma', 'zs-milu365', '903561702', '13524512531', '021-84122521', '外滩一号', 'lock', '135245132623', '1462290199274575028', '1462292041515367932', '0', '', '0');
INSERT INTO `pms_users_profile` VALUES ('1469024587469707428', '李浩', '1', '1997-09-06', 'test@test.com', 'ls-milu365', '903561702', '13521234231', '021-84122521', '外滩一号', '李呀', '135245132623', '1462290228639093428', '1462292006260420932', '1', '', '1490691365');
