package com.itwillbs.with_me.vo;

import java.sql.Date;
import java.sql.Timestamp;

import lombok.Data;

@Data
public class StoreVO {
	// 1. 멤버변수 선언
	// ---- 생성자 정의 생략(기본 생성자 활용) ------
	// 2. Getter/Setter 정의
	// 3. toString() 메서드 오버라이딩
	// ----------------------------------------------
	private int product_idx;
	private String product_code;
	private String product_name;
	private String product_description;
	private String product_category;
	private int product_price;
	private int product_stock;
	private int product_status;
	private String product_img;
	private Date product_created;            // 상품등록일
	private int product_address_idx;
	private String product_shipping_info;    // 배송 정보
	private int product_rating;              // 상품평점
	private int product_review_count;        // 리뷰수
	private int product_like_count;          // 좋아요 수
}
