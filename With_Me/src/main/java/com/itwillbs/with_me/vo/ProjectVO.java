package com.itwillbs.with_me.vo;

import java.sql.Date;
import java.sql.Timestamp;

import org.springframework.web.multipart.MultipartFile;

import lombok.Data;

@Data
public class ProjectVO {
	// 1. 멤버변수 선언
	// ---- 생성자 정의 생략(기본 생성자 활용) ------
	// 2. Getter/Setter 정의
	// 3. toString() 메서드 오버라이딩
	// ----------------------------------------------
	private int project_idx;
	private String project_code;
	private String project_status;
	private int creator_idx;
	private String project_category;
	private String project_category_detail;
	private String project_title;
	private String project_summary;
	
	// --------------------------------------------------------------------------------
	// 파일 업로드 시 실제 파일과 파일명을 별도로 분리하여 관리
	// 1) String 타입으로 지정할 변수는 실제 파일이 아닌 파일명을 다룰 용도로 사용
	//    => 멤버변수명은 form 태그에서 지정한 파일 업로드 요소의 name 속성과 다르게,
	//       DB 의 파일명 저장하는 컬럼명과 같게 지정
	private String project_image;
	// 2) MultipartFile 타입으로 지정할 변수는 업로드되는 실제 파일을 다룰 용도로 사용
	//    => 멤버변수명은 form 태그에서 지정한 파일 업로드 요소의 name 속성과 같게 지정
	private MultipartFile projectImg;
	// --------------------------------------------------------------------------------
	
	private String search_tag;
	private int target_price;
	private int funding_commission;
	private int funding_premium;
	private Date funding_start_date;
	private Date funding_end_date;
	// --------------------------------------------------------------------------------
	private String project_introduce;
	private String project_budget;
	private String project_schedule;
	private String project_team_introduce;
	private String project_sponsor;

	private MultipartFile introduceImg;
	private MultipartFile budgetImg;
	private MultipartFile scheduleImg;
	private MultipartFile inteteamInterducerduceImg;
	private MultipartFile sponsorImg;
	// --------------------------------------------------------------------------------
	
	private String project_policy;
	private Timestamp project_submit_date;
	
}
