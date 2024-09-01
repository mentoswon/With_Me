package com.itwillbs.with_me.vo;

import lombok.Data;

@Data
public class LikeVO {
	// 1. 멤버변수 선언
	// ---- 생성자 정의 생략(기본 생성자 활용) ------
	// 2. Getter/Setter 정의
	// 3. toString() 메서드 오버라이딩
	// ----------------------------------------------
	private int like_idx;
	private String like_mem_email;
	private String like_project_code;
	private String like_product_code;
	private String like_status; // Y: 좋아요 상태  N: 안 좋아요 상태
}
