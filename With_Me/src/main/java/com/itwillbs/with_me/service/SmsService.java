package com.itwillbs.with_me.service;

import java.util.Random;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.itwillbs.with_me.handler.SendSmsClient;
import com.itwillbs.with_me.mapper.SmsMapper;
import com.itwillbs.with_me.vo.SmsAuthInfo;

@Service
public class SmsService {
	@Autowired
	private SmsMapper mapper;
	
    public SmsAuthInfo sendAuthSMS(String id, String phone_number) {
    	// 문자 인증에 포함시킬 난수 생성
    	// GenerateRandomCode 클래스의 static getRandomCode() 메서드 호출하여 난수 리턴
    	String auth_code = AuthCode();
		System.out.println("생성된 인증코드 : " + auth_code);
    	
		String content = "위드미의 인증번호는 [" + auth_code + "]입니다. 인증번호를 입력해주세요.";
		
		
		// ===================================================================
		// 쓰레드로 SMS 발송 작업 수행
		new Thread(new Runnable() { // 1회용 쓰레드 생성
			@Override
			public void run() {
				// 쓰레드로 수행할 작업
				SendSmsClient.sendSms(phone_number, content);
				System.out.println("쓰레드 작업 완료");
			}
		}).start(); // start() 메서드 호출 필수!
		
		// ===================================================================
		// SmsAuthInfo 객체 생성 후 이메일 주소, 전화번호, 인증 코드 저장 후 리턴
		SmsAuthInfo smsAuthInfo = new SmsAuthInfo(id, phone_number, auth_code);
    	return smsAuthInfo;
    }
    
    // 문자 인증 정보 등록 요청
    public void registSmsAuthInfo(SmsAuthInfo smsAuthInfo) {
    	// 기존 인증정보 존재 여부 확인
		SmsAuthInfo dbSmsAuthInfo = mapper.selectSmsAuthInfo(smsAuthInfo);
		System.out.println("조회된 인증 정보 : " + dbSmsAuthInfo);
		
		// 인증정보 조회 결과 판별
		if(dbSmsAuthInfo == null) { // 기존 인증정보 없음(인증문자 발송 이력 없음)
			// 새 인증정보 등록(INSERT)
			mapper.insertSmsAuthInfo(smsAuthInfo);
		} else { // 기존 인증정보 있음(인증문자 발송 이력 있음)
			// 기존 인증정보 갱신(UPDATE)
			mapper.updateSmsAuthInfo(smsAuthInfo);
		}
    	
    }

    // 문자 인증 정보 조회
	public SmsAuthInfo getSmsAuthInfo(SmsAuthInfo smsAuthInfo) {
		return mapper.selectSmsAuthInfo(smsAuthInfo); 
	}
	
	public String AuthCode() {
		// 1. java.util.Random 클래스 활용
		// 6자리 정수(0 ~ 999999)로 된 난수 생성
		Random r = new Random();
		int rNum = r.nextInt(1000000); // 0 ~ 999999 까지의 난수 생성
		String strNum = String.format("%06d", rNum);	// 6자리 아닐 경우 앞에 0으로 채움
		System.out.println("strNum : " + strNum);
		return strNum;
	}
	
}