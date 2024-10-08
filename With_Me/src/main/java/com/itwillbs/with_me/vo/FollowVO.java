package com.itwillbs.with_me.vo;

import lombok.Data;

@Data
public class FollowVO {
	// 1. 멤버변수 선언
	// ---- 생성자 정의 생략(기본 생성자 활용) ------
	// 2. Getter/Setter 정의
	// 3. toString() 메서드 오버라이딩
	// ----------------------------------------------
	private int follow_idx;
	private String follow_mem_email;
	private String follow_creator;
	private String follow_status; // Y: 팔로우상태  N: 언팔로우 상태
}
