package com.hospital.mapper;

import com.hospital.domain.DrugTemplate;
import org.apache.ibatis.annotations.Insert;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Select;
import org.springframework.stereotype.Repository;

/**
 * @author liyu
 */
@Mapper
@Repository
public interface IDrugTemplateMapper {

    @Insert("INSERT INTO drugtempl VALUES(#{presId},#{drugId},#{useWay},#{dosage},#{frequency},#{number})")
    public void insertDrugTemplate(DrugTemplate d);

    /**
     * 查看指定处方中有没有对应id药品（不能重复添加）
     * @param d
     * @return
     */
    @Select("  SELECT COUNT(drugid) FROM drugtempl WHERE presid = #{presId} AND drugid = #{drugId}")
    public int canInsert(DrugTemplate d);
}
