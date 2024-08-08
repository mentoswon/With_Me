package com.itwillbs.with_me.vo;

import java.sql.Date;
import java.sql.Timestamp;

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
	private String project_image;
	private String search_tag;
	private int target_price;
	private Date funding_start_date;
	private Date funding_end_date;
	private String project_interduce;
	private String project_budget;
	private String project_schedule;
	private String project_team_interduce;
	private String project_sponsor;
	private String project_policy;
	private Timestamp project_submit_date;
	private String mail_auth_status;
}
