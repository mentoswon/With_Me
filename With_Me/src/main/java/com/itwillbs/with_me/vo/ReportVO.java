package com.itwillbs.with_me.vo;

import org.springframework.web.multipart.MultipartFile;

import lombok.Data;

@Data
public class ReportVO {
	// 1. 멤버변수 선언
	// ---- 생성자 정의 생략(기본 생성자 활용) ------
	// 2. Getter/Setter 정의
	// 3. toString() 메서드 오버라이딩
	// ----------------------------------------------
	private int report_idx;
	private String report_mem_email;
	private String report_project_code;
	private String report_product_code;
	private String report_category;
	private String report_reason;
	private String report_file;
	private MultipartFile file;
	private String report_ref_url1;
	private String report_ref_url2;
	private String report_ref_url3;
	private String report_date;
	private String report_state;
}




















