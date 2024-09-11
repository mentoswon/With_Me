package com.itwillbs.with_me.controller;

import java.util.HashMap;
import java.util.Map;
import java.util.Random;

import javax.servlet.http.HttpSession;

import org.json.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.itwillbs.with_me.service.SmsService;
import com.itwillbs.with_me.vo.CreatorVO;
import com.itwillbs.with_me.vo.PwSmsAuthInfoVO;
import com.itwillbs.with_me.vo.SmsAuthInfo;

@Controller
public class SmsController {
	@Autowired
	private SmsService service;
	
    // 인증번호 전송
	@ResponseBody
	@PostMapping("SendSms")
	public String sendSms(HttpSession session, @RequestParam String phone_number) {
		// JSON 타입으로 리턴 데이터를 생성을 편리하게 수행하기 위해 Map<String, Object> 객체 생성
		Map<String, Object> resultMap = new HashMap<String, Object>();
		
		String id = (String)session.getAttribute("sId");
        
        // 문자 인증 발송 요청
        SmsAuthInfo smsAuthInfo = service.sendAuthSMS(id, phone_number);
        if (smsAuthInfo != null) {
            // 문자 인증 정보 등록
            service.registSmsAuthInfo(smsAuthInfo);
            resultMap.put("result", true);
        } else {
            resultMap.put("result", false);
        }
		
		// 리턴 데이터가 저장된 Map 객체를 JSON 객체 형식으로 변환
		// => org.json.JSONObject 클래스 활용
		JSONObject jo = new JSONObject(resultMap);
		System.out.println("응답 JSON 데이터 " + jo.toString());
		
		return jo.toString();
    }
    
    // 인증번호 확인
    @ResponseBody
    @PostMapping("VerifyCode")
    public String verifyCode(HttpSession session, SmsAuthInfo smsAuthInfo) {
    	// JSON 타입으로 리턴 데이터를 생성을 편리하게 수행하기 위해 Map<String, Object> 객체 생성
		Map<String, Object> resultMap = new HashMap<String, Object>();
    	String id = (String)session.getAttribute("sId");
		smsAuthInfo.setCreator_email(id);
    	
    	// DB에서 인증 정보 조회
        SmsAuthInfo storedInfo = service.getSmsAuthInfo(smsAuthInfo);
        
        if (storedInfo != null && storedInfo.getAuth_code().equals(smsAuthInfo.getAuth_code())) {
        	// 인증성공 시 creator_info 테이블의 phone_auth_status = 'Y'로 변경
        	int updateCount = service.changePhoneAuth(id);
        	if (updateCount > 0) {	// update 성공
        		resultMap.put("result", true);	// 인증 성공
			} else {
				resultMap.put("result", false);	// 인증 실패
			}
        } else {
        	resultMap.put("result", false);	// 인증 실패
        }
        // 리턴 데이터가 저장된 Map 객체를 JSON 객체 형식으로 변환
        // => org.json.JSONObject 클래스 활용
        JSONObject jo = new JSONObject(resultMap);
        System.out.println("응답 JSON 데이터 " + jo.toString());
        
        return jo.toString();
    }
    
    
    // ========================================================================================
	// 인증번호 전송(비밀번호 변경)
	@ResponseBody
	@PostMapping("PwSendSms")
	public String pwSendSms(@RequestParam String phone_number, String mem_email) {
		// JSON 타입으로 리턴 데이터를 생성을 편리하게 수행하기 위해 Map<String, Object> 객체 생성
		Map<String, Object> resultMap = new HashMap<String, Object>();
		
		System.out.println("mem_email !!!!!!!!!!!! : " + mem_email);
		System.out.println("phone_number !!!!!!!!!!! : " + phone_number);
		
		// 문자 인증 발송 요청
		PwSmsAuthInfoVO PwsmsAuthInfo = service.sendPwAuthSMS(mem_email, phone_number);
		if (PwsmsAuthInfo != null) {
			// 문자 인증 정보 등록
			service.registPwSmsAuthInfo(PwsmsAuthInfo);
			resultMap.put("result", true);
		} else {
			resultMap.put("result", false);
		}
		
		// 리턴 데이터가 저장된 Map 객체를 JSON 객체 형식으로 변환
		// => org.json.JSONObject 클래스 활용
		JSONObject jo = new JSONObject(resultMap);
		System.out.println("응답 JSON 데이터 " + jo.toString());
		
		return jo.toString();
	}
	
    // 인증번호 확인
    @ResponseBody
    @PostMapping("PwVerifyCode")
    public String pwVerifyCode(PwSmsAuthInfoVO PwsmsAuthInfo, String mem_eamil) {
    	// JSON 타입으로 리턴 데이터를 생성을 편리하게 수행하기 위해 Map<String, Object> 객체 생성
		Map<String, Object> resultMap = new HashMap<String, Object>();
    	
    	// DB에서 인증 정보 조회
		PwSmsAuthInfoVO pwSmsAuth = service.getPwSmsAuthInfo(PwsmsAuthInfo);
        
        if (pwSmsAuth != null && pwSmsAuth.getAuth_code().equals(PwsmsAuthInfo.getAuth_code())) {
        	resultMap.put("result", true);	// 인증 성공
        } else {
        	resultMap.put("result", false);	// 인증 실패
        }
        // 리턴 데이터가 저장된 Map 객체를 JSON 객체 형식으로 변환
        // => org.json.JSONObject 클래스 활용
        JSONObject jo = new JSONObject(resultMap);
        System.out.println("응답 JSON 데이터 " + jo.toString());
        
        return jo.toString();
    }
    
    
}