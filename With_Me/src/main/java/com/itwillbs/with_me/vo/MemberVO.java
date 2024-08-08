package com.itwillbs.with_me.vo;

import java.sql.Date;

import lombok.Data;

/*
-------------------------------------------------------------
--------------------------------------------------------------


*/
@Data
public class MemberVO {
	// 1. 멤버변수 선언
	// ---- 생성자 정의 생략(기본 생성자 활용) ----
	// 2. Getter/Setter 정의
	// 3. toString() 메서드 오버라이딩
	// ----------------------------------------------
	private int mem_idx;
	private String mem_email;
	private String mem_name;
	private String mem_passwd;
	private String mem_post_code;
	private String mem_add1;
	private String mem_add2;
	private String mem_tel;
	private int mem_accept_sms;
	private String mem_birthday;
	private Date mem_sign_date;
	private Date mem_withdraw_date;
	private int mem_status;
	private String mem_mail_auth_status;
	private int mem_isAdmin;
	
}



