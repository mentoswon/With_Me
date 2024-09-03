package com.itwillbs.with_me.mapper;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Param;

import com.itwillbs.with_me.vo.AddressVO;
import com.itwillbs.with_me.vo.FollowVO;
import com.itwillbs.with_me.vo.LikeVO;
import com.itwillbs.with_me.vo.MemberVO;
import com.itwillbs.with_me.vo.ProjectVO;
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
												@Param("listLimit")int listLimit);


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

	// 선택된 배송지 있는지 확인
	int selectAddressIsSelected(String id);
	
	// 원래 선택된 배송지였던 걸 N으로 변경
	int updateSelectedAddressToN(String id);
	
	// 배송지 변경
	int updateSelectedAddressToY(int address_idx);

	// 기본 배송지 변경
	int updateDefaultAddressToY(int address_idx);
	
	// 신고 접수
	int insertReport(Map<String, Object> map);

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
	int cancleLike(@Param("like_project_code")String like_project_code, @Param("like_mem_email")String like_mem_email);

	// 창작자의 누적 펀딩액
	int selectTotalFundAmtOfCreator(String creator_email);

	// ========================================================================================================================
	int insertUserFunding(Map<String, Object> map);













	







	






}
