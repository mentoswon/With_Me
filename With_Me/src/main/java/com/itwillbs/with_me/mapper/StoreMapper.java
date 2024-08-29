package com.itwillbs.with_me.mapper;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

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
	Map<String, Object> selectProduct(String product_code);
	

}
