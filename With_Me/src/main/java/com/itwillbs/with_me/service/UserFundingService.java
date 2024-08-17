package com.itwillbs.with_me.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.itwillbs.with_me.mapper.UserFundingMapper;
import com.itwillbs.with_me.vo.ProjectVO;
import com.itwillbs.with_me.vo.SponsorVO;

@Service
public class UserFundingService {
	
	@Autowired
	private UserFundingMapper mapper;
	
	// 리스트 목록 개수 가져오기
	public int getBoardListCount(String searchKeyword, String category) {
		return mapper.selectBoardListCount(searchKeyword, category);
	}
	
	// 리스트 가져오기
	public List<Map<String, Object>> getProjectList(String category, String searchKeyword, int startRow, int listLimit) {
		return mapper.selectProjectList(category, searchKeyword,startRow,listLimit);
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
	public List<SponsorVO> getSponsor(int project_idx) {
		return mapper.selectSponsorList(project_idx);
	}
	





}
