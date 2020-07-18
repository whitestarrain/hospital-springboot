package com.hospital.mapper;

import com.hospital.jo.JoDisease;
import org.apache.ibatis.annotations.Insert;
import org.apache.ibatis.annotations.Mapper;
import org.springframework.stereotype.Repository;

/**
 * @author liyu
 */
@Mapper
@Repository
public interface IDiagNoseMapper {

    @Insert("CALL doc_diag (#{0},#{2},#{1})")
    public void diagnose(int registerid,int diseaseId,int diagnoseType);


}
