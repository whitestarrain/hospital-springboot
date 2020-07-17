package com.hospital.mapper;

import com.hospital.domain.Register;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Select;
import org.springframework.stereotype.Repository;

import java.util.List;

/**
 * @author liyu
 */
@Mapper
@Repository
public interface IRegisterMapper {

    /**
     * 根据挂号id查询挂号记录
     * @param id 挂号id
     * @return 挂号信息对象
     */
    @Select("select * from register where id = #{id}")
    public Register selectById(int id);

    /**
     * 调用存储过程挂号
     * @param register 挂号信息
     */
    public void InsertRegister(Register register);

    /**
     * 根据病历号获得最近挂号信息
     * @param recordId  病历id
     * @return 挂号信息
     */
    @Select(" SELECT * FROM register WHERE id =   (SELECT MAX(id) FROM register WHERE medicalrecord = #{recordId})")
    public Register getRegisterByMedicalRecord(int recordId);


    /**
     * 获得所有今天要诊断但未诊的挂号记录
     * @return 今天要诊断但未诊的挂号记录
     */
    @Select(" SELECT * FROM register WHERE diagdate = CURDATE() AND STATUS = 1")
    public List<Register> getCurrentNoDiagnoseRegister();

    /**
     * 获得所有今天已诊断的记录
     * @return 获得所有今天已诊断的记录
     */
    @Select("SELECT * FROM register WHERE diagdate = CURDATE() AND STATUS = 2")
    public List<Register> getCurrentDiagnosedRegister();
}
