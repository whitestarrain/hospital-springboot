package com.hospital.controller;

import com.hospital.domain.Prescription;
import com.hospital.domain.User;
import com.hospital.mapper.IInvoiceMapper;
import com.hospital.mapper.IPrescribeMapper;
import com.hospital.vo.VoDrugTemplate;
import com.hospital.mapper.IVoDrugTemplateMapper;
import com.hospital.mapper.IPrescriptionMapper;
import org.springframework.beans.factory.annotation.Autowired;
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
    private IVoDrugTemplateMapper voDrugTemplateMapper;

    @Autowired
    private IPrescribeMapper prescribeMapper;
    @Autowired
    private IInvoiceMapper invoiceMapper;

    @RequestMapping("/getAll")
    public List<Prescription> getAllPrescription() {
        return prescriptionMapper.selectAllPrescription();
    }

    @RequestMapping("/getTemplate")
    public List<VoDrugTemplate> getTemplateById(int id) {
        return voDrugTemplateMapper.getVoDrugTemplateById(id);
    }

    @RequestMapping("/getTemplateByIds")
    public List<VoDrugTemplate> getTemplateByIds(String ids) {
        if (ids.length() == 0 || "".equals(ids) || ids.split(",").length == 0) {
            return null;
        }
        String[] split = ids.split(",");
        int[] ints = Arrays.stream(split).mapToInt(Integer::parseInt).toArray();
        ArrayList<VoDrugTemplate> list = new ArrayList<>();
        for (int i : ints) {
            list.addAll(voDrugTemplateMapper.getVoDrugTemplateById(i));
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

    @RequestMapping("/doPrescription")
    public void doPrescription(int registerId,String ids){
        prescriptionMapper.doPrescription(registerId,ids);
    }

    @RequestMapping("/getPrescripted")
    public List<String> getPrescripted(int registerId){
        return prescribeMapper.getPrescripted(registerId);
    }

    @RequestMapping("/pay")
    public int pay(int userId,int payWay,int registerId){
        prescriptionMapper.pay(registerId,userId,payWay);
        return invoiceMapper.SelectMaxInvoiceNum();
    }
    @RequestMapping("/distributeDrug")
    public void distributeDrug(int recordNum){
        prescribeMapper.distributeDrug(recordNum);
    }
}
