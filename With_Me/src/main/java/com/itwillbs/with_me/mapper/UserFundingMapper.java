package com.itwillbs.with_me.mapper;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Param;

import com.itwillbs.with_me.vo.AddressVO;
import com.itwillbs.with_me.vo.MemberVO;
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

	// 기본 배송지 변경
	int updateDefaultAddress(String id);

	// 1. 기본 배송지 변경하고 새로운 기본배송지 설정
	void insertNewDefaultAddress(AddressVO new_address);

	// 2. 나머지 배송지 등록
	void insertNewAddress(AddressVO new_address);

	// 배송지 삭제
	int deleteAddress(AddressVO address);

	






}
