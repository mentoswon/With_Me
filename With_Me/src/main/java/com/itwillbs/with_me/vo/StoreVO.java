package com.itwillbs.with_me.vo;

import java.sql.Date;
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
	private String product_name;
	private String product_description;
	private String product_category;
	private String project_category_detail;
	private int product_price;
	private int product_stock;
	private int product_status;
	private String product_img;
	// MultipartFile 타입으로 지정할 변수는 업로드되는 실제 파일을 다룰 용도로 사용
	private MultipartFile[] product_img_file;
	private MultipartFile product_img_file1;
	
	private Date product_created;            // 상품등록일
}
