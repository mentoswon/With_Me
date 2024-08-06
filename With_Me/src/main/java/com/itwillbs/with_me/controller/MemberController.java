package com.itwillbs.with_me.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;

import com.itwillbs.with_me.service.MemberService;

@Controller
public class MemberController {
	@Autowired
	private MemberService service;
	
	// 회원가입폼 페이지
	@GetMapping("MemberJoin")
	public String join() {
		return "member/member_join_form";
	}
	
	// 로그인 페이지
	@GetMapping("MemberLogin")
	public String login() {
		return "member/member_login_form";
	}
	
	// 아이디 찾기
	@GetMapping("Id_find")
	public String id_Find() {
		return "member/member_id_find";
	}
}
