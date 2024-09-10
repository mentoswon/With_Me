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

import com.itwillbs.with_me.service.CreatorFundingService;
import com.itwillbs.with_me.vo.BankToken;

@Component 
@EnableScheduling // 필수
public class CreatorFundingPay {

    @Autowired
    private CreatorFundingService service;

    private static final Logger logger = LoggerFactory.getLogger(BankController.class);

    // 입금이체 스케줄러 (매일 지정 시간에 진행)
    // cron = "초 분 시 일 월 요일"
    @Scheduled(cron = "0 0 10 * * ?") // 매일 오전 10시 정각에 실행
    public void scheduledDeposit() throws Exception {
    	// 1) 현재 날짜 구하기
        LocalDate now = LocalDate.now();
        System.out.println("오늘 날짜: " + now);

        // 2) DB 에서 '정산일'이 오늘이면서(project_info 테이블에서 펀딩종료일 + 16일이 오늘)
        //								  => 펀딩종료 다음날부터 7일동안 후원자 결제시도(+8일)
        //									 후원자 결제종료 다음날부터 7일째 되는 날 모금액 입금(+8일)
        // funding_user 테이블의 funding_status가 '후원완료'인 결제금액의 총합 찾아오기 => 결제성공된 금액의 합
        // => 프로젝트 번호, 코드, 제목 등의 프로젝트정보
        // 	   + 총 모금액(total_amt) + 정산액(funding_pay_amt) + 창작자 핀테크 번호(fintech_use_num)
        // 								=> 총 모금액에서 수수료(8% + VAT) 제외한 금액으로 정산됨
        //								=> 결제대행 수수료(3% + VAT) + 위드미 수수료(5% + VAT)
        List<Map<String, Object>> depositList = service.getTodayDepositFunding(now);

        // 입금 요청 2.5.2 입금이체 API
        // 해당 펀딩의 project_idx 에 맞는 창작자에게 입금 처리
        String id = "";
        Integer project_idx;
        for (Map<String, Object> funding : depositList) {
            id = (String) funding.get("email");
            project_idx = (Integer) funding.get("project_idx");

            // 액세스 토큰 관련 정보가 저장된 BankToken 객체(token)를 가져오기
            BankToken token = service.getBankUserInfo(id);
            System.out.println("token : " + token);
            
            Map<String, Object> map = new HashMap<>();
            map.put("token", token);
            map.put("id", id);

            // 입금 이체를 위한 추가 파라미터 설정 (입금처 정보 및 금액)
            map.put("deposit_client_name", funding.get("name")); // 입금자 이름
            map.put("tran_amt", funding.get("funding_pay_amt"));  // 입금 금액
            map.put("fintech_use_num", funding.get("fintech_use_num")); // 입금 계좌 번호

            logger.info(">>>>>> 입금이체 요청 파라미터 : " + map);

            // BankService - requestDeposit() 메서드 호출하여 출금이체 요청
    		// => 파라미터 : Map 객체    리턴타입 : Map<String, String>(withdrawResult)
    		Map<String, Object> depositResult = service.requestDeposit(map);
//    		Map depositResult = bankService.requestDeposit(map);
    		logger.info(">>>>>> 입금이체 요청 결과 : " + depositResult);
    		
            // creator_account 테이블에 status 입금완료로 업데이트
            service.updateFundingStatus(project_idx);
        }
    }
}