package com.itwillbs.with_me.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.itwillbs.with_me.mapper.CreatorFundingMapper;
import com.itwillbs.with_me.vo.CommonCodeVO;
import com.itwillbs.with_me.vo.ProjectVO;

@Service
public class CreatorFundingService {
	@Autowired
	private CreatorFundingMapper mapper;

	// 작성중인 프로젝트 목록 조회 요청
	public ProjectVO getProjectList(String id) {
		return mapper.selectProjectList(id);
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
    	String selectCreator = mapper.selectCreator(id);
    	
    	if (selectCreator == null) {	// 조회된 결과 없을 경우
			mapper.insertCreator(id);
		}
    }

    // 프로젝트 등록 요청
	public int registProject(String id, ProjectVO project) {
		// 창작자 번호 조회
		String creator_idx = mapper.selectCreator(id);
		
		return mapper.insertProject(creator_idx, project);
	}

	// 프로젝트 번호 조회 요청
	public Integer getProjectIdx(String id) {
		return mapper.selectProjectIdx(id);
	}

	// 프로젝트 정보 조회 요청
	public ProjectVO getProject(Integer project_idx) {
		return mapper.selectProject(project_idx);
	}



}