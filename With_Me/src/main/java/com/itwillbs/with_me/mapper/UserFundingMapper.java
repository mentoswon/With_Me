package com.itwillbs.with_me.mapper;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Param;

import com.itwillbs.with_me.vo.ProjectVO;

public interface UserFundingMapper {

	// 리스트 목록 개수 가져오기
	int selectBoardListCount(@Param("searchKeyword") String searchKeyword, @Param("category")String category);
	
	
	// 리스트 가져오기
	List<Map<String, Object>> selectProjectList(@Param("category")String category,
												  @Param("searchKeyword")String searchKeyword, 
												  @Param("startRow")int startRow, 
												  @Param("listLimit")int listLimit);


	// 프로젝트 상세정보 가져오기
	ProjectVO selectProject(String project_code);
	






}
