package com.itwillbs.with_me.service;

import java.time.LocalDate;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.itwillbs.with_me.handler.BankApiClient;
import com.itwillbs.with_me.handler.UserBankApiClient;
import com.itwillbs.with_me.mapper.BankMapper;
import com.itwillbs.with_me.mapper.UserFundingMapper;
import com.itwillbs.with_me.vo.AddressVO;
import com.itwillbs.with_me.vo.BankToken;
import com.itwillbs.with_me.vo.FollowVO;
import com.itwillbs.with_me.vo.LikeVO;
import com.itwillbs.with_me.vo.MemberVO;
import com.itwillbs.with_me.vo.ProjectVO;
import com.itwillbs.with_me.vo.ReportVO;
import com.itwillbs.with_me.vo.RewardVO;

@Service
public class UserFundingService {
	
	@Autowired
	private UserFundingMapper mapper;
	
	@Autowired
	private UserBankApiClient bankApiClient;
	
	// 리스트 목록 개수 가져오기
	public int getBoardListCount(String searchKeyword, String category, String category_detail) {
		return mapper.selectBoardListCount(searchKeyword, category, category_detail);
	}
	
	// 리스트 가져오기
	public List<Map<String, Object>> getProjectList(String category, String category_detail, String searchKeyword, int startRow, int listLimit, String id) {
		return mapper.selectProjectList(category,category_detail, searchKeyword,startRow,listLimit, id);
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
	
	// 좋아요 한거면 그 정보 가져가기
	public LikeVO getIsLike(String like_project_code, String like_mem_email) {
		return mapper.selectIsLike(like_project_code, like_mem_email);
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
	public int modifyDefaultAddressToN(String id) {
		return mapper.updateDefaultAddressToN(id);
	}


	// 배송지 등록
	public int registNewAddress(AddressVO new_address) {
		return mapper.insertNewAddress(new_address);
	}

	// 배송지 삭제
	public int removeAddress(AddressVO address) {
		
		return mapper.deleteAddress(address);
	}
	
	// 선택된 배송지 삭제하는 경우
	public void modifySelectedAddressToY2(String id) {
		mapper.updateSelectedAddressToY2(id);
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
	
	// 기본 배송지 변경
	public int modifyDefaultAddressToY(int address_idx) {
		return mapper.updateDefaultAddressToY(address_idx);
	}
	

	// 신고 접수
	public int registReport(ReportVO report) {
		return mapper.insertReport(report);
	}

	
	// ===========================================================================================
	// 팔로우 한 적 있는지 확인 부터
	public int getFollowCount(String id, String follow_creator) {
		return mapper.selectFollowCount(id, follow_creator);
	}
	
	// 팔로우 한 적 있는데 N으로 돼있으면 Y로 수정
	public int modifyFollow(String id, String follow_creator) {
		return mapper.updateFollow(id, follow_creator);
	}
	
	// 팔로우 한 적 없으면 (아예 기록 없음) 팔로우 등록
	public int registFollow(String id, String follow_creator) {
		return mapper.insertFollow(id, follow_creator);
	}

	// 언팔로우
	public int unFollow(String follow_mem_email, String follow_creator) {
		return mapper.unFollow(follow_mem_email, follow_creator);
	}

	// ===========================================================================================
	// 좋아요 한 적 있는지 확인
	public int getLikeCount(String like_project_code, String like_mem_email) {
		return mapper.selectLikeCount(like_project_code, like_mem_email);
	}
	
	// 좋아요 한 적 있으니까 update
	public int modifyLike(String like_project_code, String like_mem_email) {
		return mapper.updateLike(like_project_code, like_mem_email);
	}
	
	// 좋아요 등록 (좋아요 한 적 없음)
	public int registLike(String like_project_code, String like_mem_email) {
		return mapper.insertLike(like_project_code, like_mem_email);
	}

	// 좋아요 취소
	public int cancelLike(String like_project_code, String like_mem_email) {
		return mapper.cancelLike(like_project_code, like_mem_email);
	}

	
	// 창작자의 누적 펀딩액 
	public int getTotalFundAmtOfCreator(String creator_email) {
		return mapper.selectTotalFundAmtOfCreator(creator_email);
	}

	// ====================================================================================
	// 일반 후원 등록
	public int registDefaultFunding(Map<String, Object> map) {
		return mapper.insertDefaultFunding(map);
	}
	
	// 사용자 펀딩 등록
	public int registUserFunding(Map<String, Object> map) {
		return mapper.insertUserFunding(map);
	}

	// 몇 번째 후원자인지 카운트
	public int getFundCount(int user_funding_project_idx) {
		return mapper.selectFundCount(user_funding_project_idx);
	}
	
	// funding_idx 가져가기
	public int getNowFundingIdx(String id) {
		return mapper.selectNowFundingIdx(id);
	}

	// 결제 정보 db 저장
	public void registPaymentInfo(Map<String, Object> map) {
		mapper.insertPaymentInfo(map);
	}

	// ===========================================================================
	// 펀딩 결제해야하는 리스트
	public List<Map<String, Object>> getTodayPayFunding(LocalDate now) {
		return mapper.selectTodayPayFunding(now);
	}

	//============================================================================

	// 로그인 시 엑세스 정보 조회하여 저장하도록 처리해야하니까 일단 조회부터 (DB)
	public BankToken getBankUserInfo(String id) {
		return mapper.userSelectBankUserInfo(id);
	}

	// 핀테크 사용자 정보 조회(API)
	public Map<String, Object> getBankUserInfoFromApi(BankToken token) {
		// BankApiClient - requestUserInfo() 메서드 호출
		return bankApiClient.requestUserInfo(token);
	}
	
	// 핀테크 계좌 목록 조회
	public Map<String, Object> getBankAccountList(BankToken token) {
		return bankApiClient.requestBankAccountList(token);
	}

	// user_account 테이블에 저장
	public void registAccountInfo(Map<String, Object> map) {
		mapper.userInsertAccountInfo(map);
	}

	// fintech_user_info 테이블에 핀테크 use_num 저장
	public void registFintechInfo(String fin_use_num, String user_ci, String id) {
		mapper.userUpdateFintechInfo(fin_use_num, user_ci, id);
	}
	
	// 출금이체 요청
	public Map<String, String> requestWithdraw(Map<String, Object> map) {
		// BankApiClient - requestWithdraw() 메서드 호출
		return bankApiClient.requestWithdraw(map);
	}

	// project_payment 테이블에 오늘 날짜로 결제 날짜 업데이트 하기
	public void updatePayDate(Map<String, Object> map) {
		mapper.updatePayDate(map);
	}



	













	





}
