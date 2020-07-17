package com.hospital.mapper;

import org.apache.ibatis.annotations.Insert;
import org.apache.ibatis.annotations.Mapper;
import org.springframework.stereotype.Repository;

/**
 * @author liyu
 */
@Mapper
@Repository
public interface IDiagNoseMapper {

    @Insert("CALL doc_diag (#{0},#{1},#{2})")
    public void diagnose(int registerid,int diseaseId,int diagnoseType);
}
