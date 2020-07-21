package com.hospital.controller;

import com.hospital.mapper.IVoDrugDistributeMapper;
import com.hospital.vo.VoDrugDistribute;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

/**
 * @author liyu
 */
@RestController
@RequestMapping("/VoDrugDistribute")
public class VoDrugDistributeController {
    @Autowired
    private IVoDrugDistributeMapper voDrugDistributeMapper;
    @RequestMapping("/getVoDrugDistributeByNum")
    public List<VoDrugDistribute> getVoDrugDistributeByNum(int recordNum, String date){
        return voDrugDistributeMapper.getVoDrugDistributeByNum(recordNum,date);
    }
}
