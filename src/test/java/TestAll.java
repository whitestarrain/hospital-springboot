import com.hospital.HisSpringBootApplication;
import com.hospital.mapper.IRegisterMapper;
import com.hospital.mapper.IUserMapper;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.test.context.junit4.SpringRunner;


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
    @Test
    public void test(){
        System.out.println(registerMapper.selectById(3));
        System.out.println("test");
        System.out.println(iUserMapper.login("ghy","ghy123"));
    }
}
