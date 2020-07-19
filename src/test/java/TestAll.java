import com.hospital.HisSpringBootApplication;
import com.hospital.domain.MedicalRecord;
import com.hospital.domain.Prescription;
import com.hospital.domain.Register;
import com.hospital.mapper.*;
import com.hospital.service.IRegisterService;
import com.hospital.vo.VoConsumeInfo;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.test.context.junit4.SpringRunner;

import java.util.List;


/**
 * @author liyu
 */
@RunWith(SpringRunner.class)
@SpringBootTest(classes = HisSpringBootApplication.class)

public class TestAll {
    @Autowired
    private IRegisterMapper registerMapper;
    @Autowired
    private IUserMapper iUserMapper;

    @Autowired
    private IRegisterService service;

    @Autowired
    private IInvoiceMapper invoiceMapper;
    @Test
    public void test() {
        Register registerByMedicalRecord = registerMapper.getRegisterByMedicalRecord(600615);
        System.out.println(registerByMedicalRecord);
        System.out.println(registerMapper.selectById(5));
        System.out.println("test");
//        System.out.println(iUserMapper.login("ghy", "ghy123"));
    }

    @Test
    public void test2() {
        Register r = new Register();
        r.setAddress("1111111111111");
        r.setIdNumber("1312313131312x");
        r.setName("test");
        r.setGender(71);
//        r.setBirthday(new Date(2000, 1, 1));
//        r.setDiagDate(new Date(2000, 1, 1));
        r.setRegistrarId(300);
        r.setNoon("上");
        r.setDepaId(33);
        r.setDoctorId(111);
        r.setPayWay(1);
        r.setNeedRecord(1);
        r.setRegistrarId(112);
//        registerMapper.register(r);
        service.register(r);
        System.out.println(r.getId());
    }
    @Test
    public void test3(){
        Register aa = registerMapper.getRegisterByMedicalRecord(600611);
        System.out.println(aa);
    }

    @Test
    public void test4(){
//        List<Register> temp = registerMapper.getCurrentNoDiagnoseRegister();
//        System.out.println(temp);
    }
    @Autowired
    private IMedicalRecordMapper MedicalRecordMapper;
    @Test
    public void test5(){
        System.out.println(MedicalRecordMapper.getMedicalRecordByNum(600605));
    }

    @Autowired
    private IVoDiseaseMapper joDiseaseMapper;

    @Test
    public void test6(){
        System.out.println(joDiseaseMapper.getJoDisease());
        
        MedicalRecord m = new MedicalRecord();
        m.setRecordNum(111111);
        m.setAllergyhis("11");
        m.setAnamnesis("ss");
        m.setAttention("sss");
        m.setTreatment("sss");
        MedicalRecordMapper.InsertMedical(m);
    }
    @Test
    public void test7(){
        System.out.println(MedicalRecordMapper.isHas(111111));
        MedicalRecord m = new MedicalRecord();
        m.setRecordNum(111111);
        m.setAllergyhis("11");
        m.setAnamnesis("ss");
        m.setAttention("sss");
        m.setTreatment("sss");
        MedicalRecordMapper.updateMedicalRecord(m);
    }
    @Autowired
    private IVoDiagnoseMapper joDiagnoseMapper;
    @Test
    public void test8(){
        System.out.println(joDiagnoseMapper.getChineseJoDiagnoseByRegisterId(206));
        System.out.println(joDiagnoseMapper.getWeaternJoDiagnoseByRegisterId(206));
    }
    @Autowired
    private IPrescriptionMapper prescriptionMapper;

    @Test
    public void test9(){
        System.out.println(prescriptionMapper.selectAllPrescription());
    }

    @Autowired
    private IVoDrugTemplateMapper joDrugTemplateMapper;
    @Test
    public void test10(){
        System.out.println(joDrugTemplateMapper.getVoDrugTemplateById(2));
    }
    @Test
    public void test11(){
        Prescription p = new Prescription();
        p.setName("name111");
        p.setDocId(1);
        prescriptionMapper.insertPrescription(p);
        System.out.println(p.getId());
    }

    @Autowired
    private IVoDrugDetailMapper voDrugDetailMapper;
    @Test
    public void test12(){
        System.out.println(voDrugDetailMapper.getVoDrugDetailById(3));
//        prescriptionMapper.doPrescription(209,"2,3");
    }

    @Autowired
    private IPrescribeMapper prescribeMapper;

    @Test
    public void test13(){
        System.out.println(prescribeMapper.getPrescripted(208));
    }
    @Test
    public void test14(){
        List<Integer> ids = registerMapper.getRegisterIdsByRecordNum(600628);
        System.out.println(ids);
    }

    @Autowired
    private IVoConsumeInfoMapper voConsumeInfoMapper;
    @Test
    public void test15(){
        List<VoConsumeInfo> consumeInfo = voConsumeInfoMapper.getConsumeInfo(208);
        System.out.println(consumeInfo);
    }

    @Test
    public void test16(){
        prescriptionMapper.pay(33, 2, 1);
        System.out.println(invoiceMapper.SelectMaxInvoiceNum());
    }

}
