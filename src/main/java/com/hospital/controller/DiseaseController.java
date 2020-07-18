package com.hospital.controller;

import com.hospital.vo.VoDisease;
import com.hospital.mapper.IVoDiseaseMapper;
import org.springframework.beans.factory.annotation.Autowired;
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
    private IVoDiseaseMapper VoDiseaseMapper;

    @RequestMapping("/getDiseases")
    public List<VoDisease> getDiseases() {
        return VoDiseaseMapper.getJoDisease();
    }
}
