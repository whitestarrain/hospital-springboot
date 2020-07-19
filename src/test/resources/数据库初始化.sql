DROP DATABASE IF EXISTS hishospital;
CREATE DATABASE IF NOT EXISTS hishospital CHARACTER SET utf8;-- 创建云医院数据库
USE hishospital; -- 使用数据库

CREATE TABLE register(
	id INT PRIMARY KEY AUTO_INCREMENT, -- 挂号id
	medicalrecord INT, -- 对应病历号id
	NAME VARCHAR(20), -- 挂号人姓名
	gender INT, -- 挂号人性别，id对应的常数项表中
	idnumber VARCHAR(20), -- 身份证号
	birthday DATE, -- 出生日期。
	-- 年龄作为派生属性将不记录在表中
	payway INT, -- 结算类型，对应结算类别表
	address VARCHAR(20), -- 住址
	diagdate DATE, -- 看诊日期
	noon VARCHAR(10), -- 午别，上午还是下午
	regidate TIMESTAMP, -- 挂号时间
	depaid INT, -- 挂号科室id
	doctorid INT, -- 挂号医生id
	-- 每个医生固定挂号级别，不进行冗余记录
	needrecord INT, -- 是否需要病历本，1要，0不要
	registrarid INT, -- 挂号员id
	STATUS INT-- 看诊状态(未诊1，已诊2，诊毕3,退号4)
);-- 挂号信息表
CREATE TABLE regilevel(
	id INT PRIMARY KEY AUTO_INCREMENT, -- 挂号级别id
	NAME VARCHAR(10), -- 号别名称
	-- 拼音首字母助记码作为派生属性不进行记录
	fee INT, -- 挂号费
	limitnum INT, -- 挂号限额
	isdel INT -- 逻辑删除
);-- 挂号级别
CREATE TABLE medicalrecord(
	recordnum INT PRIMARY KEY AUTO_INCREMENT, -- 病历号，对应病人
	symptom VARCHAR(100), -- 主诉
	nowhistory VARCHAR(1000), -- 现病史
	anamnesis VARCHAR(1000), -- 既往病史
	allergyhis VARCHAR(1000), -- 过敏史
	treatment VARCHAR(500), -- 现病治疗情况
	checkup VARCHAR(100), -- 体格检查
	checksugg VARCHAR(100), -- 检查建议
	attention VARCHAR(100), -- 注意事项
	result VARCHAR(100) -- 诊断结果
);-- 病历表
CREATE TABLE diagnose(
	recordnum INT, -- 病历号
	registerid INT PRIMARY KEY, -- 挂号id。每一次挂号都对应一次诊断
	diagtype INT, -- 诊断类别（1西医，2中医）
	diseaseid INT, -- 诊断疾病id
	diagdate TIMESTAMP -- 诊断日期
);-- 诊断表
CREATE TABLE prescribe(
	id INT PRIMARY KEY AUTO_INCREMENT, -- 开处方记录主键
	recordnum INT, -- 病历号。-- 数据冗余，换取速度。因为支付时要频繁通过病历号查询
	registerid INT, -- 挂号id。
	doctid INT, -- 开立医生id
	NAME VARCHAR(30), -- 处方名称
	presdate DATE, -- 开立时间 
	STATUS INT -- 缴费状态（1开立未缴费，2缴费，3发药，6退费）
);-- 开设处方记录表。每一个挂号可能开几个处方


CREATE TABLE prescription(
	id INT PRIMARY KEY AUTO_INCREMENT, -- 处方id
	NAME VARCHAR(30), -- 处方名称
	doctid INT, -- 创立医生id
	creatdate TIMESTAMP, -- 创建时间
	isdel INT -- 逻辑删除
	-- 需求文档中未提及处方使用范围，此处删除使用范围信息
); -- 处方表
CREATE TABLE drugtempl(
	presid INT, -- 处方id
	drugid INT, -- 药品id
	useway VARCHAR(20), -- 用法
	dosage VARCHAR(20), -- 用量
	frequency VARCHAR(20), -- 频次
	number INT, -- 数量
	PRIMARY KEY (presid,drugid) -- 一个处方中的一个药，对应一个用法用量
); -- 药品模版表。用来存储处方对应药品

CREATE TABLE drug(
	id INT PRIMARY KEY AUTO_INCREMENT, -- 药品id
	NAME VARCHAR(100), -- 药品名称
	specification VARCHAR(20), -- 药品规格
	price DECIMAL(9,2), -- 药品单价
	isdel INT -- 逻辑删除
);-- 药品表。此处为了速度，将其他信息写到另一个表 药品详细信息中
CREATE TABLE drugdetail(
	drugid INT PRIMARY KEY, -- 药品id
	drugcode VARCHAR(20), -- 药品编码
	pack VARCHAR(5), -- 包装单位
	manufacturer VARCHAR(20), -- 生产厂家
	form INT, -- 剂型（片，针）,常项表中
	TYPE INT, -- 类型（中成，中草药，西药）常项表中
	createtime TIMESTAMP, -- 创建时间
	updatetime DATE, -- 修改时间
	isdel INT, -- 逻辑删除
	CONSTRAINT drug_detail FOREIGN KEY (drugid) REFERENCES drug(id) -- 因为不会频繁进行修改，对性能影响较小，同时也有约束，所以这里使用外键
);-- 药品详细信息

CREATE TABLE disease(
	id INT PRIMARY KEY AUTO_INCREMENT,-- 疾病id
	NAME VARCHAR(100), -- 疾病名称
	icd VARCHAR(10), -- 国际idc编码
	typeid INT,-- 疾病类别
	isdel INT -- 逻辑删除
); -- 疾病表


CREATE TABLE diseasetype(
	id INT PRIMARY KEY AUTO_INCREMENT,-- 疾病类别
	NAME VARCHAR(20), -- 疾病类别名称
	SIGN INT, -- 疾病标记
	isdel INT -- 逻辑删除
);-- 疾病类别表

CREATE TABLE department(
	id INT PRIMARY KEY AUTO_INCREMENT, -- 科室id
	NAME VARCHAR(20), -- 科室名称
	departype INT,-- 科室分类
	departform INT, -- 科室类型
	isdel INT -- 逻辑删除
); -- 科室表

CREATE TABLE USER(
	id INT PRIMARY KEY AUTO_INCREMENT, -- 用户id
	username VARCHAR(20), -- 登录名称
	PASSWORD VARCHAR(20), -- 密码
	NAME VARCHAR(20), -- 真实姓名
	TYPE INT, -- 用户类别（1,2,3）
	profession INT, -- 职称，在常项表中
	iswork VARCHAR(5), -- 是否参与排班
	departid INT, -- 所在科室id
	levelid INT, -- 挂号级别id
	isdel INT, -- 逻辑删除
	CONSTRAINT user_level FOREIGN KEY (levelid) REFERENCES regilevel(id) -- 挂号等级外键
); -- 用户表
CREATE TABLE rule(
	id INT PRIMARY KEY AUTO_INCREMENT, -- 规则id
	NAME VARCHAR(20),-- 规则名称
	departid INT, -- 科室id
	doctid INT, -- 医生id
	weekarra VARCHAR(20), -- 星期每天的安排
	isdel INT -- 逻辑删除
);-- 排班规则

CREATE TABLE scheduling(
	id INT PRIMARY KEY AUTO_INCREMENT, -- id
	workdate DATE, -- 排班时间
	departid INT, -- 科室id
	doctid INT, -- 医生id
	noon VARCHAR(10), -- 午别
	isdel INT -- 逻辑删除
	-- 其实可以选择排班规则id替代上面俩，这里是数据冗余，求速度
); -- 排班表

CREATE TABLE invoice(
	id INT PRIMARY KEY AUTO_INCREMENT, -- 发票id
	number INT, -- 发票号码
	payamount DECIMAL(9,2), -- 支付金额
	STATUS INT,-- 发票状态（1-正常  2-作废 ）
	TIME TIMESTAMP, -- 收/退费时间
	userid INT, -- 收/退费人员id
	registerid INT, -- 挂号id
	paywayid INT -- 结算方式id
);-- 发票
CREATE TABLE costdetail(
	id INT PRIMARY KEY AUTO_INCREMENT, -- id
	invoicenum INT, -- 所属发票号码
	TYPE INT, -- 项目类型（1非药品 2药品）
	NAME VARCHAR(20), -- 项目名称（~颗粒，洗胃,挂号费等等）
	price DECIMAL(9,2), -- 项目单价。单价为负表示退费
	num INT, -- 数量
	departid INT, -- 执行科室id（支付时会查询诊断表指定病历号下的今天挂的号所开的药，此时顺便可以获得科室id）
	inittime TIMESTAMP -- 开立时间
); -- 费用明细。发票上会有的所有记录
CREATE TABLE payway(
	id INT PRIMARY KEY AUTO_INCREMENT, -- id
	typecode VARCHAR(10), -- 类别编码
	typename VARCHAR(10), -- 类别名称
	isdel INT -- 逻辑删除
);-- 结算方式

CREATE TABLE constanttype(
	id INT PRIMARY KEY AUTO_INCREMENT, -- id
	typecode VARCHAR(20), -- 类别编码
	NAME VARCHAR(20), -- 类别名称
	isdel INT -- 逻辑删除
);-- 常数项类别


CREATE TABLE constantitem(
	id INT PRIMARY KEY AUTO_INCREMENT, -- id
	typeid INT, -- 所属常数项类别
	NAME VARCHAR(20), -- 常数项名称
	isdel INT, -- 逻辑删除
	CONSTRAINT item_type FOREIGN KEY (typeid) REFERENCES constanttype(id)	-- 常数项类别外键
);-- 常数项表




-- register表
INSERT INTO register VALUES (3,600600,'李白',71,'110101199003073335','1900-01-02',1,'北京','2019-03-18','上午','2019-03-18 09:20:34',1,1,1,301,2);
INSERT INTO register VALUES (4,600601,'杜甫',71,'110101199003073634','1900-01-02',2,'雄安','2019-03-19','下午','2019-03-18 09:21:26',2,1,1,301,1);
INSERT INTO register VALUES (5,600602,'李商隐',71,'110101199003075496','1900-01-02',1,'哈尔滨','2019-03-18','上午','2019-03-18 09:22:24',2,1,0,301,1);
INSERT INTO register VALUES (6,600603,'杜牧',71,'110101199003072519','1900-01-02',2,'大连','2019-03-19','上午','2019-03-19 09:18:25',1,1,1,301,2);
INSERT INTO register VALUES (8,600605,'李贺',71,'110101199003078937','1900-01-02',1,'长沙','2019-03-19','上午','2019-03-19 10:09:35',1,1,1,301,1);
INSERT INTO register VALUES (9,600606,'卢照邻',71,'110101199003079577','1900-01-02',1,'天津','2019-03-19','下午','2019-03-19 10:10:44',2,1,0,301,2);
INSERT INTO register VALUES (26,600607,'陆游',71,'110101199003072770','1900-01-02',1,'上海','2019-03-26','上午','2019-03-26 09:27:00',1,1,1,301,2);
INSERT INTO register VALUES (27,600608,'屈原',71,'11010119900307045X','1900-01-02',1,'广州','2019-03-28','上午','2019-03-28 10:55:20',1,1,1,301,3);
INSERT INTO register VALUES (28,600609,'白居易',71,'210102199208051076','1900-01-02',1,'台北','2019-03-28','上午','2019-03-28 10:57:03',1,1,0,301,3);
INSERT INTO register VALUES (29,600610,'王安石',71,'210102199208050938','1900-01-02',1,'香港','2019-03-28','下午','2019-03-28 13:45:25',1,1,1,9,3);
INSERT INTO register VALUES (30,600611,'李煜',71,'210102199208051834','1900-01-02',1,'杭州','2019-03-28','下午','2019-03-28 15:23:48',1,1,1,10,3);
INSERT INTO register VALUES (31,600612,'孟浩然',71,'210102199208058972','1900-01-02',1,'南京','2019-03-26','上午','2019-03-28 16:53:35',1,1,1,9,3);
INSERT INTO register VALUES (32,600613,'王勃',71,'210102199208055392','1900-01-02',1,'武汉','2019-03-29','上午','2019-03-29 09:23:45',1,1,0,9,2);
INSERT INTO register VALUES (33,600614,'范仲淹',71,'210102199208056053','1900-01-02',1,'成都','2019-03-29','上午','2019-03-29 14:41:00',1,1,0,9,3);
INSERT INTO register VALUES (34,600615,'陶渊明',71,'210102199208059377','1900-01-02',1,'深圳','2019-03-29','上午','2019-03-29 14:46:17',1,1,0,9,2);
INSERT INTO register VALUES (36,600617,'苏洵',71,'210102199208059916','1900-01-02',1,'重庆','2019-04-01','下午','2019-04-01 10:36:40',1,1,1,9,1);
INSERT INTO register VALUES (37,600618,'苏辙',71,'210102199208058999','1900-01-02',1,'厦门','2019-04-01','下午','2019-04-01 13:25:23',1,2,0,9,2);
INSERT INTO register VALUES (39,600619,'苏轼',71,'21010219920805025X','2000-01-01',1,'沈阳','2019-06-24','上','2019-06-24 10:59:19',1,2,0,9,4);
INSERT INTO register VALUES (40,600620,'苏轼',71,'21010219920805025X','2000-01-01',1,'沈阳','2019-06-24','上','2019-06-24 10:59:29',1,2,0,9,2);
INSERT INTO register VALUES (41,600621,'苏轼',71,'21010219920805025X','2000-01-01',1,'沈阳','2019-06-24','下','2019-06-24 11:07:19',1,2,0,9,4);
INSERT INTO register VALUES (121,600622,'辛弃疾',71,'210102199208057253','1900-01-02',1,'沈阳','2019-07-01','上','2019-07-02 04:30:08',1,1,1,9,3);
INSERT INTO register VALUES (122,600623,'刘禹锡',71,'320114198702156937','1900-01-02',1,'南京','2019-07-01','上','2019-07-02 04:30:08',1,1,1,9,3);
INSERT INTO register VALUES (123,600624,'王维',71,'320114198702158713','1900-01-02',1,'南京','2019-07-01','下','2019-07-02 04:30:08',1,1,0,9,3);
INSERT INTO register VALUES (124,600625,'李商隐',71,'32011419870215929X','1900-01-02',1,'南京','2019-07-01','上','2019-07-02 04:30:08',1,1,1,9,3);
INSERT INTO register VALUES (125,600626,'纳兰性德',71,'320114198702159134','1900-01-02',1,'南京','2019-07-01','上','2019-07-02 04:30:09',1,1,0,9,3);
INSERT INTO register VALUES (126,600627,'杜牧',71,'320114198702159038','1900-01-02',1,'南京','2019-07-01','下','2019-07-02 04:30:09',1,1,1,9,3);
INSERT INTO register VALUES (127,600628,'元稹',71,'320114198702158932','1900-01-02',1,'南京','2019-07-01','上','2019-07-02 04:30:09',1,1,0,9,3);
INSERT INTO register VALUES (128,600629,'柳宗元',71,'320114198702157593','1900-01-02',1,'南京','2019-07-01','上','2019-07-02 04:30:09',1,1,1,9,3);
INSERT INTO register VALUES (129,600630,'岑参',71,'320114198702159775','1900-01-02',1,'南京','2019-07-01','上','2019-07-02 04:30:09',1,1,1,9,3);
INSERT INTO register VALUES (130,600631,'韩愈',71,'320114198702159097','1900-01-02',1,'南京','2019-07-01','上','2019-07-02 04:30:09',1,1,1,9,3);
INSERT INTO register VALUES (131,600632,'欧阳修',71,'320114198702156056','1900-01-02',1,'南京','2019-07-01','上','2019-07-02 04:30:09',1,1,1,9,3);
INSERT INTO register VALUES (132,600633,'齐己',71,'320114198702156275','1900-01-02',1,'南京','2019-07-01','下','2019-07-02 04:30:09',1,1,1,9,3);
INSERT INTO register VALUES (133,600634,'贾岛',71,'320114198702156996','1900-01-02',1,'南京','2019-07-01','下','2019-07-02 04:30:09',1,1,1,9,3);
INSERT INTO register VALUES (134,600635,'韦应物',71,'320114198702158836','1900-01-02',1,'南京','2019-07-01','下','2019-07-02 04:30:09',1,1,1,9,3);
INSERT INTO register VALUES (135,600636,'曹操',71,'320114198702157497','1900-01-02',1,'南京','2019-07-01','上','2019-07-02 04:30:09',1,1,1,9,3);
INSERT INTO register VALUES (136,600637,'温庭筠',71,'32011419870215945X','1900-01-02',1,'南京','2019-07-01','下','2019-07-02 04:30:09',1,1,1,9,3);
INSERT INTO register VALUES (137,600638,'柳永',71,'440304199210189484','1900-01-02',1,'深圳','2019-07-01','上','2019-07-02 04:30:09',1,1,1,9,3);
INSERT INTO register VALUES (138,600639,'刘长卿',71,'440304199210187462','1900-01-02',1,'深圳','2019-07-01','上','2019-07-02 04:30:09',1,1,1,9,3);
INSERT INTO register VALUES (139,600640,'曹植',71,'440304199210188967','1900-01-02',1,'深圳','2019-07-01','上','2019-07-02 04:30:09',1,1,0,9,3);
INSERT INTO register VALUES (140,600641,'王昌龄',71,'440304199210188326','1900-01-02',1,'深圳','2019-07-01','下','2019-07-02 04:30:09',1,1,1,9,3);
INSERT INTO register VALUES (141,600642,'张籍',71,'440304199210186267','1900-01-02',1,'深圳','2019-07-01','上','2019-07-02 04:30:09',1,1,1,9,3);
INSERT INTO register VALUES (142,600643,'孟郊',71,'440304199210186523','1900-01-02',1,'深圳','2019-07-01','下','2019-07-02 04:30:09',1,1,1,9,3);
INSERT INTO register VALUES (143,600644,'皎然',71,'440304199210186347','1900-01-02',1,'深圳','2019-07-01','上','2019-07-02 04:30:09',1,1,0,9,3);
INSERT INTO register VALUES (144,600645,'贯休',71,'440304199210188182','1900-01-02',1,'深圳','2019-07-01','上','2019-07-02 04:30:09',1,1,1,9,3);
INSERT INTO register VALUES (145,600646,'许浑',71,'440304199210189409','1900-01-02',1,'深圳','2019-07-01','下','2019-07-02 04:30:09',1,1,1,9,3);
INSERT INTO register VALUES (146,600647,'罗隐',71,'440304199210189222','1900-01-02',1,'深圳','2019-07-01','上','2019-07-02 04:30:09',1,1,1,9,3);
INSERT INTO register VALUES (147,600648,'杨万里',71,'440304199210186267','1900-01-02',1,'深圳','2019-07-01','下','2019-07-02 04:30:09',1,1,1,9,3);
INSERT INTO register VALUES (148,600649,'陆龟蒙',71,'440304199210188203','1900-01-02',1,'深圳','2019-07-01','下','2019-07-02 04:30:09',1,1,1,9,3);
INSERT INTO register VALUES (149,600650,'张祜',71,'440304199210186689','1900-01-02',1,'深圳','2019-07-01','下','2019-07-02 04:30:09',1,1,0,9,3);
INSERT INTO register VALUES (150,600651,'王建',71,'44030419921018830X','1900-01-02',1,'深圳','2019-07-01','上','2019-07-02 04:30:09',1,1,1,9,3);
INSERT INTO register VALUES (151,600652,'韦庄',71,'440304199210188924','1900-01-02',1,'深圳','2019-07-01','上','2019-07-02 04:30:09',1,1,1,9,3);
INSERT INTO register VALUES (152,600653,'诸葛亮',71,'430111197906137887','1900-01-02',1,'长沙','2019-07-01','上','2019-07-02 04:30:09',1,1,1,9,3);
INSERT INTO register VALUES (153,600654,'姚合',71,'430111197906136681','1900-01-02',1,'长沙','2019-07-01','上','2019-07-02 04:30:09',1,1,1,9,3);
INSERT INTO register VALUES (154,600655,'晏殊',71,'430111197906139727','1900-01-02',1,'长沙','2019-07-01','下','2019-07-02 04:30:09',1,1,1,9,3);
INSERT INTO register VALUES (155,600656,'卢纶',71,'430111197906139161','1900-01-02',1,'长沙','2019-07-01','上','2019-07-02 04:30:09',1,1,0,9,3);
INSERT INTO register VALUES (156,600657,'杜荀鹤',71,'430111197906138249','1900-01-02',1,'长沙','2019-07-01','上','2019-07-02 04:30:09',1,1,1,9,3);
INSERT INTO register VALUES (157,600658,'岳飞',71,'430111197906137182','1900-01-02',1,'长沙','2019-07-01','上','2019-07-02 04:30:09',1,1,1,9,3);
INSERT INTO register VALUES (158,600659,'周邦彦',71,'430111197906139727','1900-01-02',1,'长沙','2019-07-01','下','2019-07-02 04:30:09',1,1,1,9,3);
INSERT INTO register VALUES (159,600660,'晏几道',71,'430111197906138388','1900-01-02',1,'长沙','2019-07-01','上','2019-07-02 04:30:09',1,1,1,9,3);
INSERT INTO register VALUES (160,600661,'钱起',71,'43011119790613730X','1900-01-02',1,'长沙','2019-07-01','上','2019-07-02 04:30:09',1,1,1,9,3);
INSERT INTO register VALUES (161,600662,'韩偓',71,'430111197906139444','1900-01-02',1,'长沙','2019-07-01','上','2019-07-02 04:30:09',1,1,1,9,3);
INSERT INTO register VALUES (162,600663,'皮日休',71,'430111197906137983','1900-01-02',1,'长沙','2019-07-01','下','2019-07-02 04:30:09',1,1,1,9,3);
INSERT INTO register VALUES (163,600664,'秦观',71,'430111197906137203','1900-01-02',1,'长沙','2019-07-01','上','2019-07-02 04:30:09',1,1,1,9,3);
INSERT INTO register VALUES (164,600665,'吴文英',71,'430111197906138126','1900-01-02',1,'长沙','2019-07-01','下','2019-07-02 04:30:09',1,1,0,9,3);
INSERT INTO register VALUES (165,600666,'朱熹',71,'430111197906136665','1900-01-02',1,'长沙','2019-07-01','上','2019-07-02 04:30:09',1,1,1,9,3);
INSERT INTO register VALUES (166,600667,'高适',71,'430111197906137326','1900-01-02',1,'长沙','2019-07-01','上','2019-07-02 04:30:09',1,1,1,9,3);
INSERT INTO register VALUES (167,600668,'方干',71,'35021119790613928X','1900-01-02',1,'厦门','2019-07-01','下','2019-07-02 04:30:09',1,1,1,9,3);
INSERT INTO register VALUES (168,600669,'马致远',71,'350211197906138180','1900-01-02',1,'厦门','2019-07-01','上','2019-07-02 04:30:09',1,1,1,9,3);
INSERT INTO register VALUES (169,600670,'李峤',71,'350211197906138287','1900-01-02',1,'厦门','2019-07-01','下','2019-07-02 04:30:09',1,1,1,9,3);
INSERT INTO register VALUES (170,600671,'权德舆',71,'350211197906136046','1900-01-02',1,'厦门','2019-07-01','上','2019-07-02 04:30:09',1,1,1,9,3);
INSERT INTO register VALUES (171,600672,'皇甫冉',71,'350211197906136409','1900-01-02',1,'厦门','2019-07-01','上','2019-07-02 04:30:09',1,1,1,9,3);
INSERT INTO register VALUES (172,600673,'左丘明',71,'350211197906136943','1900-01-02',1,'厦门','2019-07-01','下','2019-07-02 04:30:09',1,1,0,9,3);
INSERT INTO register VALUES (173,600674,'刘辰翁',71,'350211197906138922','1900-01-02',1,'厦门','2019-07-01','上','2019-07-02 04:30:09',1,1,1,9,3);
INSERT INTO register VALUES (174,600675,'郑谷',71,'350211197906136986','1900-01-02',1,'厦门','2019-07-01','上','2019-07-02 04:30:09',1,1,1,9,3);
INSERT INTO register VALUES (175,600676,'黄庭坚',71,'350211197906139984','1900-01-02',1,'厦门','2019-07-01','上','2019-07-02 04:30:09',1,1,1,9,3);
INSERT INTO register VALUES (176,600677,'贺铸',71,'350211197906138826','1900-01-02',1,'厦门','2019-07-01','下','2019-07-02 04:30:09',1,1,1,9,3);
INSERT INTO register VALUES (177,600678,'赵长卿',71,'350211197906138041','1900-01-02',1,'厦门','2019-07-01','上','2019-07-02 04:30:09',1,1,1,9,3);
INSERT INTO register VALUES (178,600679,'张九龄',71,'350211197906137882','1900-01-02',1,'厦门','2019-07-01','下','2019-07-02 04:30:09',1,1,1,9,3);
INSERT INTO register VALUES (179,600680,'卓文君',71,'350211197906138105','1900-01-02',1,'厦门','2019-07-01','上','2019-07-02 04:30:09',1,1,1,9,3);
INSERT INTO register VALUES (180,600681,'戴叔伦司',71,'350211197906139327','1900-01-02',1,'厦门','2019-07-01','下','2019-07-02 04:30:09',1,1,1,9,3);
INSERT INTO register VALUES (181,600682,'马迁周',71,'35021119790613928X','1900-01-02',1,'厦门','2019-07-01','下','2019-07-02 04:30:09',1,1,1,9,3);
INSERT INTO register VALUES (182,600683,'敦颐',71,'510101199008166455','1900-01-02',1,'成都','2019-07-01','下','2019-07-02 04:30:09',1,1,1,9,3);
INSERT INTO register VALUES (183,600684,'文天祥',71,'51010119900816787X','1900-01-02',1,'成都','2019-07-01','上','2019-07-02 04:30:09',1,1,0,9,3);
INSERT INTO register VALUES (184,600685,'张说',71,'510101199008167810','1900-01-02',1,'成都','2019-07-01','上','2019-07-02 04:30:09',1,1,1,9,3);
INSERT INTO register VALUES (185,600686,'张炎',71,'510101199008167650','1900-01-02',1,'成都','2019-07-01','上','2019-07-02 04:30:09',1,1,1,9,3);
INSERT INTO register VALUES (186,600687,'吴融',71,'510101199008168573','1900-01-02',1,'成都','2019-07-01','上','2019-07-02 04:30:09',1,1,1,9,3);
INSERT INTO register VALUES (187,600688,'郦道元',71,'510101199008168370','1900-01-02',1,'成都','2019-07-01','下','2019-07-02 04:30:09',1,1,1,9,3);
INSERT INTO register VALUES (188,600689,'陈著',71,'510101199008167896','1900-01-02',1,'成都','2019-07-01','下','2019-07-02 04:30:09',1,1,1,9,3);
INSERT INTO register VALUES (189,600690,'宋之问',71,'510101199008168178','1900-01-02',1,'成都','2019-07-01','上','2019-07-02 04:30:09',1,1,0,9,3);
INSERT INTO register VALUES (190,600691,'贺知章',71,'510101199008169832','1900-01-02',1,'成都','2019-07-01','上','2019-07-02 04:30:09',1,1,1,9,3);
INSERT INTO register VALUES (191,600692,'王之涣',71,'510101199008168995','1900-01-02',1,'成都','2019-07-01','下','2019-07-02 04:30:09',1,1,1,9,3);
INSERT INTO register VALUES (192,600693,'吴潜',71,'510101199008166973','1900-01-02',1,'成都','2019-07-01','上','2019-07-02 04:30:09',1,1,1,9,3);
INSERT INTO register VALUES (193,600694,'范成大',71,'510101199008167351','1900-01-02',1,'成都','2019-07-01','下','2019-07-02 04:30:09',1,1,1,9,3);
INSERT INTO register VALUES (194,600695,'李端',71,'510101199008168012','1900-01-02',1,'成都','2019-07-01','下','2019-07-02 04:30:09',1,1,1,9,3);
INSERT INTO register VALUES (195,600696,'白朴',71,'510101199008167896','1900-01-02',1,'成都','2019-07-01','下','2019-07-02 04:30:09',1,1,1,9,3);
INSERT INTO register VALUES (196,600697,'刘克庄',71,'510101199008166578','1900-01-02',1,'成都','2019-07-01','上','2019-07-02 04:30:09',1,1,1,9,3);
INSERT INTO register VALUES (197,600698,'顾况',71,'510101199008169728','1900-01-02',1,'成都','2019-07-01','下','2019-07-02 04:30:09',1,1,1,9,3);
INSERT INTO register VALUES (198,600699,'张乔',71,'510101199008167220','1900-01-02',1,'成都','2019-07-01','上','2019-07-02 04:30:09',1,1,1,9,3);
INSERT INTO register VALUES (199,600700,'马戴',71,'510101199008166543','1900-01-02',1,'成都','2019-07-01','上','2019-07-02 04:30:09',1,1,1,9,3);


