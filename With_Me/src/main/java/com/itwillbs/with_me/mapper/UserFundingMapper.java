package com.itwillbs.with_me.mapper;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Param;

public interface UserFundingMapper {

	// 검색어나 카테고리에 맞게 리스트 목록 개수 가져오기
	int selectBoardListCount(@Param("searchKeyword") String searchKeyword, @Param("category")String category);

	// 프로젝트 목록 표출
	List<Map<String, Object>> selectProjectList(@Param("category")String category,
									  @Param("searchKeyword")String searchKeyword, 
									  @Param("startRow")int startRow, 
									  @Param("listLimit")int listLimit);

}
