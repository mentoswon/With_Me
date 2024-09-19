package com.itwillbs.with_me.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;

import com.itwillbs.with_me.service.CommonCodeService;
import com.itwillbs.with_me.vo.CommonCodeVO;

@Controller
public class CommonCodeController {
	
	@Autowired CommonCodeService service;
	
	// 공통코드
	@GetMapping("CommonCode") 
	public String commonCode(CommonCodeVO commonCode) {
		
		
		
		return "admin/common_code_add";
	}

	// 공통코드 추가
//	@PostMapping("RegistCode")
//	public String registCode() {
//		
//		// 상품등록 작업 요청
////		int insertCount = service.registProduct(store);
//		int insertCount = service.registCode();
//		
//		// 상품 등록 작업 요청 결과 판별
//		if(insertCount > 0) { // 성공
//			
//			model.addAttribute("msg", "상품이 등록되었습니다!");
//			model.addAttribute("targetURL", "CommonCode");
//			
//			// 상품관리(AdminStore) 서블릿 주소 리다이렉트
//			return "result/success";
//		} else { // 실패
//			// "상품등록 실패!" 메세지 출력 및 이전 페이지 돌아가기 처리
//			model.addAttribute("msg", "공통코드 등록 실패!");
//			return "result/fail";
//		}
//		return "";
//	}
}























