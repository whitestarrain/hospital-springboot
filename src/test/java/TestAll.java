import com.hospital.HisSpringBootApplication;
import com.hospital.domain.Register;
import com.hospital.mapper.IInvoiceMapper;
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
        System.out.println(registerMapper.selectById(3));
        System.out.println("test");
        System.out.println(iUserMapper.login("ghy", "ghy123"));
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
        service.register(r,5);
        System.out.println(r.getId());
    }
    @Test
    public void test3(){
        int i = invoiceMapper.SelectMaxInvoiceNum();
        System.out.println(i);
    }

}
