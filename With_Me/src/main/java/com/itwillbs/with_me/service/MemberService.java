package com.itwillbs.with_me.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.itwillbs.with_me.mapper.MemberMapper;
import com.itwillbs.with_me.vo.CreatorVO;
import com.itwillbs.with_me.vo.MailAuthInfo;
import com.itwillbs.with_me.vo.MemberVO;
import com.itwillbs.with_me.vo.ProjectVO;

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
	
	// 이메일 인증 처리 요청
	public boolean requestEmailAuth(MailAuthInfo authInfo) {
		boolean isAuthSuccess = false;
		
		// MemberMapper - selectMailAuthInfo() 메서드 호출하여 인증정보 조회 수행
		// => 파라미터 : MailAuthInfo 객체   리턴타입 : MailAuthInfo
		MailAuthInfo dbMailAuthInfo = mapper.selectMailAuthInfo(authInfo);
		
		// 인증정보 조회 결과 판별
		if(dbMailAuthInfo != null) { // 인증코드가 존재할 경우
			// 하이퍼링크를 통해 전달받은 인증코드와 조회된 인증코드 문자열 비교
			if(authInfo.getAuth_code().equals(dbMailAuthInfo.getAuth_code())) { // 인증코드 일치
				// 1) MemberMapper - updateMailAuthStatus() 메서드 호출하여
				//    member 테이블의 이메일 인증 상태(mail_auth_status)값을 "Y"로 변경
				//    => 파라미터 : MailAuthInfo 객체
				mapper.updateMailAuthStatus(authInfo);
				
				// 2) MemberMapper - deleteMailAuthInfo() 메서드 호출하여
				//    mail_auth_info  테이블의 인증정보 삭제
//			    => 파라미터 : MailAuthInfo 객체
				mapper.deleteMailAuthInfo(authInfo);
				// 인증 수행 결과 저장 변수값을 true로 변경
				isAuthSuccess = true;
			}
		}
		
		// MemberMapper - updateEmailAuth() 메서드 호출하여 이메일 인증 처리
		return isAuthSuccess;
	}

	// 회원정보 조회
	public List<MemberVO> getMember() {
		return mapper.selectMember();
	}

	// 이메일로 창작자이름 조회
	public CreatorVO getCreatorName(MemberVO member) {
		return mapper.selectCreator(member);
	}

//	// 프로젝트 정보 조회
//	public ProjectVO getProject(MemberVO member) {
//		return mapper.selectProject(member);
//	}

//	// 프로젝트 정보 조회
//	public List<ProjectVO> getProjectList(MemberVO member) {
//		return mapper.selectProjectList(member);
//	}

	// 프로젝트 리스트 목록 개수 가져오기
	public int getProjectListCount() {
		return mapper.selectProjectListCount();
	}

	// 프로젝트 리스트 가져오기
	public List<Map<String, Object>> getProjectList(int startRow, int listLimit) {
		return mapper.selectProjectList(startRow, listLimit);
	}
	
}

















