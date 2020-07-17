package com.hospital.controller;

import com.hospital.domain.Register;
import com.hospital.service.impl.RegisterService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

/**
 * @author liyu
 */
@RestController
@RequestMapping("/register")
public class RegisterController {
    @Autowired
    private RegisterService rs;
    @RequestMapping("/doRegister")
    public int register(Register r){

        return 0;
    }
}
