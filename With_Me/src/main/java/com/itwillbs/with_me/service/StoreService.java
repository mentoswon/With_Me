package com.itwillbs.with_me.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.itwillbs.with_me.mapper.StoreMapper;
import com.itwillbs.with_me.vo.AddressVO;
import com.itwillbs.with_me.vo.LikeVO;
import com.itwillbs.with_me.vo.MemberVO;
import com.itwillbs.with_me.vo.StoreVO;

@Service
public class StoreService {
	
	@Autowired
	private StoreMapper mapper;
	
	// 리스트 목록 개수 가져오기
	public int getBoardListCount(String searchKeyword, String productCategory, String productCategory_detail, String product_state) {
		
		return mapper.selectBoardListCount(searchKeyword, productCategory, productCategory_detail, product_state);
	}
	
	// 리스트 가져오기
	public List<Map<String, Object>> getStoreList(String searchKeyword, String productCategory,
			String productCategory_detail, int startRow, int listLimit, String id, String product_state) {
		
		return mapper.selectStoreList(searchKeyword, productCategory, productCategory_detail, startRow, listLimit, id, product_state);
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
	public int modifyDefaultAddressToN(String id) {
		 
		return mapper.updateDefaultAddressToN(id);
	}
	
	// 배송지 등록
	public int registNewAddress(AddressVO new_address) {
		return mapper.insertNewAddress(new_address);
		
	}
	
	// 배송지 삭제
	public int removeAddress(AddressVO address) {
		
		return mapper.deleteAddress(address);
	}
	// 선택된 배송지 있는지 확인
	public int getAddressIsSelected(String id) {
		return mapper.selectAddressIsSelected(id);
	}
	
	// 원래 선택된 배송지였던 걸 N으로 변경
	public int modifySelectedAddressToN(String id) {
		return mapper.updateSelectedAddressToN(id);
	}
	
	// 배송지 변경
	public int modifySelectedAddressToY(int address_idx) {
		return mapper.updateSelectedAddressToY(address_idx);
	}
	
	// 기본 배송지 변경
	public int modifyDefaultAddressToY(int address_idx) {
		return mapper.updateDefaultAddressToY(address_idx);
	}	
	
	// 선택된 배송지 삭제하는 경우
	public void modifySelectedAddressToY2(String id) {
		mapper.updateSelectedAddressToY2(id);
	}
	
	// 신고 접수
	public int registReport(Map<String, Object> map) {
		
		return mapper.insertReport(map);
	}
	
// ==============================================================================
	
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
	public int cancelLike(String like_product_code, String like_mem_email) {
		return mapper.cancelLike(like_product_code, like_mem_email);
	}
// ===============================================================================
	
	// 상품별 옵션정보 리스트 가져오기
	public List<Map<String, Object>> getProductOptionList(Integer product_idx) {
		return mapper.selectProductOptionList(product_idx);
	}
	
	// 사용자 주문 등록
	public int registUserOrder(Map<String, Object> map) {
		return mapper.insertUserOrder(map);
	}
	
	// 스토어 결제 정보 db 저장
	public void registStorePaymentInfo(Map<String, Object> map) {
		mapper.insertStorePaymentInfo(map);
		
	}

		
}


	

	

	

	
	
	
	


