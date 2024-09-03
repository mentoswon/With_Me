package com.itwillbs.with_me.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.itwillbs.with_me.mapper.StoreMapper;
import com.itwillbs.with_me.vo.AddressVO;
import com.itwillbs.with_me.vo.LikeVO;
import com.itwillbs.with_me.vo.MemberVO;

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
	public Map<String, Object> getProduct(String product_detail) {
		
		return mapper.selectProduct(product_detail);
	}
	
	// 리스트 가져오기2222 전부
	public List<Map<String, Object>> getStoreListAll(String searchKeyword, String productCategory,
			String productCategory_detail, int startRow, int listLimit) {
		return mapper.selectStoreListAll(searchKeyword, productCategory, productCategory_detail, startRow, listLimit);
	}
	
	// 사용자 주소(배송지) 정보 가져오기 
	public List<AddressVO> getUserAddress(MemberVO member) {
		
		return mapper.selectUserAddress(member);
	}
	
	// 기본 배송지 여부 확인
	public int getAddressIsDefault(String id) {

		return mapper.selectAddressIsDefault(id);
	}
	
	// 기본 배송지 변경
	public int modifyDefaultAddress(String id) {
		 
		return mapper.updateDefaultAddress(id);
	}
	
	// 1. 기본 배송지 변경하고 새로운 기본배송지 설정
	public void registNewDefaultAddress(AddressVO new_address) {
		mapper.insertNewDefaultAddress(new_address);
	}
	
	// 2. 나머지 배송지 등록
	public void registNewAddress(AddressVO new_address) {
		mapper.insertNewAddress(new_address);
		
	}
	
	// 배송지 삭제
	public int removeAddress(AddressVO address) {
		
		return mapper.deleteAddres(address);
	}
	
	// 좋아요 했다면 정보 가져가기
	public LikeVO getIsLike(String like_product_code, String like_mem_email) {
		// TODO Auto-generated method stub
		return mapper.selectIsLike(like_product_code, like_mem_email);
	}
	// ===========================================================================================
	// 좋아요 한 적 있는지 확인
	public int getLikeCount(String like_product_code, String like_mem_email) {
		return mapper.selectLikeCount(like_product_code, like_mem_email);
	}
	
	// 좋아요 한 적 있으니까 update
	public int modifyLike(String like_product_code, String like_mem_email) {
		return mapper.updateLike(like_product_code, like_mem_email);
	}
	
	// 좋아요 등록 (좋아요 한 적 없음)
	public int registLike(String like_product_code, String like_mem_email) {
		return mapper.insertLike(like_product_code, like_mem_email);
	}

	// 좋아요 취소
	public int cancleLike(String like_product_code, String like_mem_email) {
		return mapper.cancleLike(like_product_code, like_mem_email);
	}

	

}
