package com.hospital.mapper;

import com.hospital.vo.VoConsumeInfo;
import org.apache.ibatis.annotations.Mapper;
import org.springframework.stereotype.Repository;

import java.util.List;

/**
 * @author liyu
 */
@Mapper
@Repository
public interface IVoConsumeInfoMapper {

    public List<VoConsumeInfo> getConsumeInfo(int registerid);
}