-- 挂号等级
INSERT INTO regilevel VALUES(1,	'专家号',50,	20,	1);
INSERT INTO regilevel VALUES(2,	'普通号',8,	30,	1);

-- 病历


INSERT INTO medicalrecord VALUES (600601,'半月前受凉后开始咳嗽，呈阵发性，无畏冷发热，无咯血及胸痛，伴有少量的白色黏稠痰。曾服止咳糖浆等3天，效果不好。','阵发性咳嗽半月','既往有10年余慢性咳嗽史，曾诊断为“慢性支气管炎”，不吸烟。否认肺结核病史。','无','曾服止咳糖浆等3天，效果不好','BP 128/80mmHg,无呼吸困难，唇不发绀，双肺有散在干性啰音，未闻及湿啰性啰音，心率90次/min，律齐，无杂音，腹平软无压痛，肝脾未触及，双下肢无浮肿。','血常规，胸片','无','');
INSERT INTO medicalrecord VALUES (600607,'转移性右下腹痛伴恶心、呕吐8小时。','该患于8小时前无诱因出现腹部疼痛，初表现为上腹部隐痛，4小时后疼痛逐渐加重并转移至右下腹固定，无腰背部及会阴部放散痛，呈阵发性发作，伴有恶心、呕吐数次，呕吐物为胃内容物，量共约200毫升，未经任何诊治，今因腹痛不缓解前来我院就诊，门诊以“腹痛待查”收入院。病程中患者无咳嗽、咳痰，无心悸、气短，无呼吸困难，无腹胀、腹泻，无尿频、尿急、尿痛及血尿，患病以来，睡眠不良，食欲欠佳，大小便正常。','无结核及肝炎病史，无糖尿病及心脏病、高血压病史，无药物过敏史及手术史。','无','该患以转移性右下腹痛伴恶心、呕吐8小时于2008年06月11日入院。','无','血常规','无','');
INSERT INTO medicalrecord VALUES (600605,'间断性右上腹疼痛2年。','该患缘于2年前无明显诱因开始出现右上腹部隐痛，伴右胸背部放散痛，无肩部放散痛，腹痛呈间断性发作，曾予以抗感染治疗（具体药名及剂量不详）后腹痛可缓解。','无结核及肝炎病史，无糖尿病及心脏病、高血压病史，无药物过敏史及手术史。','无','于2010年1月14日在四平市爱龄齐医院行超声检查提示：胆囊多发结石，但未经治疗，今为进一步治疗来我院，门诊以胆囊结石收入院。病程中无寒战、高热，无反酸、嗳气，无恶心、呕吐，无呕血、黑便，无黄染。患病以来，睡眠不良，食欲欠佳，大小便正常。','无','腹部彩超（2008-06-11）','低脂饮食','');
INSERT INTO medicalrecord VALUES (600606,'右下腹痛伴恶心。','该患于8小时前无诱因出现腹部疼痛，初表现为上腹部隐痛，4小时后疼痛逐渐加重并转移至右下腹固定，无腰背部及会阴部放散痛，呈阵发性发作，伴有恶心、呕吐数次，呕吐物为胃内容物，量共约200毫升，未经任何诊治，今因腹痛不缓解前来我院就诊，门诊以“腹痛待查”收入院。病程中患者无咳嗽、咳痰，无心悸、气短，无呼吸困难，无腹胀、腹泻，无尿频、尿急、尿痛及血尿，患病以来，睡眠不良，食欲欠佳，大小便正常。','无结核及肝炎病史，无糖尿病及心脏病、高血压病史，无药物过敏史及手术史。','无','该患以转移性右下腹痛伴恶心、呕吐8小时于2008年06月11日入院。','无','血常规','无','');
INSERT INTO medicalrecord VALUES (600609,'111','222','444','555','333','666','777','888','');
INSERT INTO medicalrecord VALUES (600608,'苏二强苏二强苏二强苏二强苏二强啊啊','苏二强苏二强苏二强苏二强','苏二强苏二强苏二强苏二强','苏二强苏二强苏二强苏二强','苏二强苏二强苏二强苏二强','苏二强苏二强苏二强苏二强苏二强','苏二强','苏二强','');
INSERT INTO medicalrecord VALUES (600610,'q','q','q','q','q','q','q','q','');
INSERT INTO medicalrecord VALUES (600611,'3','3','3','3','3','3','3','3','');
INSERT INTO medicalrecord VALUES (600612,'','','','','','','','','');
INSERT INTO medicalrecord VALUES (600613,'','','','','','','','','');
INSERT INTO medicalrecord VALUES (600614,'','','','','','','','','');
INSERT INTO medicalrecord VALUES (600615,'','','','','','','','','');
INSERT INTO medicalrecord VALUES (600618,'qq','','','','','','','','');
INSERT INTO medicalrecord VALUES (600620,'头痛','感冒','发烧','无','吃了头孢','体温偏高','','','');




-- 诊断表
INSERT INTO diagnose VALUES(1,	3,	1,	10310,	'2010-06-11 00:00:00');
INSERT INTO diagnose VALUES(3,	4,	1,	4,	'2010-06-11 00:00:00');
INSERT INTO diagnose VALUES(4,	6,	1,	9,	'2019-03-19 00:00:00');
INSERT INTO diagnose VALUES(5,	9,	1,	5,	'2019-03-20 15:21:00');
INSERT INTO diagnose VALUES(1,	25,	2,	27149,	'2019-03-25 16:51:00');
INSERT INTO diagnose VALUES(1,	26,	1,	8,	'2019-03-26 09:28:00');
INSERT INTO diagnose VALUES(8,	27,	1,	8,	'2019-03-28 00:00:00');
INSERT INTO diagnose VALUES(1,	29,	1,	5,	'2019-03-28 13:45:00');
INSERT INTO diagnose VALUES(1,	30,	1,	1,	'2019-03-28 15:25:00');
INSERT INTO diagnose VALUES(19,	34,	1,	4,	'2019-03-29 15:15:00');
INSERT INTO diagnose VALUES(1,	0,	1,	0,	'2019-04-01 13:26:36');

-- 开设处方表
INSERT INTO prescribe  VALUES('1','600601','35','2','小儿感冒','2019-06-13','3');
INSERT INTO prescribe  VALUES('2','600601','4','5','肠炎','2019-06-13','3');
INSERT INTO prescribe  VALUES('38','600605','9','1','模板：念珠菌性皮炎','2019-06-13','1');
INSERT INTO prescribe  VALUES('39','600605','9','1','新增处方1','2019-06-13','1');
INSERT INTO prescribe  VALUES('40','600608','27','1','新增处方1','2019-06-13','2');
INSERT INTO prescribe  VALUES('41','600609','29','1','新增处方1','2019-06-13','6');
INSERT INTO prescribe  VALUES('46','600610','30','1','www','2019-06-13','6');
INSERT INTO prescribe  VALUES('47','600610','30','1','模板：病毒性胃肠炎','2019-06-13','6');
INSERT INTO prescribe  VALUES('48','600615','32','1','s1','2019-06-13','6');
INSERT INTO prescribe  VALUES('51','600618','33','1','病毒性胃肠炎','2019-06-13','1');
INSERT INTO prescribe  VALUES('52','600618','33','1','念珠菌性皮炎','2019-06-13','1');
INSERT INTO prescribe  VALUES('53','600619','34','1','病毒性胃肠炎','2019-06-13','2');
INSERT INTO prescribe  VALUES('54','600619','34','1','季节性常发哮喘','2019-06-13','2');
INSERT INTO prescribe  VALUES('55','600607','26','1','季节性常发哮喘','2019-06-13','1');
INSERT INTO prescribe  VALUES('56','600620','37','1','a1','2019-06-13','2');
INSERT INTO prescribe  VALUES('57','600620','37','1','支气管哮喘','2019-06-13','1');
INSERT INTO prescribe  VALUES('58','600620','40','2','感冒','2019-06-13','1');
INSERT INTO prescribe  VALUES('59','600620','40','2','感冒','2019-06-13','1');
INSERT INTO prescribe  VALUES('60','600620','40','2','感冒','2019-06-13','1');
INSERT INTO prescribe  VALUES('61','600620','40','2','感冒','2019-06-13','1');
INSERT INTO prescribe  VALUES('62','600620','40','2','感冒','2019-06-13','1');
INSERT INTO prescribe  VALUES('63','600620','40','2','感冒','2019-06-13','1');
INSERT INTO prescribe  VALUES('64','600620','40','2','感冒','2019-06-13','1');
INSERT INTO prescribe  VALUES('65','600620','40','2','感冒','2019-06-13','1');
INSERT INTO prescribe  VALUES('66','600620','40','2','感冒','2019-06-13','1');
INSERT INTO prescribe  VALUES('67','600620','40','2','感冒','2019-06-13','1');
INSERT INTO prescribe  VALUES('68','600620','40','2','感冒','2019-06-13','1');
INSERT INTO prescribe  VALUES('69','600620','40','2','感冒','2019-06-13','1');
INSERT INTO prescribe  VALUES('70','600620','40','2','感冒','2019-06-13','1');
INSERT INTO prescribe  VALUES('71','600620','40','2','感冒','2019-06-13','1');
INSERT INTO prescribe  VALUES('72','600620','40','2','感冒','2019-06-13','1');
INSERT INTO prescribe  VALUES('73','600620','40','2','感冒','2019-06-13','1');
INSERT INTO prescribe  VALUES('74','600620','40','2','感冒','2019-06-13','1');
INSERT INTO prescribe  VALUES('75','600620','40','2','感冒','2019-06-13','1');
INSERT INTO prescribe  VALUES('76','600620','40','2','感冒','2019-06-13','1');
INSERT INTO prescribe  VALUES('77','600620','40','2','感冒','2019-06-13','1');
INSERT INTO prescribe  VALUES('78','600620','40','2','感冒','2019-06-13','1');
INSERT INTO prescribe  VALUES('79','600620','40','2','感冒','2019-06-13','1');
INSERT INTO prescribe  VALUES('80','600620','40','2','感冒','2019-06-13','1');
INSERT INTO prescribe  VALUES('81','600620','40','2','感冒','2019-06-13','1');
INSERT INTO prescribe  VALUES('82','600620','40','2','感冒','2019-06-13','1');
INSERT INTO prescribe  VALUES('83','600620','40','2','感冒','2019-06-13','1');
INSERT INTO prescribe  VALUES('84','600620','40','2','感冒','2019-06-13','1');
INSERT INTO prescribe  VALUES('85','600620','40','2','感冒','2019-06-13','1');
INSERT INTO prescribe  VALUES('86','600620','40','2','感冒','2019-06-13','1');
INSERT INTO prescribe  VALUES('87','600620','40','2','感冒','2019-06-13','1');
INSERT INTO prescribe  VALUES('88','600620','40','2','感冒','2019-06-13','1');
INSERT INTO prescribe  VALUES('89','600620','40','2','感冒','2019-06-13','1');
INSERT INTO prescribe  VALUES('90','600620','40','2','感冒','2019-06-13','1');
INSERT INTO prescribe  VALUES('91','600620','40','2','感冒','2019-06-13','1');
INSERT INTO prescribe  VALUES('92','600620','40','2','感冒','2019-06-13','1');
INSERT INTO prescribe  VALUES('93','600620','40','2','感冒','2019-06-13','1');
INSERT INTO prescribe  VALUES('94','600620','40','2','感冒','2019-06-13','1');
INSERT INTO prescribe  VALUES('95','600620','40','2','感冒','2019-06-13','1');
INSERT INTO prescribe  VALUES('96','600620','40','2','感冒','2019-06-13','1');
INSERT INTO prescribe  VALUES('97','600620','40','2','感冒','2019-06-13','1');
INSERT INTO prescribe  VALUES('98','600620','40','2','感冒','2019-06-13','1');
INSERT INTO prescribe  VALUES('99','600620','40','2','感冒','2019-06-13','1');
INSERT INTO prescribe  VALUES('100','600620','40','2','感冒','2019-06-13','1');
UPDATE prescribe SET presdate = CURDATE() WHERE registerid = 33;



-- 处方表

INSERT INTO prescription VALUES(2,	'念珠菌性皮炎',	1,	'2019-03-21 13:25:45',	1);
INSERT INTO prescription VALUES(3,	'急性黄疸性丁型肝炎',	1,	'2019-03-21 13:25:59',	1);
INSERT INTO prescription VALUES(4,	'病毒性胃肠炎',	1,	'2019-03-21 13:26:25',	1);
INSERT INTO prescription VALUES(5,	'流行性腮腺炎NOS',	1,	'2019-03-21 13:26:33',	1);
INSERT INTO prescription VALUES(7,	'春季常发性感冒',	1,	'2019-03-22 16:34:08',	1);
INSERT INTO prescription VALUES(8,	'季节性常发哮喘',	1,	'2019-03-29 14:50:13',	1);
INSERT INTO prescription VALUES(9,	'支气管哮喘',	1,	'2019-04-01 13:43:44',	1);

-- 药品模版
INSERT INTO drugtempl VALUES( 2,	23,	'静脉注射',	'100ml',	'一日一次',	1);
INSERT INTO drugtempl VALUES( 2,	30,	'静脉注射',	'200ml',	'一日一次',	1);
INSERT INTO drugtempl VALUES( 5,	86,	'静脉注射',	'201ml',	'一日一次',	1);
INSERT INTO drugtempl VALUES( 3,	5,	'静脉注射',	'202ml',	'一日一次',	1);
INSERT INTO drugtempl VALUES( 3,	57,	'静脉注射',	'203ml',	'一日一次',	1);
INSERT INTO drugtempl VALUES( 7,	9,	'静脉注射',	'204ml',	'一日一次',	1);
INSERT INTO drugtempl VALUES( 4,	36,	'静脉注射',	'205ml',	'一日一次',	1);
INSERT INTO drugtempl VALUES( 4,	39,	'静脉注射',	'206ml',	'一日一次',	1);
INSERT INTO drugtempl VALUES( 4,	2,	'静脉注射',	'207ml',	'一日一次',	1);
INSERT INTO drugtempl VALUES( 8,	9,	'口服',	'1g',	'一日三次',	1);
INSERT INTO drugtempl VALUES( 8,	33,	'口服',	'2g',	'一日三次',	1);
INSERT INTO drugtempl VALUES( 8,	47,	'口服',	'适量',	'多次',	1);
INSERT INTO drugtempl VALUES( 9,	44,	'11',	'11',	'11',	1);
INSERT INTO drugtempl VALUES( 9,	68,	'22',	'22',	'22',	1);

-- 药品
INSERT INTO drug VALUES ('1','注射用甲氨喋呤','1g×1支',15.73,1);
INSERT INTO drug VALUES ('2','氟康唑氯化钠注射液(大扶康)','200mg×100ml/瓶',7.01,1);
INSERT INTO drug VALUES ('3','50%葡萄糖注射液(塑瓶)','10:20ml×1支',25.16,1);
INSERT INTO drug VALUES ('4','盐酸特比萘芬泡腾片（丁克）','50mg×7片/盒',40.62,1);
INSERT INTO drug VALUES ('5','红芪冲剂','10g/袋',30.79,1);
INSERT INTO drug VALUES ('6','盐酸氨酮戊酸散（外用）','118mg×1瓶',19.51,1);
INSERT INTO drug VALUES ('7','盐酸美金刚片(易贝申)','10mg×28片/盒',22.05,1);
INSERT INTO drug VALUES ('8','磷酸奥司他韦胶囊(达菲)','75mg×10粒/盒',60.96,1);
INSERT INTO drug VALUES ('9','泽泻颗粒','1g/10g/袋',0.09,1);
INSERT INTO drug VALUES ('10','山药颗粒','0.5g/10g/袋',6.79,1);
INSERT INTO drug VALUES ('11','熟大黄颗粒','1g/6g/袋',23.51,1);
INSERT INTO drug VALUES ('12','黄连颗粒','0.5g/3g袋',1.07,1);
INSERT INTO drug VALUES ('13','黄芩颗粒(酒)','2g/10g/袋',81.74,1);
INSERT INTO drug VALUES ('14','炒白芍颗粒','1g/10g/袋',31.86,1);
INSERT INTO drug VALUES ('15','炒白术颗粒','3g/10g/袋',41.5,1);
INSERT INTO drug VALUES ('16','白芷颗粒','1g/6g/袋',67.72,1);
INSERT INTO drug VALUES ('17','薤白颗粒','2.5g/10g袋',17.95,1);
INSERT INTO drug VALUES ('18','川芎颗粒','2g/6g/袋',0.7,1);
INSERT INTO drug VALUES ('19','维生素K1注射液','1ml:10mg×10支/盒',10.39,1);
INSERT INTO drug VALUES ('20','利培酮片（维思通）','1mg×20片/盒',5.52,1);
INSERT INTO drug VALUES ('21','0.9%氯化钠注射液(塑瓶)','2.25g:250ml×1瓶',14.34,1);
INSERT INTO drug VALUES ('22','0.9%氯化钠注射液（百特）','500ml×1袋',46.91,1);
INSERT INTO drug VALUES ('23','0.9%氯化钠注射液(塑瓶)','0.9g:100ml×1瓶',6.34,1);
INSERT INTO drug VALUES ('24','10%葡萄糖注射液(塑瓶)','50g:500ml×1瓶',5.04,1);
INSERT INTO drug VALUES ('25','10%葡萄糖注射液(塑瓶)','25g:250ml×1瓶',16.02,1);
INSERT INTO drug VALUES ('26','5%葡萄糖注射液(塑瓶)','25g:500ml×1瓶',47.78,1);
INSERT INTO drug VALUES ('27','5%葡萄糖注射液(塑瓶)','12.5g:250ml×1瓶',45.62,1);
INSERT INTO drug VALUES ('28','5%葡萄糖注射液(塑瓶)','5g:100ml×1瓶',17.53,1);
INSERT INTO drug VALUES ('29','胃苏颗粒','5g*9袋/盒',1.73,1);
INSERT INTO drug VALUES ('30','复方甘露醇注射液(伸宁)','250ml×1袋',15.56,1);
INSERT INTO drug VALUES ('31','艾塞那肽注射液(百泌达)','5ug:1.2ml×1支',23.71,1);
INSERT INTO drug VALUES ('32','艾塞那肽注射液(百泌达)','10ug:2.4ml×1支',91.92,1);
INSERT INTO drug VALUES ('33','丹参颗粒','2g/10g/袋',11.61,1);
INSERT INTO drug VALUES ('34','亮菌甲素注射液','10ml:5mg×1支',62.41,1);
INSERT INTO drug VALUES ('35','瞿麦','1000mg/g',43.84,1);
INSERT INTO drug VALUES ('36','肠内营养粉剂(安素)','1000mg/g',3.12,1);
INSERT INTO drug VALUES ('37','桉叶油','1000g/瓶',3.4,1);
INSERT INTO drug VALUES ('38','肉苁蓉','1000mg/g',51.82,1);
INSERT INTO drug VALUES ('39','番木鳖酊','1000mg/g',16.84,1);
INSERT INTO drug VALUES ('40','枸橼酸芬太尼注射液','0.1mg×1支',19.42,1);
INSERT INTO drug VALUES ('41','枸橼酸芬太尼注射液','0.5mg×1支',2.66,1);
INSERT INTO drug VALUES ('42','酚红(AR)','25g×1瓶',13.43,1);
INSERT INTO drug VALUES ('43','酚红IND','25g×1瓶',4.07,1);
INSERT INTO drug VALUES ('44','酚酞','25g×1瓶',10.42,1);
INSERT INTO drug VALUES ('45','蜂蜡','500g×1瓶',3.47,1);
INSERT INTO drug VALUES ('46','呋喃西林','25g×1袋',37.75,1);
INSERT INTO drug VALUES ('47','氯雷他定糖浆(开瑞坦)','60ml：60mg×1瓶',72.62,1);
INSERT INTO drug VALUES ('48','丙泊酚注射液(得普利麻)','50ml：0.5g×1瓶',2.23,1);
INSERT INTO drug VALUES ('49','BG维生素E软胶囊','0.1g×30粒/盒',11.03,1);
INSERT INTO drug VALUES ('50','贝前列素钠片','20ug×10片/盒',30.09,1);
INSERT INTO drug VALUES ('51','盐酸伊立替康注射液(开普拓）','5ml:100mg×1瓶',7.42,1);
INSERT INTO drug VALUES ('52','磺胺(AR)','100g×1瓶',1.72,1);
INSERT INTO drug VALUES ('53','白附子','1000mg/g',31.83,1);
INSERT INTO drug VALUES ('54','白癫风胶囊','1000mg/g',3.41,1);
INSERT INTO drug VALUES ('55','奋乃静片','2mg×100片/瓶',0.54,1);
INSERT INTO drug VALUES ('56','注射用头孢他啶(复达欣)','1g×1支',8.05,1);
INSERT INTO drug VALUES ('57','复方氨基酸(绿支安)18AA注射液','10.3%200ml×1瓶',49.18,1);
INSERT INTO drug VALUES ('58','吡诺克辛滴眼液(卡林-U)','5ml×1支',51.24,1);
INSERT INTO drug VALUES ('59','卡巴胆碱注射液（卡米可林）','0.1mg×1支',5.23,1);
INSERT INTO drug VALUES ('60','重组人粒细胞(特尔立)巨噬细胞集落冻干粉针','150ug×1瓶',32.97,1);
INSERT INTO drug VALUES ('61','哌拉西林他唑巴坦钠(特治星)','4.5g×1支',50.5,1);
INSERT INTO drug VALUES ('62','地黄颗粒','3g/10g/袋',5.48,1);
INSERT INTO drug VALUES ('63','当归颗粒','4g/10g/袋',68.19,1);
INSERT INTO drug VALUES ('64','维生素B1注射液','2ml:100mg×10支/盒',12.7,1);
INSERT INTO drug VALUES ('65','芒硝颗粒','10g/4g/袋',13,1);
INSERT INTO drug VALUES ('66','生大黄颗粒','1g:3g/袋',30.87,1);
INSERT INTO drug VALUES ('67','虎杖颗粒','1g/15g/袋',23.76,1);
INSERT INTO drug VALUES ('68','鱼腥草颗粒','1g/15g/袋',14.89,1);
INSERT INTO drug VALUES ('69','苦参颗粒','1g/10g/袋',1.39,1);
INSERT INTO drug VALUES ('70','硫酸镁注射液','10ml:2.5g×5支/盒',42.29,1);
INSERT INTO drug VALUES ('71','胡黄连','1000mg/g',37.2,1);
INSERT INTO drug VALUES ('72','虎杖','1000mg/g',16.01,1);
INSERT INTO drug VALUES ('73','聚桂醇注射液','10ml:100mg×1支/盒',12.87,1);
INSERT INTO drug VALUES ('74','康肤冲剂(I)','20g×10袋/盒',33.74,1);
INSERT INTO drug VALUES ('75','注射用头孢哌酮舒巴坦(舒普深)','1.5g×1瓶',2.07,1);
INSERT INTO drug VALUES ('76','清热通淋片','0.39g*48片/盒',19.18,1);
INSERT INTO drug VALUES ('77','康莱特注射液','10g×100ml/瓶',11.36,1);
INSERT INTO drug VALUES ('78','山茨菇','1000mg/g',70.02,1);
INSERT INTO drug VALUES ('79','马来酸桂哌齐特注射液(克林澳)','80mg×1支',67.66,1);
INSERT INTO drug VALUES ('80','氯化镁','500g×1瓶',6.25,1);
INSERT INTO drug VALUES ('81','呋塞米注射液(速尿)','2ml:20mg×10支/盒',5.63,1);
INSERT INTO drug VALUES ('82','注射用奈达铂（奥先达）','10mg×1支',9.04,1);
INSERT INTO drug VALUES ('83','注射用夫西地酸钠','0.125g×1支',44.97,1);
INSERT INTO drug VALUES ('84','阳起石','1000mg/g',25.38,1);
INSERT INTO drug VALUES ('85','铜绿假单胞菌注射液','1ml×1支',37.76,1);
INSERT INTO drug VALUES ('86','盐酸氟西汀胶囊(百忧解)','20mg×7粒/盒',15.61,1);
INSERT INTO drug VALUES ('87','10%氯化钠注射液','10ml:1g×5支/盒',4.5,1);
INSERT INTO drug VALUES ('88','注射用替考拉宁(他格适)','200mg×1瓶',14.21,1);
INSERT INTO drug VALUES ('89','石决明','1000mg/g',10.74,1);
INSERT INTO drug VALUES ('90','石榴皮','1000mg/g',9.49,1);
INSERT INTO drug VALUES ('91','熟地','1000mg/g',55.1,1);
INSERT INTO drug VALUES ('92','水牛角片','1000mg/g',5.68,1);
INSERT INTO drug VALUES ('93','水蜈蚣','1000mg/g',2.2,1);
INSERT INTO drug VALUES ('94','水蛭','1000mg/g',71.56,1);
INSERT INTO drug VALUES ('95','苏梗','1000mg/g',17.14,1);
INSERT INTO drug VALUES ('96','苏木','1000mg/g',34.06,1);
INSERT INTO drug VALUES ('97','太子参','1000mg/g',28.5,1);
INSERT INTO drug VALUES ('98','檀香','1000mg/g',1.48,1);
INSERT INTO drug VALUES ('99','桃仁','1000mg/g',41.29,1);
INSERT INTO drug VALUES ('100','天冬','1000mg/g',38.04,1);



