package com.itwillbs.with_me.service;

import java.util.Random;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.itwillbs.with_me.mapper.SmsMapper;
import com.itwillbs.with_me.vo.SmsAuthInfo;

@Service
public class SmsService {
	@Autowired
	private SmsMapper mapper;
	
	private static final String SMS_API_URL = "https://api.coolsms.co.kr/sms/send";
    private static final String API_KEY = "NCSQMHZF0P97BK4W";
    private static final String API_SECRET = "L5IOFHZAB61DFSN9LOSZ0F2GU3KAMQDH";


	public boolean sendSMS(SmsAuthInfo sms) {
		// 인증번호 생성
        String verificationCode = generateVerificationCode();
        sms.setAuth_code(verificationCode);

        // SMS 전송 API 호출
        boolean isSent = sendSmsViaApi(sms);

        return mapper.saveSmsAuthInfo(sms);
	}
	
	public SmsAuthInfo getSmsAuthInfo(String phone_number) {
        return mapper.getSmsAuthInfoByPhoneNumber(phone_number);
    }
	
	private boolean sendSmsViaApi(SmsAuthInfo sms) {
        // 실제 SMS 전송 로직 구현
        // 예시: 외부 API를 통해 SMS 전송
        System.out.println("Sending SMS to " + sms.getPhone_number() + " with message: " + sms.getAuth_code());

        // 실제 구현에서는 전송 성공 여부에 따라 true 또는 false 반환
        return true; // 예시로 항상 성공 처리
    }
	
	// 6자리 난수 생성 메서드
    private String generateVerificationCode() {
        Random random = new Random();
        int randomCode = 100000 + random.nextInt(900000); // 100000 ~ 999999 범위의 난수 생성
        return String.valueOf(randomCode);
    }
}