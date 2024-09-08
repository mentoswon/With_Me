package com.itwillbs.with_me.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.itwillbs.with_me.mapper.HomeMapper;
import com.itwillbs.with_me.vo.StoreVO;

@Service
public class HomeService {
	@Autowired
	private HomeMapper mapper;

	public List<Map<String, Object>> getProjectList(String sId) {
		return mapper.selectProjectList(sId);
	}

	public List<Map<String, Object>> getStoreList(String sId) {
		return mapper.selectStoreList(sId);
	}

	// 메인페이지 프로젝트 인기 순위
	public List<Map<String, Object>> getPopularProList() {
		return mapper.selectPopularProList();
	}

	// 메인페이지 스토어 인기 순위
	public List<Map<String, Object>> getPopularProductList() {
		return mapper.selectPopularProductList();
	}
	
	
}
