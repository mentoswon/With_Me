package com.itwillbs.with_me.vo;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import lombok.ToString;

/*
 *  회원 이메일 인증 정보 관리할 mail_auth_info 테이블 정의
 *  ---------------------------------------------------------
 *  이메일(email) - 50글자, PK, 참조키 : member 테이블의 email 컬럼(DELETE 옵션)
 *  인증코드(auth_code) - 50글자, NN
 *  ---------------------------------------------------------
 *  CREATE TABLE mail_auth_info (
	email VARCHAR(50) PRIMARY KEY,
	auth_code VARCHAR(50) NOT NULL,
	FOREIGN KEY (email) REFERENCES member(email) ON DELETE CASCADE
    );
 */

@Getter
@Setter
@ToString
@AllArgsConstructor
@NoArgsConstructor
public class MailAuthInfo {
	private String email;
	private String auth_code;
}
