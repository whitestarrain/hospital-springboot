package com.hospital.controller;

import com.hospital.domain.Prescription;
import com.hospital.domain.User;
import com.hospital.jo.JoDrugTemplate;
import com.hospital.mapper.IJoDrugTemplateMapper;
import com.hospital.mapper.IPrescriptionMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.ui.Model;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import javax.servlet.http.HttpSession;
import java.util.ArrayList;
import java.util.Arrays;
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
    public List<Prescription> getAllPrescription() {
        return prescriptionMapper.selectAllPrescription();
    }

    @RequestMapping("/getTemplate")
    public List<JoDrugTemplate> getTemplateById(int id) {
        return joDrugTemplateMapper.getJoDrugTemplateById(id);
    }

    @RequestMapping("/getTemplateByIds")
    public List<JoDrugTemplate> getTemplateByIds(String ids) {
        if (ids.length() == 0 || "".equals(ids) || ids.split(",").length == 0) {
            return null;
        }
        String[] split = ids.split(",");
        int[] ints = Arrays.stream(split).mapToInt(Integer::parseInt).toArray();
        ArrayList<JoDrugTemplate> list = new ArrayList<>();
        for (int i : ints) {
            list.addAll(joDrugTemplateMapper.getJoDrugTemplateById(i));
        }

        return list;
    }

    @RequestMapping("/insertPrescription")
    public int insertPrescription(@RequestParam("name") String name, HttpSession session) {
        Prescription p = new Prescription();
        p.setName(name);
        int userId = ((User)(session.getAttribute("user"))).getId();
        p.setDocId(userId);
        prescriptionMapper.insertPrescription(p);
        return p.getId();
    }
}
