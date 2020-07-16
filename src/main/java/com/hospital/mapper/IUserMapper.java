package com.hospital.mapper;

import com.hospital.domain.User;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Select;
import org.springframework.stereotype.Repository;

/**
 * @author liyu
 */
@Repository
@Mapper
public interface IUserMapper {
    /**
     * 登录验证
     * @param userName 用户名
     * @param password 用户密码
     * @return 用户对象
     */
    @Select("select * from user where username=#{0} and password = #{1}")
    public User login(String userName,String password);
}
