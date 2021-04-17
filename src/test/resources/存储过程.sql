-- 第一部分 挂号 
DROP PROCEDURE IF EXISTS register_p ;

CREATE PROCEDURE register_p (
  IN idnumber_p VARCHAR (20),
  IN name_p VARCHAR (20),
  IN gender_p VARCHAR (10),
  IN birthday_p DATE,
  IN address_p VARCHAR (20),
  IN regidate_p DATE,
  IN noon_p VARCHAR (10),
  IN depaid_p INT,
  IN doctid_p INT,
  IN levelid_p INT,
  IN payway_p INT,
  IN needrecord_p INT,
  IN registrarid_p INT
) 
BEGIN
  DECLARE medicalrecord_id INT ;
  
  DECLARE gender_id INT ;
  
	-- 获得性别对应常数项id
  SELECT 
    id INTO gender_id 
  FROM
    constantitem 
  WHERE NAME = gender_p ;
  
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
      gender_id,
      idnumber_p,
      birthday_p,
      payway_p,
      address_p,
      regidate_p,
      noon_p,
      NULL,
      -- 时间戳类型，不需要指定时间
      depaid_p,
      doctid_p,
      needrecord_p,
      registrarid_p,
      1
    ) ;
  
END ;

select * from medicalrecord ORDER BY recordnum DESC;
select id,medicalrecord,regidate from register ORDER BY id DESC;
CALL register_p (
  110101199003073335,
  '李白',
  '男',
  '1900-01-02',
  '北京',
  CURDATE(),
  '上午',
  1,
  1,
  1,
  1,
  0,
  301
) ; -- 用原有的病历本

CALL register_p (
  110101199003073335,
  '李白',
  '男',
  '1900-01-02',
  '北京',
  CURDATE(),
  '上午',
  1,
  1,
  1,
  1,
  1,
  301
) ; -- 曾经有病历本，但要新的病历本

CALL register_p (
  110101199003079999,
  '新人',
  '男',
  '1900-01-02',
  '北京',
  CURDATE(),
  '上午',
  1,
  1,
  1,
  1,
  1,
  301
) ; -- 不要病历本，但是是第一次来，不得不要

-- 测试代码

select * from medicalrecord ORDER BY recordnum DESC;
select id,medicalrecord,regidate from register ORDER BY id DESC;






-- 第二部分 退号 
DROP PROCEDURE IF EXISTS cancel_regi ;

CREATE PROCEDURE cancel_regi (IN register_id INT) 
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
  
END ;

-- 测试代码

-- 看诊状态(未诊1，已诊2，诊毕3,退号4)

SELECT id,medicalrecord,STATUS FROM register WHERE id = 4;

CALL cancel_regi(4); -- 根据挂号id进行退号

SELECT id,medicalrecord,STATUS FROM register WHERE id = 4;


SELECT id,medicalrecord,STATUS FROM register WHERE id = 3;
CALL cancel_regi (3) ; -- 已诊，失败演示
SELECT id,medicalrecord,STATUS FROM register WHERE id = 3;







-- 第三部分 医生看诊 
DROP PROCEDURE IF EXISTS doc_diag ;

CREATE PROCEDURE doc_diag (
  IN regi_id INT,
  IN diag_resu_id INT,
  IN diag_resu_type INT
) begin_name :
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
  
END ;

-- 测试代码

SELECT recordnum,result FROM medicalrecord WHERE recordnum=(SELECT medicalrecord FROM register WHERE id=40); -- 未看诊病历本
SELECT * FROM diagnose WHERE registerid= 40; -- 未看诊，诊断结果
CALL doc_diag (40, 8, 1) ; -- 看诊
SELECT recordnum,result FROM medicalrecord WHERE recordnum=(SELECT medicalrecord FROM register WHERE id=40); -- 看诊后历本
SELECT * FROM diagnose WHERE registerid= 40; -- 看诊后，诊断结果


CALL doc_diag(10000,8,1);-- 无效挂号id。失败演示



-- 第四部分-通过已有模版进行开药
DROP PROCEDURE IF EXISTS doct_prescribe ;

