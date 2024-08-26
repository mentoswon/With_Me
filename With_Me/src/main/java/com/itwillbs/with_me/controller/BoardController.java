package com.itwillbs.with_me.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
public class BoardController {
	// 공지사항 게시글 목록 페이지
	@GetMapping("BoardList")
	public String boardList() {
		return "board/board_list";
	}
	
	// 공지사항 게시글 상세 페이지 
	@GetMapping("BoardDetail")
	public String boardDetail() {
		return "board/board_detail";
	}
	
	
	
	
	
	
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
	
	// 헬프센터 기본질문-4
	@GetMapping("Basic4")
	public String basic4() {
		return "help/basic_4";
		
	}
}