-- 药品详细
INSERT INTO drugdetail VALUES(1,	'86979474000208',	'支',	'江苏恒瑞医药股份有限公司',	110,	101,	'2019-03-01 00:00:00',	NULL,	1);
INSERT INTO drugdetail VALUES(2,	'86979474000209',	'瓶',	'辉瑞制药有限公司',	110,	101,	'2019-03-01 00:00:00',	NULL,	1);
INSERT INTO drugdetail VALUES(3,	'86979474000208',	'支',	'中国大冢制药有限公司',	110,	101,	'2019-03-01 00:00:00',	NULL,	1);
INSERT INTO drugdetail VALUES(4,	'86979474000209',	'盒',	'齐鲁制药有限公司',	111,	101,	'2019-03-01 00:00:00',	NULL,	1);
INSERT INTO drugdetail VALUES(5,	'86979474000208',	'袋',	'南京药业股份有限公司药材分公司',	112,	103,	'2019-03-01 00:00:00',	NULL,	1);
INSERT INTO drugdetail VALUES(6,	'86979474000208',	'瓶',	'上海复旦张江生物医药股份有限公司',	113,	101,	'2019-03-01 00:00:00',	NULL,	1);
INSERT INTO drugdetail VALUES(7,	'86979474000209',	'盒',	'丹麦灵北药厂',	111,	101,	'2019-03-01 00:00:00',	NULL,	1);
INSERT INTO drugdetail VALUES(8,	'86979474000208',	'盒',	'上海罗氏制药有限公司S',	114,	101,	'2019-03-01 00:00:00',	NULL,	1);
INSERT INTO drugdetail VALUES(9,	'86979474000209',	'袋',	'江阴天江药业有限公司',	115,	102,	'2019-03-01 00:00:00',	NULL,	1);
INSERT INTO drugdetail VALUES(10,	'86979474000208',	'袋',	'江阴天江药业有限公司',	115,	102,	'2019-03-01 00:00:00',	NULL,	1);
INSERT INTO drugdetail VALUES(11,	'86979474000208',	'袋',	'江阴天江药业有限公司',	115,	102,	'2019-03-01 00:00:00',	NULL,	1);
INSERT INTO drugdetail VALUES(12,	'86979474000209',	'袋',	'江阴天江药业有限公司',	115,	102,	'2019-03-01 00:00:00',	NULL,	1);
INSERT INTO drugdetail VALUES(13,	'86979474000208',	'袋',	'江阴天江药业有限公司',	115,	102,	'2019-03-01 00:00:00',	NULL,	1);
INSERT INTO drugdetail VALUES(14,	'86979474000209',	'袋',	'江阴天江药业有限公司',	115,	102,	'2019-03-01 00:00:00',	NULL,	1);
INSERT INTO drugdetail VALUES(15,	'86979474000208',	'袋',	'江阴天江药业有限公司',	115,	102,	'2019-03-01 00:00:00',	NULL,	1);
INSERT INTO drugdetail VALUES(16,	'86979474000208',	'袋',	'江阴天江药业有限公司',	115,	102,	'2019-03-01 00:00:00',	NULL,	1);
INSERT INTO drugdetail VALUES(17,	'86979474000209',	'袋',	'江阴天江药业有限公司',	115,	102,	'2019-03-01 00:00:00',	NULL,	1);
INSERT INTO drugdetail VALUES(18,	'86979474000208',	'袋',	'江阴天江药业有限公司',	115,	102,	'2019-03-01 00:00:00',	NULL,	1);
INSERT INTO drugdetail VALUES(19,	'86979474000209',	'盒',	'江阴天江药业有限公司',	110,	101,	'2019-03-01 00:00:00',	NULL,	1);
INSERT INTO drugdetail VALUES(20,	'86979474000208',	'盒',	'西安杨森制药有限公司',	111,	101,	'2019-03-01 00:00:00',	NULL,	1);
INSERT INTO drugdetail VALUES(21,	'86979474000208',	'瓶',	'中国大冢制药有限公司',	110,	101,	'2019-03-01 00:00:00',	NULL,	1);
INSERT INTO drugdetail VALUES(22,	'86979474000209',	'瓶',	'上海百特医疗用品有限公司',	110,	101,	'2019-03-01 00:00:00',	NULL,	1);
INSERT INTO drugdetail VALUES(23,	'86979474000208',	'瓶',	'中国大冢制药有限公司',	110,	101,	'2019-03-01 00:00:00',	NULL,	1);
INSERT INTO drugdetail VALUES(24,	'86979474000209',	'瓶',	'中国大冢制药有限公司',	110,	101,	'2019-03-01 00:00:00',	NULL,	1);
INSERT INTO drugdetail VALUES(25,	'86979474000208',	'袋',	'中国大冢制药有限公司',	110,	101,	'2019-03-01 00:00:00',	NULL,	1);
INSERT INTO drugdetail VALUES(26,	'86979474000208',	'瓶',	'中国大冢制药有限公司',	110,	101,	'2019-03-01 00:00:00',	NULL,	1);
INSERT INTO drugdetail VALUES(27,	'86979474000209',	'瓶',	'中国大冢制药有限公司',	110,	101,	'2019-03-01 00:00:00',	NULL,	1);
INSERT INTO drugdetail VALUES(28,	'86979474000208',	'瓶',	'中国大冢制药有限公司',	110,	101,	'2019-03-01 00:00:00',	NULL,	1);
INSERT INTO drugdetail VALUES(29,	'86979474000209',	'盒',	'扬子江药业集团有限公司',	115,	102,	'2019-03-01 00:00:00',	NULL,	1);
INSERT INTO drugdetail VALUES(30,	'86979474000208',	'袋',	'南京正大天晴制药有限公司',	110,	101,	'2019-03-01 00:00:00',	NULL,	1);
INSERT INTO drugdetail VALUES(31,	'86979474000208',	'支',	'礼来（美国）公司S',	110,	101,	'2019-03-01 00:00:00',	NULL,	1);
INSERT INTO drugdetail VALUES(32,	'86979474000209',	'支',	'礼来（美国）公司',	110,	101,	'2019-03-01 00:00:00',	NULL,	1);
INSERT INTO drugdetail VALUES(33,	'86979474000208',	'袋',	'江阴天江药业有限公司',	115,	102,	'2019-03-01 00:00:00',	NULL,	1);
INSERT INTO drugdetail VALUES(34,	'86979474000209',	'支',	'云南大理药业股份有限公司',	110,	101,	'2019-03-01 00:00:00',	NULL,	1);
INSERT INTO drugdetail VALUES(35,	'86979474000208',	'克',	'江苏',	112,	103,	'2019-03-01 00:00:00',	NULL,	1);
INSERT INTO drugdetail VALUES(36,	'86979474000208',	'克',	'雅培荷兰',	116,	101,	'2019-03-01 00:00:00',	NULL,	1);
INSERT INTO drugdetail VALUES(37,	'86979474000209',	'瓶',	'吉水同仁',	157,	101,	'2019-03-01 00:00:00',	NULL,	1);
INSERT INTO drugdetail VALUES(38,	'86979474000208',	'克',	'内蒙',	112,	103,	'2019-03-01 00:00:00',	NULL,	1);
INSERT INTO drugdetail VALUES(39,	'86979474000209',	'克',	'内蒙',	157,	101,	'2019-03-01 00:00:00',	NULL,	1);
INSERT INTO drugdetail VALUES(40,	'86979474000208',	'支',	'内蒙',	110,	101,	'2019-03-01 00:00:00',	NULL,	1);
INSERT INTO drugdetail VALUES(41,	'86979474000208',	'支',	'内蒙',	110,	101,	'2019-03-01 00:00:00',	NULL,	1);
INSERT INTO drugdetail VALUES(42,	'86979474000209',	'瓶',	'内蒙',	157,	101,	'2019-03-01 00:00:00',	NULL,	1);
INSERT INTO drugdetail VALUES(43,	'86979474000208',	'瓶',	'内蒙',	157,	101,	'2019-03-01 00:00:00',	NULL,	1);
INSERT INTO drugdetail VALUES(44,	'86979474000209',	'瓶',	'内蒙',	157,	101,	'2019-03-01 00:00:00',	NULL,	1);
INSERT INTO drugdetail VALUES(45,	'86979474000208',	'瓶',	'内蒙',	157,	101,	'2019-03-01 00:00:00',	NULL,	1);
INSERT INTO drugdetail VALUES(46,	'86979474000208',	'袋',	'内蒙',	157,	101,	'2019-03-01 00:00:00',	NULL,	1);
INSERT INTO drugdetail VALUES(47,	'86979474000209',	'瓶',	'内蒙',	158,	101,	'2019-03-01 00:00:00',	NULL,	1);
INSERT INTO drugdetail VALUES(48,	'86979474000208',	'瓶',	'内蒙',	110,	101,	'2019-03-01 00:00:00',	NULL,	1);
INSERT INTO drugdetail VALUES(49,	'86979474000209',	'盒',	'内蒙',	159,	101,	'2019-03-01 00:00:00',	NULL,	1);
INSERT INTO drugdetail VALUES(50,	'86979474000208',	'盒',	'内蒙',	111,	101,	'2019-03-01 00:00:00',	NULL,	1);
INSERT INTO drugdetail VALUES(51,	'86979474000208',	'瓶',	'内蒙',	110,	101,	'2019-03-01 00:00:00',	NULL,	1);
INSERT INTO drugdetail VALUES(52,	'86979474000209',	'瓶',	'内蒙',	157,	101,	'2019-03-01 00:00:00',	NULL,	1);
INSERT INTO drugdetail VALUES(53,	'86979474000208',	'克',	'内蒙',	112,	103,	'2019-03-01 00:00:00',	NULL,	1);
INSERT INTO drugdetail VALUES(54,	'86979474000209',	'克',	'天津宏仁堂药业有限公司',	114,	101,	'2019-03-01 00:00:00',	NULL,	1);
INSERT INTO drugdetail VALUES(55,	'86979474000208',	'瓶',	'上海朝晖药业有限公司',	111,	101,	'2019-03-01 00:00:00',	NULL,	1);
INSERT INTO drugdetail VALUES(57,	'86979474000209',	'瓶',	'广州绿十字制药有限公司',	110,	101,	'2019-03-01 00:00:00',	NULL,	1);
INSERT INTO drugdetail VALUES(58,	'86979474000208',	'支',	'日本参天制药株式会社',	160,	101,	'2019-03-01 00:00:00',	NULL,	1);
INSERT INTO drugdetail VALUES(59,	'86979474000209',	'支',	'山东正大福瑞达制药有限公司',	160,	101,	'2019-03-01 00:00:00',	NULL,	1);
INSERT INTO drugdetail VALUES(60,	'86979474000208',	'瓶',	'夏门特宝生物工程股份有限公司',	161,	101,	'2019-03-01 00:00:00',	NULL,	1);
INSERT INTO drugdetail VALUES(61,	'86979474000208',	'支',	'惠氏制药有限公司',	110,	101,	'2019-03-01 00:00:00',	NULL,	1);
INSERT INTO drugdetail VALUES(62,	'86979474000209',	'袋',	'江阴天江药业有限公司',	115,	102,	'2019-03-01 00:00:00',	NULL,	1);
INSERT INTO drugdetail VALUES(63,	'86979474000208',	'袋',	'江阴天江药业有限公司',	115,	102,	'2019-03-01 00:00:00',	NULL,	1);
INSERT INTO drugdetail VALUES(64,	'86979474000209',	'盒',	'杭州民生药业有限公司',	110,	101,	'2019-03-01 00:00:00',	NULL,	1);
INSERT INTO drugdetail VALUES(65,	'86979474000208',	'袋',	'江阴天江药业有限公司',	115,	102,	'2019-03-01 00:00:00',	NULL,	1);
INSERT INTO drugdetail VALUES(66,	'86979474000208',	'袋',	'江阴天江药业有限公司',	115,	102,	'2019-03-01 00:00:00',	NULL,	1);
INSERT INTO drugdetail VALUES(67,	'86979474000209',	'袋',	'江阴天江药业有限公司',	115,	102,	'2019-03-01 00:00:00',	NULL,	1);
INSERT INTO drugdetail VALUES(68,	'86979474000208',	'袋',	'江阴天江药业有限公司',	115,	102,	'2019-03-01 00:00:00',	NULL,	1);
INSERT INTO drugdetail VALUES(69,	'86979474000209',	'袋',	'江阴天江药业有限公司',	115,	102,	'2019-03-01 00:00:00',	NULL,	1);
INSERT INTO drugdetail VALUES(70,	'86979474000208',	'盒',	'杭州民生药业有限公司',	110,	101,	'2019-03-01 00:00:00',	NULL,	1);
INSERT INTO drugdetail VALUES(71,	'86979474000208',	'克',	'进口',	112,	103,	'2019-03-01 00:00:00',	NULL,	1);
INSERT INTO drugdetail VALUES(72,	'86979474000209',	'克',	'江苏',	112,	103,	'2019-03-01 00:00:00',	NULL,	1);
INSERT INTO drugdetail VALUES(73,	'86979474000208',	'盒',	'陕西天宇制药有限公司S',	110,	101,	'2019-03-01 00:00:00',	NULL,	1);
INSERT INTO drugdetail VALUES(74,	'86979474000209',	'盒',	'南京市中西医结合医院',	162,	102,	'2019-03-01 00:00:00',	NULL,	1);
INSERT INTO drugdetail VALUES(75,	'86979474000208',	'瓶',	'辉瑞制药有限公司（大连）',	110,	101,	'2019-03-01 00:00:00',	NULL,	1);
INSERT INTO drugdetail VALUES(76,	'86979474000208',	'盒',	'江西杏林白马药业有限公司',	111,	101,	'2019-03-01 00:00:00',	NULL,	1);
INSERT INTO drugdetail VALUES(77,	'86979474000209',	'瓶',	'浙江康莱特药业有限公司',	110,	101,	'2019-03-01 00:00:00',	NULL,	1);
INSERT INTO drugdetail VALUES(78,	'86979474000208',	'克',	 '贵州',	112,	103,	'2019-03-01 00:00:00',	NULL,	1);
INSERT INTO drugdetail VALUES(79,	'86979474000209',	'支',	'北京四环制药有限公司',	110,	101,	'2019-03-01 00:00:00',	NULL,	1);
INSERT INTO drugdetail VALUES(80,	'86979474000208',	'瓶',	'北京',	157,	101,	'2019-03-01 00:00:00',	NULL,	1);
INSERT INTO drugdetail VALUES(81,	'86979474000208',	'盒',	'上海禾丰制药有限公司',	110,	101,	'2019-03-01 00:00:00',	NULL,	1);
INSERT INTO drugdetail VALUES(82,	'86979474000209',	'支',	'江苏奥赛康药业股份有限公司',	110,	101,	'2019-03-01 00:00:00',	NULL,	1);
INSERT INTO drugdetail VALUES(83,	'86979474000208',	'支',	'G成都天台山制药有限公司',	110,	101,	'2019-03-01 00:00:00',	NULL,	1);
INSERT INTO drugdetail VALUES(84,	'86979474000209',	'克',	'G成都天台山制药有限公司',	112,	103,	'2019-03-01 00:00:00',	NULL,	1);
INSERT INTO drugdetail VALUES(85,	'86979474000208',	'支',	'G成都天台山制药有限公司',	110,	101,	'2019-03-01 00:00:00',	NULL,	1);
INSERT INTO drugdetail VALUES(86,	'86979474000208',	'盒',	'G成都天台山制药有限公司',	111,	101,	'2019-03-01 00:00:00',	NULL,	1);
INSERT INTO drugdetail VALUES(87,	'86979474000209',	'盒',	'G成都天台山制药有限公司',	110,	101,	'2019-03-01 00:00:00',	NULL,	1);
INSERT INTO drugdetail VALUES(88,	'86979474000208',	'瓶',	'G成都天台山制药有限公司',	110,	101,	'2019-03-01 00:00:00',	NULL,	1);
INSERT INTO drugdetail VALUES(89,	'86979474000209',	'克',	'G成都天台山制药有限公司',	112,	103,	'2019-03-01 00:00:00',	NULL,	1);
INSERT INTO drugdetail VALUES(90,	'86979474000208',	'克',	'G成都天台山制药有限公司',	112,	103,	'2019-03-01 00:00:00',	NULL,	1);
INSERT INTO drugdetail VALUES(91,	'86979474000208',	'克',	'G成都天台山制药有限公司',	112,	103,	'2019-03-01 00:00:00',	NULL,	1);
INSERT INTO drugdetail VALUES(92,	'86979474000209',	'克',	'G成都天台山制药有限公司',	112,	103,	'2019-03-01 00:00:00',	NULL,	1);
INSERT INTO drugdetail VALUES(93,	'86979474000208',	'克',	'G成都天台山制药有限公司',	112,	103,	'2019-03-01 00:00:00',	NULL,	1);
INSERT INTO drugdetail VALUES(94,	'86979474000209',	'克',	'G成都天台山制药有限公司',	112,	103,	'2019-03-01 00:00:00',	NULL,	1);
INSERT INTO drugdetail VALUES(95,	'86979474000208',	'克',	'G成都天台山制药有限公司',	112,	103,	'2019-03-01 00:00:00',	NULL,	1);
INSERT INTO drugdetail VALUES(96,	'86979474000208',	'克',	'G成都天台山制药有限公司',	112,	103,	'2019-03-01 00:00:00',	NULL,	1);
INSERT INTO drugdetail VALUES(97,	'86979474000209',	'克',	'G成都天台山制药有限公司',	112,	103,	'2019-03-01 00:00:00',	NULL,	1);
INSERT INTO drugdetail VALUES(98,	'86979474000208',	'克',	'G成都天台山制药有限公司',	112,	103,	'2019-03-01 00:00:00',	NULL,	1);
INSERT INTO drugdetail VALUES(99,	'86979474000209',	'克',	'G成都天台山制药有限公司',	112,	103,	'2019-03-01 00:00:00',	NULL,	1);
INSERT INTO drugdetail VALUES(100,	'86979474000208',	'克',	'湖北',	112,	103,	'2019-03-01 00:00:00',	NULL,	1);


-- 疾病类别

