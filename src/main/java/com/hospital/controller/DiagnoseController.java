package com.hospital.controller;

import com.hospital.vo.VoDiagnose;
import com.hospital.mapper.IDiagNoseMapper;
import com.hospital.mapper.IVoDiagnoseMapper;
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
    private IVoDiagnoseMapper iVoDiagnoseMapper;

    @RequestMapping("/doDiagnose")
    public void diagnose(int registerId,int diagnoseType,int selectDiseaseId){
        iDiagNoseMapper.diagnose(registerId,diagnoseType,selectDiseaseId);
    }

    @RequestMapping("/ChineseDiagnose")
    public VoDiagnose getChineseJoDiagnoseByRegisterId(int registerId){
        return iVoDiagnoseMapper.getChineseJoDiagnoseByRegisterId(registerId);
    }

    @RequestMapping("/WesternDiagnose")
    public VoDiagnose getWesternJoDiagnoseByRegisterId(int registerId){
        return iVoDiagnoseMapper.getWeaternJoDiagnoseByRegisterId(registerId);
    }

}
