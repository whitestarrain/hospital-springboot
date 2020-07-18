package com.hospital.controller;

import com.hospital.mapper.IVoDrugDetailMapper;
import com.hospital.vo.VoDrugDetail;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

/**
 * @author liyu
 */
@RestController
@RequestMapping("/drug")
public class DrugController {
    @Autowired
    private IVoDrugDetailMapper voDrugDetailMapper;

    @RequestMapping("/getDrugDetails")
    public List<VoDrugDetail> getSomVoDrugDetail(){
        return voDrugDetailMapper.getSomVoDrugDetail();
    }
}
