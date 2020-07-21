package com.hospital.controller;

import com.hospital.mapper.IVoRegisterMapper;
import com.hospital.vo.VoRegister;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

/**
 * @author liyu
 */
@RestController
@RequestMapping("/voRegister")
public class VoRegisterController {
    @Autowired
    private IVoRegisterMapper IVoRegisterMapper;
    @RequestMapping("/getRegisterListByNum")
    public List<VoRegister> getRegisterListByNum(int medicalRecord){
        return  IVoRegisterMapper.getVoRegisterByNum(medicalRecord);
    }
}
