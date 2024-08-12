package com.itwillbs.with_me.vo;

import java.sql.Timestamp;

import lombok.Data;

@Data
public class CommonCodeVO {

	// 1. 멤버변수 선언
	// ---- 생성자 정의 생략(기본 생성자 활용) ----
	// 2. Getter/Setter 정의
	// 3. toString() 메서드 오버라이딩
	// ----------------------------------------------
	private int common_code_idx;
	private String common_code;
	private String common_code_name;
	private String common_code_top;
	private String common_code_explain;
	private Timestamp common_code_reg_date;
}
