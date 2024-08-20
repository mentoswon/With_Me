package com.itwillbs.with_me.controller;

import java.io.IOException;

import javax.servlet.http.HttpServletResponse;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.itwillbs.with_me.handler.kakaoOAuth;

@Controller
public class KakaoLoginController {
	
	private static final Logger logger = LoggerFactory.getLogger(KakaoLoginController.class);
	
	@GetMapping("KakaoLogin")
	public String kakaoLogin() {
		return "member/kakao_login_form";
	}
	
    private final kakaoOAuth kakaoOAuth;
    
    // 생성자 주입을 사용하여 kakaoOAuth 주입
    public KakaoLoginController(kakaoOAuth kakaoOAuth) {
        this.kakaoOAuth = kakaoOAuth;
    }
	
	@GetMapping("/kakao")
	public void getKakaoAuthUrl(HttpServletResponse response) throws IOException{
		response.sendRedirect(kakaoOAuth.responseUrl());
	}
}









