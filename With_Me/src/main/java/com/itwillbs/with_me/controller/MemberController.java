package com.itwillbs.with_me.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;

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
	
	// 회원가입 완료 페이지
	
	
	
	// 로그인 페이지
	@GetMapping("MemberLogin")
	public String login() {
		return "member/member_login_form";
	}
	
	// 아이디 찾기
	@GetMapping("IdFind")
	public String id_Find() {
		return "member/member_id_find";
	}
	
	// 비밀번호 찾기
	@GetMapping("PasswdFind")
	public String passwd_Find() {
		return "member/member_pw_find";
	}
	
	// 비밀번호 찾기
	@PostMapping("PwFindPro")
	public String pwFindPro() {
		return "member/member_pw_find_pro";
	}
	
	// 비밀번호 재설정
	@PostMapping("PwReset")
	public String pwReset() {
		return "member/member_pw_reset";
	}
}
