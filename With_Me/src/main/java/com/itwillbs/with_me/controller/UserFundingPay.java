package com.itwillbs.with_me.controller;

import java.time.LocalDate;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.scheduling.annotation.EnableScheduling;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;

import com.itwillbs.with_me.service.UserFundingService;
import com.itwillbs.with_me.vo.BankToken;

@Component 
@EnableScheduling // 필수
public class UserFundingPay{
	
	@Autowired
	private UserFundingService service;
	
	private static final Logger logger = LoggerFactory.getLogger(BankController.class);
	
	// ================================================================================================================
	@Scheduled(cron = "0 10 21 * * ?")  //0 12 10 * * ?매일 지정 시간에 진행 (오전 10시 설정 예정)
	public void sche () throws Exception {
		
		// ----------------------------------------------------------
		// DB 가서 결제일이 오늘인 후원 내역 찾기
		
		// 1) 오늘 날짜 구하기
		// 현재 날짜 구하기        
		LocalDate now = LocalDate.now();
		System.out.println(now);
		
		// 2) funding_user 테이블에 funding_pay_date (결제 예정일) 가 저장되어있음. 
		//	  오늘 날짜와 동일한 거 들고오기
		List<Map<String, Object>> payList = service.getTodayPayFunding(now);
		
		// -------------------------------------------------------------------------------
		// 해당 펀딩의 funding_idx 에 맞는 사람이 결제돼야함. (출금처리)
		
		// 2.5. 계좌이체 서비스 - 2.5.1. 출금이체 API
		// https://testapi.openbanking.or.kr/v2.0/transfer/withdraw/fin_num
		String id = "";
		
		for(Map<String, Object> list : payList) {
			id = (String)list.get("funding_mem_email");
			
			// 엑세스토큰 관련 정보가 저장된 BankToken 객체(token)를 가져오기
			BankToken token = service.getBankUserInfo(id);	
			
			Map<String, Object> map = new HashMap<String, Object>();
			
			map.put("token", token);
			map.put("id", id);
			
			// withdraw_fintech_use_num(token 에 들어있음), withdraw_client_name, tran_amt(funding_pay_amt) 추가 필요
			map.put("withdraw_client_name", list.get("name"));
			map.put("tran_amt", list.get("funding_pay_amt"));
			
			logger.info("출금이체 요청 파라미터 : " + map);
			
			// BankService - requestWithdraw() 메서드 호출하여 출금이체 요청
			// => 파라미터 : Map 객체    리턴타입 : Map<String, String>(withdrawResult)
			Map<String, String> withdrawResult = service.requestWithdraw(map);
			logger.info(">>>>>>> 출금이체 요청 결과 : " + withdrawResult);
			
			// project_payment 테이블에 오늘 날짜로 결제 날짜 업데이트 하기
			service.updatePayDate(map);
			
			// funding_user 테이블에 funding_status 후원 완료로 업데이트
//			service.updateFundingStatus(map);
		}
		
		
	}
	
	
}


















