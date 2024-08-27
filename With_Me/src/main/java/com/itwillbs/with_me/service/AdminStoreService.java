package com.itwillbs.with_me.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.itwillbs.with_me.mapper.AdminStoreMapper;
import com.itwillbs.with_me.vo.StoreVO;

@Service
public class AdminStoreService {
	@Autowired
	private AdminStoreMapper mapper;
	
	// 상품 목록 리스트
	public List<StoreVO> getProductList(String searchType, String searchKeyword, int startRow, int listLimit) {
		return mapper.selectProductList(searchType, searchKeyword, startRow, listLimit);
	}	
	// 상품 리스트 총 갯수 조회 요청
	public int getProductListCount(String searchType, String searchKeyword) {
		return mapper.selectProcutListCount(searchType, searchKeyword);
	}
	
	// 상품 등록
	public int registProduct(StoreVO store) {
		return mapper.insertProduct(store);
	}
	
	// 상품 상세보기
	public StoreVO getProduct(int product_idx) {
		return mapper.selectProduct(product_idx);
	}
	
	// 상품 삭제
	public int removeProduct(int product_idx) {
		return mapper.deleteProduct(product_idx);
	}
	
	// 상품 수정
	public int modifyProduct(StoreVO store) {
		return mapper.updateProduct(store);
	}
	
	// 상품 이미지 삭제
	public int removeProductImg(Map<String, String> map) {
		return mapper.deleteProductImg(map);
	}
	
	
}
