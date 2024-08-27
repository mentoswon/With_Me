package com.itwillbs.with_me.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.itwillbs.with_me.mapper.UserFundingMapper;
import com.itwillbs.with_me.vo.AddressVO;
import com.itwillbs.with_me.vo.MemberVO;
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

	// 기본 배송지 여부 확인
	public int getAddressIsDefault(String id) {
		return mapper.selectAddressIsDefault(id);
	}

	// 기본 배송지 변경
	public int modifyDefaultAddress(String id) {
		return mapper.updateDefaultAddress(id);
	}

	// 1. 기본 배송지 변경하고 새로운 기본배송지 설정
	public void registNewDefaultAddress(AddressVO new_address) {
		mapper.insertNewDefaultAddress(new_address);
	}

	// 2. 나머지 배송지 등록
	public void registNewAddress(AddressVO new_address) {
		mapper.insertNewAddress(new_address);
	}



	





}
