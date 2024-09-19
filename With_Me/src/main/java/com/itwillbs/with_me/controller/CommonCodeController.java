package com.itwillbs.with_me.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
public class CommonCodeController {
	
	// 공통코드 추가
	@GetMapping("CommonCode") 
	public String commonCode() {
		return "admin/common_code_add";
	}

}























