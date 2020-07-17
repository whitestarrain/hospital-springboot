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


    public Register getRegisterByMedicalRecord(int recordNum);

    public List<Register> getCurrentNoDiagnoseRegister();

    public List<Register> getCurrentDiagnosedRegister();
}
