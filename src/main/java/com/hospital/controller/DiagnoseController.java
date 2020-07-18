package com.hospital.controller;

import com.hospital.jo.JoDiagnose;
import com.hospital.mapper.IDiagNoseMapper;
import com.hospital.mapper.IJoDiagnoseMapper;
import org.apache.ibatis.annotations.Mapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

/**
 * @author liyu
 */
@RestController
@RequestMapping("/diagnose")
public class DiagnoseController {
    @Autowired
    private IDiagNoseMapper iDiagNoseMapper;
    @Autowired
    private IJoDiagnoseMapper iJoDiagnoseMapper;

    @RequestMapping("/doDiagnose")
    public void diagnose(int registerId,int diagnoseType,int selectDiseaseId){
        iDiagNoseMapper.diagnose(registerId,diagnoseType,selectDiseaseId);
    }

    @RequestMapping("/ChineseDiagnose")
    public JoDiagnose getChineseJoDiagnoseByRegisterId(int registerId){
        return iJoDiagnoseMapper.getChineseJoDiagnoseByRegisterId(registerId);
    }

    @RequestMapping("/WesternDiagnose")
    public JoDiagnose getWesternJoDiagnoseByRegisterId(int registerId){
        return iJoDiagnoseMapper.getWeaternJoDiagnoseByRegisterId(registerId);
    }

}
