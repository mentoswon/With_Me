package com.itwillbs.with_me.mapper;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import com.itwillbs.with_me.vo.StoreVO;
import com.itwillbs.with_me.vo.Store_userVO;

@Mapper
public interface AdminStoreMapper {
	
	// 상품 목록 리스트
	List<StoreVO> selectProductList(
						@Param("searchType") String searchType,
						@Param("searchKeyword") String searchKeyword,
						@Param("startRow") int startRow,
						@Param("listLimit") int listLimit);
	
	// 상품 게시물 갯수 조회
	int selectProcutListCount(@Param("searchType") String searchType, @Param("searchKeyword") String searchKeyword);
	
	// 상품등록
	int insertProduct(StoreVO store);

	// 상품 상세보기
	StoreVO selectProduct(int product_idx);

	// 상품 옵션값 리스트
	List<Map<String, Object>> selectProductOptions(int product_idx);
	
	// 상품 삭제
	int deleteProduct(int product_idx);

	// 상품 수정
	int updateProduct(StoreVO store);

	// 상품 이미지 삭제
	int deleteProductImg(Map<String, String> map);

	// 상품 주문내역 개수 조회
	int selectProcutOrderListCount(@Param("searchType")String searchType, @Param("searchType")String searchKeyword);

	// 상품 주문내역 리스트
	List<Map<String, Object>> selectProductOrderList(
								@Param("searchType")String searchType,
								@Param("searchKeyword")String searchKeyword,
								@Param("startRow")int startRow,
								@Param("listLimit")int listLimit);

	// 상품 주문내역 상세정보
	Map<String, Object> selectProductOrderDetail(int order_idx);

	// 상품 주문내역 배송정보 변경
	int updateProductOrder(Store_userVO store_user);

	// 상품 주문내역 값 들고오기
	Store_userVO selectProductOrder(int order_idx);

	// 상품 주문내역 삭제
	int deleteProductOrder(int order_idx);
}
