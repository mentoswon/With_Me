package com.itwillbs.with_me.handler;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;

import lombok.RequiredArgsConstructor;

@Component
@RequiredArgsConstructor
public class kakaoOAuth {
	
	@Value("${app.kakao.restApiKey}")
	private String restApiKey;
	
	@Value("${app.kakao.redirectUrl}")
	private String kakaoRedirectUrl;
	
	private final String KAKAO_TOKEN_REQUEST_URL = "https://kauth.kakao.com/oauth/token";
	
	public String responseUrl() {
		String kakaoLoginUrl = "https://kauth.kakao.com/oauth/authorize?client_id=" 
								+ restApiKey + "&redirect_url=" + kakaoRedirectUrl + "&response_type=code";
		return kakaoLoginUrl;
	}
}
