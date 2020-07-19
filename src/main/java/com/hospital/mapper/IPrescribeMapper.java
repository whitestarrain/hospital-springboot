package com.hospital.mapper;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Select;
import org.springframework.stereotype.Repository;

import java.util.List;

/**
 * @author liyu
 */
@Mapper
@Repository
public interface IPrescribeMapper {

    @Select("SELECT NAME FROM prescribe WHERE registerid = #{registerId} AND presdate = CURDATE()")
    List<String> getPrescripted(int registerId);
}
