package com.hospital.controller;

import com.hospital.domain.Register;
import com.hospital.domain.User;
import com.hospital.service.impl.RegisterService;
import org.apache.ibatis.annotations.Param;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import javax.servlet.http.HttpServletRequest;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * @author liyu
 */
@RestController
@RequestMapping("/register")
public class RegisterController {
    @Autowired
    private RegisterService rs;

    @RequestMapping("/doRegister")
    public int register(Register registerdata) {
        int invoiceNum = rs.register(registerdata);

        return invoiceNum;
    }

    @RequestMapping("/getRegisterByMedicalRecord")
    public Register getRegisterByMedicalRecord(@RequestParam("medicalRecord") String recordNumStr) {
        int recordNum = 0;
        if (recordNumStr != null && recordNumStr.length() > 0) {
            recordNum = Integer.parseInt(recordNumStr);
        } else {
            return null;
        }
        Register record = rs.getRegisterByMedicalRecord(recordNum);
        return record;
    }

    @RequestMapping("/getCurrentNoDiagnoseRegister")
    public List<Register> getCurrentNoDiagnoseRegister() {
        return rs.getCurrentNoDiagnoseRegister();
    }

    @RequestMapping("/getCurrentDiagnosedRegister")
    public List<Register> getCurrentDiagnosedRegister() {
        return rs.getCurrentDiagnosedRegister();
    }

    @RequestMapping("/getRegisterIdsByRecordNum")
    public List<Integer> getRegisterIdsByRecordNum(int recordNum){
        return rs.getRegisterIdsByRecordNum(recordNum);
    }

    @RequestMapping("/getRegisterById")
    public Register getRegisterById(int registerId){
        return rs.selectById(registerId);
    }
}
