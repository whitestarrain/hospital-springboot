package com.hospital.mapper;

import com.hospital.jo.JoDrugTemplate;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Select;
import org.springframework.stereotype.Repository;

import java.util.List;

/**
 * @author liyu
 */
@Repository
@Mapper
public interface IJoDrugTemplateMapper {
    /**
     * 根据处方id获取模版信息
     *
     * @param id 处方id
     * @return
     */
    @Select("SELECT \n" +
            "  * \n" +
            "FROM\n" +
            "    (SELECT \n" +
            "      drugid id,useway, dosage, frequency,number\n" +
            "    FROM\n" +
            "      drugtempl \n" +
            "    WHERE presid = #{id}) t2 NATURAL JOIN \n" +
            "    (SELECT \n" +
            "      id,\n" +
            "      NAME,\n" +
            "      specification,\n" +
            "      price \n" +
            "    FROM\n" +
            "      drug \n" +
            "    WHERE id IN \n" +
            "      (SELECT \n" +
            "        drugid \n" +
            "      FROM\n" +
            "        drugtempl \n" +
            "      WHERE presid = #{id})) t3")
    public List<JoDrugTemplate> getJoDrugTemplateById(int id);
}
