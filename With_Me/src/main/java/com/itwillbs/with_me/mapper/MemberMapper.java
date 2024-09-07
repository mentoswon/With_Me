package com.itwillbs.with_me.mapper;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import org.springframework.web.bind.annotation.RequestParam;

import com.itwillbs.with_me.vo.CreatorVO;
import com.itwillbs.with_me.vo.FollowVO;
import com.itwillbs.with_me.vo.FundingVO;
import com.itwillbs.with_me.vo.LikeVO;
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
	
	// 회원 아이디로 비밀번호 찾기
	MemberVO selectFindPasswdFromEmail(MemberVO member);
	
	// 아이디 + 전화번호로 비밀번호 리셋폼으로 넘어가기
	MemberVO selectFindPasswdFromTel(MemberVO member);
	
	// 회원 비밀번호 변경
	int updatePasswd(Map<String, String> map);
	
	// 회원 상세정보 조회
	List<MemberVO> selectMember();

	// 이메일로 창작자 조회
	CreatorVO selectCreator(MemberVO member);

	// 프로젝트 리스트 개수 조회
	int selectProjectListCount();

	// 팔로우 리스트 개수 조회
	int selectFollowListCount(String mem_email);
	
	// 좋아요 리스트 개수 조회
	int selectLikeListCount();
	
	// 내 마이페이지 프로젝트 리스트
	List<Map<String, Object>> selectProjectList(
								@Param("startRow") int startRow,
								@Param("listLimit") int listLimit,
								@Param("mem_email") String mem_email);
	
	// 상대방 마이페이지 프로젝트 리스트
	List<Map<String, Object>> selectOtherProjectList(
								@Param("startRow") int startRow,
								@Param("listLimit") int listLimit,
								@Param("creatorEmail") String creatorEmail);
	
	// 내 마이페이지에서 후원한 프로젝트 가져오기
	List<Map<String, Object>> selectDonationProjectList(
								@Param("startRow") int startRow,
								@Param("listLimit") int listLimit,
								@Param("mem_email") String mem_email);

	// 후원한 프로젝트 세부정보
	Map<String, Object> selectDonationProjectDetail(int funding_idx);
	
	// 후원 상태 변경(취소)
	int updateDonationProject(FundingVO funding);
	
	// 내 마이페이지에서 팔로우 리스트 조회
	List<Map<String, Object>> selectFollowList(
								@Param("startRow") int startRow,
								@Param("listLimit") int listLimit,
								@Param("mem_email") String mem_email);
	
	// 내 마이페이지에서 팔로잉 리스트 조회
	List<Map<String, Object>> selectFollowingList(
								@Param("startRow") int startRow,
								@Param("listLimit") int listLimit,
								@Param("mem_email") String mem_email);
	
	// 내 마이페이지에서 좋아요 프로젝트 리스트 조회
	List<Map<String, Object>> selectLikeProjectList(
								@Param("startRow") int startRow,
								@Param("listLimit") int listLimit,
								@Param("mem_email") String mem_email);
	// 내 마이페이지에서 좋아요 상품 리스트 조회
	List<Map<String, Object>> selectLikeProductList(
								@Param("startRow") int startRow,
								@Param("listLimit") int listLimit,
								@Param("mem_email") String mem_email);
	
	// 프로젝트 상세정보 가져오기(프로젝트 하나만 들오고기)
	Map<String, Object> selectProject(String mem_email);
	
	// 좋아요 취소
	int cancleLike(@Param("like_project_code")String like_project_code, @Param("like_mem_email")String like_mem_email);
	
	// 창작자가 아닌 상대방 마이페이지에서 팔로우 리스트 가져오기
	List<Map<String, Object>> selectOtherNoCreatorFollowList(
								@Param("startRow") int startRow,
								@Param("listLimit") int listLimit,
								@Param("mem_email") String mem_email);
	
	// 창작자가 아닌 상대방 마이페이지에서 팔로잉 리스트 가져오기
	List<Map<String, Object>> selectOtherNoCreatorFollowingList(
								@Param("startRow") int startRow,
								@Param("listLimit") int listLimit,
								@Param("mem_email") String mem_email);
	
	// 창작자인 상대방 마이페이지에서 팔로워 리스트 가져오기
	List<Map<String, Object>> selectOtherCreatorFollowList(
								@Param("startRow") int startRow,
								@Param("listLimit") int listLimit,
								@Param("creatorEmail") String creatorEmail);
	
	// 창작자인 상대방 마이페이지에서 팔로잉 리스트 가져오기
	List<Map<String, Object>> selectOtherCreatorFollowingList(
								@Param("startRow") int startRow,
								@Param("listLimit") int listLimit,
								@Param("creatorEmail") String creatorEmail);
	
	// 창작자가 아닌경우 후원한 프로젝트 목록 나타내기
	List<Map<String, Object>> selectOtherNoCreatorDonationProjectList(
								@Param("startRow") int startRow,
								@Param("listLimit") int listLimit,
								@Param("mem_email") String mem_email);
	
	// 창작자가 아닌경우 후원한 프로젝트 목록 나타내기
	List<Map<String, Object>> selectOtherCreatorDonationProjectList(
								@Param("startRow") int startRow,
								@Param("listLimit") int listLimit,
								@Param("creatorEmail") String creatorEmail);
	
	// 팔로우 리스트에서 내가 팔로우한 사람이 팔로우한 수
//	List<FollowVO> selectFollowerCount(List<FollowVO> followerCount);

	// 프로필 사진 삭제
	int deleteProfileDelete(Map<String, String> map);

	// 회원 아이디 조회(채팅용)
	String selectMemberId(String receiver_id);

	// 마이페이지(기본정보 수정)
	int updateMember(Map<String, String> map);

	// 팔로우나 프로젝트 리스트에서 들어가는 마이페이지
	String selectCreatorName(String creatorEmail);
	
	// 상대방 마이페이지(창작자가 아닌 경우)
	MemberVO selectMemberInfo(String creatorEmail);
	
	// 상대방 마이페이지(창작자인 경우)
	CreatorVO selectOtherCreatorInfo(String creatorEmail);
	
	
	
	// ===============================================
	// 회원 가입 시 기본 배송지 등록
	void insertTransAddress(@Param("address_mem_email")String address_mem_email, 
			@Param("address_receiver_name")	String address_receiver_name, 
			@Param("address_post_code") String address_post_code,
			@Param("address_main") String address_main, 
			@Param("address_sub") String address_sub, 
			@Param("address_receiver_tel")String address_receiver_tel);

	// creator_email 들고와서 mem_email값 가져오기
	String selectMemEmail(String creatorEmail);
























}
