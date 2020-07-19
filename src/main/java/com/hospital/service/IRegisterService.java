package com.hospital.service;

import com.hospital.domain.Register;

import java.util.List;

/**
 * @author liyu
 */
public interface IRegisterService {
    /**
     * 进行挂号
     * @param register 挂号信息
     * @return 发票num
     */
    public int register(Register register);


    /**
     * 根据病历号获得*最近*挂号信息
     * @param recordNum 病历号
     * @return *最近*挂号信息
     */
    public Register getRegisterByMedicalRecord(int recordNum);

    public Register selectById(int id);

    public List<Register> getCurrentNoDiagnoseRegister(int doctorId);

    public List<Register> getCurrentDiagnosedRegister(int doctorId);

    public List<Integer> getRegisterIdsByRecordNum(int recordNum);

    public int getRegistedNumByDocId(int docId);
}
