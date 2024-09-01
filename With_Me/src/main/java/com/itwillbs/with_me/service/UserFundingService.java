package com.itwillbs.with_me.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.itwillbs.with_me.mapper.UserFundingMapper;
import com.itwillbs.with_me.vo.AddressVO;
import com.itwillbs.with_me.vo.FollowVO;
import com.itwillbs.with_me.vo.MemberVO;
import com.itwillbs.with_me.vo.ProjectVO;
import com.itwillbs.with_me.vo.RewardVO;

@Service
public class UserFundingService {
	
	@Autowired
	private UserFundingMapper mapper;
	
	// 리스트 목록 개수 가져오기
	public int getBoardListCount(String searchKeyword, String category, String category_detail) {
		return mapper.selectBoardListCount(searchKeyword, category, category_detail);
	}
	
	// 리스트 가져오기
	public List<Map<String, Object>> getProjectList(String category, String category_detail, String searchKeyword, int startRow, int listLimit) {
		return mapper.selectProjectList(category,category_detail, searchKeyword,startRow,listLimit);
	}

	
	// 프로젝트 상세정보 가져오기
	public Map<String, Object> getProject(String project_code) {
		return mapper.selectProject(project_code);
	}

	// 팔로워 수 계산
	public int countFollower(String creator_email) {
		return mapper.countFollower(creator_email);
	}
	
	// 팔로워 리스트
	public List<FollowVO> getFollowerList(String creator_email) {
		return mapper.selectFollowerList(creator_email);
	}

	// 후원 리워드 리스트
	public List<RewardVO> getReward(int project_idx) {
		return mapper.selectRewardList(project_idx);
	}

	// 리워드 별 아이템
	public List<Map<String, Object>> getRewardItemList(int reward_idx) {
		return mapper.selectRewardItemList(reward_idx);
	}
	
	// 리워드가 객관식일 경우 아이템 옵션
	public List<Map<String, Object>> getItemOpionList(String item_idx) {
		return mapper.selectItemOptionList(item_idx);
	}

	// 사용자 배송지 가져오기
	public List<AddressVO> getUserAddress(MemberVO member) {
		return mapper.selectUserAddress(member);
	}

	// 기본 배송지 가져오기
//	public List<AddressVO> getDefaultAddress(MemberVO member) {
//		return null;
//	}
	
	// 기본 배송지 여부 확인
	public int getAddressIsDefault(String id) {
		return mapper.selectAddressIsDefault(id);
	}

	// 기본 배송지 변경
	public int modifyDefaultAddress(String id) {
		return mapper.updateDefaultAddress(id);
	}


	// 배송지 등록
	public int registNewAddress(AddressVO new_address) {
		return mapper.insertNewAddress(new_address);
	}

	// 배송지 삭제
	public int removeAddress(AddressVO address) {
		
		return mapper.deleteAddress(address);
	}

	// 선택된 배송지 있는지 확인
	public int getAddressIsSelected(String id) {
		return mapper.selectAddressIsSelected(id);
	}
	
	// 원래 선택된 배송지였던 걸 N으로 변경
	public int modifySelectedAddressToN(String id) {
		return mapper.updateSelectedAddressToN(id);
	}
	
	// 배송지 변경
	public int modifySelectedAddressToY(int address_idx) {
		return mapper.updateSelectedAddressToY(address_idx);
	}

	// 신고 접수
	public int registReport(Map<String, Object> map) {
		return mapper.insertReport(map);
	}

	
	// ===========================================================================================
	// 팔로우 등록
	public int registFollow(String id, String follow_creator) {
		return mapper.insertFollow(id, follow_creator);
	}

	// 언팔로우
	public int unFollow(String follow_mem_email, String follow_creator) {
		return mapper.unFollow(follow_mem_email, follow_creator);
	}

	// ===========================================================================================
	// 좋아요 등록
	public int registLike(String like_project_code, String like_mem_email) {
		return mapper.insertLike(like_project_code, like_mem_email);
	}









	





}
