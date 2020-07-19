package com.hospital.controller;

import com.hospital.mapper.IVoConsumeInfoMapper;
import com.hospital.vo.VoConsumeInfo;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

/**
 * @author liyu
 */
@RestController
@RequestMapping("/voConsumeInfo")
public class VoConsumeInfoController {
    @Autowired
    private IVoConsumeInfoMapper iVoConsumeInfoMapper;
    @RequestMapping("/getInfoByRegisterId")
    public List<VoConsumeInfo> getInfoByRegisterId(int registerId){
        return iVoConsumeInfoMapper.getConsumeInfo(registerId);
    }
}
