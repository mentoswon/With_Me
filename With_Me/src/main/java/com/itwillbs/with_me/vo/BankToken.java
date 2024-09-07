package com.itwillbs.with_me.vo;

import lombok.Data;

@Data
public class BankToken {
//2.1.2. 토큰발급 API - 사용자 토큰 발급 API (3-legged)요청에 대한 응답데이터 관리할 클래스 정의

	private String id;
	private String access_token;
	private String token_type;
	private String expires_in;
	private String refresh_token;
	private String scope;
	private String user_seq_no;
	private String user_ci;
	private String fintech_use_num;
	// -------------------------------
	private String client_use_code; // 관리자 토큰용
	// -----------------------------
	private String name; // 관리자 토큰용
}
