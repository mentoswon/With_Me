package com.itwillbs.with_me.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.itwillbs.with_me.mapper.MemberMapper;
import com.itwillbs.with_me.vo.MailAuthInfo;
import com.itwillbs.with_me.vo.MemberVO;

@Service
public class MemberService {
	@Autowired
	private MemberMapper mapper;
	
	// 회원가입 요청
	public int registMember(MemberVO member) {
		return mapper.insertMember(member);
	}
	
	// 회원 상세정보 요청
	public MemberVO getMember(MemberVO member) {
		return mapper.selectMember(member);
	}
	
	// 아이디 조회
	public MemberVO getId(MemberVO member) {
		return mapper.selectId(member);
	}

	// 이메일 인증 정보 등록 요청
	public void registMailAuthInfo(MailAuthInfo mailAuthInfo) {
		// 기존 인증정보 존재 여부 확인
		// MemberMapper - selectMailAuthInfo() 메서드 호출
		MailAuthInfo dbMailAuthInfo = mapper.selectMailAuthInfo(mailAuthInfo);
		System.out.println("조회된 인증 정보 : " + dbMailAuthInfo);
		
		// 인증정보 조회 결과 판별
		if(dbMailAuthInfo == null) { // 기존 인증정보 없음
			// 새 인증정보 등록 위해 insertMailAuthInfo() 메서드 호출하여 등록 작업 요청(INSERT)
			mapper.insertMailAuthInfo(mailAuthInfo);
			
		} else { // 기존 인증정보 있음(인증메일 발송 이력 있음)
			// 기존 인증정보 갱신 위해 updateMailAuthInfo() 메서드 호출하여 수정 작업 요청(UPDATE)
			mapper.updateMailAuthInfo(mailAuthInfo);
		}
	}
	
	//
	public boolean requestEmailAuth(MailAuthInfo authInfo) {
		return false;
	}
}
