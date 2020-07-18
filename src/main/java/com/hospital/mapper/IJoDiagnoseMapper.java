package com.hospital.mapper;

import com.hospital.jo.JoDiagnose;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Select;
import org.springframework.stereotype.Repository;

/**
 * @author liyu
 */
@Repository
@Mapper
public interface IJoDiagnoseMapper {

    /**
     * 获取中医诊断记录
     *
     * @param num
     * @return
     */
    @Select("SELECT diagnose.recordnum,diagnose.registerid,diagnose.diagtype,diagnose.diseaseid,diagnose.diagdate " +
            "insertTime,disease.name diseaseName,disease.icd FROM diagnose INNER JOIN disease ON diagnose" +
            ".diseaseid=disease.id WHERE registerid=#{id} AND diagtype=2")
    public JoDiagnose getChineseJoDiagnoseByRegisterId(int id);

    /**
     * 获取西医诊断记录
     *
     * @param num
     * @return
     */
    @Select("SELECT diagnose.recordnum,diagnose.registerid,diagnose.diagtype,diagnose.diseaseid,diagnose.diagdate " +
            "insertTime,disease.name diseaseName,disease.icd FROM diagnose INNER JOIN disease ON diagnose" +
            ".diseaseid=disease.id WHERE registerid=#{id} AND diagtype=1")
    public JoDiagnose getWeaternJoDiagnoseByRegisterId(int id);
}
