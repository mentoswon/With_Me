package com.itwillbs.with_me.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.itwillbs.with_me.mapper.UserFundingMapper;
import com.itwillbs.with_me.vo.ProjectVO;

@Service
public class UserFundingService {
	
	@Autowired
	private UserFundingMapper mapper;
	
	// 검색어나 카테고리에 맞게 리스트 목록 개수 가져오기
	public int getBoardListCount(String searchKeyword, String category) {
		
		return mapper.selectBoardListCount(searchKeyword, category);
	}

	// 프로젝츠 목록 표출
	public List<Map<String, Object>> getProjectList(String category, String searchKeyword, int startRow, int listLimit) {
		return mapper.selectProjectList(category, searchKeyword,startRow,listLimit);
	}


}
