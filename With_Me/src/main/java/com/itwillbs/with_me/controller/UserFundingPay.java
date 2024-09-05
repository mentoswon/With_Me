package com.itwillbs.with_me.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.ApplicationContext;
import org.springframework.context.annotation.ComponentScan;
import org.springframework.context.annotation.Configuration;
import org.springframework.scheduling.annotation.EnableScheduling;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;
import org.springframework.stereotype.Controller;

import com.itwillbs.with_me.service.UserFundingService;

//@Controller // 2번 실행
//@Configuration // 2번 실행
//@Component // 2번 실행 // => 이것들이 있어야 스케줄러가 작동을 하는데 2번씩 실행됨. *-context.xml에는 추가된거 없음 ..
//@EnableScheduling

@Configuration
@ComponentScan(basePackages = "com.itwillbs.with_me.controller")
//@EnableScheduling // 필수
public class UserFundingPay {
	
	@Autowired
	private UserFundingService service;
	// ================================================================================================================
	
//	@Transactional(propagation = Propagation.REQUIRED, rollbackFor = { Exception.class, SQLException.class }, readOnly = false)
	@Scheduled(fixedDelay = 10000)
	public void sche () throws Exception {
//		 오전 10시마다 결제 진행
		System.out.println("스케줄 확인222");
		// ----------------------------------------------------------
		// DB 가서 결제일이 오늘인 후원 내역 찾기
		
		// 1) 오늘 날짜 구하기
		// 현재 날짜 구하기        
//		LocalDate now = LocalDate.now();
//		System.out.println(now);
		
		// 2) funding_user 테이블에 funding_pay_date (결제 예정일) 가 저장되어있음. 
		//	  오늘 날짜와 동일한 거 들고오기
//		List<Map<String, Object>> payList = service.getTodayPayFunding(now);
		
//		System.out.println(payList);
	}
	
}


















