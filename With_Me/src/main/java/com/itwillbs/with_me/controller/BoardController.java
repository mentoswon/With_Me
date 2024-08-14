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
		return "board/board_view";
	}
}
