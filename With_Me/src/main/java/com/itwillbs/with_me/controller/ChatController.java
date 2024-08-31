package com.itwillbs.with_me.controller;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
public class ChatController {
	
	@GetMapping("MyChat")
	public String mychat() {
		return "chat/index";
	}
	
	
	@GetMapping("Chating")
	public String chating(HttpSession session, Model model, HttpServletRequest request) {
		String id = (String)session.getAttribute("sId");
		
		if(id == null) {
			model.addAttribute("msg", "로그인 필수!");
			model.addAttribute("targetURL", "MemberLogin");
			
			// request 객체의 getQueryString() 메서드 호출 시 요청 파라미터도 접근 가능하므로
			// 파라미터를 요청 주소 뒤에 붙여서 전달도 가능하다!
//			System.out.println(request.getQueryString());
			session.setAttribute("prevURL", request.getServletPath() + "?" + request.getQueryString());
			
			return "result/fail";
		}
		
		return "chat/chat_main2";
	}
	

}
