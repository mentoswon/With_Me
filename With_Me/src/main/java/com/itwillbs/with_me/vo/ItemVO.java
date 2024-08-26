package com.itwillbs.with_me.vo;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class ItemVO {
	// 1. 멤버변수 선언
	// ---- 생성자 정의 생략(기본 생성자 활용) ------
	// 2. Getter/Setter 정의
	// 3. toString() 메서드 오버라이딩
	// ----------------------------------------------
	private int item_idx;
	private int project_idx;
//	private String sponsor_item_name; 0821 컬럼 삭제로 멤버변수도 삭제
	private String item_name;
	private String item_condition;
	private String multiple_option;
}
