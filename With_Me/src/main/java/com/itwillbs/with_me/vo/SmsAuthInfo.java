package com.itwillbs.with_me.vo;

import lombok.Data;

@Data
public class SmsAuthInfo {
	// 1. 멤버변수 선언
	// ---- 생성자 정의 생략(기본 생성자 활용) ------
	// 2. Getter/Setter 정의
	// 3. toString() 메서드 오버라이딩
	// ----------------------------------------------
//	private int sms_idx;
	private String creator_email;		// 크리에이트 이메일
	private String phone_number;		// 전화번호
	private String auth_code;	// 인증코드
}
