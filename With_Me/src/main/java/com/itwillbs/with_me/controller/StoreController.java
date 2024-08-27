package com.itwillbs.with_me.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
public class StoreController {
	
	// 스토어 메인 페이지 이동
	@GetMapping("Store")
	public String store() {
		return "store/store_main";
	}
}
