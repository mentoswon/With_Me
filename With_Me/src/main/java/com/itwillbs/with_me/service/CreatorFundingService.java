package com.itwillbs.with_me.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.itwillbs.with_me.mapper.CreatorFundingMapper;
import com.itwillbs.with_me.vo.ProjectVO;

@Service
public class CreatorFundingService {
	@Autowired
	private CreatorFundingMapper mapper;

	// 작성중인 프로젝트 목록 조회 요청
	public ProjectVO getProjectList(String id) {
		return mapper.selectProjectList(id);
	}

}
