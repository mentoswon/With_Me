package com.itwillbs.with_me.vo;

import lombok.Data;

@Data
public class KakaoTokenVO {
	// 1. 멤버변수 선언
	// ---- 생성자 정의 생략(기본 생성자 활용) ------
	// 2. Getter/Setter 정의
	// 3. toString() 메서드 오버라이딩
	// ----------------------------------------------
	private String token_type;
	private String access_token;
	private String id_token;
	private String expires_in;
	private String refresh_token;
	private String refresh_token_expires_in;
	private String scope;
}
