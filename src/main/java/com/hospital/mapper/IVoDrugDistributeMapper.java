package com.hospital.mapper;

import com.hospital.vo.VoDrugDistribute;
import org.apache.ibatis.annotations.Mapper;
import org.springframework.stereotype.Repository;

import java.sql.Date;
import java.util.List;

/**
 * @author liyu
 */
@Mapper
@Repository
public interface IVoDrugDistributeMapper {

    public List<VoDrugDistribute> getVoDrugDistributeByNum(int recordNum, String date);
}
