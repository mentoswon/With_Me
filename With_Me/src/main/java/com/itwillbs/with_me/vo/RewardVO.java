package com.itwillbs.with_me.vo;

import lombok.Data;

@Data
public class RewardVO {
	// 1. 멤버변수 선언
	// ---- 생성자 정의 생략(기본 생성자 활용) ------
	// 2. Getter/Setter 정의
	// 3. toString() 메서드 오버라이딩
	// ----------------------------------------------
	private int reward_idx;
	private int project_idx;
//	private String sponsor_item_name; 0821 컬럼 삭제로 멤버변수도 삭제
	private String reward_title;
	private String reward_item_idx;
	private String amount_limit;
	private int item_amount;
	private String delivery_status;
	private int reward_price;
}