INSERT INTO diseasetype VALUES ('1','阿米巴病','1',1);
INSERT INTO diseasetype VALUES ('2','癌症','1',1);
INSERT INTO diseasetype VALUES ('3','白斑病','1',1);
INSERT INTO diseasetype VALUES ('4','白内障','1',1);
INSERT INTO diseasetype VALUES ('5','白血病','1',1);
INSERT INTO diseasetype VALUES ('6','白血症','1',1);
INSERT INTO diseasetype VALUES ('7','百日咳','1',1);
INSERT INTO diseasetype VALUES ('8','败血病','1',1);
INSERT INTO diseasetype VALUES ('9','败血症','1',1);
INSERT INTO diseasetype VALUES ('10','斑疹热','1',1);
INSERT INTO diseasetype VALUES ('11','瘢痕','1',1);
INSERT INTO diseasetype VALUES ('12','半月板疾病','1',1);
INSERT INTO diseasetype VALUES ('13','包皮疾病','1',1);
INSERT INTO diseasetype VALUES ('14','孢子菌病','1',1);
INSERT INTO diseasetype VALUES ('15','贲门疾病','1',1);
INSERT INTO diseasetype VALUES ('16','鼻部疾病','1',1);
INSERT INTO diseasetype VALUES ('17','扁桃体疾病','1',1);
INSERT INTO diseasetype VALUES ('18','扁桃体炎','1',1);
INSERT INTO diseasetype VALUES ('19','髌骨疾病','1',1);
INSERT INTO diseasetype VALUES ('20','病毒病','1',1);
INSERT INTO diseasetype VALUES ('21','玻璃体疾病','1',1);
INSERT INTO diseasetype VALUES ('22','玻璃体炎','1',1);
INSERT INTO diseasetype VALUES ('23','不良性行为','1',1);
INSERT INTO diseasetype VALUES ('24','不育症','1',1);
INSERT INTO diseasetype VALUES ('25','产后疾病','1',1);
INSERT INTO diseasetype VALUES ('26','产科疾病','1',1);
INSERT INTO diseasetype VALUES ('27','产前检查','1',1);
INSERT INTO diseasetype VALUES ('28','产伤','1',1);
INSERT INTO diseasetype VALUES ('29','产伤引起的疾病','1',1);
INSERT INTO diseasetype VALUES ('30','肠道传染病','1',1);
INSERT INTO diseasetype VALUES ('31','肠道疾病','1',1);
INSERT INTO diseasetype VALUES ('32','肠梗阻','1',1);
INSERT INTO diseasetype VALUES ('33','肠炎','1',1);
INSERT INTO diseasetype VALUES ('34','痴呆','1',1);
INSERT INTO diseasetype VALUES ('35','齿槽疾病','1',1);
INSERT INTO diseasetype VALUES ('36','虫病','1',1);
INSERT INTO diseasetype VALUES ('37','抽动症','1',1);
INSERT INTO diseasetype VALUES ('38','出血','1',1);
INSERT INTO diseasetype VALUES ('39','出血热','1',1);
INSERT INTO diseasetype VALUES ('40','除异物','1',1);
INSERT INTO diseasetype VALUES ('41','搐动症','1',1);
INSERT INTO diseasetype VALUES ('42','搐搦症','1',1);
INSERT INTO diseasetype VALUES ('43','疮','1',1);
INSERT INTO diseasetype VALUES ('44','创伤性疾病','1',1);
INSERT INTO diseasetype VALUES ('45','垂体疾病','1',1);
INSERT INTO diseasetype VALUES ('46','唇裂','1',1);
INSERT INTO diseasetype VALUES ('47','促性腺激素缺乏症','1',1);
INSERT INTO diseasetype VALUES ('48','痤疮','1',1);
INSERT INTO diseasetype VALUES ('49','挫伤','1',1);
INSERT INTO diseasetype VALUES ('50','大肠疾病','1',1);
INSERT INTO diseasetype VALUES ('51','呆小病','1',1);
INSERT INTO diseasetype VALUES ('52','代谢紊乱','1',1);
INSERT INTO diseasetype VALUES ('53','胆囊疾病','1',1);
INSERT INTO diseasetype VALUES ('54','蛋白尿','1',1);
INSERT INTO diseasetype VALUES ('55','倒睫','1',1);
INSERT INTO diseasetype VALUES ('56','低血糖','1',1);
INSERT INTO diseasetype VALUES ('57','癫痫','1',1);
INSERT INTO diseasetype VALUES ('58','动脉闭塞','1',1);
INSERT INTO diseasetype VALUES ('59','动脉供血不足','1',1);
INSERT INTO diseasetype VALUES ('60','动脉回流','1',1);
INSERT INTO diseasetype VALUES ('61','动脉扩张','1',1);
INSERT INTO diseasetype VALUES ('62','动脉瘤','1',1);
INSERT INTO diseasetype VALUES ('63','动脉硬化','1',1);
INSERT INTO diseasetype VALUES ('64','冻伤','1',1);
INSERT INTO diseasetype VALUES ('65','痘病','1',1);
INSERT INTO diseasetype VALUES ('66','多动症','1',1);
INSERT INTO diseasetype VALUES ('67','多糖病','1',1);
INSERT INTO diseasetype VALUES ('68','恶心','1',1);
INSERT INTO diseasetype VALUES ('69','腭裂','1',1);
INSERT INTO diseasetype VALUES ('70','耳部疾病','1',1);
INSERT INTO diseasetype VALUES ('71','耳聋','1',1);
INSERT INTO diseasetype VALUES ('72','二尖瓣疾病','1',1);
INSERT INTO diseasetype VALUES ('73','发热','1',1);
INSERT INTO diseasetype VALUES ('74','发育不良','1',1);
INSERT INTO diseasetype VALUES ('75','发育疾病','1',1);
INSERT INTO diseasetype VALUES ('76','房室传导','1',1);
INSERT INTO diseasetype VALUES ('77','肥胖','1',1);
INSERT INTO diseasetype VALUES ('78','腓骨疾病','1',1);
INSERT INTO diseasetype VALUES ('79','肺病','1',1);
INSERT INTO diseasetype VALUES ('80','肺动脉疾病','1',1);
INSERT INTO diseasetype VALUES ('81','肺炎','1',1);
INSERT INTO diseasetype VALUES ('82','分娩','1',1);
INSERT INTO diseasetype VALUES ('83','蜂窝织炎','1',1);
INSERT INTO diseasetype VALUES ('84','蜂窝组织炎','1',1);
INSERT INTO diseasetype VALUES ('85','腐蚀伤','1',1);
INSERT INTO diseasetype VALUES ('86','妇科疾病','1',1);
INSERT INTO diseasetype VALUES ('87','附睾疾病','1',1);
INSERT INTO diseasetype VALUES ('88','附睾炎','1',1);
INSERT INTO diseasetype VALUES ('89','腹膜疾病','1',1);
INSERT INTO diseasetype VALUES ('90','腹膜炎','1',1);
INSERT INTO diseasetype VALUES ('91','腹泻','1',1);
INSERT INTO diseasetype VALUES ('92','肝部疾病','1',1);
INSERT INTO diseasetype VALUES ('93','肝炎','1',1);
INSERT INTO diseasetype VALUES ('94','感冒','1',1);
INSERT INTO diseasetype VALUES ('95','感染','1',1);
INSERT INTO diseasetype VALUES ('96','肛门疾病','1',1);
INSERT INTO diseasetype VALUES ('97','肛周疾病','1',1);
INSERT INTO diseasetype VALUES ('98','高血糖','1',1);
INSERT INTO diseasetype VALUES ('99','高血压','1',1);
INSERT INTO diseasetype VALUES ('100','高脂血症','1',1);
INSERT INTO diseasetype VALUES ('101','睾丸疾病','1',1);
INSERT INTO diseasetype VALUES ('102','宫颈疾病','1',1);
INSERT INTO diseasetype VALUES ('103','宫颈炎','1',1);
INSERT INTO diseasetype VALUES ('104','巩膜炎','1',1);
INSERT INTO diseasetype VALUES ('105','佝偻病','1',1);
INSERT INTO diseasetype VALUES ('106','骨刺','1',1);
INSERT INTO diseasetype VALUES ('107','骨骺炎','1',1);
INSERT INTO diseasetype VALUES ('108','骨坏死','1',1);
INSERT INTO diseasetype VALUES ('109','骨活组织检查','1',1);
INSERT INTO diseasetype VALUES ('110','骨膜炎','1',1);
INSERT INTO diseasetype VALUES ('111','骨切开','1',1);
INSERT INTO diseasetype VALUES ('112','骨软化','1',1);
INSERT INTO diseasetype VALUES ('113','骨髓疾病','1',1);
INSERT INTO diseasetype VALUES ('114','骨髓炎','1',1);
INSERT INTO diseasetype VALUES ('115','骨炎','1',1);
INSERT INTO diseasetype VALUES ('116','骨折','1',1);
INSERT INTO diseasetype VALUES ('117','骨质疏松','1',1);
INSERT INTO diseasetype VALUES ('118','骨质增生','1',1);
INSERT INTO diseasetype VALUES ('119','骨纵形短缺缺陷','1',1);
INSERT INTO diseasetype VALUES ('120','鼓膜疾病','1',1);
INSERT INTO diseasetype VALUES ('121','鼓膜炎','1',1);
INSERT INTO diseasetype VALUES ('122','鼓室炎','1',1);
INSERT INTO diseasetype VALUES ('123','关节疾病','1',1);
INSERT INTO diseasetype VALUES ('124','关节炎','1',1);
INSERT INTO diseasetype VALUES ('125','冠状动脉疾病','1',1);
INSERT INTO diseasetype VALUES ('126','龟头炎','1',1);
INSERT INTO diseasetype VALUES ('127','颌窦炎','1',1);
INSERT INTO diseasetype VALUES ('128','颌骨疾病','1',1);
INSERT INTO diseasetype VALUES ('129','颌下腺疾病','1',1);
INSERT INTO diseasetype VALUES ('130','黑(色素)瘤','1',1);
INSERT INTO diseasetype VALUES ('131','黑色素瘤','1',1);
INSERT INTO diseasetype VALUES ('132','虹膜疾病','1',1);
INSERT INTO diseasetype VALUES ('133','喉部疾病','1',1);
INSERT INTO diseasetype VALUES ('134','滑膜炎','1',1);
INSERT INTO diseasetype VALUES ('135','滑囊炎','1',1);
INSERT INTO diseasetype VALUES ('136','踝部疾病','1',1);
INSERT INTO diseasetype VALUES ('137','黄疸','1',1);
INSERT INTO diseasetype VALUES ('138','蛔虫','1',1);
INSERT INTO diseasetype VALUES ('139','昏迷','1',1);
INSERT INTO diseasetype VALUES ('140','霍乱','1',1);
INSERT INTO diseasetype VALUES ('141','肌断裂','1',1);
INSERT INTO diseasetype VALUES ('142','肌腱疾病','1',1);
INSERT INTO diseasetype VALUES ('143','肌挛缩','1',1);
INSERT INTO diseasetype VALUES ('144','肌肉萎缩','1',1);
INSERT INTO diseasetype VALUES ('145','肌无力','1',1);
INSERT INTO diseasetype VALUES ('146','肌炎','1',1);
INSERT INTO diseasetype VALUES ('147','肌张力障碍','1',1);
INSERT INTO diseasetype VALUES ('148','畸形','1',1);
INSERT INTO diseasetype VALUES ('149','疾病疗法','1',1);
INSERT INTO diseasetype VALUES ('150','挤压伤','1',1);
INSERT INTO diseasetype VALUES ('151','脊髓灰质炎','1',1);
INSERT INTO diseasetype VALUES ('152','脊髓疾病','1',1);
INSERT INTO diseasetype VALUES ('153','脊髓炎','1',1);
INSERT INTO diseasetype VALUES ('154','脊柱疾病','1',1);
INSERT INTO diseasetype VALUES ('155','脊柱炎','1',1);
INSERT INTO diseasetype VALUES ('156','寄生虫病','1',1);
INSERT INTO diseasetype VALUES ('157','甲沟炎','1',1);
INSERT INTO diseasetype VALUES ('158','甲状旁腺疾病','1',1);
INSERT INTO diseasetype VALUES ('159','甲状腺疾病','1',1);
INSERT INTO diseasetype VALUES ('160','假肢安装','1',1);
INSERT INTO diseasetype VALUES ('161','间质病','1',1);
INSERT INTO diseasetype VALUES ('162','腱鞘囊肿','1',1);
INSERT INTO diseasetype VALUES ('163','腱鞘炎','1',1);
INSERT INTO diseasetype VALUES ('164','浆膜炎','1',1);
INSERT INTO diseasetype VALUES ('165','焦虑障碍','1',1);
INSERT INTO diseasetype VALUES ('166','角膜疾病','1',1);
INSERT INTO diseasetype VALUES ('167','角膜炎','1',1);
INSERT INTO diseasetype VALUES ('168','脚气','1',1);
INSERT INTO diseasetype VALUES ('169','疖病','1',1);
INSERT INTO diseasetype VALUES ('170','结肠疾病','1',1);
INSERT INTO diseasetype VALUES ('171','结核','1',1);
INSERT INTO diseasetype VALUES ('172','结节病','1',1);
INSERT INTO diseasetype VALUES ('173','结膜疾病','1',1);
INSERT INTO diseasetype VALUES ('174','结膜炎','1',1);
INSERT INTO diseasetype VALUES ('175','截瘫','1',1);
INSERT INTO diseasetype VALUES ('176','精囊疾病','1',1);
INSERT INTO diseasetype VALUES ('177','精神和行为障碍','1',1);
INSERT INTO diseasetype VALUES ('178','颈动脉疾病','1',1);
INSERT INTO diseasetype VALUES ('179','痉挛','1',1);
INSERT INTO diseasetype VALUES ('180','静脉梗阻','1',1);
INSERT INTO diseasetype VALUES ('181','静脉疾病','1',1);
INSERT INTO diseasetype VALUES ('182','静脉瘤','1',1);
INSERT INTO diseasetype VALUES ('183','静脉曲张','1',1);
INSERT INTO diseasetype VALUES ('184','静脉栓塞','1',1);
INSERT INTO diseasetype VALUES ('185','静脉炎','1',1);
INSERT INTO diseasetype VALUES ('186','静脉阻塞','1',1);
INSERT INTO diseasetype VALUES ('187','疽病','1',1);
INSERT INTO diseasetype VALUES ('188','菌病','1',1);
INSERT INTO diseasetype VALUES ('189','菌血病','1',1);
INSERT INTO diseasetype VALUES ('190','开放性伤口','1',1);
INSERT INTO diseasetype VALUES ('191','口部疾病','1',1);
INSERT INTO diseasetype VALUES ('192','口腔炎','1',1);
INSERT INTO diseasetype VALUES ('193','口炎','1',1);
INSERT INTO diseasetype VALUES ('194','狂犬病','1',1);
INSERT INTO diseasetype VALUES ('195','溃疡','1',1);
INSERT INTO diseasetype VALUES ('196','阑尾炎','1',1);
INSERT INTO diseasetype VALUES ('197','劳损','1',1);
INSERT INTO diseasetype VALUES ('198','泪囊炎','1',1);
INSERT INTO diseasetype VALUES ('199','泪腺炎','1',1);
INSERT INTO diseasetype VALUES ('200','痢疾','1',1);
INSERT INTO diseasetype VALUES ('201','裂伤','1',1);
INSERT INTO diseasetype VALUES ('202','淋巴管疾病','1',1);
INSERT INTO diseasetype VALUES ('203','淋巴管瘤','1',1);
INSERT INTO diseasetype VALUES ('204','淋巴管炎','1',1);
INSERT INTO diseasetype VALUES ('205','淋巴疾病','1',1);
INSERT INTO diseasetype VALUES ('206','淋巴结病','1',1);
INSERT INTO diseasetype VALUES ('207','淋巴结炎','1',1);
INSERT INTO diseasetype VALUES ('208','淋巴瘤','1',1);
INSERT INTO diseasetype VALUES ('209','淋病','1',1);
INSERT INTO diseasetype VALUES ('210','流产','1',1);
INSERT INTO diseasetype VALUES ('211','流感','1',1);
INSERT INTO diseasetype VALUES ('212','瘘病','1',1);
INSERT INTO diseasetype VALUES ('213','颅内疾病','1',1);
INSERT INTO diseasetype VALUES ('214','颅内损伤','1',1);
INSERT INTO diseasetype VALUES ('215','鲁氏菌病','1',1);
INSERT INTO diseasetype VALUES ('216','螺旋体病','1',1);
INSERT INTO diseasetype VALUES ('217','麻痹','1',1);
INSERT INTO diseasetype VALUES ('218','麻风病','1',1);
INSERT INTO diseasetype VALUES ('219','麻疹','1',1);
INSERT INTO diseasetype VALUES ('220','脉管炎','1',1);
INSERT INTO diseasetype VALUES ('221','脉络膜炎','1',1);
INSERT INTO diseasetype VALUES ('222','慢性查加斯病','1',1);
INSERT INTO diseasetype VALUES ('223','盲肠疾病','1',1);
INSERT INTO diseasetype VALUES ('224','毛囊炎','1',1);
INSERT INTO diseasetype VALUES ('225','梅毒','1',1);
INSERT INTO diseasetype VALUES ('226','霉菌病','1',1);
INSERT INTO diseasetype VALUES ('227','霉菌性疾病','1',1);
INSERT INTO diseasetype VALUES ('228','免疫性疾病','1',1);
INSERT INTO diseasetype VALUES ('229','膜睫状体炎','1',1);
INSERT INTO diseasetype VALUES ('230','男科疾病','1',1);
INSERT INTO diseasetype VALUES ('231','囊肿','1',1);
INSERT INTO diseasetype VALUES ('232','脑膜炎','1',1);
INSERT INTO diseasetype VALUES ('233','脑血管病','1',1);
INSERT INTO diseasetype VALUES ('234','脑炎','1',1);
INSERT INTO diseasetype VALUES ('235','内分泌系统疾病','1',1);
INSERT INTO diseasetype VALUES ('236','念珠菌病','1',1);
INSERT INTO diseasetype VALUES ('237','尿道疾病','1',1);
INSERT INTO diseasetype VALUES ('238','尿道炎','1',1);
INSERT INTO diseasetype VALUES ('239','尿毒症','1',1);
INSERT INTO diseasetype VALUES ('240','尿失禁','1',1);
INSERT INTO diseasetype VALUES ('241','凝血疾病','1',1);
INSERT INTO diseasetype VALUES ('242','脓疱','1',1);
INSERT INTO diseasetype VALUES ('243','脓肿','1',1);
INSERT INTO diseasetype VALUES ('244','疟疾','1',1);
INSERT INTO diseasetype VALUES ('245','帕金森','1',1);
INSERT INTO diseasetype VALUES ('246','膀胱疾病','1',1);
INSERT INTO diseasetype VALUES ('247','膀胱炎','1',1);
INSERT INTO diseasetype VALUES ('248','疱疹','1',1);
INSERT INTO diseasetype VALUES ('249','盆腔炎','1',1);
INSERT INTO diseasetype VALUES ('250','皮肤病','1',1);
INSERT INTO diseasetype VALUES ('251','皮瘤','1',1);
INSERT INTO diseasetype VALUES ('252','皮炎','1',1);
INSERT INTO diseasetype VALUES ('253','脾病','1',1);
INSERT INTO diseasetype VALUES ('254','偏瘫','1',1);
INSERT INTO diseasetype VALUES ('255','贫血','1',1);
INSERT INTO diseasetype VALUES ('256','品行障碍','1',1);
INSERT INTO diseasetype VALUES ('257','破伤风','1',1);
INSERT INTO diseasetype VALUES ('258','葡萄胎','1',1);
INSERT INTO diseasetype VALUES ('259','其他肠类疾病','1',1);
INSERT INTO diseasetype VALUES ('260','其他动脉疾病','1',1);
INSERT INTO diseasetype VALUES ('261','其他瘤','1',1);
INSERT INTO diseasetype VALUES ('262','其他胰腺疾病','1',1);
INSERT INTO diseasetype VALUES ('263','其他章疾病','1',1);
INSERT INTO diseasetype VALUES ('264','其它腹部疾病','1',1);
INSERT INTO diseasetype VALUES ('265','其它骨疾病','1',1);
INSERT INTO diseasetype VALUES ('266','其它呼吸疾病','1',1);
INSERT INTO diseasetype VALUES ('267','其它肌部疾病','1',1);
INSERT INTO diseasetype VALUES ('268','其它疾病','1',1);
INSERT INTO diseasetype VALUES ('269','其它泌尿系统疾病','1',1);
INSERT INTO diseasetype VALUES ('270','其它气管病','1',1);
INSERT INTO diseasetype VALUES ('271','其它热病','1',1);
INSERT INTO diseasetype VALUES ('272','其它舌部疾病','1',1);
INSERT INTO diseasetype VALUES ('273','其它疼痛','1',1);
INSERT INTO diseasetype VALUES ('274','其它胸部疾病','1',1);
INSERT INTO diseasetype VALUES ('275','其它血液疾病','1',1);
INSERT INTO diseasetype VALUES ('276','其它咽部疾病','1',1);
INSERT INTO diseasetype VALUES ('277','其它炎症','1',1);
INSERT INTO diseasetype VALUES ('278','其它暂时无法归类的','1',1);
INSERT INTO diseasetype VALUES ('279','其它支气管病','1',1);
INSERT INTO diseasetype VALUES ('280','其它足部疾病','1',1);
INSERT INTO diseasetype VALUES ('281','脐带疾病','1',1);
INSERT INTO diseasetype VALUES ('282','气道疾病','1',1);
INSERT INTO diseasetype VALUES ('283','气管炎','1',1);
INSERT INTO diseasetype VALUES ('284','气胸','1',1);
INSERT INTO diseasetype VALUES ('285','前列腺疾病','1',1);
INSERT INTO diseasetype VALUES ('286','前列腺炎','1',1);
INSERT INTO diseasetype VALUES ('287','浅表损伤','1',1);
INSERT INTO diseasetype VALUES ('288','羟化酶缺陷','1',1);
INSERT INTO diseasetype VALUES ('289','情感障碍','1',1);
INSERT INTO diseasetype VALUES ('290','曲霉病','1',1);
INSERT INTO diseasetype VALUES ('291','染色体疾病','1',1);
INSERT INTO diseasetype VALUES ('292','人格障碍','1',1);
INSERT INTO diseasetype VALUES ('293','妊娠引起的疾病','1',1);
INSERT INTO diseasetype VALUES ('294','肉瘤 ','1',1);
INSERT INTO diseasetype VALUES ('295','肉芽肿','1',1);
INSERT INTO diseasetype VALUES ('296','蠕虫病','1',1);
INSERT INTO diseasetype VALUES ('297','乳突炎','1',1);
INSERT INTO diseasetype VALUES ('298','乳腺疾病','1',1);
INSERT INTO diseasetype VALUES ('299','乳腺炎','1',1);
INSERT INTO diseasetype VALUES ('300','软骨病','1',1);
INSERT INTO diseasetype VALUES ('301','软骨瘤','1',1);
INSERT INTO diseasetype VALUES ('302','腮腺炎','1',1);
INSERT INTO diseasetype VALUES ('303','三尖瓣疾病','1',1);
INSERT INTO diseasetype VALUES ('304','晒伤','1',1);
INSERT INTO diseasetype VALUES ('305','疝病','1',1);
INSERT INTO diseasetype VALUES ('306','伤寒','1',1);
INSERT INTO diseasetype VALUES ('307','上肢疾病','1',1);
INSERT INTO diseasetype VALUES ('308','上肢其它疾病','1',1);
INSERT INTO diseasetype VALUES ('309','烧伤','1',1);
INSERT INTO diseasetype VALUES ('310','舌炎','1',1);
INSERT INTO diseasetype VALUES ('311','蛇咬伤','1',1);
INSERT INTO diseasetype VALUES ('312','身材矮小','1',1);
INSERT INTO diseasetype VALUES ('313','神经系统疾病','1',1);
INSERT INTO diseasetype VALUES ('314','肾病','1',1);
INSERT INTO diseasetype VALUES ('315','肾炎','1',1);
INSERT INTO diseasetype VALUES ('316','声带疾病','1',1);
INSERT INTO diseasetype VALUES ('317','失语','1',1);
INSERT INTO diseasetype VALUES ('318','虱病','1',1);
INSERT INTO diseasetype VALUES ('319','湿疣','1',1);
INSERT INTO diseasetype VALUES ('320','湿疹','1',1);
INSERT INTO diseasetype VALUES ('321','十二指肠疾病','1',1);
INSERT INTO diseasetype VALUES ('322','食道疾病','1',1);
INSERT INTO diseasetype VALUES ('323','食管疾病','1',1);
INSERT INTO diseasetype VALUES ('324','食物中毒','1',1);
INSERT INTO diseasetype VALUES ('325','视力疾病','1',1);
INSERT INTO diseasetype VALUES ('326','视网膜疾病','1',1);
INSERT INTO diseasetype VALUES ('327','视网膜炎','1',1);
INSERT INTO diseasetype VALUES ('328','手部疾病','1',1);
INSERT INTO diseasetype VALUES ('329','手部其它疾病','1',1);
INSERT INTO diseasetype VALUES ('330','手术','1',1);
INSERT INTO diseasetype VALUES ('331','输精管疾病','1',1);
INSERT INTO diseasetype VALUES ('332','输卵管疾病','1',1);
INSERT INTO diseasetype VALUES ('333','输尿管疾病','1',1);
INSERT INTO diseasetype VALUES ('334','输尿管炎','1',1);
INSERT INTO diseasetype VALUES ('335','鼠疫','1',1);
INSERT INTO diseasetype VALUES ('336','水痘','1',1);
INSERT INTO diseasetype VALUES ('337','水肿','1',1);
INSERT INTO diseasetype VALUES ('338','睡眠疾病','1',1);
INSERT INTO diseasetype VALUES ('339','四肢其它疾病','1',1);
INSERT INTO diseasetype VALUES ('340','粟疹','1',1);
INSERT INTO diseasetype VALUES ('341','酸尿证','1',1);
INSERT INTO diseasetype VALUES ('342','酸血症','1',1);
INSERT INTO diseasetype VALUES ('343','损伤','1',1);
INSERT INTO diseasetype VALUES ('344','锁骨疾病','1',1);
INSERT INTO diseasetype VALUES ('345','瘫痪','1',1);
INSERT INTO diseasetype VALUES ('346','炭疽','1',1);
INSERT INTO diseasetype VALUES ('347','唐氏综合征','1',1);
INSERT INTO diseasetype VALUES ('348','糖尿病','1',1);
INSERT INTO diseasetype VALUES ('349','天花','1',1);
INSERT INTO diseasetype VALUES ('350','听道疾病','1',1);
INSERT INTO diseasetype VALUES ('351','听骨疾病','1',1);
INSERT INTO diseasetype VALUES ('352','听觉丧失','1',1);
INSERT INTO diseasetype VALUES ('353','听力疾病','1',1);
INSERT INTO diseasetype VALUES ('354','瞳孔疾病','1',1);
INSERT INTO diseasetype VALUES ('355','痛风','1',1);
INSERT INTO diseasetype VALUES ('356','痛经','1',1);
INSERT INTO diseasetype VALUES ('357','头部疾病','1',1);
INSERT INTO diseasetype VALUES ('358','头痛','1',1);
INSERT INTO diseasetype VALUES ('359','土拉菌病','1',1);
INSERT INTO diseasetype VALUES ('360','腿部疾病','1',1);
INSERT INTO diseasetype VALUES ('361','吞咽困难','1',1);
INSERT INTO diseasetype VALUES ('362','脱出','1',1);
INSERT INTO diseasetype VALUES ('363','脱发','1',1);
INSERT INTO diseasetype VALUES ('364','脱髓鞘','1',1);
INSERT INTO diseasetype VALUES ('365','脱位','1',1);
INSERT INTO diseasetype VALUES ('366','外翻','1',1);
INSERT INTO diseasetype VALUES ('367','外阴疾病','1',1);
INSERT INTO diseasetype VALUES ('368','外阴炎','1',1);
INSERT INTO diseasetype VALUES ('369','维生素疾病','1',1);
INSERT INTO diseasetype VALUES ('370','胃部疾病','1',1);
INSERT INTO diseasetype VALUES ('371','胃炎','1',1);
INSERT INTO diseasetype VALUES ('372','吸虫病','1',1);
INSERT INTO diseasetype VALUES ('373','吸收障碍','1',1);
INSERT INTO diseasetype VALUES ('374','息肉','1',1);
INSERT INTO diseasetype VALUES ('375','膝部疾病','1',1);
INSERT INTO diseasetype VALUES ('376','细胞疾病','1',1);
INSERT INTO diseasetype VALUES ('377','细胞瘤','1',1);
INSERT INTO diseasetype VALUES ('378','细胞再生障碍','1',1);
INSERT INTO diseasetype VALUES ('379','细胞增多症','1',1);
INSERT INTO diseasetype VALUES ('380','细菌性疾病','1',1);
INSERT INTO diseasetype VALUES ('381','下疳','1',1);
INSERT INTO diseasetype VALUES ('382','下肢其它疾病','1',1);
INSERT INTO diseasetype VALUES ('383','先天性疾病','1',1);
INSERT INTO diseasetype VALUES ('384','纤维瘤','1',1);
INSERT INTO diseasetype VALUES ('385','腺体疾病','1',1);
INSERT INTO diseasetype VALUES ('386','腺样体疾病','1',1);
INSERT INTO diseasetype VALUES ('387','消化道疾病','1',1);
INSERT INTO diseasetype VALUES ('388','消化疾病','1',1);
INSERT INTO diseasetype VALUES ('389','小肠疾病','1',1);
INSERT INTO diseasetype VALUES ('390','哮喘','1',1);
INSERT INTO diseasetype VALUES ('391','斜视','1',1);
INSERT INTO diseasetype VALUES ('392','心瓣疾病','1',1);
INSERT INTO diseasetype VALUES ('393','心包疾病','1',1);
INSERT INTO diseasetype VALUES ('394','心包炎','1',1);
INSERT INTO diseasetype VALUES ('395','心动过缓','1',1);
INSERT INTO diseasetype VALUES ('396','心动过速','1',1);
INSERT INTO diseasetype VALUES ('397','心肌病','1',1);
INSERT INTO diseasetype VALUES ('398','心绞痛','1',1);
INSERT INTO diseasetype VALUES ('399','心境障碍','1',1);
INSERT INTO diseasetype VALUES ('400','心律疾病','1',1);
INSERT INTO diseasetype VALUES ('401','心内膜炎','1',1);
INSERT INTO diseasetype VALUES ('402','心血管病','1',1);
INSERT INTO diseasetype VALUES ('403','心脏病','1',1);
INSERT INTO diseasetype VALUES ('404','心脏疾病','1',1);
INSERT INTO diseasetype VALUES ('405','新生儿疾病','1',1);
INSERT INTO diseasetype VALUES ('406','胸骨疾病','1',1);
INSERT INTO diseasetype VALUES ('407','胸膜疾病','1',1);
INSERT INTO diseasetype VALUES ('408','胸膜炎','1',1);
INSERT INTO diseasetype VALUES ('409','胸腺疾病','1',1);
INSERT INTO diseasetype VALUES ('410','休克','1',1);
INSERT INTO diseasetype VALUES ('411','徐动症','1',1);
INSERT INTO diseasetype VALUES ('412','眩晕','1',1);
INSERT INTO diseasetype VALUES ('413','血管疾病','1',1);
INSERT INTO diseasetype VALUES ('414','血管瘤','1',1);
INSERT INTO diseasetype VALUES ('415','血管炎','1',1);
INSERT INTO diseasetype VALUES ('416','血红蛋白病','1',1);
INSERT INTO diseasetype VALUES ('417','血红蛋白尿','1',1);
INSERT INTO diseasetype VALUES ('418','血尿','1',1);
INSERT INTO diseasetype VALUES ('419','血栓','1',1);
INSERT INTO diseasetype VALUES ('420','血小板疾病','1',1);
INSERT INTO diseasetype VALUES ('421','血友病','1',1);
INSERT INTO diseasetype VALUES ('422','血肿','1',1);
INSERT INTO diseasetype VALUES ('423','荨麻疹','1',1);
INSERT INTO diseasetype VALUES ('424','循环系统疾病','1',1);
INSERT INTO diseasetype VALUES ('425','牙齿疾病','1',1);
INSERT INTO diseasetype VALUES ('426','芽生菌病','1',1);
INSERT INTO diseasetype VALUES ('427','雅司病','1',1);
INSERT INTO diseasetype VALUES ('428','咽峡炎','1',1);
INSERT INTO diseasetype VALUES ('429','咽炎','1',1);
INSERT INTO diseasetype VALUES ('430','眼部疾病','1',1);
INSERT INTO diseasetype VALUES ('431','咬伤','1',1);
INSERT INTO diseasetype VALUES ('432','药物反应','1',1);
INSERT INTO diseasetype VALUES ('433','药物引起的疾病','1',1);
INSERT INTO diseasetype VALUES ('434','依恋障碍','1',1);
INSERT INTO diseasetype VALUES ('435','胰部疾病','1',1);
INSERT INTO diseasetype VALUES ('436','胰岛素疾病','1',1);
INSERT INTO diseasetype VALUES ('437','胰腺炎','1',1);
INSERT INTO diseasetype VALUES ('438','移植','1',1);
INSERT INTO diseasetype VALUES ('439','遗传疾病','1',1);
INSERT INTO diseasetype VALUES ('440','遗尿','1',1);
INSERT INTO diseasetype VALUES ('441','遗尿症','1',1);
INSERT INTO diseasetype VALUES ('442','抑郁','1',1);
INSERT INTO diseasetype VALUES ('443','疫苗引起的疾病','1',1);
INSERT INTO diseasetype VALUES ('444','癔病','1',1);
INSERT INTO diseasetype VALUES ('445','阴囊疾病','1',1);
INSERT INTO diseasetype VALUES ('446','引产','1',1);
INSERT INTO diseasetype VALUES ('447','引流','1',1);
INSERT INTO diseasetype VALUES ('448','营养不良','1',1);
INSERT INTO diseasetype VALUES ('449','营养过度','1',1);
INSERT INTO diseasetype VALUES ('450','蝇蛆病','1',1);
INSERT INTO diseasetype VALUES ('451','痈病','1',1);
INSERT INTO diseasetype VALUES ('452','幽门疾病','1',1);
INSERT INTO diseasetype VALUES ('453','疣病','1',1);
INSERT INTO diseasetype VALUES ('454','幼儿急疹','1',1);
INSERT INTO diseasetype VALUES ('455','原虫性疾病','1',1);
INSERT INTO diseasetype VALUES ('456','晕动病','1',1);
INSERT INTO diseasetype VALUES ('457','晕厥','1',1);
INSERT INTO diseasetype VALUES ('458','孕产妇医疗','1',1);
INSERT INTO diseasetype VALUES ('459','早熟','1',1);
INSERT INTO diseasetype VALUES ('460','造影术','1',1);
INSERT INTO diseasetype VALUES ('461','粘膜斑','1',1);
INSERT INTO diseasetype VALUES ('462','粘液囊炎','1',1);
INSERT INTO diseasetype VALUES ('463','照相术','1',1);
INSERT INTO diseasetype VALUES ('464','真菌性疾病','1',1);
INSERT INTO diseasetype VALUES ('465','支气管炎','1',1);
INSERT INTO diseasetype VALUES ('466','肢体疾病','1',1);
INSERT INTO diseasetype VALUES ('467','脂肪瘤','1',1);
INSERT INTO diseasetype VALUES ('468','直肠疾病','1',1);
INSERT INTO diseasetype VALUES ('469','指','1',1);
INSERT INTO diseasetype VALUES ('470','痣','1',1);
INSERT INTO diseasetype VALUES ('471','中毒','1',1);
INSERT INTO diseasetype VALUES ('472','中医疾病','2',1);
INSERT INTO diseasetype VALUES ('473','肿瘤','1',1);
INSERT INTO diseasetype VALUES ('474','肿胀','1',1);
INSERT INTO diseasetype VALUES ('475','蛛网膜疾病','1',1);
INSERT INTO diseasetype VALUES ('476','蛛网膜炎','1',1);
INSERT INTO diseasetype VALUES ('477','主动脉疾病','1',1);
INSERT INTO diseasetype VALUES ('478','注射','1',1);
INSERT INTO diseasetype VALUES ('479','椎管疾病','1',1);
INSERT INTO diseasetype VALUES ('480','椎管狭窄','1',1);
INSERT INTO diseasetype VALUES ('481','紫癜','1',1);
INSERT INTO diseasetype VALUES ('482','自杀','1',1);

