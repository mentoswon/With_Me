package com.itwillbs.with_me.vo;

import java.sql.Timestamp;

import org.springframework.web.multipart.MultipartFile;

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
	private String product_code1; // SHOP/FUND
	private String product_code2; // FO/FA ~~
	private String product_code3; // FEE/GUM ~~
	private String product_code4; // 01, 02 ~~
	private String product_name;
	private String product_description;
	private String product_category;
	private String product_category_detail;
	private String product_item_option;
	private int product_price;
	private int product_stock;
	private int product_status;
	private String product_img;
	private String product_img2;
	// MultipartFile 타입으로 지정할 변수는 업로드되는 실제 파일을 다룰 용도로 사용
	private MultipartFile[] product_img_file;
	private MultipartFile product_img_file1;
	private MultipartFile product_img_file2;
	private String splited_product_option;
	private Timestamp product_created;            // 상품등록일
}
