package com.itwillbs.with_me.service;

import java.net.URI;
import java.util.Map;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.core.ParameterizedTypeReference;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpMethod;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;
import org.springframework.util.LinkedMultiValueMap;
import org.springframework.web.client.RestTemplate;
import org.springframework.web.util.UriComponentsBuilder;

@Service
public class KakaoService {
	@Value("${kakao_client_id}")
	private String client_id;
	
	@Value("${kakao_client_secret}")
	private String client_secret;
	
	@Value("${kakao_redirect_uri}")
	private String redirect_uri;
	
	private static final String REQUEST_TOKEN_URL = "https://kauth.kakao.com/oauth/token"; 
	private static final String REQUEST_USER_INFO_URL = "https://kapi.kakao.com/v2/user/me"; 
	
	public Map<String, String> requestKakaoAccessToken(String code) {
		URI uri = UriComponentsBuilder
				.fromUriString(REQUEST_TOKEN_URL) // 요청 주소 설정
				.encode() // 주소 인코딩
				.build() // UriComponents 타입 객체 생성
				.toUri(); // URI 타입 객체로 변환
	
		HttpHeaders headers = new HttpHeaders(); // 추가할 헤더정보가 1개이므로 기본 생성자 활용
		headers.add(HttpHeaders.CONTENT_TYPE, "application/x-www-form-urlencoded;charset=utf-8");
		
		LinkedMultiValueMap<String, String> parameters = new LinkedMultiValueMap<String, String>();
		parameters.add("code", code);
		parameters.add("client_id", client_id);
		parameters.add("client_secret", client_secret);
		parameters.add("redirect_uri", redirect_uri);
		parameters.add("grant_type", "authorization_code");
		
//		HttpEntity<LinkedMultiValueMap<String, String>> httpEntity =
//				new HttpEntity<LinkedMultiValueMap<String, String>>(parameters);		
		HttpEntity<LinkedMultiValueMap<String, String>> httpEntity =
				new HttpEntity<LinkedMultiValueMap<String, String>>(parameters, headers);		
		System.out.println("HttpEntity : " + httpEntity.toString());
		
		RestTemplate restTemplate = new RestTemplate();
		
		ParameterizedTypeReference<Map<String, String>> responseType = 
				new ParameterizedTypeReference<Map<String,String>>() {};
				
		ResponseEntity<Map<String, String>> responseEntity = 
				restTemplate.exchange(uri, HttpMethod.POST, httpEntity, responseType);
		
		// 임시) 응답 정보 확인을 위해 ResponseEntity 객체의 메서드 활용
		System.out.println("응답 코드 : " + responseEntity.getStatusCode());
		System.out.println("응답 헤더 : " + responseEntity.getHeaders());
		System.out.println("응답 본문 : " + responseEntity.getBody());
		
		// 5. 응답 정보 리턴
		// => ResponseEntity 객체를 직접 리턴하지 않고 getBody() 메서드 호출 결과인
		//    파싱 정보를 관리하는 객체를 리턴
		return responseEntity.getBody();
	}

	
	public Map<String, Object> requestKakaoUserInfo(Map<String, String> token) {
		URI uri = UriComponentsBuilder
				.fromUriString(REQUEST_USER_INFO_URL) // 요청 주소 설정
				.encode() // 주소 인코딩
				.build() // UriComponents 타입 객체 생성
				.toUri(); // URI 타입 객체로 변환
		
		HttpHeaders headers = new HttpHeaders(); // 추가할 헤더정보가 1개이므로 기본 생성자 활용
//		headers.add(HttpHeaders.CONTENT_TYPE, "application/x-www-form-urlencoded;charset=utf-8");
//		System.out.println("access_token : " + token.get("access_token"));
		headers.setBearerAuth(token.get("access_token"));
		
		HttpEntity<String> httpEntity = new HttpEntity<String>(headers);		
		System.out.println("HttpEntity : " + httpEntity.toString());
		
		RestTemplate restTemplate = new RestTemplate();
		
		ParameterizedTypeReference<Map<String, Object>> responseType = 
				new ParameterizedTypeReference<Map<String, Object>>() {};
				
		ResponseEntity<Map<String, Object>> responseEntity = 
				restTemplate.exchange(uri, HttpMethod.GET, httpEntity, responseType);
		
		// 임시) 응답 정보 확인을 위해 ResponseEntity 객체의 메서드 활용
		System.out.println("응답 코드 : " + responseEntity.getStatusCode());
		System.out.println("응답 헤더 : " + responseEntity.getHeaders());
		System.out.println("응답 본문 : " + responseEntity.getBody());
		
		// 5. 응답 정보 리턴
		// => ResponseEntity 객체를 직접 리턴하지 않고 getBody() 메서드 호출 결과인
		//    파싱 정보를 관리하는 객체를 리턴
		return responseEntity.getBody();
	}
	
}