-- 科室
INSERT INTO department VALUES ('1','心血管内科','11',1,1);
INSERT INTO department VALUES ('2','神经内科','11',1,1);
INSERT INTO department VALUES ('3','普通内科','11',1,1);
INSERT INTO department VALUES ('4','消化内科','11',1,1);
INSERT INTO department VALUES ('5','呼吸内科','11',1,1);
INSERT INTO department VALUES ('6','内分泌科','11',1,1);
INSERT INTO department VALUES ('7','肾病内科','11',1,1);
INSERT INTO department VALUES ('8','血液内科','11',1,1);
INSERT INTO department VALUES ('9','感染内科','11',1,1);
INSERT INTO department VALUES ('10','老年病内科','11',1,1);
INSERT INTO department VALUES ('11','风湿免疫内科','11',1,1);
INSERT INTO department VALUES ('12','透析科','11',1,1);
INSERT INTO department VALUES ('13','变态反应科','11',1,1);
INSERT INTO department VALUES ('14','普通外科','12',1,1);
INSERT INTO department VALUES ('15','泌尿外科','12',1,1);
INSERT INTO department VALUES ('16','神经外科','12',1,1);
INSERT INTO department VALUES ('17','胸外科','12',1,1);
INSERT INTO department VALUES ('18','整形外科','12',1,1);
INSERT INTO department VALUES ('19','肛肠外科','12',1,1);
INSERT INTO department VALUES ('20','肝胆外科','12',1,1);
INSERT INTO department VALUES ('21','乳腺外科','12',1,1);
INSERT INTO department VALUES ('22','心血管外科','12',1,1);
INSERT INTO department VALUES ('23','心脏外科','12',1,1);
INSERT INTO department VALUES ('24','器官移植','12',1,1);
INSERT INTO department VALUES ('25','微创外科','12',1,1);
INSERT INTO department VALUES ('26','功能神经外科','12',1,1);
INSERT INTO department VALUES ('27','腺体外科','12',1,1);
INSERT INTO department VALUES ('28','儿科综合','14',1,1);
INSERT INTO department VALUES ('29','小儿外科','14',1,1);
INSERT INTO department VALUES ('30','儿童保健科','14',1,1);
INSERT INTO department VALUES ('31','新生儿科','14',1,1);
INSERT INTO department VALUES ('32','小儿骨科','14',1,1);
INSERT INTO department VALUES ('33','小儿神经内科','14',1,1);
INSERT INTO department VALUES ('34','小儿呼吸科','14',1,1);
INSERT INTO department VALUES ('35','小儿血液科','14',1,1);
INSERT INTO department VALUES ('36','小儿耳鼻喉科','14',1,1);
INSERT INTO department VALUES ('37','小儿心内科','14',1,1);
INSERT INTO department VALUES ('38','小儿康复科','14',1,1);
INSERT INTO department VALUES ('39','小儿精神科','14',1,1);
INSERT INTO department VALUES ('40','小儿肾内科','14',1,1);
INSERT INTO department VALUES ('41','小儿消化科','14',1,1);
INSERT INTO department VALUES ('42','小儿皮肤科','14',1,1);
INSERT INTO department VALUES ('43','小儿急诊科','14',1,1);
INSERT INTO department VALUES ('44','小儿内分泌科','14',1,1);
INSERT INTO department VALUES ('45','小儿泌尿外科','14',1,1);
INSERT INTO department VALUES ('46','小儿感染科','14',1,1);
INSERT INTO department VALUES ('47','小儿心外科','14',1,1);
INSERT INTO department VALUES ('48','小儿胸外科','14',1,1);
INSERT INTO department VALUES ('49','小儿神经外科','14',1,1);
INSERT INTO department VALUES ('50','小儿整形科','14',1,1);
INSERT INTO department VALUES ('51','小儿风湿免疫科','14',1,1);
INSERT INTO department VALUES ('52','小儿妇科','14',1,1);
INSERT INTO department VALUES ('53','传染科','15',1,1);
INSERT INTO department VALUES ('54','肝病科','15',1,1);
INSERT INTO department VALUES ('55','艾滋病科','15',1,1);
INSERT INTO department VALUES ('56','传染危重室','15',1,1);
INSERT INTO department VALUES ('57','妇产科综合','16',1,1);
INSERT INTO department VALUES ('58','妇科','16',1,1);
INSERT INTO department VALUES ('59','产科','16',1,1);
INSERT INTO department VALUES ('60','计划生育科','16',1,1);
INSERT INTO department VALUES ('61','妇科内分泌','16',1,1);
INSERT INTO department VALUES ('62','遗传咨询科','16',1,1);
INSERT INTO department VALUES ('63','产前检查科','16',1,1);
INSERT INTO department VALUES ('64','妇泌尿科','16',1,1);
INSERT INTO department VALUES ('65','前列腺','17',1,1);
INSERT INTO department VALUES ('66','性功能障碍','17',1,1);
INSERT INTO department VALUES ('67','生殖器感染','17',1,1);
INSERT INTO department VALUES ('68','男性不育','17',1,1);
INSERT INTO department VALUES ('69','生殖整形','17',1,1);
INSERT INTO department VALUES ('70','精神科','18',1,1);
INSERT INTO department VALUES ('71','司法鉴定科','18',1,1);
INSERT INTO department VALUES ('72','药物依赖科','18',1,1);
INSERT INTO department VALUES ('73','中医精神科','18',1,1);
INSERT INTO department VALUES ('74','双相障碍科','18',1,1);
INSERT INTO department VALUES ('75','皮肤科','19',1,1);
INSERT INTO department VALUES ('76','性病科','19',1,1);
INSERT INTO department VALUES ('77','中医综合科','20',1,1);
INSERT INTO department VALUES ('78','针灸科','20',1,1);
INSERT INTO department VALUES ('79','中医骨科','20',1,1);
INSERT INTO department VALUES ('80','中医妇产科','20',1,1);
INSERT INTO department VALUES ('81','中医外科','20',1,1);
INSERT INTO department VALUES ('82','中医儿科','20',1,1);
INSERT INTO department VALUES ('83','中医肛肠科','20',1,1);
INSERT INTO department VALUES ('84','中医皮肤科','20',1,1);
INSERT INTO department VALUES ('85','中医五官科','20',1,1);
INSERT INTO department VALUES ('86','中医按摩科','20',1,1);
INSERT INTO department VALUES ('87','中医消化科','20',1,1);
INSERT INTO department VALUES ('88','中医肿瘤科','20',1,1);
INSERT INTO department VALUES ('89','中医心内科','20',1,1);
INSERT INTO department VALUES ('90','中医神经内科','20',1,1);
INSERT INTO department VALUES ('91','中医肾病内科','20',1,1);
INSERT INTO department VALUES ('92','中医内分泌','20',1,1);
INSERT INTO department VALUES ('93','中医呼吸科','20',1,1);
INSERT INTO department VALUES ('94','中医肝病科','20',1,1);
INSERT INTO department VALUES ('95','中医男科','20',1,1);
INSERT INTO department VALUES ('96','中医风湿免疫内科','20',1,1);
INSERT INTO department VALUES ('97','中医血液科','20',1,1);
INSERT INTO department VALUES ('98','中医乳腺外科','20',1,1);
INSERT INTO department VALUES ('99','中医老年病科','20',1,1);
INSERT INTO department VALUES ('100','肿瘤综合科','21',1,1);
INSERT INTO department VALUES ('101','肿瘤内科','21',1,1);
INSERT INTO department VALUES ('102','放疗科','21',1,1);
INSERT INTO department VALUES ('103','肿瘤外科','21',1,1);
INSERT INTO department VALUES ('104','肿瘤妇科','21',1,1);
INSERT INTO department VALUES ('105','骨肿瘤科','21',1,1);
INSERT INTO department VALUES ('106','肿瘤康复科','21',1,1);
INSERT INTO department VALUES ('107','骨外科','22',1,1);
INSERT INTO department VALUES ('108','手外科','22',1,1);
INSERT INTO department VALUES ('109','创伤骨科','22',1,1);
INSERT INTO department VALUES ('110','脊柱外科','22',1,1);
INSERT INTO department VALUES ('111','骨关节科','22',1,1);
INSERT INTO department VALUES ('112','骨质疏松科','22',1,1);
INSERT INTO department VALUES ('113','矫形骨科','22',1,1);
INSERT INTO department VALUES ('114','耳鼻咽喉头颈科','23',1,1);
INSERT INTO department VALUES ('115','口腔科','23',1,1);
INSERT INTO department VALUES ('116','眼科','23',1,1);
INSERT INTO department VALUES ('117','康复科','24',2,1);
INSERT INTO department VALUES ('118','理疗科','24',2,1);
INSERT INTO department VALUES ('119','麻醉科','25',2,1);
INSERT INTO department VALUES ('120','疼痛科','25',2,1);
INSERT INTO department VALUES ('121','营养科','26',2,1);
INSERT INTO department VALUES ('122','高压氧科','27',2,1);
INSERT INTO department VALUES ('123','功能检查科','27',2,1);
INSERT INTO department VALUES ('124','病理科','27',2,1);
INSERT INTO department VALUES ('125','检验科','27',2,1);
INSERT INTO department VALUES ('126','实验中心','27',2,1);
INSERT INTO department VALUES ('127','心电图科','27',2,1);
INSERT INTO department VALUES ('128','放射科','28',2,1);
INSERT INTO department VALUES ('129','超声诊断科','28',2,1);
INSERT INTO department VALUES ('130','医学影像科','28',2,1);
INSERT INTO department VALUES ('131','核医学科','28',2,1);
INSERT INTO department VALUES ('132','药剂科','29',2,1);
INSERT INTO department VALUES ('133','护理科','29',2,1);
INSERT INTO department VALUES ('134','体检科','29',2,1);
INSERT INTO department VALUES ('135','急诊科','29',2,1);
INSERT INTO department VALUES ('136','公共卫生与预防科','29',2,1);
INSERT INTO department VALUES ('137','设备科','29',4,1);
INSERT INTO department VALUES ('138','财务科','29',3,1);

-- 用户表
INSERT INTO USER VALUES ('1','bianque','bianque123','扁鹊',3,81,'是',1,1,1);
INSERT INTO USER VALUES ('2','fwb','fwb123','张仲景',3,83,'是',1,2,1);
INSERT INTO USER VALUES ('3','hqb','hqb123','皇甫谧',3,83,'是',1,2,1);
INSERT INTO USER VALUES ('4','huatuo','huatuo123','华佗',3,81,'是',2,1,1);
INSERT INTO USER VALUES ('5','xll','xll123','葛洪',3,83,'是',2,2,1);
INSERT INTO USER VALUES ('6','adq','adq123','孙思邈',3,83,'是',2,2,1);
INSERT INTO USER VALUES ('8','dd','iop888','钱乙',1,84,'否',9,2,1);
INSERT INTO USER VALUES ('9','root','root','李时珍',1,81,'否',1,1,1);
INSERT INTO USER VALUES ('10','ghy','ghy123','挂号收费员',2,81,'否',1,1,1);
INSERT INTO USER VALUES ('11','admin','admin123','医院管理员',1,81,'否',1,1,1);

-- 排班规则

INSERT INTO rule VALUES(1,	'q1',	1,	1,	'11111111100000',	1);
INSERT INTO rule VALUES(2,	'q1',	2,	6,	'11111111110000',	1);
INSERT INTO rule VALUES(3,	'q1',	1,	2,	'11111100000000',	1);
INSERT INTO rule VALUES(4,	'q1',	2,	5,	'11111111100000',	1);
INSERT INTO rule VALUES(5,	'q1',	2,	4,	'11111100000000',	1);
INSERT INTO rule VALUES(6,	'q1',	1,	3,	'11111111100000',	1);
INSERT INTO rule VALUES(7,	'周日值班',	2,	6,	'00000000001100',	1);
INSERT INTO rule VALUES(8,	'周日值班',	2,	5,	'00000000000011',	1);
INSERT INTO rule VALUES(9,	'm1',	2,	6,	'00000011110000',	1);
INSERT INTO rule VALUES(10,	'b1',	1,	1,	'11111111100000',	1);

-- 排班表
INSERT INTO scheduling VALUES(54,	'2019-04-01',	1,	1,	'上午',	1);
INSERT INTO scheduling VALUES(55,	'2019-04-01',	1,	2,	'上午',	1);
INSERT INTO scheduling VALUES(56,	'2019-04-01',	1,	3,	'上午',	1);
INSERT INTO scheduling VALUES(57,	'2019-04-01',	1,	2,	'下午',	1);
INSERT INTO scheduling VALUES(58,	'2019-04-01',	1,	3,	'下午',	1);
INSERT INTO scheduling VALUES(59,	'2019-04-02',	1,	2,	'上午',	1);
INSERT INTO scheduling VALUES(60,	'2019-04-02',	1,	3,	'上午',	1);
INSERT INTO scheduling VALUES(61,	'2019-04-02',	1,	2,	'下午',	1);
INSERT INTO scheduling VALUES(62,	'2019-04-02',	1,	3,	'下午',	1);
INSERT INTO scheduling VALUES(63,	'2019-04-03',	1,	2,	'上午',	1);
INSERT INTO scheduling VALUES(64,	'2019-04-01',	1,	1,	'下午',	1);
INSERT INTO scheduling VALUES(65,	'2019-04-03',	1,	3,	'上午',	1);
INSERT INTO scheduling VALUES(66,	'2019-04-03',	1,	2,	'下午',	1);
INSERT INTO scheduling VALUES(67,	'2019-04-02',	1,	1,	'上午',	1);
INSERT INTO scheduling VALUES(68,	'2019-04-03',	1,	3,	'下午',	1);
INSERT INTO scheduling VALUES(69,	'2019-04-02',	1,	1,	'下午',	1);
INSERT INTO scheduling VALUES(70,	'2019-04-04',	1,	3,	'上午',	1);
INSERT INTO scheduling VALUES(71,	'2019-04-03',	1,	1,	'上午',	1);
INSERT INTO scheduling VALUES(72,	'2019-04-04',	1,	3,	'下午',	1);
INSERT INTO scheduling VALUES(73,	'2019-04-03',	1,	1,	'下午',	1);
INSERT INTO scheduling VALUES(74,	'2019-04-05',	1,	3,	'上午',	1);
INSERT INTO scheduling VALUES(75,	'2019-04-04',	1,	1,	'上午',	1);
INSERT INTO scheduling VALUES(76,	'2019-04-04',	1,	1,	'下午',	1);
INSERT INTO scheduling VALUES(77,	'2019-04-05',	1,	1,	'上午',	1);
INSERT INTO scheduling VALUES(78,	'2019-03-25',	1,	1,	'上午',	1);
INSERT INTO scheduling VALUES(79,	'2019-03-25',	1,	1,	'下午',	1);
INSERT INTO scheduling VALUES(80,	'2019-03-26',	1,	1,	'上午',	1);
INSERT INTO scheduling VALUES(81,	'2019-03-26',	1,	1,	'下午',	1);
INSERT INTO scheduling VALUES(82,	'2019-03-27',	1,	1,	'上午',	1);
INSERT INTO scheduling VALUES(83,	'2019-03-27',	1,	1,	'下午',	1);
INSERT INTO scheduling VALUES(84,	'2019-03-28',	1,	1,	'上午',	1);
INSERT INTO scheduling VALUES(85,	'2019-03-28',	1,	1,	'下午',	1);
INSERT INTO scheduling VALUES(86,	'2019-03-29',	1,	1,	'上午',	1);


-- 发票


INSERT INTO invoice VALUES ('56','800801',51,2,'2019-03-25 10:09:28',301,24,51);
INSERT INTO invoice VALUES ('132','800802',48.65,3,'2019-03-25 10:09:28',9,35,51);
INSERT INTO invoice VALUES ('133','800803',-8.65,7,'2019-03-25 10:09:28',9,35,51);
INSERT INTO invoice VALUES ('134','800804',48.65,3,'2019-03-25 10:09:28',9,35,51);
INSERT INTO invoice VALUES ('135','800805',-48.65,7,'2019-03-25 10:09:28',9,35,51);
INSERT INTO invoice VALUES ('136','800806',77.9,3,'2019-03-25 10:09:28',9,35,51);
INSERT INTO invoice VALUES ('137','800807',-67.9,7,'2019-03-25 10:09:28',9,35,51);
INSERT INTO invoice VALUES ('138','800808',-10,7,'2019-03-25 10:09:28',9,35,51);
INSERT INTO invoice VALUES ('139','800809',8,3,'2019-03-25 10:09:28',9,37,51);
INSERT INTO invoice VALUES ('142','800810',129.94,3,'2019-03-25 10:09:28',9,37,51);
INSERT INTO invoice VALUES ('143','800811',-129.94,7,'2019-03-25 10:09:28',9,37,51);
INSERT INTO invoice VALUES ('144','800812',247.37,3,'2019-03-25 10:09:28',9,37,52);
INSERT INTO invoice VALUES ('145','800813',-155,7,'2019-03-25 10:09:28',9,37,51);
INSERT INTO invoice VALUES ('146','800814',0,1,'2019-03-25 10:09:28',9,40,51);
INSERT INTO invoice VALUES ('147','800815',0,1,'2019-03-25 10:09:28',9,40,51);
INSERT INTO invoice VALUES ('148','800816',0,1,'2019-03-25 10:09:28',9,40,51);
INSERT INTO invoice VALUES ('149','800817',0,1,'2019-03-25 10:09:28',9,40,51);
INSERT INTO invoice VALUES ('150','800818',0,1,'2019-03-25 10:09:28',9,40,51);
INSERT INTO invoice VALUES ('151','800819',0,1,'2019-03-25 10:09:28',9,40,51);
INSERT INTO invoice VALUES ('152','800820',0,1,'2019-03-25 10:09:28',9,40,51);
INSERT INTO invoice VALUES ('153','800821',0,1,'2019-03-25 10:09:28',9,40,51);
INSERT INTO invoice VALUES ('154','800822',0,1,'2019-03-25 10:09:28',9,40,51);
INSERT INTO invoice VALUES ('155','800823',27,1,'2019-03-25 10:09:28',9,40,51);
INSERT INTO invoice VALUES ('156','800824',27,1,'2019-03-25 10:09:28',9,40,51);
INSERT INTO invoice VALUES ('159','800827',-27,7,'2019-03-25 10:09:28',9,40,51);
INSERT INTO invoice VALUES ('160','800828',-27,7,'2019-03-25 10:09:28',9,40,51);
UPDATE invoice SET STATUS = 2 WHERE STATUS <> 1;
UPDATE invoice SET payamount=-payamount WHERE payamount<0;
UPDATE invoice SET TIME = '2019-03-25 10:09:28'; -- 纠正数据

-- 费用明细

INSERT INTO costdetail VALUES ('256','135',1,'胃苏颗粒',1.73,-5,22,'2019-04-01 11:38:23');
INSERT INTO costdetail VALUES ('257','135',1,'洗胃',40,-1,22,'2019-04-01 11:38:23');
INSERT INTO costdetail VALUES ('258','136',1,'山药颗粒',6.79,10,22,'2019-04-01 11:38:23');
INSERT INTO costdetail VALUES ('259','136',1,'灌肠',10,1,22,'2019-04-01 11:38:23');
INSERT INTO costdetail VALUES ('260','137',1,'山药颗粒',6.79,-10,22,'2019-04-01 11:38:23');
INSERT INTO costdetail VALUES ('261','138',1,'灌肠',10,-1,22,'2019-04-01 11:38:23');
INSERT INTO costdetail VALUES ('262','139',1,'挂号费',8,1,1,'2019-04-01 11:38:23');
INSERT INTO costdetail VALUES ('263','142',1,'蜂蜡',3.47,2,22,'2019-04-01 11:38:23');
INSERT INTO costdetail VALUES ('264','142',1,'甲紫溶液',41,3,22,'2019-04-01 11:38:23');
INSERT INTO costdetail VALUES ('265','143',1,'蜂蜡',3.47,-2,22,'2019-04-01 11:38:23');
INSERT INTO costdetail VALUES ('266','143',1,'甲紫溶液',41,-3,22,'2019-04-01 11:38:23');
INSERT INTO costdetail VALUES ('267','144',1,'红芪冲剂',30.79,3,22,'2019-04-01 11:38:23');
INSERT INTO costdetail VALUES ('268','144',1,'脑室碘水造影',60,1,22,'2019-04-01 11:38:23');
INSERT INTO costdetail VALUES ('269','144',1,'气脑造影',80,1,22,'2019-04-01 11:38:23');
INSERT INTO costdetail VALUES ('270','144',1,'食管钡餐透视',15,1,22,'2019-04-01 11:38:23');
INSERT INTO costdetail VALUES ('271','145',1,'脑室碘水造影',60,-1,22,'2019-04-01 11:38:23');
INSERT INTO costdetail VALUES ('272','145',1,'气脑造影',80,-1,22,'2019-04-01 11:38:23');
INSERT INTO costdetail VALUES ('273','145',1,'食管钡餐透视',15,-1,22,'2019-04-01 11:38:23');
INSERT INTO costdetail VALUES ('274','0',1,'鱼腥草颗粒',15,1,1,'2019-04-01 11:38:23');
INSERT INTO costdetail VALUES ('275','0',1,'鱼腥草颗粒',15,1,1,'2019-04-01 11:38:23');
INSERT INTO costdetail VALUES ('276','0',1,'鱼腥草颗粒',15,1,1,'2019-04-01 11:38:23');
INSERT INTO costdetail VALUES ('277','0',1,'鱼腥草颗粒',15,1,1,'2019-04-01 11:38:23');
INSERT INTO costdetail VALUES ('278','0',1,'鱼腥草颗粒',15,1,1,'2019-04-01 11:38:23');
INSERT INTO costdetail VALUES ('279','0',1,'0.9%氯化钠注射液(塑瓶)',6,2,1,'2019-04-01 11:38:23');
INSERT INTO costdetail VALUES ('280','800816',1,'鱼腥草颗粒',15,1,1,'2019-04-01 11:38:23');
INSERT INTO costdetail VALUES ('281','800816',1,'0.9%氯化钠注射液(塑瓶)',6,2,1,'2019-04-01 11:38:23');
INSERT INTO costdetail VALUES ('282','800817',1,'鱼腥草颗粒',15,1,1,'2019-04-01 11:38:23');
INSERT INTO costdetail VALUES ('283','800817',1,'0.9%氯化钠注射液(塑瓶)',6,2,1,'2019-04-01 11:38:23');
INSERT INTO costdetail VALUES ('284','800818',1,'鱼腥草颗粒',15,1,1,'2019-04-01 11:38:23');
INSERT INTO costdetail VALUES ('285','800818',1,'0.9%氯化钠注射液(塑瓶)',6,2,1,'2019-04-01 11:38:23');
INSERT INTO costdetail VALUES ('286','800819',1,'鱼腥草颗粒',15,1,1,'2019-04-01 11:38:23');
INSERT INTO costdetail VALUES ('287','800819',1,'0.9%氯化钠注射液(塑瓶)',6,2,1,'2019-04-01 11:38:23');
INSERT INTO costdetail VALUES ('288','800820',1,'鱼腥草颗粒',15,1,1,'2019-04-01 11:38:23');
INSERT INTO costdetail VALUES ('289','800820',1,'0.9%氯化钠注射液(塑瓶)',6,2,1,'2019-04-01 11:38:23');
INSERT INTO costdetail VALUES ('290','800821',1,'鱼腥草颗粒',15,1,1,'2019-04-01 11:38:23');
INSERT INTO costdetail VALUES ('291','800821',1,'0.9%氯化钠注射液(塑瓶)',6,2,1,'2019-04-01 11:38:23');
INSERT INTO costdetail VALUES ('292','800822',1,'鱼腥草颗粒',15,1,1,'2019-04-01 11:38:23');
INSERT INTO costdetail VALUES ('293','800822',1,'0.9%氯化钠注射液(塑瓶)',6,2,1,'2019-04-01 11:38:23');
INSERT INTO costdetail VALUES ('294','800824',1,'鱼腥草颗粒',15,1,1,'2019-04-01 11:38:23');
INSERT INTO costdetail VALUES ('295','800824',1,'0.9%氯化钠注射液(塑瓶)',6,2,1,'2019-04-01 11:38:23');
INSERT INTO costdetail VALUES ('296','800827',1,'鱼腥草颗粒',-15,1,1,'2019-04-01 11:38:23');
INSERT INTO costdetail VALUES ('297','800827',1,'0.9%氯化钠注射液(塑瓶)',-6,2,1,'2019-04-01 11:38:23');
INSERT INTO costdetail VALUES ('298','800828',1,'鱼腥草颗粒',-15,1,1,'2019-04-01 11:38:23');
INSERT INTO costdetail VALUES ('299','800828',1,'0.9%氯化钠注射液(塑瓶)',-6,2,1,'2019-04-01 11:38:23');
UPDATE costdetail SET num=-num WHERE num<0; -- 格式整理，价格为负表示推费



-- 结算方式
INSERT INTO payway VALUES(1,	'js001',	'自费',	1);
INSERT INTO payway VALUES(2,	'js002',	'市医保',	1);

-- 常熟项类别
INSERT INTO constanttype VALUES(1,	'DeptCategory',	'科室分类',	1);
INSERT INTO constanttype VALUES(5,	'FeeType',	'收费方式',	1);
INSERT INTO constanttype VALUES(7,	'Gender',	'性别类型',	1);
INSERT INTO constanttype VALUES(8,	'DocTitle',	'医生职称',	1);
INSERT INTO constanttype VALUES(10,	'Drugs_Type',	'药品类型',	1);
INSERT INTO constanttype VALUES(11,	'Drugs_Dosage',	'药品剂型',	1);

-- 常数项
INSERT INTO constantitem VALUES(11,	1,	'内科',	1);
INSERT INTO constantitem VALUES(12,	1,	'外科',	1);
INSERT INTO constantitem VALUES(14,	1,	'儿科',	1);
INSERT INTO constantitem VALUES(15,	1,	'传染病科',	1);
INSERT INTO constantitem VALUES(16,	1,	'妇产科',	1);
INSERT INTO constantitem VALUES(17,	1,	'男科',	1);
INSERT INTO constantitem VALUES(18,	1,	'精神心理科',	1);
INSERT INTO constantitem VALUES(19,	1,	'皮肤性病科',	1);
INSERT INTO constantitem VALUES(20,	1,	'中医科',	1);
INSERT INTO constantitem VALUES(21,	1,	'肿瘤科',	1);
INSERT INTO constantitem VALUES(22,	1,	'骨科',	1);
INSERT INTO constantitem VALUES(23,	1,	'五官科',	1);
INSERT INTO constantitem VALUES(24,	1,	'康复医学科',	1);
INSERT INTO constantitem VALUES(25,	1,	'麻醉医学科',	1);
INSERT INTO constantitem VALUES(26,	1,	'营养科',	1);
INSERT INTO constantitem VALUES(27,	1,	'医技科',	1);
INSERT INTO constantitem VALUES(28,	1,	'医学影像学',	1);
INSERT INTO constantitem VALUES(29,	1,	'其他科室',	1);
INSERT INTO constantitem VALUES(51,	5,	'现金',	1);
INSERT INTO constantitem VALUES(52,	5,	'医保卡',	1);
INSERT INTO constantitem VALUES(53,	5,	'银行卡',	1);
INSERT INTO constantitem VALUES(54,	5,	'信用卡',	1);
INSERT INTO constantitem VALUES(55,	5,	'微信',	1);
INSERT INTO constantitem VALUES(56,	5,	'支付宝',	1);
INSERT INTO constantitem VALUES(57,	5,	'云闪付',	1);
INSERT INTO constantitem VALUES(58,	5,	'其它',	1);
INSERT INTO constantitem VALUES(71,	7,	'男',	1);
INSERT INTO constantitem VALUES(72,	7,	'女',	1);
INSERT INTO constantitem VALUES(81,	8,	'主任医师',	1);
INSERT INTO constantitem VALUES(82,	8,	'副主任医师',	1);
INSERT INTO constantitem VALUES(83,	8,	'主治医师',	1);
INSERT INTO constantitem VALUES(84,	8,	'住院医师',	1);
INSERT INTO constantitem VALUES(101,	10,	'西药',	1);
INSERT INTO constantitem VALUES(102,	10,	'中成药',	1);
INSERT INTO constantitem VALUES(103,	10,	'中草药',	1);
INSERT INTO constantitem VALUES(110,	11,	'针剂',	1);
INSERT INTO constantitem VALUES(111,	11,	'片剂',	1);
INSERT INTO constantitem VALUES(112,	11,	'中药饮片',	1);
INSERT INTO constantitem VALUES(113,	11,	'散剂',	1);
INSERT INTO constantitem VALUES(114,	11,	'胶囊',	1);
INSERT INTO constantitem VALUES(115,	11,	'颗粒剂',	1);
INSERT INTO constantitem VALUES(116,	11,	'粉剂',	1);
INSERT INTO constantitem VALUES(117,	11,	'簿膜片',	1);
INSERT INTO constantitem VALUES(118,	11,	'乳剂',	1);
INSERT INTO constantitem VALUES(119,	11,	'液剂',	1);
INSERT INTO constantitem VALUES(120,	11,	'凝胶',	1);
INSERT INTO constantitem VALUES(121,	11,	'软膏剂',	1);
INSERT INTO constantitem VALUES(122,	11,	'气雾剂',	1);
INSERT INTO constantitem VALUES(123,	11,	'分散片',	1);
INSERT INTO constantitem VALUES(124,	11,	'药品器械',	1);
INSERT INTO constantitem VALUES(125,	11,	'栓剂',	1);
INSERT INTO constantitem VALUES(126,	11,	'内服水剂',	1);
INSERT INTO constantitem VALUES(127,	11,	'喷剂',	1);
INSERT INTO constantitem VALUES(128,	11,	'胶剂',	1);
INSERT INTO constantitem VALUES(129,	11,	'酊剂',	1);
INSERT INTO constantitem VALUES(130,	11,	'滴剂',	1);
INSERT INTO constantitem VALUES(131,	11,	'缓释片',	1);
INSERT INTO constantitem VALUES(132,	11,	'眼膏制剂',	1);
INSERT INTO constantitem VALUES(133,	11,	'肠溶片',	1);
INSERT INTO constantitem VALUES(134,	11,	'霜剂',	1);
INSERT INTO constantitem VALUES(135,	11,	'滴耳剂',	1);
INSERT INTO constantitem VALUES(136,	11,	'混悬剂',	1);
INSERT INTO constantitem VALUES(137,	11,	'缓释胶囊',	1);
INSERT INTO constantitem VALUES(138,	11,	'凝胶胶囊',	1);
INSERT INTO constantitem VALUES(139,	11,	'擦剂',	1);
INSERT INTO constantitem VALUES(140,	11,	'含片',	1);
INSERT INTO constantitem VALUES(141,	11,	'干混剂',	1);
INSERT INTO constantitem VALUES(142,	11,	'洗剂',	1);
INSERT INTO constantitem VALUES(143,	11,	'鼻喷剂',	1);
INSERT INTO constantitem VALUES(144,	11,	'膜剂',	1);
INSERT INTO constantitem VALUES(145,	11,	'贴膏',	1);
INSERT INTO constantitem VALUES(146,	11,	'贴剂',	1);
INSERT INTO constantitem VALUES(147,	11,	'合剂',	1);
INSERT INTO constantitem VALUES(148,	11,	'湿巾',	1);
INSERT INTO constantitem VALUES(149,	11,	'口喷剂',	1);
INSERT INTO constantitem VALUES(150,	11,	'大输液',	1);
INSERT INTO constantitem VALUES(151,	11,	'药品材料',	1);
INSERT INTO constantitem VALUES(152,	11,	'控释片',	1);
INSERT INTO constantitem VALUES(153,	11,	'滴鼻剂',	1);
INSERT INTO constantitem VALUES(154,	11,	'滴丸',	1);
INSERT INTO constantitem VALUES(155,	11,	'干糖浆剂',	1);
INSERT INTO constantitem VALUES(156,	11,	'雾化吸入剂',	1);
INSERT INTO constantitem VALUES(157,	11,	'原料药',	1);
INSERT INTO constantitem VALUES(158,	11,	'糖浆剂',	1);
INSERT INTO constantitem VALUES(159,	11,	'软胶囊',	1);
INSERT INTO constantitem VALUES(160,	11,	'滴眼剂',	1);
INSERT INTO constantitem VALUES(161,	11,	'冻干粉针',	1);
INSERT INTO constantitem VALUES(162,	11,	'冲剂',	1);
INSERT INTO constantitem VALUES(163,	11,	'丸剂',	1);
INSERT INTO constantitem VALUES(164,	11,	'口服液类',	1);




