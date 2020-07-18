package com.hospital.mapper;

import com.hospital.vo.VoDrugDetail;
import org.apache.ibatis.annotations.Mapper;
import org.springframework.stereotype.Repository;

/**
 * @author liyu
 */
@Mapper
@Repository
public interface IVoDrugDetailMapper {
    /**
     * 根据药品id获取药品详细
     * @return
     */
    public VoDrugDetail getJoDrugDetailById(int id);
}
