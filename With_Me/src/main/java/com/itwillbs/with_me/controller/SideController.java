package com.itwillbs.with_me.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
public class SideController {
	
	//=========================================================================
	//-------------------------------------------------------------------------
	// 헬프센터 
	
	// 헬프센터 메인 페이지 
	@GetMapping("HelpCenter")
	public String helpCenter() {
		return "help/helpcenter_main";
	}
	
	// 헬프센터 기본질문-1
	@GetMapping("Basic1")
	public String basic1() {
		return "help/basic_1";
	}
	
	// 헬프센터 기본질문-2
	@GetMapping("Basic2")
	public String basic2() {
		return "help/basic_2";
		
	}
	
	// 헬프센터 기본질문-3
	@GetMapping("Basic3")
	public String basic3() {
		return "help/basic_3";
		
	}
	
	// ===============================
	// 헬프센터 후원자질문-1
	@GetMapping("CreatorQna1")
	public String creatorQna1() {
		return "help/creator_qna_1";
		
	}
	// 헬프센터 후원자질문-2
	@GetMapping("CreatorQna2")
	public String creatorQna2() {
		return "help/creator_qna_2";
		
	}
	// 헬프센터 후원자질문-3
	@GetMapping("CreatorQna3")
	public String creatorQna3() {
		return "help/creator_qna_3";
		
	}
	// 헬프센터 프로젝트 올리기질문-1
	@GetMapping("UploadQna1")
	public String uploadQna1() {
		return "help/upload_qna_1";
		
	}
	// 헬프센터 프로젝트 올리기질문-2
	@GetMapping("UploadQna2")
	public String uploadQna2() {
		return "help/upload_qna_2";
		
	}
	// 헬프센터 프로젝트 올리기질문-3
	@GetMapping("UploadQna3")
	public String uploadQna3() {
		return "help/upload_qna_3";
		
	}
	
// =========================================================
	// 후원자 이용 가이드
	@GetMapping("UserGuide")
	public String userGuide() {
		
		return "guide/user_guide";
	}
	
	// 창작자 이용 가이드
	@GetMapping("CreatorGuide")
	public String creatorGuide() {
		
		return "guide/creator_guide";
	}	
	
	
}
