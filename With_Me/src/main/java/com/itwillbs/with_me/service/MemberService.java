package com.itwillbs.with_me.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.itwillbs.with_me.mapper.MemberMapper;
import com.itwillbs.with_me.vo.CreatorVO;
import com.itwillbs.with_me.vo.FollowVO;
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

	// 이메일로 창작자정보 조회
	public List<CreatorVO> getCreatorInfo(MemberVO member) {
		return mapper.selectCreator(member);
	}

	// 프로젝트 리스트 목록 개수 가져오기
	public int getProjectListCount() {
		return mapper.selectProjectListCount();
	}

	// 프로젝트 리스트 가져오기
	public List<Map<String, Object>> getProjectList(int startRow, int listLimit) {
		return mapper.selectProjectList(startRow, listLimit);
	}

//	// 팔로워 값 가져오기
//	public List<FollowVO> getFollower(MemberVO member) {
//		return mapper.selectFollower(member);
//	}

	// 팔로우 리스트 개수 가져오기
	public int getFollowListCount() {
		return mapper.selectFollowListCount();
	}
	
	// 좋아요 리스트 개수 가져오기
	public int getLikeListCount() {
		return mapper.selectLikeListCount();
	}

	// 내 마이페이지에서 팔로우 리스트 가져오기
	public List<Map<String, Object>> getFollowtList(int startRow, int listLimit, String mem_email) {
		return mapper.selectFollowList(startRow, listLimit, mem_email);
	}
	
	// 크리에이터 이메일 들고와서 mem_email 들고오기
	public String getMemEmail(String creatorEmail) {
		return mapper.selectMemEmail(creatorEmail);
	}
	
	// 창작자가 아닌 상대방 마이페이지에서 팔로우 리스트 가져오기
	public List<Map<String, Object>> getOtherNoCreatorFollowtList(int startRow, int listLimit, String mem_email) {
		return mapper.selectOtherNoCreatorFollowList(startRow, listLimit, mem_email);
	}
	
	// 창작자인 상대방 마이페이지에서 팔로우 리스트 가져오기 
	public List<Map<String, Object>> getOtherCreatorFollowtList(int startRow, int listLimit, String getCreator_email) {
		return mapper.selectOtherCreatorFollowList(startRow, listLimit, getCreator_email);
	}
	
	

	// 팔로우 리스트에서 내가 팔로우한 사람이 팔로우한 수
//	public List<FollowVO> getFollowerCount(List<FollowVO> followerCount) {
//		return mapper.selectFollowerCount(followerCount);
//	}

	// 프로필 사진 삭제
	public int removeProfileDelete(Map<String, String> map) {
		return mapper.deleteProfileDelete(map);
	}

	// 마이페이지(기본정보 수정)
	public int modifyMember(Map<String, String> map) {
		return mapper.updateMember(map);
	}
	
	// 팔로우나 프로젝트 리스트에서 들어가는 마이페이지 들어가기 위해 창작자 이름 가져오기
	public String getCreatorName(String creatorEmail) {
		return mapper.selectCreatorName(creatorEmail);
	}

	// 상대방 마이페이지(창작자가 아닌 경우)
	public MemberVO getMemberInfo(String creatorEmail) {
		return mapper.selectMemberInfo(creatorEmail);
	}
	
	// 상대방 마이페이지(창작자인 경우)
	public List<CreatorVO> getOtherCreatorInfo(String creatorEmail) {
		return mapper.selectOtherCreatorInfo(creatorEmail);
	}
	
	
	
	// ========================================
	// 회원 아이디 조회(채팅용)
	public String getMemberId(String receiver_id) {
		return mapper.selectMemberId(receiver_id);
	}
	// ================================================
	// 회원 가입 시 배송지 등록
	public void registTransAddress(String address_mem_email, String address_receiver_name, String address_post_code,
			String address_main, String address_sub, String address_receiver_tel) {
		mapper.insertTransAddress(address_mem_email, address_receiver_name, address_post_code,address_main, address_sub,address_receiver_tel);
	}





}

