-- 额外表，仅仅用于完成查询语句中的第9题
CREATE TABLE checkpatient(
	id INT PRIMARY KEY AUTO_INCREMENT,
	recordid INT,
	regiid INT,
	itemid INT,
	itemname VARCHAR(20),
	purpose VARCHAR(20),
	checkpart VARCHAR(20),
	isurgent INT,
	number INT,
	createtime TIMESTAMP,
	doctid INT,
	checkerid INT,
	inputerid INT,
	checktime DATE,
	result VARCHAR(200),
	resulttime DATE,
	STATUS INT,
	TYPE INT
); -- 检查
INSERT INTO checkpatient VALUES(6,6,35,10,'中毒','','',0,1,'2019-03-25 08:39:40',1,2,2,NULL,NULL,NULL,'6',1);
INSERT INTO checkpatient VALUES(7,6,35,12,'中毒','','',0,1,'2019-03-25 08:39:40',1,2,2,NULL,NULL,NULL,'6',1);
INSERT INTO checkpatient VALUES(12,6,25,7,'模板：肩周炎','','',0,1,'2019-03-25 08:39:40',1,2,2,NULL,NULL,NULL,'6',1);
INSERT INTO checkpatient VALUES(24,6,25,10,'模板：骨外伤','','胃部',0,1,'2019-03-25 08:39:40',1,2,2,NULL,NULL,NULL,'1',1);
INSERT INTO checkpatient VALUES(25,6,25,1,'模板：骨外伤','','全身',0,1,'2019-03-25 08:39:40',1,2,2,NULL,NULL,NULL,'1',1);
INSERT INTO checkpatient VALUES(30,7,26,36,'模板：小儿感冒','','',0,1,'2019-03-25 08:39:40',1,2,2,NULL,NULL,NULL,'0',1);
INSERT INTO checkpatient VALUES(31,7,26,44,'模板：腱鞘炎','','',0,1,'2019-03-25 08:39:40',1,2,2,NULL,NULL,NULL,'1',1);
INSERT INTO checkpatient VALUES(32,7,26,41,'模板：腱鞘炎','','',0,1,'2019-03-25 08:39:40',1,2,2,NULL,NULL,NULL,'1',1);
INSERT INTO checkpatient VALUES(33,7,26,36,'模板：小儿感冒','','',0,1,'2019-03-25 08:39:40',1,2,2,NULL,NULL,NULL,'1',1);
INSERT INTO checkpatient VALUES(34,7,26,55,'模板：小儿感冒','','',0,1,'2019-03-25 08:39:40',1,2,2,NULL,NULL,NULL,'1',1);
INSERT INTO checkpatient VALUES(37,8,27,1,'模板：骨外伤','','全身',0,1,'2019-03-25 08:39:40',1,2,2,NULL,NULL,NULL,'3',1);
INSERT INTO checkpatient VALUES(38,8,27,10,'模板：骨外伤','','胃部',0,1,'2019-03-25 08:39:40',1,2,2,NULL,NULL,NULL,'3',1);
INSERT INTO checkpatient VALUES(39,9,29,20,'q','q','q',0,1,'2019-03-25 08:39:40',1,2,2,NULL,NULL,NULL,'6',1);
INSERT INTO checkpatient VALUES(40,9,29,29,'d','d','d',0,1,'2019-03-25 08:39:40',1,2,2,NULL,NULL,NULL,'6',1);
INSERT INTO checkpatient VALUES(41,10,30,20,'3','3','3',0,1,'2019-03-25 08:39:40',1,2,2,NULL,NULL,NULL,'6',1);
INSERT INTO checkpatient VALUES(42,10,30,27,'e','e','e',0,1,'2019-03-25 08:39:40',1,2,2,NULL,NULL,NULL,'6',1);
INSERT INTO checkpatient VALUES(43,10,30,29,'r','r','r',0,1,'2019-03-25 08:39:40',1,2,2,NULL,NULL,NULL,'6',1);
INSERT INTO checkpatient VALUES(44,15,32,20,'d','d','d',0,1,'2019-03-25 08:39:40',1,2,2,NULL,NULL,NULL,'2',1);
INSERT INTO checkpatient VALUES(45,15,32,25,'f','f','f',0,1,'2019-03-25 08:39:40',1,2,2,NULL,NULL,NULL,'2',1);
INSERT INTO checkpatient VALUES(46,15,32,28,'g','g','g',0,1,'2019-03-25 08:39:40',1,2,2,NULL,NULL,NULL,'2',1);
INSERT INTO checkpatient VALUES(47,15,32,44,'模板：腱鞘炎','','',0,1,'2019-03-25 08:39:40',1,2,2,NULL,NULL,NULL,'1',1);
INSERT INTO checkpatient VALUES(48,15,32,41,'模板：腱鞘炎','','',0,1,'2019-03-25 08:39:40',1,2,2,NULL,NULL,NULL,'1',1);
INSERT INTO checkpatient VALUES(49,18,33,55,'模板：小儿感冒','','',0,1,'2019-03-25 08:39:40',1,2,2,NULL,NULL,NULL,'3',1);
INSERT INTO checkpatient VALUES(50,18,33,36,'模板：小儿感冒','','',0,1,'2019-03-25 08:39:40',1,2,2,NULL,NULL,NULL,'3',1);
INSERT INTO checkpatient VALUES(51,19,34,55,'模板：小儿感冒','','',0,1,'2019-03-25 08:39:40',1,2,2,NULL,NULL,NULL,'2',1);
INSERT INTO checkpatient VALUES(52,19,34,36,'模板：小儿感冒','','',0,1,'2019-03-25 08:39:40',1,2,2,NULL,NULL,NULL,'2',1);
INSERT INTO checkpatient VALUES(53,20,37,29,'w','w','w',0,1,'2019-03-25 08:39:40',1,2,2,NULL,NULL,NULL,'6',1);
INSERT INTO checkpatient VALUES(54,20,37,28,'e','e','e',0,1,'2019-03-25 08:39:40',1,2,2,NULL,NULL,NULL,'6',1);
INSERT INTO checkpatient VALUES(55,20,37,25,'g','g','g',0,1,'2019-03-25 08:39:40',1,2,2,NULL,NULL,NULL,'6',1);
INSERT INTO checkpatient VALUES(58,4,6,41,'模板：腱鞘炎','','',0,1,'2019-03-25 08:39:40',1,2,2,NULL,NULL,NULL,'1',1);
INSERT INTO checkpatient VALUES(59,4,6,44,'模板：腱鞘炎','','',0,1,'2019-03-25 08:39:40',1,2,2,NULL,NULL,NULL,'1',1);



