package com.hospital.mapper;

import com.hospital.jo.JoDisease;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Select;
import org.springframework.stereotype.Repository;

import java.util.List;

/**
 * @author liyu
 */
@Repository
@Mapper
public interface IJoDiseaseMapper {
    /**
     * 查询5条疾病记录用来测试
     * @return 疾病信息记录
     */
    @Select("SELECT disease.*,diseasetype.name TYPE FROM disease,diseasetype WHERE disease.typeid = diseasetype.id LIMIT 0,4")
    public List<JoDisease> getJoDisease();
}
