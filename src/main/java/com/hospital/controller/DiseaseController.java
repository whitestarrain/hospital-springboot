package com.hospital.controller;

import com.hospital.jo.JoDisease;
import com.hospital.mapper.IJoDiseaseMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

/**
 * @author liyu
 */
@RestController
@RequestMapping("/disease")
public class DiseaseController {
    @Autowired
    private IJoDiseaseMapper joDiseaseMapper;

    @RequestMapping("/getDiseases")
    public List<JoDisease> getDiseases() {
        return joDiseaseMapper.getJoDisease();
    }
}