CREATE PROCEDURE doct_prescribe (
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
  
END ;

-- 测试代码

-- 缴费状态（1开立未缴费，2缴费，3发药，6退费）
SELECT * FROM prescribe WHERE registerid = 4; -- 未开药前
CALL doct_prescribe (4, '2,3,5,7') ; -- 开药
SELECT * FROM prescribe WHERE registerid = 4; -- 开药后




-- 第四部分-新增处方模版

DROP PROCEDURE IF EXISTS add_drug_template ;

CREATE PROCEDURE add_drug_template (
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
  
END ;

-- 测试代码

SELECT * FROM prescription ORDER BY id DESC;
SELECT * FROM drugtempl ORDER BY presid DESC; -- 未加处方和模版
CALL add_drug_template (
  '治死人不偿命模版',
  2, -- 创建者医生id
  '1,2,3,4', -- 药id
  '喝1,喝2,喝3,喝4',
  '100ml,100ml,100ml,100ml',
  '一天一次,一天二次,一天三次,一天四次',
  '1,2,3,4' -- s数量
) ; -- 加处方和模版
SELECT * FROM prescription ORDER BY id DESC;
SELECT * FROM drugtempl ORDER BY presid DESC; -- 加处方和模版后





-- 第五部分 患者缴费

DROP PROCEDURE IF EXISTS patient_pay ;

CREATE PROCEDURE patient_pay (IN regi_id INT, IN user_id INT) 
BEGIN
  DECLARE new_invoice_num INT ;
  
  DECLARE end_loop INT DEFAULT 0 ;
  
  DECLARE drug_template_drugid INT ;
  
  DECLARE drug_template_drugnum INT ;
  
  DECLARE drug_name VARCHAR (100) ;
  
  DECLARE drug_price DOUBLE ;
  
  DECLARE depa_id INT ;
  
  DECLARE all_money DOUBLE DEFAULT(0) ;
  
  DECLARE pay_way INT DEFAULT(51) ;
  
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
	
END ;

-- 测试代码
-- 缴费状态（1开立未缴费，2缴费，3发药，6退费）
SELECT * FROM prescribe WHERE registerid=33 OR registerid=4;
SELECT * FROM invoice ORDER BY id DESC; 
SELECT * FROM costdetail ORDER BY id DESC; -- 未缴费，无记录
CALL patient_pay (33, 302) ;
CALL patient_pay(4, 303); -- 缴费
SELECT * FROM prescribe WHERE registerid=33 OR registerid=4;
SELECT * FROM invoice ORDER BY id DESC;
SELECT * FROM costdetail ORDER BY id DESC; -- 缴费后





-- 第六部分 患者退费

DROP PROCEDURE IF EXISTS patient_refund ;

CREATE PROCEDURE patient_refund (IN invoice_num INT, user_id INT) 
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
  
END ;
-- 发票(1正常 2废弃)
-- 缴费状态（1开立未缴费，2缴费，3发药，6退费）
SELECT * FROM prescribe WHERE registerid=33;
SELECT * FROM invoice WHERE number=800829;
SELECT * FROM costdetail WHERE invoicenum=800829 ORDER BY id DESC;
CALL patient_refund (800829, 300) ; -- 退费
SELECT * FROM prescribe WHERE registerid=33;
SELECT * FROM invoice WHERE number=800829;
SELECT * FROM costdetail WHERE invoicenum=800829 ORDER BY id DESC;







-- 第七部分 药房发药

DROP PROCEDURE IF EXISTS dispense_drug ;

-- （1开立未缴费，2缴费，3发药，6退费）
CREATE PROCEDURE dispense_drug (IN record_num INT) 
BEGIN
  UPDATE 
    prescribe 
  SET
    STATUS = 3 
  WHERE STATUS = 2 
    AND recordnum = record_num 
    AND presdate = CURDATE() ;
  
END ;



-- （1开立未缴费，2缴费，3发药，6退费）
SELECT * FROM prescribe WHERE recordnum = 600601 ORDER BY id DESC;
CALL dispense_drug (600601) ;
SELECT * FROM prescribe WHERE recordnum = 600601 ORDER BY id DESC;
