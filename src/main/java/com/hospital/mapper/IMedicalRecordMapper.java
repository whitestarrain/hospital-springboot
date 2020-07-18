package com.hospital.mapper;

import com.hospital.domain.MedicalRecord;
import org.apache.ibatis.annotations.Insert;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Select;
import org.apache.ibatis.annotations.Update;
import org.springframework.stereotype.Repository;

import java.util.List;

/**
 * @author liyu
 */
@Repository
@Mapper
public interface IMedicalRecordMapper {

    /**
     * 根据病历号获得病历
     *
     * @param num
     * @return
     */
    @Select("SELECT * FROM medicalrecord WHERE recordnum = #{num}")
    public MedicalRecord getMedicalRecordByNum(int num);

    @Insert(" INSERT INTO medicalrecord VALUES (#{recordNum},#{symptom},#{nowHistory},#{anamnesis},#{allergyhis}," +
            "#{treatment},#{checkup},#{checkSugg},#{attention},#{result});")
    public void InsertMedical(MedicalRecord m);

    @Update("UPDATE medicalrecord SET symptom = #{symptom},nowhistory =  #{nowHistory},anamnesis=#{anamnesis}," +
            "allergyhis=#{allergyhis},treatment=#{treatment},checkup=#{checkup},checksugg=#{checkSugg}," +
            "attention=#{attention} where recordnum = #{recordNum}")
    public void updateMedicalRecord(MedicalRecord m);

    @Select("SELECT COUNT(recordnum) FROM medicalrecord WHERE recordnum=#{recordNum}")
    public int isHas(int recordNum);

}
