package com.itwillbs.with_me.vo;

import java.sql.Timestamp;

import org.springframework.web.multipart.MultipartFile;

import lombok.Data;

@Data
public class Store_userVO {
	// 1. 멤버변수 선언
	// ---- 생성자 정의 생략(기본 생성자 활용) ------
	// 2. Getter/Setter 정의
	// 3. toString() 메서드 오버라이딩
	// ----------------------------------------------
	private int order_idx;
	private String product_mem_email;
	private String product_idx;
	private String product_item_option;
	private String product_address_idx;
	private String product_shipping_info;
	private int product_pay_amt;
	private String order_count;
	private Timestamp order_date;
}
