package com.hospital.mapper;

import com.hospital.vo.VoDrugDetail;
import org.apache.ibatis.annotations.Mapper;
import org.springframework.stereotype.Repository;

import java.util.List;

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
    public VoDrugDetail getVoDrugDetailById(int id);

    /**
     * 用于测试，获取部分药品详细信息
     * @return
     */
    public List<VoDrugDetail> getSomVoDrugDetail();
}
