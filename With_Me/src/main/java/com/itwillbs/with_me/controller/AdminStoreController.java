package com.itwillbs.with_me.controller;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;

import com.itwillbs.with_me.vo.StoreVO;

@Controller
public class AdminStoreController {
	
	// 스토어 뷰폼
	@GetMapping("AdminStore")
	public String adminStore() {
		return "admin/admin_store_list";
	}
	
	// 상품 등록
	@GetMapping("ProductRegist")
	public String productRegist(HttpSession session, Model model) {
		
		// 관리자 권한이 없는 경우 접근 차단
		if(session.getAttribute("sIsAdmin").equals("N")) {
			model.addAttribute("msg", "관리자 권한이 없습니다.");
			model.addAttribute("targetURL", "./");
			return "result/fail";
		}
		return "admin/admin_product_regist";
	}
	
//	// 상품 등록 로직
//	@PostMapping("ProductRegist")
//	public String productRegistPro(StoreVO store, HttpServletRequest request, HttpSession session, Model model) {
//		
//		// 파일 업로드 처리
//		String realPath = session.getServletContext().getRealPath(uploadPath); // 가상의 경로 전달
//		
//		return "";
//	}
	
}























