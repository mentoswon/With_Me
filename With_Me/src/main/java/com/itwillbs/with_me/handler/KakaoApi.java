package com.itwillbs.with_me.handler;

import java.util.HashMap;
import java.util.Map;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;

import lombok.Data;
import lombok.RequiredArgsConstructor;

@Data
@Component
@RequiredArgsConstructor
public class KakaoApi {
	
	@Value("${kakao.api_key}")
	private String kakaoApiKey;
	
	@Value("${kakao.redirect_uri}")
	private String kakaoRedirectUri;
	

	//인가 코드를 받아서 accessToken을 반환
	public static String getAccessToken(String code) {
		// TODO Auto-generated method stub
		return null;
	}

	//accessToken을 받아서 UserInfo 반환
	public HashMap<String, Object> getUserInfo(String accessToken) {
		// TODO Auto-generated method stub
		return null;
	}

	//accessToken을 받아서 로그아웃 시키는 메서드
	public void kakaoLogout(String accessToken) {}
	
}
