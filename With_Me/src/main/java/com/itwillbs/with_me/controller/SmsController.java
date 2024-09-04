package com.itwillbs.with_me.controller;

import java.util.HashMap;
import java.util.Map;
import java.util.Random;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.itwillbs.with_me.service.SmsService;
import com.itwillbs.with_me.vo.SmsAuthInfo;

@Controller
public class SmsController {
	@Autowired
	private SmsService service;
	
	// 전화번호와 인증번호를 매핑하여 저장하는 Map (DB 대신 예시용)
    private Map<String, String> verificationCodes = new HashMap<>();
    
    // 인증번호 전송
	@ResponseBody
	@PostMapping("SendSms")
	public String sendSms(HttpSession session, @RequestParam String phone_number) {
		String id = (String)session.getAttribute("sId");
        
        // 메시지 구성
//        String message = "위드미의 인증번호는 [" + verificationCode + "]입니다. 인증번호를 입력해주세요.";
        
        // SmsVO 객체 생성 및 값 설정
        SmsAuthInfo smsAuthInfo = new SmsAuthInfo();
        smsAuthInfo.setCreator_email(id);
        smsAuthInfo.setPhone_number(phone_number);
        
        // 서비스 호출 (SMS 전송)
        boolean isSent = service.sendSMS(smsAuthInfo);
        
        if (isSent) {
            // 전송된 인증번호를 Map 또는 DB에 저장
            return "문자인증 성공!";
        } else {
        	return "문자인증 실패ㅠ";
        }
    }
    
    // 인증번호 확인
    @ResponseBody
    @PostMapping("VerifyCode")
    public String verifyCode(@RequestParam String phone_number, @RequestParam String code) {
    	// DB에서 인증 정보 조회
        SmsAuthInfo storedInfo = service.getSmsAuthInfo(phone_number);
        
        if (storedInfo != null && storedInfo.getAuth_code().equals(code)) {
            return "인증되었습니다.";
        } else {
            return "인증번호가 틀립니다.";
        }
    }
    
    
}