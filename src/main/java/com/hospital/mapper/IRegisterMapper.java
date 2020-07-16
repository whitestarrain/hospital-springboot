package com.hospital.mapper;

import com.hospital.domain.Register;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Select;
import org.springframework.stereotype.Repository;

/**
 * @author liyu
 */
@Mapper
@Repository
public interface IRegisterMapper {

    /**
     * 根据挂号id查询挂号记录
     * @param id 挂号id
     * @return 挂号信息对象
     */
    @Select("select * from register where id = #{id}")
    public Register selectById(int id);
}
