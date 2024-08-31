package com.itwillbs.with_me.mapper;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import org.springframework.web.bind.annotation.RequestParam;

import com.itwillbs.with_me.vo.CreatorVO;
import com.itwillbs.with_me.vo.FollowVO;
import com.itwillbs.with_me.vo.MailAuthInfo;
import com.itwillbs.with_me.vo.MemberVO;
import com.itwillbs.with_me.vo.ProjectVO;

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
	
	// 회원 상세정보 조회
	List<MemberVO> selectMember();

	// 이메일로 창작자 조회
	CreatorVO selectCreator(MemberVO member);

	// 프로젝트 리스트 개수 조회
	int selectProjectListCount();

	// 프로젝트 리스트
	List<Map<String, Object>> selectProjectList(@Param("startRow") int startRow, @Param("listLimit") int listLimit);

//	// 팔로워 값 가져오기
//	List<FollowVO> selectFollower(MemberVO member);

	// 팔로우 리스트 개수 조회
	int selectFollowListCount();

	// 팔로우 리스트 조회
	List<Map<String, Object>> selectFollowList(@Param("startRow") int startRow, @Param("listLimit") int listLimit);

	// 팔로우 리스트에서 내가 팔로우한 사람이 팔로우한 수
	List<FollowVO> selectFollowerCount(List<FollowVO> followerCount);

	// 팔로우값 가져오기
	FollowVO selectFollow();

	// 프로필 사진 삭제
	int deleteProfileDelete(Map<String, String> map);

	// 회원 아이디 조회(채팅용)
	String selectMemberId(String receiver_id);

}
