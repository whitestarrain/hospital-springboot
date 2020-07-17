import com.hospital.HisSpringBootApplication;
import com.hospital.domain.Register;
import com.hospital.mapper.IInvoiceMapper;
import com.hospital.mapper.IMedicalRecordMapper;
import com.hospital.mapper.IRegisterMapper;
import com.hospital.mapper.IUserMapper;
import com.hospital.service.IRegisterService;
import com.hospital.service.impl.RegisterService;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.test.context.junit4.SpringRunner;

import java.sql.Date;
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
        r.setBirthday(new Date(2000, 1, 1));
        r.setDiagDate(new Date(2000, 1, 1));
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
        List<Register> temp = registerMapper.getCurrentNoDiagnoseRegister();
        System.out.println(temp);
    }
    @Autowired
    private IMedicalRecordMapper iMedicalRecordMapper;
    @Test
    public void test5(){
        System.out.println(iMedicalRecordMapper.getMedicalRecordByNum(600601));
    }
}
