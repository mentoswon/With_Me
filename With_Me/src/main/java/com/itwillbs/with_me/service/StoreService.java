package com.itwillbs.with_me.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.itwillbs.with_me.mapper.StoreMapper;

@Service
public class StoreService {
	
	@Autowired
	private StoreMapper mapper;
	
	// 리스트 목록 개수 가져오기
	public int getBoardListCount(String searchKeyword, String productCategory, String productCategory_detail) {
		
		return mapper.selectBoardListCount(searchKeyword, productCategory, productCategory_detail);
	}
	
	// 리스트 가져오기
	public List<Map<String, Object>> getStoreList(String searchKeyword, String productCategory,
			String productCategory_detail, int startRow, int listLimit) {
		
		return mapper.selectStoreList(searchKeyword, productCategory, productCategory_detail, startRow, listLimit);
	}

	// 상품 상세정보 가져오기
	public Map<String, Object> getProduct(String product_code) {
		
		return mapper.selectProduct(product_code);
	}

}
