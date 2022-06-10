package kr.co.hlm.system;


import lombok.extern.log4j.Log4j2;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.context.annotation.Configuration;

@Log4j2
@Configuration
@SpringBootApplication
public class HlmSystemApplication {
    public static void main(String[] args) {
        SpringApplication.run(HlmSystemApplication.class, args);
        log.info("Helmet Loss Management Server Start!");
    }
}
