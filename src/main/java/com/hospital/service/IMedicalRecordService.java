package com.hospital.service;

import com.hospital.domain.MedicalRecord;

/**
 * @author liyu
 */
public interface IMedicalRecordService {
    /**
     * 根据是否存在进行medicalrecord的更新或插入
     * @param m
     */
    public void InsertOrUpdateMedicalRecord(MedicalRecord m);

    /**
     * 根据病历号获取病历信息
     * @param recordNum 病历号
     * @return 病历
     */
    public MedicalRecord getMedicalRecordByNum(int recordNum);
}
