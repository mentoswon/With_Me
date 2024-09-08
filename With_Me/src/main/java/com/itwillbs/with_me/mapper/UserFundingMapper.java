package com.itwillbs.with_me.mapper;

import java.time.LocalDate;
import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Param;

import com.itwillbs.with_me.vo.AddressVO;
import com.itwillbs.with_me.vo.BankToken;
import com.itwillbs.with_me.vo.FollowVO;
import com.itwillbs.with_me.vo.LikeVO;
import com.itwillbs.with_me.vo.MemberVO;
import com.itwillbs.with_me.vo.ProjectVO;
import com.itwillbs.with_me.vo.ReportVO;
import com.itwillbs.with_me.vo.RewardVO;

public interface UserFundingMapper {

	// 리스트 목록 개수 가져오기
	int selectBoardListCount(@Param("searchKeyword") String searchKeyword, 
							 @Param("category")String category, 
							 @Param("category_detail")String category_detail);
	
	
	// 리스트 가져오기
	List<Map<String, Object>> selectProjectList(@Param("category")String category,
												@Param("category_detail")String category_detail,
												@Param("searchKeyword")String searchKeyword, 
												@Param("startRow")int startRow, 
												@Param("listLimit")int listLimit,
												@Param("id")String id);


	// 프로젝트 상세정보 가져오기
	Map<String, Object> selectProject(String project_code);

	// 팔로워 수 계산
	int countFollower(String creator_email);
	
	// 팔로워 리스트
	List<FollowVO> selectFollowerList(String creator_email);
	
	// 좋아요 한건지 판단 후 가져가기
	LikeVO selectIsLike(@Param("like_project_code")String like_project_code, @Param("like_mem_email")String like_mem_email);

	// 후원 리워드 리스트
	List<RewardVO> selectRewardList(int project_idx);

	// 리워드 별 아이템
	List<Map<String, Object>> selectRewardItemList(int reward_idx);

	// 리워드가 객관식일 경우 아이템 옵션
	List<Map<String, Object>> selectItemOptionList(String item_idx);

	// 사용자 배송지 가져오기
	List<AddressVO> selectUserAddress(MemberVO member);

	// 기본 배송지 여부 확인
	int selectAddressIsDefault(String id);

	// 기본 배송지 변경 (N으로)
	int updateDefaultAddressToN(String id);

	// 배송지 등록
	int insertNewAddress(AddressVO new_address);

	// 배송지 삭제
	int deleteAddress(AddressVO address);

	// 선택된 배송지 삭제하는 경우
	void updateSelectedAddressToY2(String id);
	
	// 선택된 배송지 있는지 확인
	int selectAddressIsSelected(String id);
	
	// 원래 선택된 배송지였던 걸 N으로 변경
	int updateSelectedAddressToN(String id);
	
	// 배송지 변경
	int updateSelectedAddressToY(int address_idx);

	// 기본 배송지 변경
	int updateDefaultAddressToY(int address_idx);
	
	// 신고 접수
	int insertReport(ReportVO report);

	// 팔로우 한 적 있는지 확인 부터
	int selectFollowCount(@Param("id") String id, @Param("follow_creator") String follow_creator);
	
	// 팔로우 한 적 있는데 N으로 돼있으면 언팔상태 -> Y로 수정하면 됨
	int updateFollow(@Param("id") String id, @Param("follow_creator") String follow_creator);
	
	// 팔로우 등록
	int insertFollow(@Param("id") String id, @Param("follow_creator") String follow_creator);

	// 언팔로우
	int unFollow(@Param("follow_mem_email")String follow_mem_email, @Param("follow_creator")String follow_creator);

	// 좋아요 한 적 있는지 확인
	int selectLikeCount(@Param("like_project_code")String like_project_code, @Param("like_mem_email")String like_mem_email);
	
	// 좋아요 한 적 있으니까 update
	int updateLike(@Param("like_project_code")String like_project_code, @Param("like_mem_email")String like_mem_email);
	
	// 좋아요 등록
	int insertLike(@Param("like_project_code")String like_project_code, @Param("like_mem_email")String like_mem_email);

	// 좋아요 취소
	int cancelLike(@Param("like_project_code")String like_project_code, @Param("like_mem_email")String like_mem_email);

	// 창작자의 누적 펀딩액
	int selectTotalFundAmtOfCreator(String creator_email);

	// ========================================================================================================================
	// 일반 후원 등록
	int insertDefaultFunding(Map<String, Object> map);
	
	// 사용자 후원 등록
	int insertUserFunding(Map<String, Object> map);

	// 몇 번째 후원자인지 카운트
	int selectFundCount(int user_funding_project_idx);

	// 지금 후원한 funding_idx 가져가기 
	int selectNowFundingIdx(String id);

	// 결제 정보 db 저장
	void insertPaymentInfo(Map<String, Object> map);

	// ==============================================================================
	// 오늘 결제하는 펀딩 리스트
	List<Map<String, Object>> selectTodayPayFunding(LocalDate now);

	// ==============================================================================

	// 로그인 시 엑세스 정보 조회하여 저장하도록 처리해야하니까 일단 조회부터
	BankToken userSelectBankUserInfo(String id);

	// fintech_user_info 테이블에 핀테크 use_num 저장
	void userUpdateFintechInfo(@Param("fin_use_num")String fin_use_num, @Param("user_ci")String user_ci, @Param("id")String id);
	
	// user_account 에 저장
	void userInsertAccountInfo(Map<String, Object> map);

	// project_payment 테이블에 오늘 날짜로 결제 날짜 업데이트 하기
	void updatePayDate(Map<String, Object> map);


















	







	






}
