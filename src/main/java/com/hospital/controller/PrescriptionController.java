package com.hospital.controller;

import com.hospital.domain.Prescription;
import com.hospital.jo.JoDrugTemplate;
import com.hospital.mapper.IJoDrugTemplateMapper;
import com.hospital.mapper.IPrescriptionMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

/**
 * @author liyu
 */
@RestController
@RequestMapping("/prescription")
public class PrescriptionController {
    @Autowired
    private IPrescriptionMapper prescriptionMapper;
    @Autowired
    private IJoDrugTemplateMapper joDrugTemplateMapper;
    @RequestMapping("/getAll")
    public List<Prescription> getAllPrescription(){
        return prescriptionMapper.selectAllPrescription();
    }
    @RequestMapping("/getTemplate")
    public List<JoDrugTemplate> getTemplateById(int id){
        return joDrugTemplateMapper.getJoDrugTemplateById(id);
    }
}