INSERT INTO disease VALUES ('1','古典型霍乱','A00.051',140,1);
INSERT INTO disease VALUES ('2','中型[典型]霍乱','A00.052',140,1);
INSERT INTO disease VALUES ('3','重型[暴发型或干性]霍乱','A00.053',140,1);
INSERT INTO disease VALUES ('4','轻型[非典型]霍乱','A00.151',140,1);
INSERT INTO disease VALUES ('5','埃尔托霍乱','A00.152',140,1);
INSERT INTO disease VALUES ('6','埃尔托小肠炎','A00.153',33,1);
INSERT INTO disease VALUES ('7','霍乱 NOS','A00.901',140,1);
INSERT INTO disease VALUES ('8','伤寒','A01.001',306,1);
INSERT INTO disease VALUES ('9','伤寒杆菌性败血症','A01.002',306,1);
INSERT INTO disease VALUES ('10','伤寒性脑膜炎','A01.003+',232,1);
INSERT INTO disease VALUES ('11','伤寒肺炎','A01.051+',81,1);
INSERT INTO disease VALUES ('12','伤寒腹膜炎','A01.052',306,1);
INSERT INTO disease VALUES ('13','埃贝特Eberth`s氏病(伤寒)','A01.053',306,1);
INSERT INTO disease VALUES ('14','肠出血性伤寒','A01.054',306,1);
INSERT INTO disease VALUES ('15','伤寒性肠穿孔','A01.055',306,1);
INSERT INTO disease VALUES ('16','肠伤寒','A01.056',306,1);
INSERT INTO disease VALUES ('17','伤寒样小肠炎','A01.057',33,1);
INSERT INTO disease VALUES ('18','甲型副伤寒','A01.101',306,1);
INSERT INTO disease VALUES ('19','乙型副伤寒','A01.201',306,1);
INSERT INTO disease VALUES ('20','丙型副伤寒','A01.301',306,1);
INSERT INTO disease VALUES ('21','副伤寒','A01.401',306,1);
INSERT INTO disease VALUES ('22','Ｂ群沙门氏菌肠炎','A02.001',33,1);
INSERT INTO disease VALUES ('23','Ｃ群沙门氏菌肠炎','A02.002',33,1);
INSERT INTO disease VALUES ('24','阿哥拉沙门氏菌肠炎','A02.003',33,1);
INSERT INTO disease VALUES ('25','沙门氏菌性肠炎','A02.004',33,1);
INSERT INTO disease VALUES ('26','沙门氏菌伦敦血清型肠炎','A02.005',33,1);
INSERT INTO disease VALUES ('27','沙门氏菌胃肠炎','A02.006',33,1);
INSERT INTO disease VALUES ('28','鼠伤寒沙门氏菌性肠炎','A02.007',33,1);
INSERT INTO disease VALUES ('29','婴儿沙门氏菌肠炎','A02.008',33,1);
INSERT INTO disease VALUES ('30','沙门氏菌肠道感染','A02.051',31,1);
INSERT INTO disease VALUES ('31','沙门氏菌(亚利桑那)小肠炎','A02.052',33,1);
INSERT INTO disease VALUES ('32','沙门氏菌败血症','A02.101',9,1);
INSERT INTO disease VALUES ('33','沙门氏菌鼠伤寒伴有败血症','A02.102',306,1);
INSERT INTO disease VALUES ('34','沙门氏菌性肺炎','A02.201+',81,1);
INSERT INTO disease VALUES ('35','沙门氏菌性关节炎','A02.202+',123,1);
INSERT INTO disease VALUES ('36','沙门氏菌性脑膜炎','A02.203+',232,1);
INSERT INTO disease VALUES ('37','沙门氏菌性骨髓炎','A02.251+',114,1);
INSERT INTO disease VALUES ('38','沙门氏菌性肾小管-间质病','A02.252+',161,1);
INSERT INTO disease VALUES ('39','其他特指的沙门氏菌感染','A02.851',95,1);
INSERT INTO disease VALUES ('40','沙门氏菌感染 NOS','A02.901',95,1);
INSERT INTO disease VALUES ('41','鼠伤寒沙门氏菌感染','A02.902',306,1);
INSERT INTO disease VALUES ('42','沙门氏菌属食物中毒','A02.903',324,1);
INSERT INTO disease VALUES ('43','什密氏志贺菌痢疾','A03.001',200,1);
INSERT INTO disease VALUES ('44','志贺-克鲁泽痢疾[A亚群志贺菌病]','A03.051',200,1);
INSERT INTO disease VALUES ('45','施米茨(－施蒂策)痢疾','A03.052',200,1);
INSERT INTO disease VALUES ('46','弗氏志贺菌痢疾','A03.101',200,1);
INSERT INTO disease VALUES ('47','希斯－罗素细菌性痢疾','A03.151',380,1);
INSERT INTO disease VALUES ('48','鲍氏志贺菌痢疾','A03.201',200,1);
INSERT INTO disease VALUES ('49','波伊德细菌性痢疾','A03.251',380,1);
INSERT INTO disease VALUES ('50','宋内氏志贺菌痢疾','A03.301',200,1);
INSERT INTO disease VALUES ('51','不定型志贺菌痢疾','A03.801',200,1);
INSERT INTO disease VALUES ('52','菌痢混合感染','A03.802',95,1);
INSERT INTO disease VALUES ('53','其他志贺菌痢疾','A03.851',200,1);
INSERT INTO disease VALUES ('54','细菌性痢疾 NOS','A03.901',380,1);
INSERT INTO disease VALUES ('55','慢性细菌性痢疾急性发作','A03.902',380,1);
INSERT INTO disease VALUES ('56','慢性迁延型细菌性痢疾','A03.903',380,1);
INSERT INTO disease VALUES ('57','慢性隐伏型菌痢','A03.904',278,1);
INSERT INTO disease VALUES ('58','中毒性[暴发型]痢疾','A03.905',200,1);
INSERT INTO disease VALUES ('59','细菌性结肠炎','A03.951',33,1);
INSERT INTO disease VALUES ('60','细菌性关节炎痢疾','A03.952+',123,1);
INSERT INTO disease VALUES ('61','新生儿肠病原性大肠埃希氏菌肠炎','A04.001',33,1);
INSERT INTO disease VALUES ('62','肠病原性大肠埃希氏菌肠炎','A04.002',33,1);
INSERT INTO disease VALUES ('63','肠道原病性大肠埃希氏菌感染','A04.051',31,1);
INSERT INTO disease VALUES ('64','肠毒性大肠埃希氏菌肠炎','A04.101',33,1);
INSERT INTO disease VALUES ('65','新生儿肠毒性大肠埃希氏菌肠炎','A04.102',33,1);
INSERT INTO disease VALUES ('66','肠毒性大肠埃希氏菌感染','A04.151',95,1);
INSERT INTO disease VALUES ('67','侵袭性大肠埃希氏菌肠炎','A04.201',33,1);
INSERT INTO disease VALUES ('68','新生儿侵袭性大肠杆菌肠炎','A04.202',33,1);
INSERT INTO disease VALUES ('69','出血性大肠埃希氏菌肠炎','A04.301',33,1);
INSERT INTO disease VALUES ('70','新生儿出血性大肠杆菌肠炎','A04.302',33,1);
INSERT INTO disease VALUES ('71','大肠埃希氏杆菌性肠道感染','A04.401',31,1);
INSERT INTO disease VALUES ('72','新生儿大肠杆菌肠炎','A04.402',33,1);
INSERT INTO disease VALUES ('73','新生儿粘附性大肠杆菌肠炎','A04.403',33,1);
INSERT INTO disease VALUES ('74','粘附性大肠杆菌肠炎','A04.404',33,1);
INSERT INTO disease VALUES ('75','弯曲杆菌肠炎','A04.501',33,1);
INSERT INTO disease VALUES ('76','耶尔森氏菌肠炎[冰箱病]','A04.601',33,1);
INSERT INTO disease VALUES ('77','难辨梭状芽胞杆菌肠炎','A04.701',33,1);
INSERT INTO disease VALUES ('78','难辨梭状芽胞杆菌性小肠结肠炎','A04.751',33,1);
INSERT INTO disease VALUES ('79','吡邻单胞菌肠炎','A04.801',33,1);
INSERT INTO disease VALUES ('80','变形杆菌性肠炎','A04.802',33,1);
INSERT INTO disease VALUES ('81','产气杆菌肠炎','A04.803',33,1);
INSERT INTO disease VALUES ('82','肠道厌氧菌感染','A04.804',31,1);
INSERT INTO disease VALUES ('83','副霍乱','A04.805',140,1);
INSERT INTO disease VALUES ('84','副溶血孤菌肠炎','A04.806',33,1);
INSERT INTO disease VALUES ('85','金黄色葡萄球菌性肠炎','A04.807',33,1);
INSERT INTO disease VALUES ('86','绿脓杆菌性肠炎','A04.808',33,1);
INSERT INTO disease VALUES ('87','难辨芽胞杆菌肠炎','A04.809',33,1);
INSERT INTO disease VALUES ('88','嗜水气单胞菌肠炎','A04.810',33,1);
INSERT INTO disease VALUES ('89','产气荚膜梭状芽胞杆菌(产气荚膜杆菌)肠炎','A04.851',33,1);
INSERT INTO disease VALUES ('90','肠道感染','A04.901',31,1);
INSERT INTO disease VALUES ('91','细菌性肠炎 NOS','A04.902',33,1);
INSERT INTO disease VALUES ('92','感染性腹泻','A04.903',95,1);
INSERT INTO disease VALUES ('93','葡萄球菌性食物中毒','A05.001',324,1);
INSERT INTO disease VALUES ('94','肉毒中毒','A05.101',471,1);
INSERT INTO disease VALUES ('95','肉毒梭状芽胞杆菌性食物中毒','A05.151',324,1);
INSERT INTO disease VALUES ('96','出血性坏死性肠炎','A05.201',33,1);
INSERT INTO disease VALUES ('97','急性坏死性肠炎','A05.202',33,1);
INSERT INTO disease VALUES ('98','急性出血性坏死性肠炎','A05.203',33,1);
INSERT INTO disease VALUES ('99','坏死性肠炎','A05.251',33,1);
INSERT INTO disease VALUES ('100','产气夹膜梭状芽胞杆菌[韦尔希梭状芽胞杆菌]性食物中毒','A05.252',324,1);
INSERT INTO disease VALUES ('101','猪腹病','A05.253',264,1);
INSERT INTO disease VALUES ('102','副溶血弧菌性食物中毒','A05.301',324,1);
INSERT INTO disease VALUES ('103','蜡样芽胞杆菌性食物中毒','A05.451',324,1);
INSERT INTO disease VALUES ('104','大肠杆菌性食物中毒','A05.851',324,1);
INSERT INTO disease VALUES ('105','嗜盐杆菌性食物中毒','A05.852',324,1);
INSERT INTO disease VALUES ('106','细菌性食物中毒','A05.901',324,1);
INSERT INTO disease VALUES ('107','食物中毒 NOS','A05.951',324,1);
INSERT INTO disease VALUES ('108','胃肠型食物中毒','A05.952',324,1);
INSERT INTO disease VALUES ('109','香肠(腊肠)食物中毒','A05.953',324,1);
INSERT INTO disease VALUES ('110','阿米巴性肠炎','A06.001',33,1);
INSERT INTO disease VALUES ('111','阿米巴性结肠炎','A06.002',33,1);
INSERT INTO disease VALUES ('112','阿米巴性痢疾','A06.003',200,1);
INSERT INTO disease VALUES ('113','肠道阿米巴病 NOS','A06.004',31,1);
INSERT INTO disease VALUES ('114','急性阿米巴痢疾','A06.005',200,1);
INSERT INTO disease VALUES ('115','急性阿米巴病','A06.051',1,1);
INSERT INTO disease VALUES ('116','慢性肠道阿米巴病','A06.101',31,1);
INSERT INTO disease VALUES ('117','慢性阿米巴性痢疾','A06.151',200,1);
INSERT INTO disease VALUES ('118','阿米巴(肠)溃疡','A06.152',1,1);
INSERT INTO disease VALUES ('119','慢性阿米巴病','A06.153',1,1);
INSERT INTO disease VALUES ('120','慢性阿米巴病肠炎','A06.154',33,1);
INSERT INTO disease VALUES ('121','非痢疾性阿米巴结肠炎','A06.201',33,1);
INSERT INTO disease VALUES ('122','非痢疾性阿米巴肠炎','A06.251',33,1);
INSERT INTO disease VALUES ('123','急性非痢疾性阿米巴肠炎','A06.252',33,1);
INSERT INTO disease VALUES ('124','慢性非痢疾性阿米巴肠炎','A06.253',33,1);
INSERT INTO disease VALUES ('125','阿米巴性肉芽肿(阿米巴瘤)','A06.301',1,1);
INSERT INTO disease VALUES ('126','阿米巴病肠穿孔','A06.351',1,1);
INSERT INTO disease VALUES ('127','肠道阿米巴','A06.352',31,1);
INSERT INTO disease VALUES ('128','阿米巴性肝脓肿','A06.401',243,1);
INSERT INTO disease VALUES ('129','肝阿米巴病','A06.402',92,1);
INSERT INTO disease VALUES ('130','阿米巴脓肿','A06.451',243,1);
INSERT INTO disease VALUES ('131','阿米巴性肺脓肿','A06.501+',243,1);
INSERT INTO disease VALUES ('132','肝肺阿米巴脓肿','A06.502+',243,1);
INSERT INTO disease VALUES ('133','阿米巴性脑脓肿','A06.651+',243,1);
INSERT INTO disease VALUES ('134','阿米巴脑和肝脓肿','A06.652+',243,1);
INSERT INTO disease VALUES ('135','阿米巴脑和肺脓肿','A06.653+',243,1);
INSERT INTO disease VALUES ('136','阿米巴脑和肝、肺脓肿','A06.654+',243,1);
INSERT INTO disease VALUES ('137','阿米巴性皮肤溃疡','A06.701',250,1);
INSERT INTO disease VALUES ('138','阿米巴皮炎','A06.751',1,1);
INSERT INTO disease VALUES ('139','肺阿米巴病','A06.801+',1,1);
INSERT INTO disease VALUES ('140','阿米巴性阑尾炎','A06.851',1,1);
INSERT INTO disease VALUES ('141','阿米巴性外阴炎','A06.852',1,1);
INSERT INTO disease VALUES ('142','阿米巴性心包炎','A06.853+',1,1);
INSERT INTO disease VALUES ('143','阿米巴性龟头炎','A06.854+',126,1);
INSERT INTO disease VALUES ('144','阿米巴病 NOS','A06.901',1,1);
INSERT INTO disease VALUES ('145','小袋虫病','A07.001',36,1);
INSERT INTO disease VALUES ('146','小袋虫性痢疾','A07.051',200,1);
INSERT INTO disease VALUES ('147','贾第虫病(肠贾第虫)[兰伯鞭毛虫病]','A07.101',36,1);
INSERT INTO disease VALUES ('148','肠梨形鞭毛虫病[蓝氏贾第鞭毛虫病]','A07.151',36,1);
INSERT INTO disease VALUES ('149','隐孢子虫病','A07.251',36,1);
INSERT INTO disease VALUES ('150','等孢子球虫病(球虫病)','A07.301',36,1);
INSERT INTO disease VALUES ('151','肠道球虫病','A07.351',31,1);
INSERT INTO disease VALUES ('152','肠道滴虫病','A07.801',31,1);
INSERT INTO disease VALUES ('153','肉孢子虫病','A07.802',36,1);
INSERT INTO disease VALUES ('154','肠道毛滴虫病','A07.851',31,1);
INSERT INTO disease VALUES ('155','鞭毛虫性腹泻','A07.951',91,1);
INSERT INTO disease VALUES ('156','原生动物性结肠炎','A07.952',33,1);
INSERT INTO disease VALUES ('157','原生动物性痢疾','A07.953',200,1);
INSERT INTO disease VALUES ('158','原生动物性腹泻','A07.954',91,1);
INSERT INTO disease VALUES ('159','旋转(轮状)病毒肠炎','A08.001',33,1);
INSERT INTO disease VALUES ('160','诺瓦克病毒肠炎','A08.101',33,1);
INSERT INTO disease VALUES ('161','流行性恶心','A08.151',68,1);
INSERT INTO disease VALUES ('162','流行性病毒性诺瓦克型胃肠病','A08.152',370,1);
INSERT INTO disease VALUES ('163','流行性呕吐综合征[布拉德利病]','A08.153',268,1);
INSERT INTO disease VALUES ('164','流行性胃肠炎[斯潘塞病]','A08.154',33,1);
INSERT INTO disease VALUES ('165','小圆结构病毒性肠炎','A08.155',33,1);
INSERT INTO disease VALUES ('166','腺病毒肠炎','A08.201',33,1);
INSERT INTO disease VALUES ('167','轮转病毒胃肠炎','A08.351',33,1);
INSERT INTO disease VALUES ('168','病毒性肠炎','A08.401',33,1);
INSERT INTO disease VALUES ('169','病毒性胃肠炎','A08.402',33,1);
INSERT INTO disease VALUES ('170','肠道病毒感染','A08.451',31,1);
INSERT INTO disease VALUES ('171','病毒性胃肠病','A08.452',370,1);
INSERT INTO disease VALUES ('172','肺结核，显微镜检证实','A15.001',171,1);
INSERT INTO disease VALUES ('173','结核性肺纤维变性，经显微镜下痰检查证实','A15.051',171,1);
INSERT INTO disease VALUES ('174','结核性气胸，经显微镜下痰检查证实','A15.052',171,1);
INSERT INTO disease VALUES ('175','结核性肺炎，经显微镜下痰检查证实','A15.053',81,1);
INSERT INTO disease VALUES ('176','结核性支气管扩张，经显微镜下痰检查证实','A15.054',171,1);
INSERT INTO disease VALUES ('177','肺结核病，仅经痰培养所证实','A15.101',171,1);
INSERT INTO disease VALUES ('178','结核性肺纤维变性，仅经痰培养所证实','A15.151',171,1);
INSERT INTO disease VALUES ('179','结核性气胸，仅经痰培养所证实','A15.152',171,1);
INSERT INTO disease VALUES ('180','结核性肺炎，仅经痰培养所证实','A15.153',81,1);
INSERT INTO disease VALUES ('181','结核性支气管扩张，仅经痰培养所证实','A15.154',171,1);
INSERT INTO disease VALUES ('182','肺结核病，经组织学所证实','A15.201',171,1);
INSERT INTO disease VALUES ('183','结核性肺纤维变性，经组织学所证实','A15.251',171,1);
INSERT INTO disease VALUES ('184','结核性气胸，经组织学所证实','A15.252',171,1);
INSERT INTO disease VALUES ('185','结核性肺炎，经组织学所证实','A15.253',81,1);
INSERT INTO disease VALUES ('186','结核性支气管扩张，经组织学所证实','A15.254',171,1);
INSERT INTO disease VALUES ('187','肺结核病，经未特指的方法所证实','A15.351',171,1);
INSERT INTO disease VALUES ('188','结核性肺纤维变性，经未特指的方法所证实','A15.352',171,1);
INSERT INTO disease VALUES ('189','结核性气胸，经未特指的方法所证实','A15.353',171,1);
INSERT INTO disease VALUES ('190','结核性肺炎，经未特指的方法所证实','A15.354',81,1);
INSERT INTO disease VALUES ('191','结核性支气管扩张，经未特指的方法所证实','A15.355',171,1);
INSERT INTO disease VALUES ('192','肺门淋巴结结核病，经细菌学和组织学所证实','A15.451',171,1);
INSERT INTO disease VALUES ('193','纵隔淋巴结结核病，经细菌学和组织学所证实','A15.452',171,1);
INSERT INTO disease VALUES ('194','气管支气管淋巴结结核病，经细菌学和组织学所证实','A15.453',171,1);
INSERT INTO disease VALUES ('195','肺门淋巴结结核,已证实','A15.501',171,1);
INSERT INTO disease VALUES ('196','支气管结核病，经细菌学和组织学所证实','A15.551',171,1);
INSERT INTO disease VALUES ('197','声门结核病，经细菌学和组织学所证实','A15.552',171,1);
INSERT INTO disease VALUES ('198','喉结核病，经细菌学和组织学所证实','A15.553',133,1);
INSERT INTO disease VALUES ('199','气管结核病，经细菌学和组织学所证实','A15.554',171,1);
INSERT INTO disease VALUES ('200','结核性胸膜炎，经细菌学和组织学所证实','A15.601',171,1);
INSERT INTO disease VALUES ('201','结核性脓胸，经细菌学和组织学所证实','A15.651',171,1);
INSERT INTO disease VALUES ('202','原发性呼吸道结核病，经细菌学和组织学所证实','A15.751',171,1);
INSERT INTO disease VALUES ('203','纵隔结核病，经细菌学和组织所证实','A15.851',171,1);
INSERT INTO disease VALUES ('204','鼻咽结核病，经细菌学和组织学所证实','A15.852',16,1);
INSERT INTO disease VALUES ('205','窦(任何鼻窦)结核病，经细菌学和组织学所证实','A15.853',16,1);
INSERT INTO disease VALUES ('206','鼻结核病，经细菌学和组织学所证实','A15.854',16,1);
INSERT INTO disease VALUES ('207','呼吸结核病 NOS，经细菌学和组织学所证实','A15.951',171,1);
INSERT INTO disease VALUES ('208','结核性支气管扩张，细菌学和组织检查为阴性','A16.051',171,1);
INSERT INTO disease VALUES ('209','结核性肺纤维变性，细菌学和组织学检查为阴性','A16.052',171,1);
INSERT INTO disease VALUES ('210','结核性肺炎，细菌学和组织学检查为阴性','A16.053',81,1);
INSERT INTO disease VALUES ('211','结核性气胸，细菌学和组织学检查为阴性','A16.054',171,1);
INSERT INTO disease VALUES ('212','肺结核病，未做细菌学和组织学检查','A16.151',171,1);
INSERT INTO disease VALUES ('213','结核性支气管扩张，未做细菌学和组织学检查','A16.152',171,1);
INSERT INTO disease VALUES ('214','结核性肺纤维变性，未做细菌学和组织学检查','A16.153',171,1);
INSERT INTO disease VALUES ('215','结核性肺炎，未做细菌学和组织学检查','A16.154',81,1);
INSERT INTO disease VALUES ('216','结核性气胸，未做细菌学和组织学检查','A16.155',171,1);
INSERT INTO disease VALUES ('217','肺干酪性结核','A16.201',171,1);
INSERT INTO disease VALUES ('218','肺结核，未提及细菌学或组织学的证实','A16.202',171,1);
INSERT INTO disease VALUES ('219','肺结核瘤，未提及细菌学或组织学的证实','A16.203',171,1);
INSERT INTO disease VALUES ('220','结核性肺炎，未提及细菌学或组织学的证实(干酪性肺炎)','A16.204',81,1);
INSERT INTO disease VALUES ('221','结核性肺纤维变性(增殖性)，未提及细菌学或组织学的证实','A16.205',171,1);
INSERT INTO disease VALUES ('222','结核性支气管扩张，未提及细菌学或组织学的证实','A16.206',171,1);
INSERT INTO disease VALUES ('223','浸润型肺结核，未提及细菌学或组织学的证实','A16.208',171,1);
INSERT INTO disease VALUES ('224','空洞型肺结核，未提及细菌学或组织学的证实','A16.209',171,1);
INSERT INTO disease VALUES ('225','增殖型肺结核，未提及细菌学或组织学的证实','A16.210',171,1);
INSERT INTO disease VALUES ('226','结核性肺出血，未提及细菌学或组织学的证实','A16.251',171,1);
INSERT INTO disease VALUES ('227','结节型肺结核，未提及细菌学或组织学的证实','A16.252',171,1);
INSERT INTO disease VALUES ('228','结核性肺脓肿，未提及细菌学或组织学的证实','A16.253',171,1);
INSERT INTO disease VALUES ('229','结核性气胸，未提及细菌学或组织学的证实','A16.254',171,1);
INSERT INTO disease VALUES ('230','矽肺肺结核，未提及细菌学或组织学的证实','A16.255',171,1);
INSERT INTO disease VALUES ('231','肺门淋巴结核，未提及细菌学或组织学的证实','A16.301',171,1);
INSERT INTO disease VALUES ('232','结核性支气管淋巴瘘','A16.302',171,1);
INSERT INTO disease VALUES ('233','胸壁淋巴结结核','A16.303',171,1);
INSERT INTO disease VALUES ('234','胸内淋巴结核，未提及细菌学或组织学的证实','A16.304',171,1);
INSERT INTO disease VALUES ('235','支气管淋巴结结核','A16.305',171,1);
INSERT INTO disease VALUES ('236','纵隔淋巴结核，未提及细菌学或组织学的证实','A16.306',171,1);
INSERT INTO disease VALUES ('237','气管支气管淋巴结核，未提及细菌学或组织学的证实','A16.351',171,1);
INSERT INTO disease VALUES ('238','喉结核，未提及细菌学或组织学的证实','A16.401',133,1);
INSERT INTO disease VALUES ('239','会厌结核','A16.402',171,1);
INSERT INTO disease VALUES ('240','气管结核，未提及细菌学或组织学的证实','A16.403',171,1);
INSERT INTO disease VALUES ('241','孤立性气管结核','A16.404',171,1);
INSERT INTO disease VALUES ('242','孤立性气管支气管结核','A16.405',171,1);
INSERT INTO disease VALUES ('243','支气管结核，未提及细菌学或组织学的证实','A16.406',171,1);
INSERT INTO disease VALUES ('244','支气管内膜结核，未提及细菌学或组织学的证实','A16.407',171,1);
INSERT INTO disease VALUES ('245','声门结核病，未提及细菌学或组织学的证实','A16.451',171,1);
INSERT INTO disease VALUES ('246','结核性干性胸膜炎','A16.501',171,1);
INSERT INTO disease VALUES ('247','结核性脓胸，未提及细菌学或组织学的证实','A16.502',171,1);
INSERT INTO disease VALUES ('248','结核性渗出性胸膜炎','A16.503',171,1);
INSERT INTO disease VALUES ('249','结核性胸膜炎(Ⅴ型)，未提及细菌学或组织学的证实','A16.504',171,1);
INSERT INTO disease VALUES ('250','结核性胸腔积液，未提及细菌学或组织学的证实','A16.505',171,1);
INSERT INTO disease VALUES ('251','胸膜结核，未提及细菌学或组织学的证实','A16.506',171,1);
INSERT INTO disease VALUES ('252','胸膜结核瘤，未提及细菌学或组织学的证实','A16.507',171,1);
INSERT INTO disease VALUES ('253','结核性胸膜炎伴积液，未提及细菌学或组织学的证实','A16.551',171,1);
INSERT INTO disease VALUES ('254','肺原发性结核性复征(原发综合征)，未提及细菌学或组织学的证实','A16.701',171,1);
INSERT INTO disease VALUES ('255','原发性肺结核，未提及细菌学或组织学的证实','A16.702',171,1);
INSERT INTO disease VALUES ('256','原发性呼吸道结核病，未提及细菌学或组织学的证实','A16.751',171,1);
INSERT INTO disease VALUES ('257','原发性结核性胸膜炎，未提及细菌学或组织学的证实','A16.752',171,1);
INSERT INTO disease VALUES ('258','鼻结核，未提及细菌学或组织学的证实','A16.801',16,1);
INSERT INTO disease VALUES ('259','干酪性鼻窦炎，未提及细菌学或组织学的证实','A16.802',16,1);
INSERT INTO disease VALUES ('260','干酪性鼻炎(结核性鼻炎)，未提及细菌学或组织学的证实','A16.803',16,1);
INSERT INTO disease VALUES ('261','膈结核','A16.804',171,1);
INSERT INTO disease VALUES ('262','胸壁结核，未提及细菌学或组织学的证实','A16.805',171,1);
INSERT INTO disease VALUES ('263','咽部结核','A16.806',171,1);
INSERT INTO disease VALUES ('264','纵膈结核瘤','A16.807',171,1);
INSERT INTO disease VALUES ('265','纵膈结核病，未提及细菌学或组织学的证实','A16.851',171,1);
INSERT INTO disease VALUES ('266','鼻窦道(任何鼻窦)结核病，未提及细菌学或组织学的证实','A16.852',16,1);
INSERT INTO disease VALUES ('267','鼻咽结核病，未提及细菌学或组织学的证实','A16.853',16,1);
INSERT INTO disease VALUES ('268','鼻窦结核，未提及细菌学或组织学的证实','A16.854',16,1);
INSERT INTO disease VALUES ('269','扁桃体结核，未提及细菌学或组织学的证实','A16.855',171,1);
INSERT INTO disease VALUES ('270','结核病，未提及细菌学或组织学的证实 NOS','A16.901',171,1);
INSERT INTO disease VALUES ('271','结核感染','A16.902',171,1);
INSERT INTO disease VALUES ('272','呼吸道结核病，未提及细菌学或组织学的证实','A16.951',171,1);
INSERT INTO disease VALUES ('273','结核性脊膜炎','A17.001+',171,1);
INSERT INTO disease VALUES ('274','结核性脑脊髓膜炎','A17.002+',171,1);
INSERT INTO disease VALUES ('275','结核性脑膜炎','A17.003+',171,1);
INSERT INTO disease VALUES ('276','结核性蛛网膜炎','A17.051+',171,1);
INSERT INTO disease VALUES ('277','结核性柔脑膜炎','A17.052+',171,1);
INSERT INTO disease VALUES ('278','脑膜结核瘤','A17.151+',171,1);
INSERT INTO disease VALUES ('279','脑脊膜核瘤','A17.152+',234,1);
INSERT INTO disease VALUES ('280','结核性脑膜脑炎','A17.801+',171,1);
INSERT INTO disease VALUES ('281','结核性脑脓肿','A17.802+',171,1);
INSERT INTO disease VALUES ('282','结核性脑肉芽肿','A17.803+',171,1);
INSERT INTO disease VALUES ('283','结核性脑炎','A17.804+',171,1);
INSERT INTO disease VALUES ('284','结核性脑脊髓膜炎(硬脊膜外)','A17.805+',171,1);
INSERT INTO disease VALUES ('285','脑结核瘤','A17.806+',171,1);
INSERT INTO disease VALUES ('286','中枢神经系统结核','A17.807+',313,1);
INSERT INTO disease VALUES ('287','结核性脊髓炎','A17.851+',171,1);
INSERT INTO disease VALUES ('288','脊髓结核病','A17.852+',171,1);
INSERT INTO disease VALUES ('289','结核性多神经病','A17.853+',313,1);
INSERT INTO disease VALUES ('290','神经系统结核病 NOS','A17.951+',313,1);
INSERT INTO disease VALUES ('291','鼻骨结核','A18.001+',16,1);
INSERT INTO disease VALUES ('292','腭骨结核','A18.002+',171,1);
INSERT INTO disease VALUES ('293','颌骨结核','A18.003+',171,1);
INSERT INTO disease VALUES ('294','乳突结核','A18.004+',171,1);
INSERT INTO disease VALUES ('295','下颌结核','A18.005+',171,1);
INSERT INTO disease VALUES ('296','颧骨结核','A18.006+',171,1);
INSERT INTO disease VALUES ('297','颈椎结核','A18.007+',171,1);
INSERT INTO disease VALUES ('298','肩关节结核','A18.008+',123,1);
INSERT INTO disease VALUES ('299','腕关节结核','A18.009+',123,1);
INSERT INTO disease VALUES ('300','胸椎结核','A18.010+',171,1);
INSERT INTO disease VALUES ('301','腰椎结核','A18.011+',171,1);
INSERT INTO disease VALUES ('302','跖趾关节结核','A18.012+',123,1);
INSERT INTO disease VALUES ('303','脊柱结核性截瘫(波特氏截瘫)','A18.013+',171,1);
INSERT INTO disease VALUES ('304','骶髂关节结核','A18.014+',123,1);
INSERT INTO disease VALUES ('305','结核性风湿病[篷塞氏病]','A18.015+',171,1);
INSERT INTO disease VALUES ('306','脊柱结核性脓肿','A18.016+',171,1);
INSERT INTO disease VALUES ('307','滑膜结核','A18.017+',171,1);
INSERT INTO disease VALUES ('308','脊椎结核并椎旁脓肿','A18.018+',171,1);
INSERT INTO disease VALUES ('309','关节结核性脓肿(关节寒性脓肿)','A18.019+',123,1);
INSERT INTO disease VALUES ('310','结核性脊柱后凸','A18.020+',171,1);
INSERT INTO disease VALUES ('311','关节结核','A18.021+',123,1);
INSERT INTO disease VALUES ('312','肘关节结核','A18.022+',123,1);
INSERT INTO disease VALUES ('313','髋关节结核','A18.023+',123,1);
INSERT INTO disease VALUES ('314','髋结核性滑膜炎','A18.024+',171,1);
INSERT INTO disease VALUES ('315','踝关节结核','A18.025+',123,1);
INSERT INTO disease VALUES ('316','耻骨结核','A18.026+',171,1);
INSERT INTO disease VALUES ('317','肋骨结核','A18.027+',171,1);
INSERT INTO disease VALUES ('318','膝关节结核','A18.028+',123,1);
INSERT INTO disease VALUES ('319','膝结核性滑膜炎','A18.029+',171,1);
INSERT INTO disease VALUES ('320','肱骨结核','A18.031+',171,1);
INSERT INTO disease VALUES ('321','股骨结核','A18.032+',171,1);
INSERT INTO disease VALUES ('322','趾骨结核','A18.033+',171,1);
INSERT INTO disease VALUES ('323','肢体骨结核','A18.034+',171,1);
INSERT INTO disease VALUES ('324','骨结核','A18.035+',171,1);
INSERT INTO disease VALUES ('325','尺骨结核','A18.036+',171,1);
INSERT INTO disease VALUES ('326','腓骨结核','A18.037+',171,1);
INSERT INTO disease VALUES ('327','胫骨结核','A18.038+',171,1);
INSERT INTO disease VALUES ('328','跟骨结核','A18.039+',171,1);
INSERT INTO disease VALUES ('329','腰部结核性窦道','A18.040+',171,1);
INSERT INTO disease VALUES ('330','结核性关节炎','A18.041+',123,1);
INSERT INTO disease VALUES ('331','第三楔骨结核','A18.042+',171,1);
INSERT INTO disease VALUES ('332','肌腱结核','A18.043+',171,1);
INSERT INTO disease VALUES ('333','掌骨结核','A18.044+',171,1);
INSERT INTO disease VALUES ('334','其他骨结核','A18.045+',171,1);
INSERT INTO disease VALUES ('335','脊柱结核','A18.046+',171,1);
INSERT INTO disease VALUES ('336','结核性乳突炎','A18.051+',171,1);
INSERT INTO disease VALUES ('337','骨关节结核','A18.052+',123,1);
INSERT INTO disease VALUES ('338','结核性膝部囊肿[结核性贝克氏囊肿]','A18.053+',171,1);
INSERT INTO disease VALUES ('339','膝关节结核伴瘘道形成','A18.054+',123,1);
INSERT INTO disease VALUES ('340','波特弯曲(脊柱)','A18.055+',154,1);
INSERT INTO disease VALUES ('341','结核性脊柱裂','A18.056+',171,1);
INSERT INTO disease VALUES ('342','结核性椎管内脓肿','A18.057+',171,1);
INSERT INTO disease VALUES ('343','胸椎结核伴脓肿','A18.058+',171,1);
INSERT INTO disease VALUES ('344','腰椎结核伴脓肿','A18.059+',171,1);
INSERT INTO disease VALUES ('345','腰椎结核伴瘘道形成','A18.060+',171,1);
INSERT INTO disease VALUES ('346','多个椎骨结核','A18.061+',171,1);
INSERT INTO disease VALUES ('347','结核性滑膜炎','A18.062+',171,1);
INSERT INTO disease VALUES ('348','结核性腱鞘炎','A18.063+',171,1);
INSERT INTO disease VALUES ('349','指(趾)关节结核','A18.064+',123,1);
INSERT INTO disease VALUES ('350','结核性骨髓炎','A18.065+',171,1);
INSERT INTO disease VALUES ('351','胸骨结核','A18.066+',171,1);
INSERT INTO disease VALUES ('352','指骨结核','A18.067+',171,1);
INSERT INTO disease VALUES ('353','跖骨结核','A18.068+',171,1);
INSERT INTO disease VALUES ('354','跗骨结核','A18.069+',171,1);
INSERT INTO disease VALUES ('355','其他特指骨结核','A18.070+',171,1);
INSERT INTO disease VALUES ('356','结核性骨坏死','A18.071+',171,1);
INSERT INTO disease VALUES ('357','泌尿生殖系结核','A18.101',171,1);
INSERT INTO disease VALUES ('358','膀胱结核','A18.102+',171,1);
INSERT INTO disease VALUES ('359','泌尿系结核','A18.103',171,1);
INSERT INTO disease VALUES ('360','子宫内膜结核','A18.104+',171,1);
INSERT INTO disease VALUES ('361','附睾结核','A18.105+',171,1);
INSERT INTO disease VALUES ('362','睾丸结核','A18.106+',171,1);
INSERT INTO disease VALUES ('363','女性盆腔结核','A18.107+',171,1);
INSERT INTO disease VALUES ('364','子宫颈结核','A18.108+',171,1);
INSERT INTO disease VALUES ('365','阴茎结核','A18.109+',171,1);
INSERT INTO disease VALUES ('366','卵巢结核','A18.110+',171,1);
INSERT INTO disease VALUES ('367','前列腺结核','A18.111+',171,1);
INSERT INTO disease VALUES ('368','肾结核','A18.112+',171,1);
INSERT INTO disease VALUES ('369','结核性肾脓肿','A18.113+',171,1);
INSERT INTO disease VALUES ('370','输精管结核','A18.114+',171,1);
INSERT INTO disease VALUES ('371','输卵管结核','A18.115+',171,1);
INSERT INTO disease VALUES ('372','结核性输尿管狭窄','A18.116+',171,1);
INSERT INTO disease VALUES ('373','输尿管结核','A18.117+',171,1);
INSERT INTO disease VALUES ('374','精囊结核','A18.118+',171,1);
INSERT INTO disease VALUES ('375','结核性肾盂积水','A18.151+',171,1);
INSERT INTO disease VALUES ('376','结核性肾盂(肾)炎','A18.152+',171,1);
INSERT INTO disease VALUES ('377','附睾结核性窦道','A18.156+',171,1);
INSERT INTO disease VALUES ('378','男性生殖器官结核','A18.157+',171,1);
INSERT INTO disease VALUES ('379','女生殖器结核','A18.159+',171,1);
INSERT INTO disease VALUES ('380','道格拉斯陷窝结核病','A18.160+',171,1);
INSERT INTO disease VALUES ('381','腹股沟淋巴结核','A18.201',171,1);
INSERT INTO disease VALUES ('382','颌下淋巴结结核','A18.202',171,1);
INSERT INTO disease VALUES ('383','结核性淋巴管炎','A18.203',171,1);
INSERT INTO disease VALUES ('384','颈部淋巴结结核','A18.204',171,1);
INSERT INTO disease VALUES ('385','颏下淋巴结结核','A18.205',171,1);
INSERT INTO disease VALUES ('386','淋巴结核','A18.206',171,1);
INSERT INTO disease VALUES ('387','腮腺淋巴结核','A18.207',171,1);
INSERT INTO disease VALUES ('388','锁骨上淋巴结核','A18.208',171,1);
INSERT INTO disease VALUES ('389','腋下(窝)淋巴结结核','A18.209',171,1);
INSERT INTO disease VALUES ('390','周围淋巴结结核','A18.210',171,1);
INSERT INTO disease VALUES ('391','结核结节','A18.251',171,1);
INSERT INTO disease VALUES ('392','结核性面颈部淋巴结炎','A18.252',171,1);
INSERT INTO disease VALUES ('393','结核性淋巴腺炎','A18.253',171,1);
INSERT INTO disease VALUES ('394','肠结核','A18.301+',171,1);
INSERT INTO disease VALUES ('395','肠系膜结核','A18.302+',171,1);
INSERT INTO disease VALUES ('396','肠系膜淋巴结结核','A18.303+',171,1);
INSERT INTO disease VALUES ('397','腹膜结核','A18.304+',171,1);
INSERT INTO disease VALUES ('398','结核性肛瘘','A18.305+',171,1);
INSERT INTO disease VALUES ('399','髂窝结核','A18.306+',171,1);
INSERT INTO disease VALUES ('400','结核性腹膜炎','A18.307+',171,1);
INSERT INTO disease VALUES ('401','腹膜后淋巴结结核','A18.308',171,1);
INSERT INTO disease VALUES ('402','腹腔结核','A18.309+',171,1);
INSERT INTO disease VALUES ('403','腹腔淋巴结核','A18.310',171,1);
INSERT INTO disease VALUES ('404','肝门淋巴结核','A18.311',171,1);
INSERT INTO disease VALUES ('405','结核性腹水','A18.312',171,1);
INSERT INTO disease VALUES ('406','结核性肠炎','A18.351+',33,1);
INSERT INTO disease VALUES ('407','肛门结核病','A18.352+',171,1);
INSERT INTO disease VALUES ('408','直肠结核病','A18.353+',171,1);
INSERT INTO disease VALUES ('409','播散性粟粒性狼疮','A18.401',250,1);
INSERT INTO disease VALUES ('410','腹壁结核','A18.402',171,1);
INSERT INTO disease VALUES ('411','腹部结核性窦道','A18.403',171,1);
INSERT INTO disease VALUES ('412','结核性结节性红斑[硬红斑、巴赞氏病]','A18.404',171,1);
INSERT INTO disease VALUES ('413','结核性皮肤脓肿','A18.405',171,1);
INSERT INTO disease VALUES ('414','酒渣样结核疹','A18.406',171,1);
INSERT INTO disease VALUES ('415','皮肤和皮下组织结核','A18.407',171,1);
INSERT INTO disease VALUES ('416','皮肤结核','A18.408',171,1);
INSERT INTO disease VALUES ('417','皮下组织结核性窦道','A18.409',171,1);
INSERT INTO disease VALUES ('418','臀部结核','A18.410',171,1);
INSERT INTO disease VALUES ('419','寻常性狼疮','A18.411',250,1);
INSERT INTO disease VALUES ('420','结核性皮肤瘢痕','A18.451',171,1);
INSERT INTO disease VALUES ('421','皮肤瘰疠(结核)','A18.452',171,1);
INSERT INTO disease VALUES ('422','硬化性皮结核','A18.453',171,1);
INSERT INTO disease VALUES ('423','皮下结核','A18.454',171,1);
INSERT INTO disease VALUES ('424','结核疹','A18.455',171,1);
INSERT INTO disease VALUES ('425','结核性狼疮','A18.456',171,1);
INSERT INTO disease VALUES ('426','腐蚀性狼疮','A18.457',250,1);
INSERT INTO disease VALUES ('427','寻常眼睑的狼疮','A18.458+',430,1);
INSERT INTO disease VALUES ('428','眼睑结核','A18.459+',430,1);
INSERT INTO disease VALUES ('429','眼结核','A18.501',430,1);
INSERT INTO disease VALUES ('430','眼眶结核','A18.502',430,1);
INSERT INTO disease VALUES ('431','巩膜结核','A18.503+',171,1);
INSERT INTO disease VALUES ('432','角膜结核','A18.504+',171,1);
INSERT INTO disease VALUES ('433','结核性视神经脉络膜炎','A18.505+',313,1);
INSERT INTO disease VALUES ('434','结核性葡萄膜炎','A18.506+',171,1);
INSERT INTO disease VALUES ('435','结核性视网膜静脉周围炎','A18.507+',171,1);
INSERT INTO disease VALUES ('436','结膜结核','A18.508+',171,1);
INSERT INTO disease VALUES ('437','脉络膜结核','A18.509+',171,1);
INSERT INTO disease VALUES ('438','脉络膜结核瘤','A18.510+',171,1);
INSERT INTO disease VALUES ('439','视神经结核','A18.511+',313,1);
INSERT INTO disease VALUES ('440','视网膜结核','A18.512+',171,1);
INSERT INTO disease VALUES ('441','结核性泪囊炎','A18.551+',171,1);
INSERT INTO disease VALUES ('442','结核性巩膜外层炎','A18.552+',171,1);
INSERT INTO disease VALUES ('443','结核性间质性角膜炎','A18.553+',171,1);
INSERT INTO disease VALUES ('444','结核性角膜结膜炎(间质性)(小泡性)','A18.554+',171,1);
INSERT INTO disease VALUES ('445','结核性虹膜睫状体炎','A18.555+',171,1);
INSERT INTO disease VALUES ('446','结核性脉络膜视网膜炎','A18.556+',171,1);
INSERT INTO disease VALUES ('447','外耳道结核','A18.601',70,1);
INSERT INTO disease VALUES ('448','中耳结核','A18.602',70,1);
INSERT INTO disease VALUES ('449','结核性中耳炎','A18.603+',70,1);
INSERT INTO disease VALUES ('450','耳结核','A18.651+',70,1);
INSERT INTO disease VALUES ('451','肾上腺结核','A18.701+',171,1);
INSERT INTO disease VALUES ('452','肾上腺结核病[艾迪生]','A18.751+',171,1);
INSERT INTO disease VALUES ('453','艾迪生结核病黑病变','A18.752+',171,1);
INSERT INTO disease VALUES ('454','结核性肾上腺机能减退','A18.753+',171,1);
INSERT INTO disease VALUES ('455','结核性肾上腺机能障碍','A18.754+',171,1);
INSERT INTO disease VALUES ('456','肺外结核','A18.801',171,1);
INSERT INTO disease VALUES ('457','乳腺结核','A18.802',171,1);
INSERT INTO disease VALUES ('458','舌结核','A18.803+',171,1);
INSERT INTO disease VALUES ('459','足结核','A18.804',171,1);
INSERT INTO disease VALUES ('460','垂体结核','A18.805+',171,1);
INSERT INTO disease VALUES ('461','唇结核','A18.806+',171,1);
INSERT INTO disease VALUES ('462','胆囊结核','A18.807+',53,1);
INSERT INTO disease VALUES ('463','肝结核','A18.808+',171,1);
INSERT INTO disease VALUES ('464','颌下腺结核','A18.809+',171,1);
INSERT INTO disease VALUES ('465','肌结核','A18.810+',171,1);
INSERT INTO disease VALUES ('466','甲状腺结核','A18.811+',171,1);
INSERT INTO disease VALUES ('467','结缔组织结核','A18.812+',171,1);
INSERT INTO disease VALUES ('468','结核性腹主动脉炎','A18.813+',171,1);
INSERT INTO disease VALUES ('469','食管结核(结核性食管炎)','A18.814+',171,1);
INSERT INTO disease VALUES ('470','结核性心包积液','A18.815+',171,1);
INSERT INTO disease VALUES ('471','心包结核(结核性心包炎)','A18.816+',171,1);
INSERT INTO disease VALUES ('472','心肌结核(结核性心肌炎)','A18.817+',171,1);
INSERT INTO disease VALUES ('473','结核性心内膜炎','A18.818+',171,1);
INSERT INTO disease VALUES ('474','咀嚼肌结核','A18.819+',171,1);
INSERT INTO disease VALUES ('475','脾结核','A18.820+',171,1);
INSERT INTO disease VALUES ('476','腮腺结核','A18.821+',171,1);
INSERT INTO disease VALUES ('477','上臂内侧横纹肌结核','A18.822+',171,1);
INSERT INTO disease VALUES ('478','胃结核','A18.823+',171,1);
INSERT INTO disease VALUES ('479','胸大肌结核','A18.824+',171,1);
INSERT INTO disease VALUES ('480','牙龈结核','A18.825+',171,1);
INSERT INTO disease VALUES ('481','腰部结核性脓肿','A18.826+',171,1);
INSERT INTO disease VALUES ('482','腰大肌结核性脓肿','A18.827+',171,1);
INSERT INTO disease VALUES ('483','腰肌结核','A18.828+',171,1);
INSERT INTO disease VALUES ('484','胰腺结核','A18.829+',171,1);
INSERT INTO disease VALUES ('485','结核性大脑动脉炎','A18.851+',171,1);
INSERT INTO disease VALUES ('486','结核性动脉内膜炎','A18.852+',171,1);
INSERT INTO disease VALUES ('487','结核性肝(肝炎)','A18.853+',93,1);
INSERT INTO disease VALUES ('488','颌下淋巴结核','A18.855+',171,1);
INSERT INTO disease VALUES ('489','髂凹结核性脓肿(髂腰肌)','A18.856+',171,1);
INSERT INTO disease VALUES ('490','臀部肌肉结核性脓肿','A18.857+',171,1);
INSERT INTO disease VALUES ('491','急性粟粒性肺结核','A19.001',171,1);
INSERT INTO disease VALUES ('492','急性血行播散型肺结核','A19.051',171,1);
INSERT INTO disease VALUES ('493','急性播散性多浆膜炎','A19.151',164,1);
INSERT INTO disease VALUES ('494','急性多发性结核病','A19.152',171,1);
INSERT INTO disease VALUES ('495','急性粟粒性结核病','A19.251',171,1);
INSERT INTO disease VALUES ('496','慢性粟粒性肺结核','A19.801',171,1);
INSERT INTO disease VALUES ('497','亚急性粟粒性肺结核','A19.802',171,1);
INSERT INTO disease VALUES ('498','亚急性血行播散型肺结核','A19.851',171,1);
INSERT INTO disease VALUES ('499','慢性结核性多浆膜炎','A19.852',171,1);
INSERT INTO disease VALUES ('500','慢性血行播散型肺结核','A19.853',171,1);
INSERT INTO disease VALUES ('501','慢性多发性结核病','A19.854',171,1);
INSERT INTO disease VALUES ('502','粟粒性脑膜结核','A19.855+',171,1);
INSERT INTO disease VALUES ('503','粟粒性结核病','A19.901',171,1);
INSERT INTO disease VALUES ('504','结核性多浆膜炎','A19.902',171,1);
INSERT INTO disease VALUES ('505','进行性恶性多发性浆膜炎','A19.903',164,1);
INSERT INTO disease VALUES ('506','全身性粟粒性结核病','A19.904',171,1);
INSERT INTO disease VALUES ('507','多系统结核','A19.951',171,1);
INSERT INTO disease VALUES ('508','多发性结核病','A19.952',171,1);
INSERT INTO disease VALUES ('509','腹股沟淋巴结炎性鼠疫','A20.051',335,1);
INSERT INTO disease VALUES ('510','蜂窝织皮下型鼠疫','A20.151',335,1);
INSERT INTO disease VALUES ('511','肺炎型鼠疫','A20.251',81,1);
INSERT INTO disease VALUES ('512','继发性肺炎型鼠疫','A20.252',81,1);
INSERT INTO disease VALUES ('513','原发性肺炎型鼠疫','A20.253',81,1);
INSERT INTO disease VALUES ('514','鼠疫型脑膜炎','A20.351',232,1);
INSERT INTO disease VALUES ('515','败血症性鼠疫','A20.751',9,1);
INSERT INTO disease VALUES ('516','顿挫性鼠疫','A20.851',335,1);
INSERT INTO disease VALUES ('517','无症状性鼠疫','A20.852',335,1);
INSERT INTO disease VALUES ('518','轻鼠疫','A20.853',335,1);
INSERT INTO disease VALUES ('519','鼠疫 NOS','A20.901',335,1);
INSERT INTO disease VALUES ('520','溃疡淋巴腺型土拉菌病','A21.051',359,1);
INSERT INTO disease VALUES ('521','眼土拉菌病','A21.151',430,1);
INSERT INTO disease VALUES ('522','眼腺型土拉菌病','A21.152',430,1);
INSERT INTO disease VALUES ('523','肺土拉菌病','A21.251',359,1);
INSERT INTO disease VALUES ('524','腹部土拉菌病','A21.351',359,1);
INSERT INTO disease VALUES ('525','胃肠土拉菌病','A21.352',370,1);
INSERT INTO disease VALUES ('526','全身性土拉菌病','A21.751',359,1);
INSERT INTO disease VALUES ('527','其他形式的土拉菌病','A21.851',359,1);
INSERT INTO disease VALUES ('528','兔热病','A21.901',268,1);
INSERT INTO disease VALUES ('529','土拉菌热','A21.951',271,1);
INSERT INTO disease VALUES ('530','皮肤炭疽','A22.051',250,1);
INSERT INTO disease VALUES ('531','恶性脓疱','A22.052',242,1);
INSERT INTO disease VALUES ('532','恶性痈','A22.053',451,1);
INSERT INTO disease VALUES ('533','肺炭疽','A22.101',346,1);
INSERT INTO disease VALUES ('534','炭疽肺炎','A22.102+',81,1);
INSERT INTO disease VALUES ('535','恶性炭疽(栋毛工病))','A22.151',346,1);
INSERT INTO disease VALUES ('536','捡破烂人病','A22.152',268,1);
INSERT INTO disease VALUES ('537','吸入性炭疽','A22.153',346,1);
INSERT INTO disease VALUES ('538','胃肠炭疽','A22.251',370,1);
INSERT INTO disease VALUES ('539','肠炭疽','A22.252',346,1);
INSERT INTO disease VALUES ('540','炭疽性败血症','A22.751',9,1);
INSERT INTO disease VALUES ('541','炭疽脑膜炎','A22.851+',232,1);
INSERT INTO disease VALUES ('542','炭疽 NOS','A22.901',346,1);
INSERT INTO disease VALUES ('543','直布罗陀热(西班牙)','A23.051',425,1);
INSERT INTO disease VALUES ('544','地中海热','A23.052',271,1);
INSERT INTO disease VALUES ('545','马耳他布鲁氏菌病','A23.053',70,1);
INSERT INTO disease VALUES ('546','塞普路斯波状热','A23.054',271,1);
INSERT INTO disease VALUES ('547','流产布鲁氏菌病','A23.151',215,1);
INSERT INTO disease VALUES ('548','猪布鲁氏菌病','A23.251',215,1);
INSERT INTO disease VALUES ('549','犬布鲁氏菌病','A23.351',215,1);
INSERT INTO disease VALUES ('550','其他布鲁氏菌病','A23.851',215,1);
INSERT INTO disease VALUES ('551','布鲁氏杆菌病[波状热]','A23.901',188,1);
INSERT INTO disease VALUES ('552','布鲁氏杆菌性关节炎','A23.902+',123,1);
INSERT INTO disease VALUES ('553','布鲁氏杆菌性眼色素膜炎','A23.903+',430,1);
INSERT INTO disease VALUES ('554','马耳他热','A23.951',70,1);
INSERT INTO disease VALUES ('555','鼻疽假单胞菌感染','A24.051',16,1);
INSERT INTO disease VALUES ('556','鼻疽','A24.052',16,1);
INSERT INTO disease VALUES ('557','类鼻疽败血症','A24.151',16,1);
INSERT INTO disease VALUES ('558','类炭疽肺炎','A24.152',81,1);
INSERT INTO disease VALUES ('559','急性和暴发性类鼻疽','A24.153',16,1);
INSERT INTO disease VALUES ('560','慢性类鼻疽','A24.251',16,1);
INSERT INTO disease VALUES ('561','亚急性类鼻疽','A24.252',16,1);
INSERT INTO disease VALUES ('562','其他类鼻疽','A24.351',16,1);
INSERT INTO disease VALUES ('563','假鼻疽假单胞菌感染','A24.451',16,1);
INSERT INTO disease VALUES ('564','惠特莫尔热','A24.452',271,1);
INSERT INTO disease VALUES ('565','螺菌病','A25.051',188,1);
INSERT INTO disease VALUES ('566','链杆菌病','A25.151',188,1);
INSERT INTO disease VALUES ('567','链杆菌性鼠咬热','A25.152',271,1);
INSERT INTO disease VALUES ('568','流行性关节红斑[哈弗山]','A25.153',123,1);
INSERT INTO disease VALUES ('569','鼠咬热 NOS','A25.901',271,1);
INSERT INTO disease VALUES ('570','皮肤类丹毒','A26.051',250,1);
INSERT INTO disease VALUES ('571','游走性红斑','A26.052',250,1);
INSERT INTO disease VALUES ('572','丹毒菌丝败血病','A26.751',8,1);
INSERT INTO disease VALUES ('573','其他形式类丹毒','A26.851',278,1);
INSERT INTO disease VALUES ('574','类丹毒 NOS','A26.901',278,1);
INSERT INTO disease VALUES ('575','出血性黄疸钩端螺旋体病[菲尔德病]','A27.001',216,1);
INSERT INTO disease VALUES ('576','流感伤寒型钩端螺旋体病','A27.801',306,1);
INSERT INTO disease VALUES ('577','南方钩端螺旋体感染','A27.802',95,1);
INSERT INTO disease VALUES ('578','波蒙纳钩端螺旋体病','A27.851',216,1);
INSERT INTO disease VALUES ('579','犬钩端螺旋体病','A27.852',216,1);
INSERT INTO disease VALUES ('580','七日热[钩端螺旋体病]','A27.853',216,1);
INSERT INTO disease VALUES ('581','钩端螺旋体脑膜炎','A27.854+',232,1);
INSERT INTO disease VALUES ('582','钩端螺旋体病 NOS','A27.901',216,1);
INSERT INTO disease VALUES ('583','巴斯德菌病','A28.051',188,1);
INSERT INTO disease VALUES ('584','猫抓病(热)','A28.101',268,1);
INSERT INTO disease VALUES ('585','肠外耶尔森菌病','A28.251',188,1);
INSERT INTO disease VALUES ('586','其他特指的动物传染的细菌性疾病，NEC','A28.851',380,1);
INSERT INTO disease VALUES ('587','动物传染的细菌性疾病 NOS','A28.951',380,1);
INSERT INTO disease VALUES ('588','Ⅰ型麻风','A30.051',218,1);
INSERT INTO disease VALUES ('589','未定型麻风','A30.052',218,1);
INSERT INTO disease VALUES ('590','类结核型麻风','A30.101',171,1);
INSERT INTO disease VALUES ('591','ＴＴ型麻风','A30.151',218,1);
INSERT INTO disease VALUES ('592','结核样型麻风','A30.152',171,1);
INSERT INTO disease VALUES ('593','ＢＴ型麻风','A30.251',218,1);
INSERT INTO disease VALUES ('594','近结核样型中间型麻风','A30.252',171,1);
INSERT INTO disease VALUES ('595','中间型麻风','A30.351',218,1);
INSERT INTO disease VALUES ('596','ＢＢ型麻风','A30.352',218,1);
INSERT INTO disease VALUES ('597','双型性(浸润性)(神经炎性)麻风','A30.353',313,1);
INSERT INTO disease VALUES ('598','混合性麻风','A30.354',218,1);
INSERT INTO disease VALUES ('599','近瘤型中间型麻风','A30.451',218,1);
INSERT INTO disease VALUES ('600','ＢＬ型麻风','A30.452',218,1);
INSERT INTO disease VALUES ('601','瘤型麻风','A30.501',218,1);
INSERT INTO disease VALUES ('602','ＬＬ型麻风','A30.551',218,1);
INSERT INTO disease VALUES ('603','结节性麻风','A30.552',218,1);
INSERT INTO disease VALUES ('604','其他特指形式麻风','A30.851',218,1);
INSERT INTO disease VALUES ('605','麻风 NOS','A30.901',218,1);
INSERT INTO disease VALUES ('606','斑疹性麻风','A30.951',218,1);
INSERT INTO disease VALUES ('607','麻木型麻风','A30.952',218,1);







