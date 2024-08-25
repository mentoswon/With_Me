package com.itwillbs.with_me.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import com.itwillbs.with_me.vo.StoreVO;

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

	
	
}
