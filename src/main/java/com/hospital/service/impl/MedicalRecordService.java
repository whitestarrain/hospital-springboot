package com.hospital.service.impl;

import com.hospital.domain.MedicalRecord;
import com.hospital.mapper.IMedicalRecordMapper;
import com.hospital.service.IMedicalRecordService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

/**
 * @author liyu
 */
@Service
public class MedicalRecordService implements IMedicalRecordService {
    @Autowired
    private IMedicalRecordMapper medicalRecordMapper;

    @Override
    public MedicalRecord getMedicalRecordByNum(int recordNum) {
        return medicalRecordMapper.getMedicalRecordByNum(recordNum);
    }

    @Override
    public void InsertOrUpdateMedicalRecord(MedicalRecord m) {
        int has = medicalRecordMapper.isHas(m.getRecordNum());
        if(has==0){
            medicalRecordMapper.InsertMedical(m);
        }else {
            medicalRecordMapper.updateMedicalRecord(m);
        }
    }
}
