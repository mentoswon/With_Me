package com.itwillbs.with_me.vo;

import java.sql.Timestamp;

import lombok.Data;

@Data
public class PremiumPaymentVO {
	// 1. 멤버변수 선언
	// ---- 생성자 정의 생략(기본 생성자 활용) ------
	// 2. Getter/Setter 정의
	// 3. toString() 메서드 오버라이딩
	// ----------------------------------------------
	private int pre_pay_idx;
	private String pre_creator_email;
	private String pre_project_code;
	private int pre_pay_method_idx;
	private String pre_pay_status;
	private Timestamp pre_pay_date;
	private int pre_pay_amt;
	private String imp_uid;
	private String merchant_uid;
	private String apply_num;
}
