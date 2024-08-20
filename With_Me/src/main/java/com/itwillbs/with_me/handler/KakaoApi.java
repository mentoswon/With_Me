package com.itwillbs.with_me.handler;

import java.util.Map;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;

import lombok.RequiredArgsConstructor;

@Component
@RequiredArgsConstructor
public class KakaoApi {
	
	@Value("${kakao.api_key}")
	private String kakaoApiKey;
	
	@Value("${kakao.redirect_uri}")
	private String kakaoRedirectUri;

	public static String getAccessToken(String code) {
		// TODO Auto-generated method stub
		return null;
	}

	public Map<String, Object> getUserInfo(String accessToken) {
		// TODO Auto-generated method stub
		return null;
	}
}
