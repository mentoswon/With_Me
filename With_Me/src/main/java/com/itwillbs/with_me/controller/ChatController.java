package com.itwillbs.with_me.controller;

import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.json.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

import com.itwillbs.with_me.service.ChatService;
import com.itwillbs.with_me.vo.ChatMessage2;

@Controller
public class ChatController {
	
	@Autowired
	private ChatService service;
	
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
	
	@GetMapping("ReadMessage")
	public String changeReadState(ChatMessage2 chatMessage2) {
		Map<String, Object> resultMap = new HashMap<String, Object>();

		int updateCount = service.updateReadState(chatMessage2);
		
		
		// 리턴 데이터가 저장된 Map 객체를 JSON 객체 형식으로 변환
		// => org.json.JSONObject 클래스 활용
		JSONObject jo = new JSONObject(resultMap);
		System.out.println("응답 JSON 데이터 " + jo.toString());
		
		return jo.toString();
	}

}
