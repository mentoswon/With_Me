package com.itwillbs.with_me.mapper;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import com.itwillbs.with_me.vo.AddressVO;
import com.itwillbs.with_me.vo.LikeVO;
import com.itwillbs.with_me.vo.MemberVO;

@Mapper
public interface StoreMapper {
	// 리스트 목록 개수 가져오기
	int selectBoardListCount(@Param("searchKeyword") String searchKeyword, 
							@Param("productCategory") String productCategory,
							@Param("productCategory_detail") String productCategory_detail); 
	
	
	// 리스트 가져오기
	List<Map<String, Object>> selectStoreList(
							@Param("searchKeyword")String searchKeyword,
							@Param("productCategory")	String productCategory,
							@Param("productCategory_detail")String productCategory_detail, 
							@Param("startRow")int startRow, 
							@Param("listLimit")int listLimit);

	// 상품 상세정보 가져오기
	Map<String, Object> selectProduct(String product_detail);
							

	// 리스트 가져오기2222
	List<Map<String, Object>> selectStoreListAll(String searchKeyword, String productCategory,
			String productCategory_detail, int startRow, int listLimit);

	// 사용자 배송지 가져오기
	List<AddressVO> selectUserAddress(MemberVO member);

	// 기본 배송지 여부 확인
	int selectAddressIsDefault(String id);

	// 기본 배송지 변경(N으로)
	int updateDefaultAddressToN(String id);

	// 1. 기본 배송지 변경후 새로운 기본 배송지 설정
	void insertNewDefaultAddress(AddressVO new_address);

	// 2. 나머지 배송지 등록
	int insertNewAddress(AddressVO new_address);

	// 배송지 삭제
	int deleteAddress(AddressVO address);



	int selectAddressIsSelected(String id);


	int updateSelectedAddressToN(String id);


	int updateSelectedAddressToY(int address_idx);


	int updateDefaultAddressToY(int address_idx);

// ===========================================================
	// 좋아요 했는지 판단 후에 가져가기 
	LikeVO selectIsLike(
			@Param("like_product_code")String like_product_code, 
			@Param("like_mem_email")String like_mem_email);
	
	// 좋아요 한 적 있는지 확인
	int selectLikeCount(@Param("like_product_code")String like_product_code, @Param("like_mem_email")String like_mem_email);
	
	// 좋아요 한 적 있으니까 update
	int updateLike(@Param("like_product_code")String like_product_code, @Param("like_mem_email")String like_mem_email);
	
	// 좋아요 등록
	int insertLike(@Param("like_product_code")String like_product_code, @Param("like_mem_email")String like_mem_email);
	
	// 좋아요 취소
	int cancleLike(@Param("like_product_code")String like_product_code, @Param("like_mem_email")String like_mem_email);
	

}
