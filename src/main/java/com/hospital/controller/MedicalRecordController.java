package com.hospital.controller;

import com.hospital.domain.MedicalRecord;
import com.hospital.mapper.IMedicalRecordMapper;
import com.hospital.service.IMedicalRecordService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

/**
 * @author liyu
 */
@RestController
@RequestMapping("/medicalRecord")
public class MedicalRecordController {
    @Autowired
    private IMedicalRecordService medicalRecordService;
    @RequestMapping("/getByNum")
    public MedicalRecord getMedicalRecordByNum(int recordNum){
        return medicalRecordService.getMedicalRecordByNum(recordNum);
    }

    @RequestMapping("/add")
    public void addMedicalRecord(MedicalRecord m){
        medicalRecordService.InsertOrUpdateMedicalRecord(m);
    }
}
