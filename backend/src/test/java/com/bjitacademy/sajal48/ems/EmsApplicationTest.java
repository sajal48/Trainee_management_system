package com.bjitacademy.sajal48.ems;
import com.bjitacademy.sajal48.ems.domian.credential.UserCredentialService;
import org.junit.jupiter.api.Test;
import org.springframework.boot.test.mock.mockito.MockBean;
public class EmsApplicationTest {
    @MockBean
    private UserCredentialService userCredentialService;
    @Test
    public void testCommandLineRunner() {
    }
}


