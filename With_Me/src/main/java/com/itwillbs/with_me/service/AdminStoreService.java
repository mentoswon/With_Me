package com.itwillbs.with_me.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.itwillbs.with_me.mapper.AdminStoreMapper;
import com.itwillbs.with_me.vo.StoreVO;
import com.itwillbs.with_me.vo.Store_userVO;

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
	
	// 상품 옵션값 가져오기
	public List<Map<String, Object>> getProdcutOption(int product_idx) {
		return mapper.selectProductOptions(product_idx);
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

	// 상품 주문내역 총 리스트 개수
	public int getProductOrderListCount(String searchType, String searchKeyword) {
		return mapper.selectProcutOrderListCount(searchType, searchKeyword);
	}
	
	// 상품 주문내역 리스트
	public List<Map<String, Object>> getProductOrderList(String searchType, String searchKeyword, int startRow, int listLimit) {
		return mapper.selectProductOrderList(searchType, searchKeyword, startRow, listLimit);
	}
	
	// 상품 주문내역 상세정보
	public Map<String, Object> getProductOrderDetail(int order_idx) {
		return mapper.selectProductOrderDetail(order_idx);
	}
	
	// 상품 주문내역 배송정보 변경
	public int modifyProductOrder(Store_userVO store_user) {
		return mapper.updateProductOrder(store_user);
	}

	
	
}
