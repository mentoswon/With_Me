package com.itwillbs.with_me.controller;

import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpSession;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.itwillbs.with_me.service.BankService;
import com.itwillbs.with_me.vo.BankToken;

@Controller
public class BankController {
	@Autowired
	private BankService service;
	
	// ========================================================================================
	// 로그 출력을 위한 기본 라이브러리(org.slf4j.Logger 타입) 변수 선언
	private static final Logger logger = LoggerFactory.getLogger(BankController.class);
	
	// 2.1.1. 사용자인증 API (3-legged)
	// 요청을 통해 사용자 인증 및 계좌 등록 수행 후
	// API 서버로부터 지정된 콜백(callback) 주소로 새로운 요청이 전달되고
	// 해당 요청을 컨트롤러에서 매핑하여 전달되는 파라미터(code, scope, client_info, state)를
	// Map 타입으로 전달받아 처리
	// => 콜백 주소 : http://localhost:8081/with_me/callback
	// => 주의! 해당 콜백 주소로 응답을 받기 위해서는 금융결제원 오픈API 사이트에서
	//    콜백 주소 등록 필수!
	@GetMapping("callback")
	public String auth(@RequestParam Map<String, String> authResponse, Model model, HttpSession session) {
		System.out.println("인증 결과 : " + authResponse); // 콘솔에 일반 콘솔 메세지로 출력
		
		// Logger 객체를 활용하여 콘솔에 로그 메세지로 출력(나중에 파일로 출력 가능)
		// => 단순 확인용 메세지이므로 로그 심각도를 info 레벨로 지정하기 위해 info() 메서드 호출
		logger.info(">>>>>>>>>>>>> 인증 결과 : " + authResponse);
		
		String id = (String) session.getAttribute("sId");
		
		if(id == null) {
			model.addAttribute("msg", "로그인 필수!");
			model.addAttribute("targetURL", "MemberLogin");
			model.addAttribute("isClose", true);
			
			// 로그인 페이지에서 로그인 완료 후 다시 원래의 페이지로 돌아오도록 하기 위해
			// 세션에 요청 주소를 저장한 후 로그인 완료 시 원래의 페이지를 활용하여 포워딩 처리
			// => 속성명 "prevURL" 로 현재 요청 주소(파라미터가 있을 경우 파라미터도 포함) 저장
			
			return "result/fail";
		}
		
		// --------------------------------------------------------------------------------------
		// 2.1.2. 토큰발급 API - 사용자 토큰 발급 API (3-legged)요청
		// 메서드 활용해서 엑세스토큰 발급 요청 !
		// 리턴은 응답 메세지 항목이 별로 없기때문에 일단 VO 만들어서 리턴받기 (p24의 응답데이터)
		BankToken token = service.getAccessToken(authResponse);
		logger.info(">>>>>>>>>>>>> 엑세스토큰 정보 : " + token);
		// ==> 엑세스토큰은 신분증 같은 거임 (이거 사용해서 계좌에 접근할거임)
		// ==> 뷰페이지에 노출되면 안되고 서버에서 관리해야함 !!
		
		// => 따라서 DB에 저장할 거임 !!!!
		
		// 요청 결과 판별
		if(token == null || token.getAccess_token() == null) {
			model.addAttribute("msg", "토큰 발급 실패 ! 재인증 필요 !");
			model.addAttribute("isClose", true);
			
			return "result/fail";
		}
		
		// BankService - registAccessToken() 메서드 호출하여 토큰 관련 정보 저장 요청
		// 파라미터 : 세션아이디 (사용자 구별), BankToken 객체
		// 만약, 세션 아이디와 BankToken 객체를 하나로 묶어서 전달하려면 Map<String, Object>로 하면 됨 ~!
		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("id", id);
		map.put("token", token);
		service.registAccessToken(map);
		
		// 세션에 엑세스토큰 관리 객체 (BankToken) 저장
		session.setAttribute("token", token);
		
		// success.jsp 포워딩
		model.addAttribute("msg", "계좌 인증 완료!");
		model.addAttribute("isClose", true);
//		
		return "result/success";
	}
	
	// --------------------------------------------------------------------------------
	
	// 계좌 목록 조회
	//https://testapi.openbanking.or.kr/v2.0/account/list
	@ResponseBody
	@GetMapping("BankAccountList")
	public Map<String, Object> bankAccountList(HttpSession session, Model model) {
		
		// 엑세스토큰 관련 정보가 저장된 BankToken(token) 객체를 세션에서 꺼내기
		BankToken token = (BankToken) session.getAttribute("token"); // -> 다운캐스팅임
		
		// -----------------------------------------------------------------------------
		// BankService - getBankAccountList() 메서드 호출하여 핀테크 계좌 목록 조회
		Map<String, Object> bankAccountList = service.getBankAccountList(token);
		logger.info(">>>> bankAccountList : " + bankAccountList);
		
		// Model 객체에 Map 객체 저장해서 뷰페이지로 가져가기
//		model.addAttribute("bankAccountList", bankAccountList); 
		
		return bankAccountList;
	}
	
}











