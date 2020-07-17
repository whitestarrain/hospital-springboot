package com.hospital.service;

import com.hospital.domain.Register;

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
}
