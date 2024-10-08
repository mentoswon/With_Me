package com.itwillbs.with_me.service;

import java.util.Random;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.itwillbs.with_me.handler.SendSmsClient;
import com.itwillbs.with_me.mapper.SmsMapper;
import com.itwillbs.with_me.vo.PwSmsAuthInfoVO;
import com.itwillbs.with_me.vo.SmsAuthInfo;

@Service
public class SmsService {
    @Autowired
    private SmsMapper mapper;
    
    @Autowired
    private SendSmsClient sendSmsClient; // SendSmsClient 인스턴스 주입

    public SmsAuthInfo sendAuthSMS(String id, String phone_number) {
        // 문자 인증에 포함시킬 난수 생성
        String auth_code = AuthCode();
        System.out.println("생성된 인증코드 : " + auth_code);
        
        String content = "위드미의 인증번호는 [" + auth_code + "]입니다. 인증번호를 입력해주세요.";

        // ===================================================================
        // 쓰레드로 SMS 발송 작업 수행
        new Thread(() -> {
            // 쓰레드로 수행할 작업
            sendSmsClient.sendSms(phone_number, content); // 인스턴스를 통해 호출
            System.out.println("쓰레드 작업 완료");
        }).start(); // start() 메서드 호출 필수!
        
        // ===================================================================
        // SmsAuthInfo 객체 생성 후 이메일 주소, 전화번호, 인증 코드 저장 후 리턴
        SmsAuthInfo smsAuthInfo = new SmsAuthInfo(id, phone_number, auth_code);
        return smsAuthInfo;
    }

    // 문자 인증 정보 등록 요청
    public void registSmsAuthInfo(SmsAuthInfo smsAuthInfo) {
        SmsAuthInfo dbSmsAuthInfo = mapper.selectSmsAuthInfo(smsAuthInfo);
        System.out.println("조회된 인증 정보 : " + dbSmsAuthInfo);
        
        if (dbSmsAuthInfo == null) {
            // 새 인증정보 등록(INSERT)
            mapper.insertSmsAuthInfo(smsAuthInfo);
        } else {
            // 기존 인증정보 갱신(UPDATE)
            mapper.updateSmsAuthInfo(smsAuthInfo);
        }
    }

    // 문자 인증 정보 조회
    public SmsAuthInfo getSmsAuthInfo(SmsAuthInfo smsAuthInfo) {
        return mapper.selectSmsAuthInfo(smsAuthInfo); 
    }

    public String AuthCode() {
        Random r = new Random();
        int rNum = r.nextInt(1000000); // 0 ~ 999999 까지의 난수 생성
        return String.format("%06d", rNum); // 6자리 아닐 경우 앞에 0으로 채움
    }

    // 휴대번호 인증 상태 변경 요청
    public int changePhoneAuth(String id) {
        return mapper.updatePhoneAuth(id);
    }

    // --------------------------------------------------------------------------------------------
    // 비밀번호 변경 문자인증
	public PwSmsAuthInfoVO sendPwAuthSMS(String mem_email, String phone_number) {
		
        // 문자 인증에 포함시킬 난수 생성
        String auth_code = AuthCode();
        System.out.println("생성된 인증코드 : " + auth_code);
        
        String content = "위드미의 인증번호는 [" + auth_code + "]입니다. 인증번호를 입력해주세요.";
        
        // ===================================================================
        // 쓰레드로 SMS 발송 작업 수행
        new Thread(() -> {
            // 쓰레드로 수행할 작업
            sendSmsClient.sendSms(phone_number, content); // 인스턴스를 통해 호출
            System.out.println("쓰레드 작업 완료");
        }).start(); // start() 메서드 호출 필수!
        
        // ===================================================================
        // PwSmsAuthInfoVO 객체 생성 후 이메일 주소, 전화번호, 인증 코드 저장 후 리턴
        PwSmsAuthInfoVO PwsmsAuthInfo = new PwSmsAuthInfoVO(mem_email, phone_number, auth_code);
        return PwsmsAuthInfo;
	}

	// 문자 인증 정보 등록 요청(비밀번호 변경)
	public void registPwSmsAuthInfo(PwSmsAuthInfoVO pwsmsAuthInfo) {
		PwSmsAuthInfoVO dbSmsAuthInfo = mapper.selectPwSmsAuthInfo(pwsmsAuthInfo);
        System.out.println("조회된 인증 정보 : " + dbSmsAuthInfo);
        
        if (dbSmsAuthInfo == null) {
            // 새 인증정보 등록(INSERT)
            mapper.insertPwSmsAuthInfo(pwsmsAuthInfo);
        } else {
            // 기존 인증정보 갱신(UPDATE)
            mapper.updatePwSmsAuthInfo(pwsmsAuthInfo);
        }
		
	}
	// 문자 인증 정보 조회(비밀번호 변경)
	public PwSmsAuthInfoVO getPwSmsAuthInfo(PwSmsAuthInfoVO pwsmsAuthInfo) {
		return mapper.selectPwSmsAuthInfo(pwsmsAuthInfo);
	}

}
