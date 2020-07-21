package com.hospital.mapper;

import com.hospital.vo.VoRegister;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Select;
import org.springframework.stereotype.Repository;

import java.util.List;

/**
 * @author liyu
 */
@Mapper
@Repository
public interface IVoRegisterMapper {
    @Select("SELECT t1.*,department.name depaName  FROM(SELECT id,regidate,depaid,STATUS FROM register WHERE " +
            "medicalrecord = #{num}) t1,department WHERE t1.depaid = department.id")
    public List<VoRegister> getVoRegisterByNum(int num);
}
