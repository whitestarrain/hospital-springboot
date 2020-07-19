package com.hospital.mapper;

import com.hospital.domain.Prescription;
import org.apache.ibatis.annotations.*;
import org.springframework.stereotype.Repository;

import java.util.List;

/**
 * @author liyu
 */
@Repository
@Mapper
public interface IPrescriptionMapper {
    /**
     * 获得所有处方信息
     * @return 处方信息
     */
    @Select("SELECT * FROM prescription")
    public List<Prescription> selectAllPrescription();

    /**
     * 添加指定名称的的处方
     */
    public void insertPrescription(Prescription p);

    @Insert("CALL doct_prescribe(#{0},#{1})")
    public void doPrescription(int registerId,String ids);

    @Update("call patient_pay(#{0},#{1},#{2})")
    void pay(int registerId, int userId, int payWay);
}
