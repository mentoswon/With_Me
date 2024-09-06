package com.itwillbs.with_me.controller;

import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.itwillbs.with_me.handler.KakaoApi;

import lombok.RequiredArgsConstructor;

@RequiredArgsConstructor
@Controller
public class KakaoLoginController {
	
	private static final Logger logger = LoggerFactory.getLogger(KakaoLoginController.class);
	private final KakaoApi kakaoApi;
	
	@GetMapping("KakaoLogin")
	public String kakaoLogin() {
		return "member/kakao_login_form";
	}
	
//    @GetMapping("/login")
//    public String loginForm(Model model){
//        model.addAttribute("kakaoApiKey", kakaoApi.getKakaoApiKey());
//        model.addAttribute("redirectUri", kakaoApi.getKakaoRedirectUri());
//        return "login";
//    }
//	
//	@RequestMapping("/login/oauth2/code/kakao")
//	public String kakaoLogin(@RequestParam String code) {
//		// @RequestParam String code = 인가 코드 받기
//		
//		// 토큰 받기
//		String accessToken = kakaoApi.getAccessToken(code);
//		
//		// 사용자 정보 받기
//		Map<String, Object> userInfo = kakaoApi.getUserInfo(accessToken);
//		
//		String email = (String)userInfo.get("email");
//		String nickname = (String)userInfo.get("nickname");
//		
//		System.out.println("email : " + email);
//		System.out.println("nickname : " + nickname);
//		System.out.println("accessToken : " + accessToken);
//		
//		return "redirect:/login";
//	}
}









