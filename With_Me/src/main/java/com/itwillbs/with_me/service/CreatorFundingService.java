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

}