package com.hospital.controller;

import com.hospital.mapper.IDiagNoseMapper;
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

    @RequestMapping("/doDiagnose")
    public void diagnose(int registerId,int diagnoseType,int selectDiseaseId){

        iDiagNoseMapper.diagnose(registerId,diagnoseType,selectDiseaseId);

    }

}
