package com.itwillbs.with_me.mapper;

import org.apache.ibatis.annotations.Mapper;

import com.itwillbs.with_me.vo.MailAuthInfo;
import com.itwillbs.with_me.vo.MemberVO;

@Mapper
public interface MemberMapper {
	
	// 회원가입 등록
	int insertMember(MemberVO member);
	
	// 회원 상세정보 조회
	MemberVO selectMember(MemberVO member);
	
	// 아이디 조회
	MemberVO selectId(MemberVO member);
	
	// 이메일 인증 정보 조회 
	MailAuthInfo selectMailAuthInfo(MailAuthInfo mailAuthInfo);
	
	// 이메일 인증 정보 등록
	void insertMailAuthInfo(MailAuthInfo mailAuthInfo);
	
	// 이메일 인증 정보 수정
	void updateMailAuthInfo(MailAuthInfo mailAuthInfo);
	
	// 이메일 인증 상태 변경
	void updateMailAuthStatus(MailAuthInfo authInfo);
	
	// 이메일 인증 정보 삭제
	void deleteMailAuthInfo(MailAuthInfo authInfo);

}
