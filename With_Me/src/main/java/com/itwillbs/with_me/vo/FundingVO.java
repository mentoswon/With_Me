package com.itwillbs.with_me.vo;

import java.sql.Timestamp;

import lombok.Data;

@Data
public class FundingVO {
	// 1. 멤버변수 선언
	// ---- 생성자 정의 생략(기본 생성자 활용) ------
	// 2. Getter/Setter 정의
	// 3. toString() 메서드 오버라이딩
	// ----------------------------------------------
	private int funding_idx;
	private String funding_mem_email;
	private int funding_project_idx;
	private int funding_reward_idx;
	private String funding_item_option;
	private int funding_count;
	private int funding_address_idx;
	private int funding_plus;
	private Timestamp funding_date;
	private int funding_pay_amt;
	
	
}
