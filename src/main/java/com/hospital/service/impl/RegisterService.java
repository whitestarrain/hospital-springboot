package com.hospital.service.impl;

import com.hospital.domain.Invoice;
import com.hospital.domain.Register;
import com.hospital.mapper.IInvoiceMapper;
import com.hospital.mapper.IRegisterMapper;
import com.hospital.service.IRegisterService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.math.BigDecimal;
import java.util.List;

/**
 * @author liyu
 */
@Service
public class RegisterService implements IRegisterService {
    @Autowired
    private IRegisterMapper registerMapper;
    @Autowired
    private IInvoiceMapper invoiceMapper;

    @Override
    public Register getRegisterByMedicalRecord(int recordNum) {
        return registerMapper.getRegisterByMedicalRecord(recordNum);
    }

    @Override
    public int register(Register register) {
        registerMapper.InsertRegister(register);
        int maxInvoiceNum = invoiceMapper.SelectMaxInvoiceNum();
        Invoice invoice = new Invoice();
        invoice.setNumber(maxInvoiceNum + 1);
        invoice.setPayAmount(new BigDecimal(20));
        invoice.setPayWay(register.getPayWay());
        invoice.setRegisterId(register.getId());
        invoice.setStatus(1);
        invoice.setUserId(register.getRegistrarId());
        invoiceMapper.insertInvovice(invoice);
        return invoice.getNumber();
    }

    @Override
    public Register selectById(int id) {
        return registerMapper.selectById(id);
    }

    @Override
    public List<Register> getCurrentNoDiagnoseRegister(int doctorId) {
        return registerMapper.getCurrentNoDiagnoseRegister(doctorId);
    }

    @Override
    public List<Integer> getRegisterIdsByRecordNum(int recordNum) {
        return registerMapper.getRegisterIdsByRecordNum(recordNum);
    }

    @Override
    public List<Register> getCurrentDiagnosedRegister(int doctorId) {
        return registerMapper.getCurrentDiagnosedRegister(doctorId);
    }
}