DELIMITER $$

USE `hishospital`$$

DROP PROCEDURE IF EXISTS `add_drug_template`$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `add_drug_template`(
  IN template_name VARCHAR (50),
  IN doct_id INT,
  IN drug_ids VARCHAR (50),
  IN use_ways VARCHAR (500),
  IN dosage_s VARCHAR (200),
  IN frequency_s VARCHAR (200),
  IN number_s VARCHAR (200)
)
BEGIN
  DECLARE new_template_id INT ;
  
  DECLARE str_index_drug INT ;
  
  DECLARE str_index_useway INT ;
  
  DECLARE str_index_dosage INT ;
  
  DECLARE str_index_frequency INT ;
  
  DECLARE str_index_number INT ;
  
  INSERT INTO prescription 
  VALUES
    (
      NULL,
      template_name,
      doct_id,
      NULL,
      1
    ) ; -- 添加新的处方
  
  SELECT 
    id INTO new_template_id 
  FROM
    prescription 
  WHERE template_name = NAME ;
  
  SET str_index_drug = INSTR(drug_ids, ',') ;
  
  SET str_index_useway = INSTR(use_ways, ',') ;
  
  SET str_index_dosage = INSTR(dosage_s, ',') ;
  
  SET str_index_frequency = INSTR(frequency_s, ',') ;
  
  SET str_index_number = INSTR(number_s, ',') ;
  
  WHILE
    str_index_drug > 0 DO 
    INSERT INTO drugtempl 
    VALUES
      (
        new_template_id,
        LEFT(drug_ids, str_index_drug - 1),
        LEFT(use_ways, str_index_useway - 1),
        LEFT(dosage_s, str_index_dosage - 1),
        LEFT(
          frequency_s,
          str_index_frequency - 1
        ),
        LEFT(number_s, str_index_number - 1)
      ) ;-- 添加药品模版
    
    SET drug_ids = SUBSTR(drug_ids, str_index_drug + 1) ;
    
    SET str_index_drug = INSTR(drug_ids, ',') ;
    
    SET use_ways = SUBSTR(use_ways, str_index_useway + 1) ;
    
    SET str_index_useway = INSTR(use_ways, ',') ;
    
    SET dosage_s = SUBSTR(dosage_s, str_index_dosage + 1) ;
    
    SET str_index_dosage = INSTR(dosage_s, ',') ;
    
    SET frequency_s = SUBSTR(
      frequency_s,
      str_index_frequency + 1
    ) ;
    
    SET str_index_frequency = INSTR(frequency_s, ',') ;
    
    SET number_s = SUBSTR(number_s, str_index_number + 1) ;
    
    SET str_index_number = INSTR(number_s, ',') ;
    
  END WHILE ;
  
  IF LENGTH(drug_ids) >= 0 
  THEN 
  INSERT INTO drugtempl 
  VALUES
    (
      new_template_id,
      drug_ids,
      use_ways,
      dosage_s,
      frequency_s,
      number_s
    ) ;
  
  END IF ;
  
END$$

DELIMITER ;



DELIMITER $$

USE `hishospital`$$

DROP PROCEDURE IF EXISTS `cancel_regi`$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `cancel_regi`(IN register_id INT)
BEGIN
  DECLARE status_p INT ;
  
	-- 获得挂号状态
  SELECT 
    STATUS INTO status_p 
  FROM
    register 
  WHERE id = register_id ;
  
	-- 条件判断是否可以退号
  IF status_p = 1 
  THEN 
  UPDATE 
    register 
  SET
    STATUS = 4 
  WHERE id = register_id ;-- 执行退号操作，更新挂号表中的挂号状态
  
  SELECT 
    'success' AS 'result' ; 
  
  ELSE 
  SELECT 
    'failure' AS 'result' ; -- 因为无法退号的话，语句不会报错，所以通过这个进行标记
  
  END IF ;
  
END$$

DELIMITER ;



DELIMITER $$

USE `hishospital`$$

DROP PROCEDURE IF EXISTS `dispense_drug`$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `dispense_drug`(IN record_num INT)
BEGIN
  UPDATE 
    prescribe 
  SET
    STATUS = 3 
  WHERE STATUS = 2 
    AND recordnum = record_num 
    AND presdate = CURDATE() ;
  
END$$

DELIMITER ;



DELIMITER $$

USE `hishospital`$$

DROP PROCEDURE IF EXISTS `doc_diag`$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `doc_diag`(
  IN regi_id INT,
  IN diag_resu_id INT,
  IN diag_resu_type INT
)
begin_name :
BEGIN
  DECLARE medicalrecord_num INT ;
  
	-- 根据挂号ID得到病历号
  SELECT 
    medicalrecord INTO medicalrecord_num 
  FROM
    register 
  WHERE id = regi_id AND STATUS = 1 ; -- 未诊才能查到
  
  IF medicalrecord_num IS NULL 
  THEN 
  SELECT 
    'failure' AS 'result' ;
  
	-- 如果没有对应病历就跳出并显示失败
	
  LEAVE begin_name ;
  
  END IF ;
	
  -- 诊断结果插入
  INSERT INTO diagnose 
  VALUES
    (
      medicalrecord_num,
      regi_id,
      diag_resu_type,
      diag_resu_id,
      NULL
    ) ;
  
	
	-- 保存诊断信息到病历表。
  UPDATE 
    medicalrecord 
  SET
    result = 
    (SELECT 
      NAME 
    FROM
      disease 
    WHERE id = diag_resu_id) 
  WHERE recordnum = medicalrecord_num ;
  
	-- 更新挂号状态为已诊
  UPDATE 
    register 
  SET
    STATUS = 2 
  WHERE id = regi_id ;
  
  SELECT 
    'success' AS 'result' ;
  
END$$

DELIMITER ;




DELIMITER $$

USE `hishospital`$$

DROP PROCEDURE IF EXISTS `doct_prescribe`$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `doct_prescribe`(
  IN regi_id INT,-- 挂号id
  IN prescriptions VARCHAR (50) -- 开的已有处方
)
BEGIN
  DECLARE str_index INT ;
  
  DECLARE record_id INT ;
  
  DECLARE doct_id INT ;
  
  DECLARE presc_name VARCHAR (30) ;
  
  SET str_index = INSTR(prescriptions, ',') ;
  
  WHILE
    str_index > 0 DO 
    SELECT 
      medicalrecord INTO record_id 
    FROM
      register 
    WHERE id = regi_id ;-- 通过挂号id获得病历号
    
    SELECT 
      doctorid INTO doct_id 
    FROM
      register 
    WHERE id = regi_id ;-- 通过挂号id获得医生id
    
    SELECT 
      NAME INTO presc_name 
    FROM
      prescription 
    WHERE id = LEFT(prescriptions, str_index - 1) ;-- 通过处方id获得处方名称
    
    INSERT INTO prescribe 
    VALUES
      (
        NULL,
        record_id,
        regi_id,
        doct_id,
        presc_name,
        CURDATE(),
        1
      ) ;-- 插入处方开药
    
    SET prescriptions = SUBSTR(prescriptions, str_index + 1) ;
    
    SET str_index = INSTR(prescriptions, ',') ;
    
  END WHILE ;
  
  IF LENGTH(prescriptions) >= 0 
  THEN 
  SELECT 
    medicalrecord INTO record_id 
  FROM
    register 
  WHERE id = regi_id ;
  
  SELECT 
    doctorid INTO doct_id 
  FROM
    register 
  WHERE id = regi_id ; -- 获得医生id
  
  SELECT 
    NAME INTO presc_name 
  FROM
    prescription 
  WHERE id = prescriptions ;
  
  INSERT INTO prescribe 
  VALUES
    (
      NULL,
      record_id,
      regi_id,
      doct_id,
      presc_name,
      CURDATE(),
      1
    ) ; -- 插入处方开药表
  
  END IF ;
	
-- 更新状态为诊毕（新增代码）
UPDATE register SET STATUS = 3 WHERE id = regi_id;
  
END$$

DELIMITER ;




DELIMITER $$

USE `hishospital`$$

DROP PROCEDURE IF EXISTS `patient_pay`$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `patient_pay`(IN regi_id INT, IN user_id INT,IN pay_way INT)
BEGIN
  DECLARE new_invoice_num INT ;
  
  DECLARE end_loop INT DEFAULT 0 ;
  
  DECLARE drug_template_drugid INT ;
  
  DECLARE drug_template_drugnum INT ;
  
  DECLARE drug_name VARCHAR (100) ;
  
  DECLARE drug_price DOUBLE ;
  
  DECLARE depa_id INT ;
  
  DECLARE all_money DOUBLE DEFAULT(0) ;
  
  
	-- 获得开药药品id和数量
  DECLARE cur CURSOR FOR 
  SELECT 
    drugid,
    number 
  FROM
    drugtempl 
  WHERE presid IN 
    (SELECT 
      id 
    FROM
      prescription 
    WHERE NAME IN 
      (SELECT 
        NAME 
      FROM
        prescribe 
      WHERE registerid = regi_id)) ;
  
  --  定义一个异常处理
  DECLARE CONTINUE HANDLER FOR NOT FOUND SET end_loop = 1 ;
  
  
  -- 获取科室id
  SELECT 
    depaid INTO depa_id 
  FROM
    register 
  WHERE id = regi_id ;
  
  -- 最大发票号加一作为新的发票号
  SELECT 
    MAX(number) + 1 INTO new_invoice_num 
  FROM
    invoice ;
  
  -- 费用明细 循环插入
  OPEN cur ;
  
  l :
  LOOP
    FETCH cur INTO drug_template_drugid,
    drug_template_drugnum ;
    
    IF end_loop = 1 
    THEN LEAVE l ;
    
    END IF ;
    
    SELECT 
      NAME INTO drug_name 
    FROM
      drug 
    WHERE id = drug_template_drugid ;
    
    SELECT 
      price INTO drug_price 
    FROM
      drug 
    WHERE id = drug_template_drugid ;
    
    SET all_money = all_money + drug_price * drug_template_drugnum ;
    
		-- 插入费用明细信息
    INSERT INTO costdetail 
    VALUES
      (
        NULL,
        new_invoice_num,
        1,
        drug_name,
        drug_price,
        drug_template_drugnum,
        depa_id,
        NULL
      ) ;
    
  END LOOP ;
  
  CLOSE cur ;
  
  -- 支票 插入
  INSERT INTO invoice 
  VALUES
    (
      NULL,
      new_invoice_num,
      all_money,
      1,
      NULL,
      user_id,
      regi_id,
      pay_way
    ) ;
		
  -- 更新缴费状态
  UPDATE 
    prescribe 
  SET
    STATUS = 2 
  WHERE registerid = regi_id 
	AND STATUS = 1;
	
SELECT MAX(number) FROM invoice; -- 获取发票号
END$$

DELIMITER ;






DELIMITER $$

USE `hishospital`$$

DROP PROCEDURE IF EXISTS `patient_refund`$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `patient_refund`(IN invoice_num INT, user_id INT)
BEGIN
  DECLARE end_loop INT DEFAULT 0 ;
  
  DECLARE regi_id INT ;
  
  DECLARE invoice_id INT ;
  
  DECLARE type_p INT ;
  
  DECLARE name_p VARCHAR (100) ;
  
  DECLARE price_p DECIMAL (9, 2) ;
  
  DECLARE num_p INT ;
  
  DECLARE depart_id INT ;
  
  DECLARE cur CURSOR FOR 
  SELECT 
    invoicenum,
    TYPE,
    NAME,
    price,
    num,
    departid 
  FROM
    costdetail 
  WHERE invoicenum = invoice_num ;
  
  --  定义一个异常处理
  DECLARE CONTINUE HANDLER FOR NOT FOUND SET end_loop = 1 ;
  
  -- 获得挂号id
  SELECT 
    registerid INTO regi_id 
  FROM
    invoice 
  WHERE invoice_num = number ;
  
  -- 处方开药改为退费
  UPDATE 
    prescribe 
  SET
    STATUS = 6 
  WHERE registerid = regi_id ;
  
  -- 插入负价格的费用明细
  OPEN cur ;
  
  l :
  LOOP
    FETCH cur INTO invoice_id,
    type_p,
    name_p,
    price_p,
    num_p,
    depart_id ;
    
    IF end_loop = 1 
    THEN LEAVE l ;
    
    END IF ;
    
    INSERT INTO costdetail 
    VALUES
      (
        NULL,
        invoice_id,
        type_p,
        name_p,
        - price_p,
        num_p,
        depart_id,
        NULL
      ) ;
    
  END LOOP ;
  
  CLOSE cur ;
  
  -- 发票状态更新
  UPDATE 
    invoice 
  SET
    STATUS = 2,
    userid = user_id 
  WHERE number = invoice_num ;
  
END$$

DELIMITER ;








DELIMITER $$

USE `hishospital`$$

DROP PROCEDURE IF EXISTS `register_p`$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `register_p`(
  IN idnumber_p VARCHAR (20),
  IN name_p VARCHAR (20),
  IN gender_p INT,
  IN birthday_p DATE,
  IN address_p VARCHAR (20),
  IN diagdate_p DATE,
  IN noon_p VARCHAR (10),
  IN depaid_p INT,
  IN doctid_p INT,
  IN payway_p INT,
  IN needrecord_p INT,
  IN registrarid_p INT
)
BEGIN
  DECLARE medicalrecord_id INT ;
  
  DECLARE gender_id INT ;
  
  
  IF needrecord_p = 1 
  THEN -- 新建病历号
  INSERT INTO medicalrecord 
  VALUES
    (NULL, '', '', '', '', '', '', '', '', '') ;
  
  SELECT 
    MAX(recordnum) INTO medicalrecord_id 
  FROM
    medicalrecord ;
  
  ELSE -- 使用已有的病历号
  SELECT 
    MAX(medicalrecord) INTO medicalrecord_id 
  FROM
    register 
  WHERE idnumber = idnumber_p ;
  
  IF medicalrecord_id IS NULL 
  THEN -- 没有挂过号，必须用新的病历号
  INSERT INTO medicalrecord 
  VALUES
    (NULL, '', '', '', '', '', '', '', '', '') ;
  
  SELECT 
    MAX(recordnum) INTO medicalrecord_id 
  FROM
    medicalrecord ;
  
  END IF ;
  
  END IF ;
  
  INSERT INTO register 
  VALUES
    (
      NULL,
      medicalrecord_id,
      name_p,
      gender_p,
      idnumber_p,
      birthday_p,
      payway_p,
      address_p,
      diagdate_p,
      noon_p,
      NULL,
      -- 时间戳类型，不需要指定时间
      depaid_p,
      doctid_p,
      needrecord_p,
      registrarid_p,
      1
    ) ;
  
END$$

DELIMITER ;