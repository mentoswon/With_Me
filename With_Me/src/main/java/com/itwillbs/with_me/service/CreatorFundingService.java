package com.itwillbs.with_me.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.itwillbs.with_me.mapper.CreatorFundingMapper;
import com.itwillbs.with_me.vo.CommonCodeVO;
import com.itwillbs.with_me.vo.CreatorVO;
import com.itwillbs.with_me.vo.ItemVO;
import com.itwillbs.with_me.vo.ProjectVO;
import com.itwillbs.with_me.vo.RewardVO;

@Service
public class CreatorFundingService {
	@Autowired
	private CreatorFundingMapper mapper;

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
    	CreatorVO selectCreator = mapper.selectCreator(id);
    	
    	if (selectCreator == null) {	// 조회된 결과 없을 경우
			mapper.insertCreator(id);
		}
    }

    // 프로젝트 등록 요청
	public int registProject(String id, ProjectVO project) {
		// 창작자 번호 조회
		CreatorVO creator = mapper.selectCreator(id);
		int creator_idx = creator.getCreator_idx();
		
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
	public CreatorVO getCreator(String id) {
		return mapper.selectCreator(id);
	}

	// 아이템 등록 요청
	public int registItem(Map<String, String> map) {
		return mapper.insertItem(map);
	}

	// 아이템 리스트 조회 요청
	public List<ItemVO> getItemList(String project_idx) {
		return mapper.selectItemList(project_idx);
	}

	// 아이템 삭제 요청
	public int deleteItem(String item_idx) {
		return mapper.deleteItem(item_idx);
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

	// 프로젝트 임시저장 요청
	public int modifyProject(ProjectVO project) {
		return mapper.updateProject(project);
	}

	// 창작자정보 임시저장 요청
	public int modifyCreator(CreatorVO creator) {
		return mapper.updateCreator(creator);
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