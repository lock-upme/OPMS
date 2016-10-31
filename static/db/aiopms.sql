/*
Navicat MySQL Data Transfer

Source Server         : z-local
Source Server Version : 50626
Source Host           : localhost:3306
Source Database       : aiopms

Target Server Type    : MYSQL
Target Server Version : 50626
File Encoding         : 65001

Date: 2016-10-21 15:46:06
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
INSERT INTO `pms_albums` VALUES ('1468934759849234932', '1461312703628858832', '美丽的背后', '/static/uploadfile/2016-9/28/d1bb6059a54a832f8542a9389d5ffcd3.jpg', '', '我想知道相片背后的故事', '1475046528', '16', '1', '2', '1');

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
INSERT INTO `pms_albums_comment` VALUES ('9305470284075008', '1468140265954907628', '1468934759849234932', '这个好美~', '1477021485', '1');

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
INSERT INTO `pms_albums_laud` VALUES ('9026951792562176', '1461312703628858832', '1468934759849234932', '1476955081', '1');
INSERT INTO `pms_albums_laud` VALUES ('9305430773731328', '1468140265954907628', '1468934759849234932', '1477021475', '1');

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
INSERT INTO `pms_businesstrips` VALUES ('1468755197309162132', '1461312703628858832', '10.2||20', '活动经费||服务费', '10.2的活动经费||20的服务经费', '30', null, '', '1', '2', '1468140265954907628,1467191338628906628', '1474866966', '1474879081');
INSERT INTO `pms_businesstrips` VALUES ('1468842643441590032', '1461312703628858832', '河北||北京', '2016-09-28||2016-09-30', '2016-09-29||2016-10-31', '3', '项目洽谈', '/static/uploadfile/2016-9/27/2.jpg', '1', '2', '1468140265954907628,1467191338628906628', '1474954412', '1474954460');

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
INSERT INTO `pms_businesstrips_approver` VALUES ('1468755197373479132', '1468755197309162132', '1468140265954907628', '魂牵梦萦', '1', '1474866966', '1474882786');
INSERT INTO `pms_businesstrips_approver` VALUES ('1468755197443881232', '1468755197309162132', '1467191338628906628', '同意', '1', '1474866966', '1474883614');
INSERT INTO `pms_businesstrips_approver` VALUES ('1468842643488774532', '1468842643441590032', '1468140265954907628', '可以~', '1', '1474954412', '1474955131');
INSERT INTO `pms_businesstrips_approver` VALUES ('1468842643513491432', '1468842643441590032', '1467191338628906628', 'ok', '1', '1474954412', '1477029517');

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
INSERT INTO `pms_checkworks` VALUES ('8568693101432832', '1461312703628858832', '10:57:03', '2', '127.0.0.1', '1476845823');
INSERT INTO `pms_checkworks` VALUES ('8568702534422528', '1461312703628858832', '10:57:05', '3', '127.0.0.1', '1476845825');
INSERT INTO `pms_checkworks` VALUES ('8906461258190848', '1461312703628858832', '09:19:14', '2', '127.0.0.1', '1476926353');
INSERT INTO `pms_checkworks` VALUES ('9335379463245824', '1461312703628858832', '13:43:36', '2', '127.0.0.1', '1477028615');
INSERT INTO `pms_checkworks` VALUES ('9358014863642624', '1461312703628858832', '08:00:03', '3', '127.0.0.1', '1477034012');

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
INSERT INTO `pms_expenses` VALUES ('1468755197309162132', '1461312703628858832', '10.2||20', '活动经费||服务费', '10.2的活动经费||20的服务经费', '30.2', '', '1', '2', '1468140265954907628,1467191338628906628', '1474866966', '1474879081');

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
INSERT INTO `pms_expenses_approver` VALUES ('1468755197373479132', '1468755197309162132', '1468140265954907628', '魂牵梦萦', '1', '1474866966', '1474882786');
INSERT INTO `pms_expenses_approver` VALUES ('1468755197443881232', '1468755197309162132', '1467191338628906628', '同意', '1', '1474866966', '1474883614');

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
INSERT INTO `pms_goouts` VALUES ('1468852391078933228', '1461312703628858832', '1474963200', '1474970400', '2', '大师傅城标魂牵梦萦', '', '1', '2', '1467191338628906628', '1474964159', '1474964172');
INSERT INTO `pms_goouts` VALUES ('1468853987531273432', '1461312703628858832', '1474966800', '1474970400', '1', 'test', '', '0', '2', '1468140265954907628', '1474965756', '1474965756');

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
INSERT INTO `pms_goouts_approver` VALUES ('1468852391132927432', '1468852391078933228', '1467191338628906628', 'ok', '1', '1474964159', '1474964213');
INSERT INTO `pms_goouts_approver` VALUES ('1468853987584299228', '1468853987531273432', '1468140265954907628', '', '0', '1474965756', '1474965756');

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
INSERT INTO `pms_knowledges` VALUES ('1468921601280784732', '1461312703628858832', '4', 'lockPHP框架升级2.0', 'php', '全新lockPHP框架升级2.0', 'https://my.oschina.net/lockupme/blog/745074', '', '<p style=\"box-sizing:inherit;-webkit-tap-highlight-color:transparent;margin-bottom:16px;color:#3D464D;font-family:&quot;font-size:16px;line-height:28px;white-space:normal;background-color:#F8F8F8;\">\n	之前一直没有维护lockPHP，最近项目中一直在使用并做了一些更改与升级\n</p>\n<p style=\"box-sizing:inherit;-webkit-tap-highlight-color:transparent;margin-bottom:16px;color:#3D464D;font-family:&quot;font-size:16px;line-height:28px;white-space:normal;background-color:#F8F8F8;\">\n	github地址：<a href=\"https://github.com/lock-upme/lockphp\" target=\"_blank\" rel=\"nofollow\" style=\"box-sizing:inherit;-webkit-tap-highlight-color:transparent;outline:0px;border:none;text-decoration:none;color:#4466BB;transition:color 0.3s;\">https://github.com/lock-upme/lockphp</a>\n</p>\n<p style=\"box-sizing:inherit;-webkit-tap-highlight-color:transparent;margin-bottom:16px;color:#3D464D;font-family:&quot;font-size:16px;line-height:28px;white-space:normal;background-color:#F8F8F8;\">\n	下一步会升级到\n</p>\n<p style=\"box-sizing:inherit;-webkit-tap-highlight-color:transparent;margin-bottom:16px;color:#3D464D;font-family:&quot;font-size:16px;line-height:28px;white-space:normal;background-color:#F8F8F8;\">\n	1.pdo\n</p>\n<p style=\"box-sizing:inherit;-webkit-tap-highlight-color:transparent;margin-bottom:16px;color:#3D464D;font-family:&quot;font-size:16px;line-height:28px;white-space:normal;background-color:#F8F8F8;\">\n	2.lock引用优化\n</p>\n<p style=\"box-sizing:inherit;-webkit-tap-highlight-color:transparent;margin-bottom:16px;color:#3D464D;font-family:&quot;font-size:16px;line-height:28px;white-space:normal;background-color:#F8F8F8;\">\n	3.添加命名空间\n</p>', '21', '3', '1', '1', '1', '1475033370', '1475051052');
INSERT INTO `pms_knowledges` VALUES ('1468921646897369828', '1461312703628858832', '4', '13 款开源的全文搜索引擎', '全文 搜索引擎', '主要介绍13款现有的开源搜索引擎，你可以将它们用在你的项目中以实现检索功能。', 'http://www.open-open.com/news/view/e36182', '', '<div class=\"inner\" style=\"box-sizing:border-box;color:#333333;font-family:&quot;font-size:14px;line-height:20px;white-space:normal;\">\n	<span style=\"box-sizing:border-box;font-weight:700;\">1.&nbsp; Lucene</span>&nbsp;<br style=\"box-sizing:border-box;\" />\n<br style=\"box-sizing:border-box;\" />\nLucene的开发语言是Java，也是Java家族中最为出名的一个开源搜索引擎，在Java世界中已经是标准的全文检索程序，它提供了完整的查询引擎和索引引擎，没有中文分词引擎，需要自己去实现，因此用Lucene去做一个搜素引擎需要自己去架构.另外它不支持实时搜索，但linkedin和twitter有分别对Lucene改进的实时搜素. 其中Lucene有一个C++移植版本叫CLucene，CLucene因为使用C++编写，所以理论上要比lucene快.&nbsp;<br style=\"box-sizing:border-box;\" />\n<br style=\"box-sizing:border-box;\" />\n官方主页：<a href=\"http://lucene.apache.org/\" target=\"_blank\" style=\"box-sizing:border-box;color:#EE6E50 !important;\">http://lucene.apache.org/</a>&nbsp;<br style=\"box-sizing:border-box;\" />\n<br style=\"box-sizing:border-box;\" />\nCLucene官方主页：<a href=\"http://sourceforge.net/projects/clucene/\" target=\"_blank\" style=\"box-sizing:border-box;color:#EE6E50 !important;\">http://sourceforge.net/projects/clucene/</a>&nbsp;<br style=\"box-sizing:border-box;\" />\n<br style=\"box-sizing:border-box;\" />\n<span style=\"box-sizing:border-box;font-weight:700;\">2.&nbsp; Sphinx</span>&nbsp;<br style=\"box-sizing:border-box;\" />\n<br style=\"box-sizing:border-box;\" />\nSphinx是一个用C++语言写的开源搜索引擎，也是现在比较主流的搜索引擎之一，在建立索引的事件方面比Lucene快50%，但是索引文件比Lucene要大一倍，因此Sphinx在索引的建立方面是空间换取事件的策略，在检索速度上，和lucene相差不大，但检索精准度方面Lucene要优于Sphinx，另外在加入中文分词引擎难度方面，Lucene要优于Sphinx.其中Sphinx支持实时搜索，使用起来比较简单方便.&nbsp;<br style=\"box-sizing:border-box;\" />\n<br style=\"box-sizing:border-box;\" />\n官方主页：<a href=\"http://sphinxsearch.com/about/sphinx/\" target=\"_blank\" style=\"box-sizing:border-box;color:#EE6E50 !important;\">http://sphinxsearch.com/about/sphinx/</a>&nbsp;<br style=\"box-sizing:border-box;\" />\n<br style=\"box-sizing:border-box;\" />\n<span style=\"box-sizing:border-box;font-weight:700;\">3.&nbsp; Xapian</span>&nbsp;<br style=\"box-sizing:border-box;\" />\n<br style=\"box-sizing:border-box;\" />\nXapian是一个用C++编写的全文检索程序，它的api和检索原理和lucene在很多方面都很相似，算是填补了lucene在C++中的一个空缺.&nbsp;<br style=\"box-sizing:border-box;\" />\n<br style=\"box-sizing:border-box;\" />\n官方主页：<a href=\"http://xapian.org/\" target=\"_blank\" style=\"box-sizing:border-box;color:#EE6E50 !important;\">http://xapian.org/</a>&nbsp;<br style=\"box-sizing:border-box;\" />\n<br style=\"box-sizing:border-box;\" />\n<span style=\"box-sizing:border-box;font-weight:700;\">4.&nbsp; Nutch</span>&nbsp;<br style=\"box-sizing:border-box;\" />\n<br style=\"box-sizing:border-box;\" />\nNutch是一个用java实现的开源的web搜索引擎，包括爬虫crawler，索引引擎，查询引擎. 其中Nutch是基于Lucene的，Lucene为Nutch提供了文本索引和搜索的API.&nbsp;<br style=\"box-sizing:border-box;\" />\n<br style=\"box-sizing:border-box;\" />\n对于应该使用Lucene还是使用Nutch，应该是如果你不需要抓取数据的话，应该使用Lucene，最常见的应用是：你有数据源，需要为这些数据提供一个搜索页面，在这种情况下，最好的方式是直接从数据库中取出数据，并用Lucene API建立索引.&nbsp;<br style=\"box-sizing:border-box;\" />\n<br style=\"box-sizing:border-box;\" />\n官方主页：<a href=\"http://nutch.apache.org/\" target=\"_blank\" style=\"box-sizing:border-box;color:#EE6E50 !important;\">http://nutch.apache.org/</a>&nbsp;<br style=\"box-sizing:border-box;\" />\n<br style=\"box-sizing:border-box;\" />\n<span style=\"box-sizing:border-box;font-weight:700;\">5.&nbsp; DataparkSearch</span>&nbsp;<br style=\"box-sizing:border-box;\" />\n<br style=\"box-sizing:border-box;\" />\nDataparkSearch是一个用C语言实现的开源的搜索引擎. 其中网页排序是采用神经网络模型.&nbsp; 其中支持HTTP，HTTPS，FTP，NNTP等下载网页.包括索引引擎，检索引擎和中文分词引擎(这个也是唯一的一个开源的搜索引擎里有中文分词引擎).能个性化定制搜索结果，拥有完整的日志记录.&nbsp;<br style=\"box-sizing:border-box;\" />\n<br style=\"box-sizing:border-box;\" />\n官方主页：<a href=\"http://www.dataparksearch.org/\" target=\"_blank\" style=\"box-sizing:border-box;color:#EE6E50 !important;\">http://www.dataparksearch.org/</a>&nbsp;<br style=\"box-sizing:border-box;\" />\n<br style=\"box-sizing:border-box;\" />\n<span style=\"box-sizing:border-box;font-weight:700;\">6.&nbsp; Zettair</span>&nbsp;<br style=\"box-sizing:border-box;\" />\n<br style=\"box-sizing:border-box;\" />\nZettair是根据Justin Zobel的研究成果为基础的全文检索实验系统.它是用C语言实现的. 其中Justin Zobel在全文检索领域很有名气，是业界第一个系统提出倒排序索引差分压缩算法的人，倒排列表的压缩大大提高了检索和加载的性能，同时空间膨胀率也缩小到相当优秀的水平. 由于Zettair是源于学术界，代码是由RMIT University的搜索引擎组织写的，因此它的代码简洁精炼，算法高效，是学习倒排索引经典算法的非常好的实例. 其中支持linux，windows，mac os等系统.&nbsp;<br style=\"box-sizing:border-box;\" />\n<br style=\"box-sizing:border-box;\" />\n官方主页：<a href=\"http://www.seg.rmit.edu.au/zettair/about.html\" target=\"_blank\" style=\"box-sizing:border-box;color:#EE6E50 !important;\">http://www.seg.rmit.edu.au/zettair/about.html</a>&nbsp;<br style=\"box-sizing:border-box;\" />\n<br style=\"box-sizing:border-box;\" />\n<span style=\"box-sizing:border-box;font-weight:700;\">7.&nbsp; Indri</span>&nbsp;<br style=\"box-sizing:border-box;\" />\n<br style=\"box-sizing:border-box;\" />\nIndri是一个用C语言和C++语言写的全文检索引擎系统，是由University of Massachusetts和Carnegie Mellon University合作推出的一个开源项目. 特点是跨平台，API接口支持Java，PHP，C++.&nbsp;<br style=\"box-sizing:border-box;\" />\n<br style=\"box-sizing:border-box;\" />\n官方主页：<a href=\"http://www.lemurproject.org/indri/\" target=\"_blank\" style=\"box-sizing:border-box;color:#EE6E50 !important;\">http://www.lemurproject.org/indri/</a>&nbsp;<br style=\"box-sizing:border-box;\" />\n<br style=\"box-sizing:border-box;\" />\n<span style=\"box-sizing:border-box;font-weight:700;\">8.&nbsp; Terrier</span>&nbsp;<br style=\"box-sizing:border-box;\" />\n<br style=\"box-sizing:border-box;\" />\nTerrier是由School of Computing Science，Universityof Glasgow用java开发的一个全文检索系统.&nbsp;<br style=\"box-sizing:border-box;\" />\n<br style=\"box-sizing:border-box;\" />\n官方主页：<a href=\"http://terrier.org/\" target=\"_blank\" style=\"box-sizing:border-box;color:#EE6E50 !important;\">http://terrier.org/</a>&nbsp;<br style=\"box-sizing:border-box;\" />\n<br style=\"box-sizing:border-box;\" />\n<span style=\"box-sizing:border-box;font-weight:700;\">9.&nbsp; Galago</span>&nbsp;<br style=\"box-sizing:border-box;\" />\n<br style=\"box-sizing:border-box;\" />\nGalago是一个用java语言写的关于文本搜索的工具集. 其中包括索引引擎和查询引擎，还包括一个叫TupleFlow的分布式计算框架(和google的MapReduce很像).这个检索系统支持很多Indri查询语言.&nbsp;<br style=\"box-sizing:border-box;\" />\n<br style=\"box-sizing:border-box;\" />\n官方主页：<a href=\"http://www.galagosearch.org/\" target=\"_blank\" style=\"box-sizing:border-box;color:#EE6E50 !important;\">http://www.galagosearch.org/</a>&nbsp;<br style=\"box-sizing:border-box;\" />\n<br style=\"box-sizing:border-box;\" />\n<span style=\"box-sizing:border-box;font-weight:700;\">10.&nbsp; Zebra</span>&nbsp;<br style=\"box-sizing:border-box;\" />\n<br style=\"box-sizing:border-box;\" />\nZebra是一个用C语言实现的检索程序，特点是对大数据的支持，支持EMAIL，XML，MARC等格式的数据.&nbsp;<br style=\"box-sizing:border-box;\" />\n<br style=\"box-sizing:border-box;\" />\n官方主页：<a href=\"https://www.indexdata.com/zebra\" target=\"_blank\" style=\"box-sizing:border-box;color:#EE6E50 !important;\">https://www.indexdata.com/zebra</a>&nbsp;<br style=\"box-sizing:border-box;\" />\n<br style=\"box-sizing:border-box;\" />\n<span style=\"box-sizing:border-box;font-weight:700;\">11.&nbsp; Solr</span>&nbsp;<br style=\"box-sizing:border-box;\" />\n<br style=\"box-sizing:border-box;\" />\nSolr是一个用java开发的独立的企业级搜索应用服务器，它提供了类似于Web-service的API接口，它是基于Lucene的全文检索服务器，也算是Lucene的一个变种，很多一线互联网公司都在使用Solr，也算是一种成熟的解决方案.&nbsp;<br style=\"box-sizing:border-box;\" />\n<br style=\"box-sizing:border-box;\" />\n官方主页：<a href=\"http://lucene.apache.org/solr/\" target=\"_blank\" style=\"box-sizing:border-box;color:#EE6E50 !important;\">http://lucene.apache.org/solr/</a>&nbsp;<br style=\"box-sizing:border-box;\" />\n<br style=\"box-sizing:border-box;\" />\n<span style=\"box-sizing:border-box;font-weight:700;\">12.&nbsp; Elasticsearch</span>&nbsp;<br style=\"box-sizing:border-box;\" />\n<br style=\"box-sizing:border-box;\" />\nElasticsearch是一个采用java语言开发的，基于Lucene构造的开源，分布式的搜索引擎. 设计用于云计算中，能够达到实时搜索，稳定可靠. Elasticsearch的数据模型是JSON.&nbsp;<br style=\"box-sizing:border-box;\" />\n<br style=\"box-sizing:border-box;\" />\n官方主页：<a href=\"http://www.elasticsearch.org/\" target=\"_blank\" style=\"box-sizing:border-box;color:#EE6E50 !important;\">http://www.elasticsearch.org/</a>&nbsp;<br style=\"box-sizing:border-box;\" />\n<br style=\"box-sizing:border-box;\" />\n<span style=\"box-sizing:border-box;font-weight:700;\">13.&nbsp; Whoosh</span>&nbsp;<br style=\"box-sizing:border-box;\" />\n<br style=\"box-sizing:border-box;\" />\nWhoosh是一个用纯python写的开源搜索引擎.&nbsp;<br style=\"box-sizing:border-box;\" />\n<br style=\"box-sizing:border-box;\" />\n官方主页：<a href=\"https://bitbucket.org/mchaput/whoosh/wiki/Home\" target=\"_blank\" style=\"box-sizing:border-box;color:#EE6E50 !important;\">https://bitbucket.org/mchaput/whoosh/wiki/Home</a>\n</div>\n<div class=\"post-tags\" style=\"box-sizing:border-box;margin-bottom:20px;color:#333333;font-family:&quot;font-size:14px;line-height:20px;white-space:normal;\">\n	<a href=\"http://www.open-open.com/news/tags/%E5%85%A8%E6%96%87%E6%90%9C%E7%B4%A2\" style=\"box-sizing:border-box;color:#EE6E50 !important;\">全文搜索</a>\n</div>', '6', '0', '0', '1', '1', '1475033415', '1475050979');
INSERT INTO `pms_knowledges` VALUES ('1468931070950897432', '1468915433602979028', '4', ' MongoDB自增主键id生成器', 'mongodb', 'mongodb不支持事务，所以，在你的项目中应用时，要注意这点。无论什么设计，都不要要求mongodb保证数据的完整性。', 'https://my.oschina.net/lockupme/blog/650734', '', '<p>\n	<p style=\"box-sizing:inherit;-webkit-tap-highlight-color:transparent;margin-bottom:16px;color:#3D464D;font-family:\'Pingfang SC\', STHeiti, \'Lantinghei SC\', \'Open Sans\', Arial, \'Hiragino Sans GB\', \'Microsoft YaHei\', \'WenQuanYi Micro Hei\', SimSun, sans-serif;font-size:16px;line-height:28px;white-space:normal;background-color:#F8F8F8;\">\n		参考地址：\n	</p>\n	<p style=\"box-sizing:inherit;-webkit-tap-highlight-color:transparent;margin-bottom:16px;color:#3D464D;font-family:\'Pingfang SC\', STHeiti, \'Lantinghei SC\', \'Open Sans\', Arial, \'Hiragino Sans GB\', \'Microsoft YaHei\', \'WenQuanYi Micro Hei\', SimSun, sans-serif;font-size:16px;line-height:28px;white-space:normal;background-color:#F8F8F8;\">\n		<a href=\"http://www.runoob.com/mongodb/mongodb-atomic-operations.html\" rel=\"nofollow\" style=\"box-sizing:inherit;-webkit-tap-highlight-color:transparent;outline:0px;border:none;text-decoration:none;color:#4466BB;transition:color 0.3s;\">http://www.runoob.com/mongodb/mongodb-atomic-operations.html</a>\n	</p>\n	<p style=\"box-sizing:inherit;-webkit-tap-highlight-color:transparent;margin-bottom:16px;color:#3D464D;font-family:\'Pingfang SC\', STHeiti, \'Lantinghei SC\', \'Open Sans\', Arial, \'Hiragino Sans GB\', \'Microsoft YaHei\', \'WenQuanYi Micro Hei\', SimSun, sans-serif;font-size:16px;line-height:28px;white-space:normal;background-color:#F8F8F8;\">\n		mongodb不支持事务，所以，在你的项目中应用时，要注意这点。无论什么设计，都不要要求mongodb保证数据的完整性。\n	</p>\n	<p style=\"box-sizing:inherit;-webkit-tap-highlight-color:transparent;margin-bottom:16px;color:#3D464D;font-family:\'Pingfang SC\', STHeiti, \'Lantinghei SC\', \'Open Sans\', Arial, \'Hiragino Sans GB\', \'Microsoft YaHei\', \'WenQuanYi Micro Hei\', SimSun, sans-serif;font-size:16px;line-height:28px;white-space:normal;background-color:#F8F8F8;\">\n		但是mongodb提供了许多原子操作，比如文档的保存，修改，删除等，都是原子操作。\n	</p>\n	<p style=\"box-sizing:inherit;-webkit-tap-highlight-color:transparent;margin-bottom:16px;color:#3D464D;font-family:\'Pingfang SC\', STHeiti, \'Lantinghei SC\', \'Open Sans\', Arial, \'Hiragino Sans GB\', \'Microsoft YaHei\', \'WenQuanYi Micro Hei\', SimSun, sans-serif;font-size:16px;line-height:28px;white-space:normal;background-color:#F8F8F8;\">\n		所谓原子操作就是要么这个文档保存到Mongodb，要么没有保存到Mongodb，不会出现查询到的文档没有保存完整的情况。\n	</p>\n	<p style=\"box-sizing:inherit;-webkit-tap-highlight-color:transparent;margin-bottom:16px;color:#3D464D;font-family:\'Pingfang SC\', STHeiti, \'Lantinghei SC\', \'Open Sans\', Arial, \'Hiragino Sans GB\', \'Microsoft YaHei\', \'WenQuanYi Micro Hei\', SimSun, sans-serif;font-size:16px;line-height:28px;white-space:normal;background-color:#F8F8F8;\">\n		<span style=\"box-sizing:inherit;-webkit-tap-highlight-color:transparent;line-height:22.5px;\">原子操作：</span>\n	</p>\n<span id=\"OSC_h4_1\" style=\"box-sizing:inherit;-webkit-tap-highlight-color:transparent;color:#3D464D;font-family:\'Pingfang SC\', STHeiti, \'Lantinghei SC\', \'Open Sans\', Arial, \'Hiragino Sans GB\', \'Microsoft YaHei\', \'WenQuanYi Micro Hei\', SimSun, sans-serif;font-size:16px;line-height:28px;white-space:normal;background-color:#F8F8F8;\"></span><span style=\"color:#3D464D;font-family:\'Pingfang SC\', STHeiti, \'Lantinghei SC\', \'Open Sans\', Arial, \'Hiragino Sans GB\', \'Microsoft YaHei\', \'WenQuanYi Micro Hei\', SimSun, sans-serif;font-size:16px;line-height:28px;white-space:normal;background-color:#F8F8F8;\"></span>\n	<h4 id=\"h4_0\" style=\"box-sizing:inherit;-webkit-tap-highlight-color:transparent;font-size:16px;font-weight:500;color:#3D464D;font-family:\'Pingfang SC\', STHeiti, \'Lantinghei SC\', \'Open Sans\', Arial, \'Hiragino Sans GB\', \'Microsoft YaHei\', \'WenQuanYi Micro Hei\', SimSun, sans-serif;line-height:28px;white-space:normal;background-color:#F8F8F8;\">\n		$inc\n	</h4>\n	<p style=\"box-sizing:inherit;-webkit-tap-highlight-color:transparent;margin-bottom:0px;white-space:normal;border:0px;margin-top:0px;padding:0px;line-height:2em;font-family:\'Microsoft Yahei\', \'Helvetica Neue\', Helvetica, Arial, sans-serif;color:#333333;background-color:#FFFFFF;\">\n		$inc可以对文档的某个值为数字型（只能为满足要求的数字）的键进行增减的操作。\n	</p>\n	<p style=\"box-sizing:inherit;-webkit-tap-highlight-color:transparent;margin-bottom:0px;white-space:normal;border:0px;margin-top:0px;padding:0px;line-height:2em;font-family:\'Microsoft Yahei\', \'Helvetica Neue\', Helvetica, Arial, sans-serif;color:#333333;background-color:#FFFFFF;\">\n		<br />\n	</p>\n	<p style=\"box-sizing:inherit;-webkit-tap-highlight-color:transparent;margin-bottom:0px;white-space:normal;border:0px;margin-top:0px;padding:0px;line-height:2em;font-family:\'Microsoft Yahei\', \'Helvetica Neue\', Helvetica, Arial, sans-serif;color:#333333;background-color:#FFFFFF;\">\n		php方法，会自动生成一张集合\n	</p>\n<pre class=\"brush:php;toolbar: true; auto-links: false; hljs\" style=\"box-sizing:inherit;-webkit-tap-highlight-color:transparent;overflow-x:auto;padding:2px;color:#DCDCDC;border-radius:3px;line-height:1.4;word-wrap:normal;font-size:13px;font-family:Menlo, Monaco, Consolas, \'Courier New\', monospace;background:#3F3F3F;\"><code class=\"hljs php\" style=\"box-sizing:inherit;-webkit-tap-highlight-color:transparent;display:block;overflow-x:auto;padding:10px;border-radius:4px;line-height:1.4;word-wrap:normal;font-family:Menlo, Monaco, Consolas, \'Courier New\', monospace;background-image:initial;background-attachment:initial;background-size:initial;background-origin:initial;background-clip:initial;background-position:initial;background-repeat:initial;\"><span class=\"hljs-function\" style=\"box-sizing:inherit;-webkit-tap-highlight-color:transparent;\"><span class=\"hljs-keyword\" style=\"box-sizing:inherit;-webkit-tap-highlight-color:transparent;color:#E3CEAB;\"><span class=\"hljs-function\" style=\"box-sizing:inherit;-webkit-tap-highlight-color:transparent;\"><span class=\"hljs-keyword\" style=\"box-sizing:inherit;-webkit-tap-highlight-color:transparent;\">function</span></span></span><span class=\"hljs-function\" style=\"box-sizing:inherit;-webkit-tap-highlight-color:transparent;\">&nbsp;</span><span class=\"hljs-title\" style=\"box-sizing:inherit;-webkit-tap-highlight-color:transparent;color:#EFEF8F;\"><span class=\"hljs-function\" style=\"box-sizing:inherit;-webkit-tap-highlight-color:transparent;\"><span class=\"hljs-title\" style=\"box-sizing:inherit;-webkit-tap-highlight-color:transparent;\">autoId</span></span></span><span class=\"hljs-params\" style=\"box-sizing:inherit;-webkit-tap-highlight-color:transparent;\"><span class=\"hljs-function\" style=\"box-sizing:inherit;-webkit-tap-highlight-color:transparent;\"><span class=\"hljs-params\" style=\"box-sizing:inherit;-webkit-tap-highlight-color:transparent;\">($name,&nbsp;$db)</span></span></span></span>{\n	&nbsp;&nbsp;&nbsp;	$update&nbsp;=&nbsp;<span class=\"hljs-keyword\" style=\"box-sizing:inherit;-webkit-tap-highlight-color:transparent;color:#E3CEAB;\">array</span>(<span class=\"hljs-string\" style=\"box-sizing:inherit;-webkit-tap-highlight-color:transparent;color:#CC9393;\">\'$inc\'</span>=&gt;<span class=\"hljs-keyword\" style=\"box-sizing:inherit;-webkit-tap-highlight-color:transparent;color:#E3CEAB;\">array</span>(<span class=\"hljs-string\" style=\"box-sizing:inherit;-webkit-tap-highlight-color:transparent;color:#CC9393;\">\"id\"</span>=&gt;<span class=\"hljs-number\" style=\"box-sizing:inherit;-webkit-tap-highlight-color:transparent;color:#8CD0D3;\">1</span>));\n	&nbsp;&nbsp;&nbsp;	$query&nbsp;=&nbsp;<span class=\"hljs-keyword\" style=\"box-sizing:inherit;-webkit-tap-highlight-color:transparent;color:#E3CEAB;\">array</span>(<span class=\"hljs-string\" style=\"box-sizing:inherit;-webkit-tap-highlight-color:transparent;color:#CC9393;\">\'name\'</span>=&gt;$name);\n	&nbsp;&nbsp;&nbsp;	$command&nbsp;=&nbsp;<span class=\"hljs-keyword\" style=\"box-sizing:inherit;-webkit-tap-highlight-color:transparent;color:#E3CEAB;\">array</span>(\n	&nbsp;&nbsp;&nbsp; <span class=\"hljs-string\" style=\"box-sizing:inherit;-webkit-tap-highlight-color:transparent;color:#CC9393;\">\'findandmodify\'</span>=&gt;<span class=\"hljs-string\" style=\"box-sizing:inherit;-webkit-tap-highlight-color:transparent;color:#CC9393;\">\'autoIds\'</span>,&nbsp;<span class=\"hljs-string\" style=\"box-sizing:inherit;-webkit-tap-highlight-color:transparent;color:#CC9393;\">\'update\'</span>=&gt;$update,\n	&nbsp;&nbsp;&nbsp; <span class=\"hljs-string\" style=\"box-sizing:inherit;-webkit-tap-highlight-color:transparent;color:#CC9393;\">\'query\'</span>=&gt;$query,&nbsp;<span class=\"hljs-string\" style=\"box-sizing:inherit;-webkit-tap-highlight-color:transparent;color:#CC9393;\">\'new\'</span>=&gt;<span class=\"hljs-keyword\" style=\"box-sizing:inherit;-webkit-tap-highlight-color:transparent;color:#E3CEAB;\">true</span>,&nbsp;<span class=\"hljs-string\" style=\"box-sizing:inherit;-webkit-tap-highlight-color:transparent;color:#CC9393;\">\'upsert\'</span>=&gt;<span class=\"hljs-keyword\" style=\"box-sizing:inherit;-webkit-tap-highlight-color:transparent;color:#E3CEAB;\">true</span> &nbsp;&nbsp;&nbsp;	);\n	&nbsp;&nbsp;&nbsp;	$id&nbsp;=&nbsp;$db-&gt;command($command);\n	&nbsp;&nbsp;&nbsp; <span class=\"hljs-keyword\" style=\"box-sizing:inherit;-webkit-tap-highlight-color:transparent;color:#E3CEAB;\">return</span>&nbsp;$id[<span class=\"hljs-string\" style=\"box-sizing:inherit;-webkit-tap-highlight-color:transparent;color:#CC9393;\">\'value\'</span>][<span class=\"hljs-string\" style=\"box-sizing:inherit;-webkit-tap-highlight-color:transparent;color:#CC9393;\">\'id\'</span>];\n&nbsp;&nbsp;&nbsp;}</code></pre>\n	<p style=\"box-sizing:inherit;-webkit-tap-highlight-color:transparent;margin-bottom:16px;color:#3D464D;font-family:\'Pingfang SC\', STHeiti, \'Lantinghei SC\', \'Open Sans\', Arial, \'Hiragino Sans GB\', \'Microsoft YaHei\', \'WenQuanYi Micro Hei\', SimSun, sans-serif;font-size:16px;line-height:28px;white-space:normal;background-color:#F8F8F8;\">\n		<br />\n	</p>\n	<p style=\"box-sizing:inherit;-webkit-tap-highlight-color:transparent;margin-bottom:16px;color:#3D464D;font-family:\'Pingfang SC\', STHeiti, \'Lantinghei SC\', \'Open Sans\', Arial, \'Hiragino Sans GB\', \'Microsoft YaHei\', \'WenQuanYi Micro Hei\', SimSun, sans-serif;font-size:16px;line-height:28px;white-space:normal;background-color:#F8F8F8;\">\n		demo:\n	</p>\n<pre class=\"brush:php;toolbar: true; auto-links: false; hljs\" style=\"box-sizing:inherit;-webkit-tap-highlight-color:transparent;overflow-x:auto;padding:2px;color:#DCDCDC;border-radius:3px;line-height:1.4;word-wrap:normal;font-size:13px;font-family:Menlo, Monaco, Consolas, \'Courier New\', monospace;background:#3F3F3F;\"><code class=\"hljs php\" style=\"box-sizing:inherit;-webkit-tap-highlight-color:transparent;display:block;overflow-x:auto;padding:10px;border-radius:4px;line-height:1.4;word-wrap:normal;font-family:Menlo, Monaco, Consolas, \'Courier New\', monospace;background-image:initial;background-attachment:initial;background-size:initial;background-origin:initial;background-clip:initial;background-position:initial;background-repeat:initial;\">&nbsp;<span class=\"hljs-comment\" style=\"box-sizing:inherit;-webkit-tap-highlight-color:transparent;color:#7F9F7F;\">//&nbsp;连接到mongodb</span> &nbsp;&nbsp;&nbsp;$m&nbsp;=&nbsp;<span class=\"hljs-keyword\" style=\"box-sizing:inherit;-webkit-tap-highlight-color:transparent;color:#E3CEAB;\">new</span>&nbsp;MongoClient();\n&nbsp;&nbsp;&nbsp;$db&nbsp;=&nbsp;$m-&gt;myblog;\n&nbsp;&nbsp;&nbsp;$collection&nbsp;=&nbsp;$db-&gt;createCollection(<span class=\"hljs-string\" style=\"box-sizing:inherit;-webkit-tap-highlight-color:transparent;color:#CC9393;\">\"blog\"</span>);\n&nbsp;&nbsp;&nbsp;$collection&nbsp;=&nbsp;$db-&gt;blog;\n&nbsp;&nbsp;&nbsp;\n&nbsp;&nbsp;&nbsp;<span class=\"hljs-comment\" style=\"box-sizing:inherit;-webkit-tap-highlight-color:transparent;color:#7F9F7F;\">//自动ID</span> &nbsp;&nbsp;&nbsp;$id&nbsp;=&nbsp;&nbsp;autoId(<span class=\"hljs-string\" style=\"box-sizing:inherit;-webkit-tap-highlight-color:transparent;color:#CC9393;\">\'blog\'</span>,&nbsp;$db);\n&nbsp;&nbsp;&nbsp;$document&nbsp;=&nbsp;<span class=\"hljs-keyword\" style=\"box-sizing:inherit;-webkit-tap-highlight-color:transparent;color:#E3CEAB;\">array</span>(\n&nbsp;&nbsp;&nbsp; <span class=\"hljs-string\" style=\"box-sizing:inherit;-webkit-tap-highlight-color:transparent;color:#CC9393;\">\"id\"</span> =&gt;&nbsp;$id,\n&nbsp;&nbsp;&nbsp; <span class=\"hljs-string\" style=\"box-sizing:inherit;-webkit-tap-highlight-color:transparent;color:#CC9393;\">\"title\"</span>&nbsp;=&gt;&nbsp;<span class=\"hljs-string\" style=\"box-sizing:inherit;-webkit-tap-highlight-color:transparent;color:#CC9393;\">\"MongoDB\"</span>,\n&nbsp;&nbsp;&nbsp; <span class=\"hljs-string\" style=\"box-sizing:inherit;-webkit-tap-highlight-color:transparent;color:#CC9393;\">\"description\"</span>&nbsp;=&gt;&nbsp;<span class=\"hljs-string\" style=\"box-sizing:inherit;-webkit-tap-highlight-color:transparent;color:#CC9393;\">\"database\"</span>,\n&nbsp;&nbsp;&nbsp; <span class=\"hljs-string\" style=\"box-sizing:inherit;-webkit-tap-highlight-color:transparent;color:#CC9393;\">\"likes\"</span>&nbsp;=&gt;&nbsp;<span class=\"hljs-number\" style=\"box-sizing:inherit;-webkit-tap-highlight-color:transparent;color:#8CD0D3;\">100</span>,\n&nbsp;&nbsp;&nbsp; <span class=\"hljs-string\" style=\"box-sizing:inherit;-webkit-tap-highlight-color:transparent;color:#CC9393;\">\"url\"</span>&nbsp;=&gt;&nbsp;<span class=\"hljs-string\" style=\"box-sizing:inherit;-webkit-tap-highlight-color:transparent;color:#CC9393;\">\"http://www.w3cschool.cc/mongodb/\"</span>,\n&nbsp;&nbsp;&nbsp; <span class=\"hljs-string\" style=\"box-sizing:inherit;-webkit-tap-highlight-color:transparent;color:#CC9393;\">\"by\"</span>,&nbsp;<span class=\"hljs-string\" style=\"box-sizing:inherit;-webkit-tap-highlight-color:transparent;color:#CC9393;\">\"w3cschool.cc\"</span> &nbsp;&nbsp;&nbsp;);&nbsp;&nbsp;\n&nbsp;&nbsp;&nbsp;$collection-&gt;insert($document);</code></pre>\n</p>', '31', '0', '0', '1', '1', '1475043974', '1475051171');

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
INSERT INTO `pms_knowledges_comment` VALUES ('9025311345741824', '1467191338628906628', '1468921601280784732', '我以前就是做PHP的', '1476954689', '1');
INSERT INTO `pms_knowledges_comment` VALUES ('9273364971524096', '1467191338628906628', '1468921601280784732', 'lockPHP', '1477013830', '1');
INSERT INTO `pms_knowledges_comment` VALUES ('9298587166969856', '1468140265954907628', '1468921601280784732', '今天的天气不错', '1477019843', '1');

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
INSERT INTO `pms_knowledges_laud` VALUES ('9297246814212096', '1468140265954907628', '1468921601280784732', '1477019524', '1');

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
INSERT INTO `pms_leaves` VALUES ('9341180651245568', '1461312703628858832', '3', '1476979200', '1477238400', '1.5', '我出去玩', '', '0', '2', '1467191338628906628,1468140265954907628', '1477029999', '1477029999');
INSERT INTO `pms_leaves` VALUES ('9341755161841664', '1461312703628858832', '8', '1477238400', '1477497600', '3', '埼魂牵梦萦', '', '0', '2', '1467191338628906628', '1477030135', '1477030135');
INSERT INTO `pms_leaves` VALUES ('9343094470217728', '1461312703628858832', '4', '1477584000', '1477584000', '1', '魂牵梦萦埼', '', '0', '1', '1468140265954907628,1467191338628906628', '1477030455', '1477030455');
INSERT INTO `pms_leaves` VALUES ('9345827742945280', '1461312703628858832', '3', '1476979200', '1476979200', '1', '魂牵梦萦城标魂牵梦萦', '', '2', '2', '1468140265954907628', '1477031106', '1477031106');
INSERT INTO `pms_leaves` VALUES ('1468485329884714828', '1467191338628906628', '3', '1474588800', '1474934400', '2', '出去走一走，看看大世界的美丽~', '', '1', '2', '1468140265954907628,1461312703628858832', '1474597098', '1474597117');
INSERT INTO `pms_leaves` VALUES ('1468486881268841232', '1467191338628906628', '4', '1474588800', '1474243200', '1', '前段时间加班太久，想休息一下', '', '2', '2', '1468140265954907628,1461312703628858832', '1474598650', '1474598650');
INSERT INTO `pms_leaves` VALUES ('1468499570776805828', '1461312703628858832', '4', '1474588800', '1474675200', '1', '大法师魂牵梦萦地城标的撒范德萨防盗防', '', '1', '2', '1468140265954907628,1467191338628906628', '1474611339', '1474611339');
INSERT INTO `pms_leaves` VALUES ('1469093116260676528', '1461312703628858832', '3', '1475164800', '1475251200', '1', '魂牵梦萦', '', '1', '2', '1468140265954907628', '1475204885', '1475204885');

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
INSERT INTO `pms_leaves_approver` VALUES ('9341180898709504', '9341180651245568', '1467191338628906628', '', '0', '1477029999', '1477029999');
INSERT INTO `pms_leaves_approver` VALUES ('9341181112619008', '9341180651245568', '1468140265954907628', '', '0', '1477029999', '1477029999');
INSERT INTO `pms_leaves_approver` VALUES ('9341755405111296', '9341755161841664', '1467191338628906628', '', '0', '1477030136', '1477030136');
INSERT INTO `pms_leaves_approver` VALUES ('9343094814150656', '9343094470217728', '1468140265954907628', '', '0', '1477030455', '1477030455');
INSERT INTO `pms_leaves_approver` VALUES ('9343095434907648', '9343094470217728', '1467191338628906628', '', '0', '1477030455', '1477030455');
INSERT INTO `pms_leaves_approver` VALUES ('9345827982020608', '9345827742945280', '1468140265954907628', '最近项目急，等下一次。', '2', '1477031107', '1477031527');
INSERT INTO `pms_leaves_approver` VALUES ('1468485329945851032', '1468485329884714828', '1468140265954907628', '让你爽一段时间吧~', '1', '1474597098', '1474597890');
INSERT INTO `pms_leaves_approver` VALUES ('1468485329970682132', '1468485329884714828', '1461312703628858832', '好的，可以~', '1', '1474597098', '1474597954');
INSERT INTO `pms_leaves_approver` VALUES ('1468486881315872732', '1468486881268841232', '1468140265954907628', '明天有个紧急项目处理完了，再调休吧', '2', '1474598650', '1474600405');
INSERT INTO `pms_leaves_approver` VALUES ('1468486881388411732', '1468486881268841232', '1461312703628858832', '前审批人拒绝，后面审批人默认拒绝', '2', '1474598650', '1474600405');
INSERT INTO `pms_leaves_approver` VALUES ('1468499570822373232', '1468499570776805828', '1468140265954907628', '可以，不容易~', '1', '1474611339', '1474618252');
INSERT INTO `pms_leaves_approver` VALUES ('1468499570879828328', '1468499570776805828', '1467191338628906628', 'OK,没有问题', '1', '1474611339', '1474618270');
INSERT INTO `pms_leaves_approver` VALUES ('1469093116306650732', '1469093116260676528', '1468140265954907628', '可以', '1', '1475204885', '1477017529');

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
INSERT INTO `pms_messages` VALUES ('9298587246661632', '1468140265954907628', '1461312703628858832', '1', '11', 'lockPHP框架升级2.0', '/knowledge/1468921601280784732', '2', '1477019843');
INSERT INTO `pms_messages` VALUES ('9305430811480064', '1468140265954907628', '1461312703628858832', '2', '22', '美丽的背后', '/album/1468934759849234932', '2', '1477021475');
INSERT INTO `pms_messages` VALUES ('9305470346989568', '1468140265954907628', '1461312703628858832', '1', '12', '美丽的背后', '/album/1468934759849234932', '2', '1477021485');
INSERT INTO `pms_messages` VALUES ('9339159604891648', '1467191338628906628', '1461312703628858832', '3', '34', '同意', '/businesstrip/approval/1468842643441590032', '2', '1477029517');
INSERT INTO `pms_messages` VALUES ('9341755593854976', '1461312703628858832', '1467191338628906628', '4', '31', '去审批处理', '/leave/approval/9341755161841664', '2', '1477030136');
INSERT INTO `pms_messages` VALUES ('9343095145500672', '1461312703628858832', '1468140265954907628', '4', '31', '去审批处理', '/leave/approval/9343094470217728', '2', '1477030455');
INSERT INTO `pms_messages` VALUES ('9343095707537408', '1461312703628858832', '1467191338628906628', '4', '31', '去审批处理', '/leave/approval/9343094470217728', '1', '1477030455');
INSERT INTO `pms_messages` VALUES ('9346109554036736', '1461312703628858832', '1468140265954907628', '4', '31', '去审批处理', '/leave/approval/9345827742945280', '2', '1477031174');
INSERT INTO `pms_messages` VALUES ('9347589832970240', '1468140265954907628', '1461312703628858832', '3', '31', '拒绝', '/leave/approval/9345827742945280', '2', '1477031527');
INSERT INTO `pms_messages` VALUES ('9350488906534912', '1461312703628858832', '1468140265954907628', '4', '32', '去审批处理', '/overtime/approval/9350441984856064', '2', '1477032218');
INSERT INTO `pms_messages` VALUES ('9350600059785216', '1468140265954907628', '1461312703628858832', '3', '32', '拒绝', '/overtime/approval/9350441984856064', '2', '1477032244');

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
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of pms_notices
-- ----------------------------
INSERT INTO `pms_notices` VALUES ('1469025346278150728', '10.1放假通知', '各部门注意，本次放假多放10天，共17天！', '1475137115', '1');

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
INSERT INTO `pms_overtimes` VALUES ('9350441984856064', '1461312703628858832', '1477032000', '1477062000', '6', '2', '2', '城标埼韦尔奇', '2', '2', '1468140265954907628', '1477032207', '1477032207');
INSERT INTO `pms_overtimes` VALUES ('1469101768980362328', '1461312703628858832', '1475213700', '1475717100', '81', '1', '2', '魂牵梦萦', '1', '2', '1469024587469707428', '1475213537', '1475213717');

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
INSERT INTO `pms_overtimes_approver` VALUES ('9350442173599744', '9350441984856064', '1468140265954907628', '今天是周五，不用加班~', '2', '1477032207', '1477032244');
INSERT INTO `pms_overtimes_approver` VALUES ('1469101769037534028', '1469101768980362328', '1469024587469707428', '可以', '1', '1475213537', '1475213870');

-- ----------------------------
-- Table structure for pms_permissions
-- ----------------------------
DROP TABLE IF EXISTS `pms_permissions`;
CREATE TABLE `pms_permissions` (
  `userid` bigint(20) NOT NULL,
  `permission` varchar(5000) DEFAULT NULL,
  `model` varchar(5000) DEFAULT NULL,
  `modelc` varchar(5000) DEFAULT NULL,
  PRIMARY KEY (`userid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of pms_permissions
-- ----------------------------
INSERT INTO `pms_permissions` VALUES ('1461312703628858832', 'project-manage,project-add,project-edit,project-team,team-add,team-delete,project-need,need-add,need-edit,project-task,task-add,task-edit,project-test,test-add,test-edit,checkwork-manage,checkwork-all,leave-manage,leave-add,leave-edit,leave-view,leave-approval,overtime-manage,overtime-add,overtime-edit,overtime-view,overtime-approval,expense-manage,expense-add,expense-edit,expense-view,expense-approval,businesstrip-manage,businesstrip-add,businesstrip-edit,businesstrip-view,businesstrip-approval,goout-manage,goout-add,goout-edit,goout-view,goout-approval,oagood-manage,oagood-add,oagood-edit,oagood-view,oagood-approval,knowledge-manage,knowledge-add,knowledge-edit,album-manage,album-upload,album-edit,resume-manage,resume-add,resume-edit,resume-delete,user-manage,user-add,user-edit,user-permission,message-manage,message-delete,department-manage,department-add,department-edit,position-manage,position-add,position-edit,notice-manage,notice-add,notice-edit,notice-delete', '项目管理-project-book||project-manage,考勤管理-checkwork-tasks||checkwork-list,审批管理-approval-suitcase||#,知识分享-knowledge-tasks||knowledge-list,员工相册-album-plane||album-list,简历管理-resume-laptop||resume-list,员工管理-user-user||#', '请假-approval||leave-manage,加班-approval||overtime-manage,报销-approval||expense-manage,出差-approval||businesstrip-manage,外出-approval||goout-manage,物品-approval||oagood-manage,员工-user||user-manage,部门-user||department-manage,职称-user||position-manage,公告-user||notice-manage');
INSERT INTO `pms_permissions` VALUES ('1467191338628906628', 'project-team,team-add,team-delete,project-need,need-add,need-edit,project-task,task-add,task-edit,project-test,test-add,test-edit,checkwork-manage,message-manage,message-delete,leave-manage,leave-add,leave-edit,leave-view,leave-approval,overtime-manage,overtime-add,overtime-edit,overtime-view,overtime-approval,expense-manage,expense-add,expense-edit,expense-view,expense-approval,businesstrip-manage,businesstrip-add,businesstrip-edit,businesstrip-view,businesstrip-approval,goout-manage,goout-add,goout-edit,goout-view,goout-approval,oagood-manage,oagood-add,oagood-edit,oagood-view,oagood-approval,knowledge-manage,knowledge-add,knowledge-edit,album-manage,album-upload,album-edit', '项目管理-project-book||project-manage,考勤管理-checkwork-tasks||checkwork-list,审批管理-approval-suitcase||#,知识分享-knowledge-tasks||knowledge-list,员工相册-album-plane||album-list', '请假-approval||leave-manage,加班-approval||overtime-manage,报销-approval||expense-manage,出差-approval||businesstrip-manage,外出-approval||goout-manage,物品-approval||oagood-manage');
INSERT INTO `pms_permissions` VALUES ('1468140265954907628', 'project-team,team-add,team-delete,project-need,need-add,need-edit,project-task,task-add,task-edit,project-test,test-add,test-edit,checkwork-manage,checkwork-all,message-manage,message-delete,leave-manage,leave-add,leave-edit,leave-view,leave-approval,overtime-manage,overtime-add,overtime-edit,overtime-view,overtime-approval,expense-manage,expense-add,expense-edit,expense-view,expense-approval,businesstrip-manage,businesstrip-add,businesstrip-edit,businesstrip-view,businesstrip-approval,goout-manage,goout-add,goout-edit,goout-view,goout-approval,oagood-manage,oagood-add,oagood-edit,oagood-view,oagood-approval,knowledge-manage,knowledge-add,knowledge-edit,album-manage,album-upload,album-edit', '项目管理-project-book||project-manage,考勤管理-checkwork-tasks||checkwork-list,审批管理-approval-suitcase||#,知识分享-knowledge-tasks||knowledge-list,员工相册-album-plane||album-list', '请假-approval||leave-manage,加班-approval||overtime-manage,报销-approval||expense-manage,出差-approval||businesstrip-manage,外出-approval||goout-manage,物品-approval||oagood-manage');
INSERT INTO `pms_permissions` VALUES ('1468915433602979028', 'project-team,team-add,team-delete,project-need,need-add,need-edit,project-task,task-add,task-edit,project-test,test-add,test-edit,leave-manage,leave-add,leave-edit,leave-view,leave-approval,overtime-manage,overtime-add,overtime-edit,overtime-view,overtime-approval,expense-manage,expense-add,expense-edit,expense-view,expense-approval,businesstrip-manage,businesstrip-add,businesstrip-edit,businesstrip-view,businesstrip-approval,goout-manage,goout-add,goout-edit,goout-view,goout-approval,oagood-manage,oagood-add,oagood-edit,oagood-view,oagood-approval,knowledge-manage,knowledge-add,knowledge-edit,album-manage,album-upload,album-edit', '项目管理-project-book||project-manage,审批管理-approval-suitcase||#,知识分享-knowledge-tasks||knowledge-list,员工相册-album-plane||album-list', '请假-approval||leave-manage,加班-approval||overtime-manage,报销-approval||expense-manage,出差-approval||businesstrip-manage,外出-approval||goout-manage,物品-approval||oagood-manage');
INSERT INTO `pms_permissions` VALUES ('1469024587469707428', 'project-team,team-add,team-delete,project-need,need-add,need-edit,project-task,task-add,task-edit,project-test,test-add,test-edit,leave-manage,leave-add,leave-edit,leave-view,leave-approval,overtime-manage,overtime-add,overtime-edit,overtime-view,overtime-approval,expense-manage,expense-add,expense-edit,expense-view,expense-approval,businesstrip-manage,businesstrip-add,businesstrip-edit,businesstrip-view,businesstrip-approval,goout-manage,goout-add,goout-edit,goout-view,goout-approval,oagood-manage,oagood-add,oagood-edit,oagood-view,oagood-approval,knowledge-manage,knowledge-add,knowledge-edit,album-manage,album-upload,album-edit', '项目管理-project-book||project-manage,审批管理-approval-suitcase||#,知识分享-knowledge-tasks||knowledge-list,员工相册-album-plane||album-list', '请假-approval||leave-manage,加班-approval||overtime-manage,报销-approval||expense-manage,出差-approval||businesstrip-manage,外出-approval||goout-manage,物品-approval||oagood-manage');

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
INSERT INTO `pms_projects` VALUES ('1467192163843257232', '1461312703628858832', 'App项目开发', 'AppStyle', '1473264000', '1475078400', 'App项目开发，主要完成第一版本功能的测试，上线~', '1473303932', '3', '1461312703628858832', '1467191338628906628', '1468140265954907628', '1468140265954907628');

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
INSERT INTO `pms_projects_needs` VALUES ('1468140408257075332', '1467192163843257232', '1461312703628858832', '活动列表模板制作 - 制作', '魂牵梦萦', '1461312703628858832', '2', '魂牵梦萦', '1', '0', '', '1474252177', '0', '2', '2');
INSERT INTO `pms_projects_needs` VALUES ('1468140431990600932', '1467192163843257232', '1461312703628858832', '移去端生成', '魂牵梦萦', '1467191338628906628', '5', '魂牵梦萦', '3', '10', '', '1474252200', '0', '3', '2');
INSERT INTO `pms_projects_needs` VALUES ('1468140748845766528', '1467192163843257232', '1461312703628858832', '移去端生成', '魂牵梦萦', '1468140265954907628', '2', '魂牵梦萦', '2', '10', '', '1474252517', '0', '2', '2');
INSERT INTO `pms_projects_needs` VALUES ('1468921774268994028', '1467192163843257232', '1461312703628858832', '活动列表模板制作 - 制作', 'fdsaffdsa', '1461312703628858832', '2', 'fdsafdsafsd', '2', '10', '/static/uploadfile/2016-9/28/2.jpg', '1475033543', '0', '1', '5');

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
INSERT INTO `pms_projects_task` VALUES ('1468156443597929432', '1468140431990600932', '1461312703628858832', '1467192163843257232', '1467191338628906628', '', '0', '朝秦暮楚', '朝秦暮楚', '', '2', '0', '0', '1474243200', '1474243200', '', '1474268212', '0', '6', '1461312703628858832', '0');
INSERT INTO `pms_projects_task` VALUES ('1468156456086352028', '1468140408257075332', '1461312703628858832', '1467192163843257232', '1467191338628906628', '', '0', '朝秦暮楚', '魂牵梦萦', '', '3', '0', '0', '1474243200', '1474243200', '', '1474268224', '0', '1', '0', '0');
INSERT INTO `pms_projects_task` VALUES ('1468156476049560632', '1468140431990600932', '1461312703628858832', '1467192163843257232', '1468140265954907628', '', '1468140265954907628', '魂牵梦萦', '魂牵梦萦', '', '6', '0', '0', '1474243200', '1474243200', '', '1474268244', '0', '3', '0', '0');

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
INSERT INTO `pms_projects_task_log` VALUES ('1468156443598942432', '1468156443597929432', '1461312703628858832', '李白创建了任务', '1474268212');
INSERT INTO `pms_projects_task_log` VALUES ('1468156456087352628', '1468156456086352028', '1461312703628858832', '李白创建了任务', '1474268224');
INSERT INTO `pms_projects_task_log` VALUES ('1468156476049560632', '1468156476049560632', '1461312703628858832', '李白创建了任务', '1474268244');
INSERT INTO `pms_projects_task_log` VALUES ('1469102375318573528', '1468156443597929432', '1461312703628858832', '李白更改任务状态为已关闭', '1475214144');
INSERT INTO `pms_projects_task_log` VALUES ('9356906980184064', '1468156476049560632', '1468140265954907628', '李四更改任务状态为已完成', '1477033748');

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
INSERT INTO `pms_projects_team` VALUES ('1467192298411400532', '1467192163843257232', '1461312703628858832', '1473304067');
INSERT INTO `pms_projects_team` VALUES ('1467192316450102228', '1467192163843257232', '1467191338628906628', '1473304085');
INSERT INTO `pms_projects_team` VALUES ('1468140282249771232', '1467192163843257232', '1468140265954907628', '1474252051');

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
INSERT INTO `pms_projects_test` VALUES ('1468158891722798928', '1468156456086352028', '1468140431990600932', '1461312703628858832', '1467192163843257232', '1461312703628858832', '1461312703628858832', '', '魂牵梦萦', '魂牵梦萦', '0', '', '', '', '1475214196', '1474270660', '0', '7');

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
INSERT INTO `pms_projects_test_log` VALUES ('1468158891723813132', '1468158891722798928', '1461312703628858832', '李白创建了测试', '1474270660');
INSERT INTO `pms_projects_test_log` VALUES ('1468158919174160132', '1468158891722798928', '1461312703628858832', '李白更改测试状态为已解决<br>', '1474270688');
INSERT INTO `pms_projects_test_log` VALUES ('1469102389536192832', '1468158891722798928', '1461312703628858832', '李白更改测试状态为延期处理<br>', '1475214158');
INSERT INTO `pms_projects_test_log` VALUES ('1469102427882017832', '1468158891722798928', '1461312703628858832', '李白更改测试状态为不予解决<br>', '1475214196');

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
INSERT INTO `pms_resumes` VALUES ('1469028741058477628', '张三', '2', '906076800', '10', '5', '', '1475140509', '1', 'fdsafas', '13524512531');

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
INSERT INTO `pms_users` VALUES ('1461312703628858832', '1461312703628858832', 'libai', 'e10adc3949ba59abbe56e057f20f883e', '/static/uploadfile/2016-9/28/b09699094fd80f154caf08de44b86b33-cropper.jpg', '1');
INSERT INTO `pms_users` VALUES ('1467191338628906628', '1467191338628906628', 'zhangsan', 'e10adc3949ba59abbe56e057f20f883e', '/static/img/avatar/3.jpg', '1');
INSERT INTO `pms_users` VALUES ('1468140265954907628', '1468140265954907628', 'lisi', 'e10adc3949ba59abbe56e057f20f883e', '/static/img/avatar/2.jpg', '1');
INSERT INTO `pms_users` VALUES ('1468915433602979028', '1468915433602979028', 'fancy', 'e10adc3949ba59abbe56e057f20f883e', '/static/img/avatar/1.jpg', '1');
INSERT INTO `pms_users` VALUES ('1469024587469707428', '1469024587469707428', 'xiaoxin', 'e10adc3949ba59abbe56e057f20f883e', '/static/img/avatar/1.jpg', '1');

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
INSERT INTO `pms_users_profile` VALUES ('1461312703628858832', '李白', '1', '1985-12-12', 'test@163.com', 'milu365', '49732343', '13754396432', '021-3432423', '九新公路华西办公楼7楼', 'zfancy', '137245613126', '1462290228639093428', '1462292041515367932', '57', '', '1477033985');
INSERT INTO `pms_users_profile` VALUES ('1467191338628906628', '张三', '1', '1985-12-12', 'test@test.com', 'zs-milu365', '903561702', '13524512531', '021-84122521', '九新公路', 'lock', '135245132623', '1462290199274575028', '1462292041515367932', '14', '', '1477028450');
INSERT INTO `pms_users_profile` VALUES ('1468140265954907628', '李四', '1', '1994-08-11', 'cto@nahehuo.com', 'zs-milu365', '903561702', '13524396586', '021-84122521', '九新公路华西办公楼', 'lock', '135245132623', '1462290127694985332', '1462292053049130632', '9', '127.0.0.1', '1477031153');
INSERT INTO `pms_users_profile` VALUES ('1468915433602979028', '朱笑天', '1', '1992-09-10', 'test@test.coma', 'zs-milu365', '903561702', '13524512531', '021-84122521', '外滩一号', 'lock', '135245132623', '1462290199274575028', '1462292041515367932', '2', '127.0.0.1', '1475051104');
INSERT INTO `pms_users_profile` VALUES ('1469024587469707428', '李浩', '1', '1997-09-06', 'test@test.com', 'ls-milu365', '903561702', '13521234231', '021-84122521', '外滩一号', '李呀', '135245132623', '1462290228639093428', '1462292006260420932', '3', '127.0.0.1', '1475213790');
