package com.itwillbs.with_me.vo;

import lombok.Data;

@Data
public class AddressVO {
	// 1. 멤버변수 선언
	// ---- 생성자 정의 생략(기본 생성자 활용) ------
	// 2. Getter/Setter 정의
	// 3. toString() 메서드 오버라이딩
	// ----------------------------------------------
	private int address_idx;
	private String address_mem_email;
	private String address_receiver_name;
	private String address_post_code;
	private String address_main;
	private String address_sub;
	private String address_receiver_tel;
}




















