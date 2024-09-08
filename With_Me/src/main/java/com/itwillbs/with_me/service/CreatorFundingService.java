package com.itwillbs.with_me.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.itwillbs.with_me.handler.CreatorBankApiClient;
import com.itwillbs.with_me.mapper.CreatorFundingMapper;
import com.itwillbs.with_me.vo.BankToken;
import com.itwillbs.with_me.vo.CommonCodeVO;
import com.itwillbs.with_me.vo.CreatorAccountVO;
import com.itwillbs.with_me.vo.CreatorVO;
import com.itwillbs.with_me.vo.ItemVO;
import com.itwillbs.with_me.vo.ProjectVO;

@Service
public class CreatorFundingService {
	@Autowired
	private CreatorFundingMapper mapper;

	@Autowired
	private CreatorBankApiClient bankApiClient;
	
	// 프로젝트 목록 조회 요청
	public List<ProjectVO> getProjectList(String id, String status) {
		return mapper.selectProjectList(id, status);
	}

	// 상위공통코드 FUND 인 컬럼(카테고리) 조회 요청
	public List<CommonCodeVO> getCategory() {
		return mapper.selectCategory();
	}
	
	// 세부 카테고리 조회 요청
    public List<CommonCodeVO> getCategoryDetail(String project_category) {
        return mapper.selectCategoryDetail(project_category);
    }

    // 창작자 정보 등록 요청
    public void registCreator(String id) {
    	// 기존에 창작자 정보 있는지 조회(창작자 번호 조회)
    	CreatorVO selectCreator = mapper.selectIsCreator(id);
    	
    	if (selectCreator == null) {	// 조회된 결과 없을 경우
			mapper.insertCreator(id);
		}
    }

    // 프로젝트 등록 요청
	public int registProject(String id, ProjectVO project) {
		// 창작자 번호 조회 요청
		CreatorVO creator = mapper.selectIsCreator(id);
		int creator_idx = creator.getCreator_idx();
		
		// 카테고리 코드 조회 요청(프로젝트 코드 조합 위함)
//		String project_category = mapper.selectProjectCategory(project.getProject_category());
		
		return mapper.insertProject(creator_idx, project);
	}

	// 프로젝트 번호 조회 요청
	public Integer getProjectIdx(String id) {
		return mapper.selectProjectIdx(id);
	}

	// 프로젝트 정보 조회 요청
	public ProjectVO getProject(String project_idx) {
		return mapper.selectProject(project_idx);
	}
	
	// 창작자 정보 조회 요청
	public CreatorVO getCreator(int creator_idx) {
		return mapper.selectCreator(creator_idx);
	}

	// 아이템 등록 요청
	public int registItem(Map<String, String> map) {
		return mapper.insertItem(map);
	}

	// 아이템 리스트 조회 요청
	public List<ItemVO> getItemList(String project_idx) {
		return mapper.selectItemList(project_idx);
	}

	// 삭제하려는 아이템이 포함되어 있는 후원구성 개수 조회 요청
	public List<Integer> getRewardIdxList(String item_idx) {
		return mapper.selectRewardIdxList(item_idx);
	}
	
	// 프로젝트에 해당하는 creator_account 정보 조회 요청
	public CreatorAccountVO getCreatorAccount(String project_idx) {
		return mapper.selectCreatorAccount(project_idx);
	}

	// 핀테크 사용자 정보 조회(DB)
	public BankToken getBankUserInfo(String id) {
		// BankMapper - selectBankUserInfo()
		return mapper.selectBankUserInfo(id);
	}
	
	// 아이템 삭제 요청
	public int deleteItem(String item_idx) {
		return mapper.deleteItem(item_idx);
	}

	// 아이템 포함되어 있는 후원구성 삭제 요청
	public int deleteIncludeReward(String item_idx) {
		return mapper.deleteIncludeReward(item_idx);
	}

	// 후원 구성 등록 요청
	public int registReward(Map<String, String> map) {
		return mapper.insertReward(map);
	}

	// 후원 구성 리스트 조회 요청
	public List<HashMap<String, String>> getRewardList(String project_idx) {
		return mapper.selectRewardList(project_idx);
	}

	// 후원 구성 삭제 요청
	public int deleteReward(String reward_idx) {
		return mapper.deleteReward(reward_idx);
	}

	// 핀테크 사용자 정보 조회(API)
	public Map<String, Object> getBankUserInfoFromApi(BankToken token) {
		// BankApiClient - requestUserInfo() 메서드 호출
		return bankApiClient.requestUserInfo(token);
	}

	// 계좌 정보 테이블에 저장 요청
	public int registCreatorAccount(Map<String, Object> accountInfo) {
		return mapper.insertCreatorAccount(accountInfo);
	}

	// 핀테크 정보에 사용자 식별번호, 핀테크번호 저장 요청(update)
	public int registFintechInfo(Map<String, Object> accountInfo) {
		return mapper.updateFintechInfo(accountInfo);
	}

	// 프로젝트 임시저장 요청
	public int modifyProject(ProjectVO project) {
		return mapper.updateProject(project);
	}

	// 창작자 정보 임시저장 요청
	public int modifyCreator(CreatorVO creator) {
		return mapper.updateCreator(creator);
	}

	// 프로젝트 삭제 요청
	public int deleteProject(String project_idx) {
		return mapper.deleteProject(project_idx);
	}

	// 프로젝트 삭제 요청 폼 제출 요청
	public int requestDeleteProject(String project_idx, String project_cancel_reason) {
		return mapper.insertRequestDeleteProject(project_idx, project_cancel_reason);
	}

	// 프로젝트 취소 요청한 프로젝트 조회 요청
	public List<Map<String, String>> getDeleteRequestList(String id) {
		return mapper.selectDeleteRequestList(id);
	}








	// 심사중인 프로젝트 목록 조회 요청
//	public List<ProjectVO> getReviewProjectList(String id) {
//		return mapper.selectReviewProjectList(id);
//	}

	// 승인된 프로젝트 목록 조회 요청
//	public List<ProjectVO> getApproveProjectList(String id) {
//		// TODO Auto-generated method stub
//		return null;
//	}



}